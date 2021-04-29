const c = @import("main.zig").c;
const std = @import("std");
const assert = std.debug.assert;

// Draw buffers for microui
const buffer_size: u32 = 16384;
var tex_buf = std.mem.zeroes([buffer_size * 8]f32);
var vert_buf = std.mem.zeroes([buffer_size * 8]f32);
var color_buf = std.mem.zeroes([buffer_size * 16]u8);
var index_buf = std.mem.zeroes([buffer_size * 6]u32);

// Window icon
var icon_loaded = false;
const icon_dat = @embedFile("../assets/icon.png");
var icon_rw: *(c.SDL_RWops) = undefined;
var icon_surface: *(c.SDL_Surface) = undefined;

// Atlas
var atlas_loaded = false;
const atlas = @import("atlas.zig");
const atlas_dat = @embedFile("../assets/atlas.png");
var atlas_rw: *(c.SDL_RWops) = undefined;
var atlas_surface: *(c.SDL_Surface) = undefined;

// Window and OpenGL context
var ctx_gl: c.SDL_GLContext = undefined;
var window: *(c.SDL_Window) = undefined;
const window_flags: u32 = c.SDL_WINDOW_OPENGL | c.SDL_WINDOW_SHOWN | c.SDL_WINDOW_RESIZABLE;
const background_color: [4]f32 = .{ 14 / 255.0, 14 / 255.0, 14 / 255.0, 255.0 };

// Window info
var viewport_width: u16 = 800;
var viewport_height: u16 = 600;
var buf_idx: u32 = 0;

/// Initialize the renderer. This must be called before using any of the
/// interface functions. Behavior without a call to this func or calling this
/// more than once leads to non-deterministic behavior.
pub fn init() !void {
    errdefer deinit();

    // Init the SDL library
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }

    // Create a window
    window = c.SDL_CreateWindow("Zig MicroUI Example", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, viewport_width, viewport_height, window_flags) orelse {
        c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    try readTexturePng(icon_dat, &icon_rw, &icon_surface);
    icon_loaded = true;

    try readTexturePng(atlas_dat, &atlas_rw, &atlas_surface);
    assert(c.SDL_LockSurface(atlas_surface) == 0); // Makes pixel pointer valid
    atlas_loaded = true;

    // Set window icon
    c.SDL_SetWindowIcon(window, icon_surface);

    // Create a 2D context for the window
    ctx_gl = c.SDL_GL_CreateContext(window) orelse {
        c.SDL_Log("Unable to create GL context: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    // Init OpenGL
    c.glEnable(c.GL_BLEND);
    c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);
    c.glDisable(c.GL_CULL_FACE);
    c.glDisable(c.GL_DEPTH_TEST);
    c.glEnable(c.GL_TEXTURE_2D);
    c.glEnableClientState(c.GL_VERTEX_ARRAY);
    c.glEnableClientState(c.GL_TEXTURE_COORD_ARRAY);
    c.glEnableClientState(c.GL_COLOR_ARRAY);

    // Init texture
    var texture_name: u32 = undefined;
    c.glGenTextures(1, &texture_name);
    c.glBindTexture(c.GL_TEXTURE_2D, texture_name);
    c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RGBA, atlas.width, atlas.height, 0, c.GL_RGBA, c.GL_UNSIGNED_BYTE, atlas_surface.pixels);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_NEAREST);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_NEAREST);
    assert(c.glGetError() == 0);
}

/// Performs cleanup of SDL etc... hence must be called before quitting.
pub fn deinit() void {
    c.SDL_GL_DeleteContext(ctx_gl);

    if (icon_loaded) {
        c.SDL_FreeSurface(icon_surface);
        _ = c.SDL_RWclose(icon_rw);
    }
    if (atlas_loaded) {
        c.SDL_FreeSurface(atlas_surface);
        _ = c.SDL_RWclose(atlas_rw);
    }

    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}

/// Handle window events. Returns true if the program should quit and false if 
/// not.
pub fn handleEvents(ctx: *c.mu_Context) bool {
    // Handle SDL events
    var e: c.SDL_Event = undefined;
    while (c.SDL_PollEvent(&e) != 0) {
        switch (e.type) {
            c.SDL_QUIT => return true,
            c.SDL_MOUSEMOTION => c.mu_input_mousemove(ctx, e.motion.x, e.motion.y),
            c.SDL_MOUSEWHEEL => c.mu_input_scroll(ctx, 0, e.wheel.y * -30),
            c.SDL_TEXTINPUT => c.mu_input_text(ctx, &e.text.text),

            c.SDL_MOUSEBUTTONDOWN, c.SDL_MOUSEBUTTONUP => {
                const button = switch (e.button.button) {
                    c.SDL_BUTTON_LEFT => c.MU_MOUSE_LEFT,
                    c.SDL_BUTTON_RIGHT => c.MU_MOUSE_RIGHT,
                    c.SDL_BUTTON_MIDDLE => c.MU_MOUSE_MIDDLE,
                    else => 0,
                };
                if (button != 0 and e.type == c.SDL_MOUSEBUTTONDOWN) {
                    c.mu_input_mousedown(ctx, e.button.x, e.button.y, button);
                }
                if (button != 0 and e.type == c.SDL_MOUSEBUTTONUP) {
                    c.mu_input_mouseup(ctx, e.button.x, e.button.y, button);
                }
            },

            c.SDL_KEYDOWN, c.SDL_KEYUP => {
                var mu_char = switch (e.key.keysym.sym) {
                    c.SDLK_LSHIFT => c.MU_KEY_SHIFT,
                    c.SDLK_RSHIFT => c.MU_KEY_SHIFT,
                    c.SDLK_LCTRL => c.MU_KEY_CTRL,
                    c.SDLK_RCTRL => c.MU_KEY_CTRL,
                    c.SDLK_LALT => c.MU_KEY_ALT,
                    c.SDLK_RALT => c.MU_KEY_ALT,
                    c.SDLK_RETURN => c.MU_KEY_RETURN,
                    c.SDLK_BACKSPACE => c.MU_KEY_BACKSPACE,
                    else => 0,
                };
                if (mu_char != 0 and e.@"type" == c.SDL_KEYDOWN) {
                    c.mu_input_keydown(ctx, mu_char);
                }
                if (mu_char != 0 and e.@"type" == c.SDL_KEYUP) {
                    c.mu_input_keyup(ctx, mu_char);
                }
            },

            c.SDL_WINDOWEVENT => {
                if (e.window.event == c.SDL_WINDOWEVENT_SIZE_CHANGED) {
                    assert(e.window.data1 >= 0);
                    assert(e.window.data2 >= 0);
                    const width: u32 = @intCast(u32, e.window.data1);
                    const height: u32 = @intCast(u32, e.window.data2);
                    handleResize(width, height);
                }
            },

            else => {},
        }
    }
    return false;
}

pub fn drawRect(rect: c.mu_Rect, color: c.mu_Color) void {
    pushQuad(rect, atlas.dict[atlas.white], color);
}

pub fn drawText(text: []const u8, pos: c.mu_Vec2, color: c.mu_Color) void {
    var dst: c.mu_Rect = .{ .x = pos.x, .y = pos.y, .w = 0, .h = 0 };
    for (text) |char| {
        const chr: u8 = if (char < 127) char else 127;
        const src: c.mu_Rect = atlas.dict[atlas.font + chr];
        dst.w = src.w;
        dst.h = src.h;
        pushQuad(dst, src, color);
        dst.x += dst.w;
    }
}

pub fn drawIcon(id: u32, rect: c.mu_Rect, color: c.mu_Color) void {
    const src: c.mu_Rect = atlas.dict[id];
    const x: i32 = @intCast(i32, rect.x) + @divExact(rect.w - src.w, 2);
    const y: i32 = @intCast(i32, rect.y) + @divExact(rect.h - src.h, 2);
    pushQuad(c.mu_rect(x, y, src.w, src.h), src, color);
}

pub fn textWidth(text: []const u8) u32 {
    var res: u32 = 0;
    for (text) |char| {
        const chr: u8 = if (char < 127) char else 127;
        const width: c_int = atlas.dict[atlas.font + chr].w;
        assert(width >= 0);
        res += @intCast(u32, width);
    }
    return res;
}

pub fn textHeight() u32 {
    return atlas.dict[atlas.font + 32].h;
}

pub fn rectClip(rect: c.mu_Rect) void {
    flush();
    c.glScissor(rect.x, viewport_height - (rect.y + rect.h), rect.w, rect.h);
}

/// Clear screen to default color
pub fn clear() void {
    flush();
    c.glClearColor(background_color[0], background_color[1], background_color[2], background_color[3]);
    c.glClear(c.GL_COLOR_BUFFER_BIT);
}

/// Update screen with whatever was rendered in this frame
pub fn present() void {
    flush();
    c.SDL_GL_SwapWindow(window);
    c.SDL_Delay(8); // Limit to ~120 fps
}

pub fn win_width() u16 {
    return viewport_width;
}

pub fn win_height() u16 {
    return viewport_height;
}

fn handleResize(width: u32, height: u32) void {
    assert(width >= 0 and width < 65536);
    assert(height >= 0 and height < 65536);
    viewport_width = @intCast(u16, width);
    viewport_height = @intCast(u16, height);
}

fn flush() void {
    if (buf_idx == 0) {
        return;
    }
    c.glViewport(0, 0, viewport_width, viewport_height);
    c.glMatrixMode(c.GL_PROJECTION);
    c.glPushMatrix();
    c.glLoadIdentity();
    c.glOrtho(0.0, @intToFloat(f64, viewport_width), @intToFloat(f64, viewport_height), 0.0, -1.0, 1.0);
    c.glMatrixMode(c.GL_MODELVIEW);
    c.glPushMatrix();
    c.glLoadIdentity();

    c.glTexCoordPointer(2, c.GL_FLOAT, 0, &tex_buf);
    c.glVertexPointer(2, c.GL_FLOAT, 0, &vert_buf);
    c.glColorPointer(4, c.GL_UNSIGNED_BYTE, 0, &color_buf);
    c.glDrawElements(c.GL_TRIANGLES, @intCast(c_int, buf_idx * 6), c.GL_UNSIGNED_INT, &index_buf);

    c.glMatrixMode(c.GL_MODELVIEW);
    c.glPopMatrix();
    c.glMatrixMode(c.GL_PROJECTION);
    c.glPopMatrix();

    buf_idx = 0;
}

fn readTextureBmp(bmp_data: []const u8, rwop: **c.SDL_RWops, surface: **c.SDL_Surface) !void {
    // Create a read only reader
    rwop.* = c.SDL_RWFromConstMem(
        @ptrCast(*const c_void, &bmp_data[0]),
        @intCast(c_int, bmp_data.len),
    ) orelse {
        c.SDL_Log("Unable to get RWFromConstMem: %s", c.SDL_GetError());
        return error.SDLImgLoadFailed;
    };
    errdefer assert(c.SDL_RWclose(rwop.*) == 0);

    // Create the surface
    surface.* = c.SDL_LoadBMP_RW(rwop.*, 0) orelse {
        c.SDL_Log("Unable to load bmp: %s", c.SDL_GetError());
        return error.SDLImgLoadFailed;
    };
    errdefer c.SDL_FreeSurface(surface.*);
}

fn readTexturePng(png_data: []const u8, rwop: **c.SDL_RWops, surface: **c.SDL_Surface) !void {
    // Create a read only reader
    rwop.* = c.SDL_RWFromConstMem(
        @ptrCast(*const c_void, &png_data[0]),
        @intCast(c_int, png_data.len),
    ) orelse {
        c.SDL_Log("Unable to get RWFromConstMem: %s", c.SDL_GetError());
        return error.SDLImgLoadFailed;
    };
    errdefer assert(c.SDL_RWclose(rwop.*) == 0);

    // Create the surface
    surface.* = c.IMG_LoadPNG_RW(rwop.*) orelse {
        c.SDL_Log("Unable to load png: %s", c.SDL_GetError());
        return error.SDLImgLoadFailed;
    };
    errdefer c.SDL_FreeSurface(surface.*);
}

fn pushQuad(dst: c.mu_Rect, src: c.mu_Rect, color: c.mu_Color) void {
    if (buf_idx == buffer_size) {
        flush();
    }

    const texvert_idx: u32 = buf_idx * 8;
    const color_idx: u32 = buf_idx * 16;
    const element_idx: u32 = buf_idx * 4;
    const index_idx: u32 = buf_idx * 6;
    buf_idx += 1;

    // Update texture buffer
    const x: f32 = @intToFloat(f32, src.x) / @intToFloat(f32, atlas.width);
    const y: f32 = @intToFloat(f32, src.y) / @intToFloat(f32, atlas.height);
    const w: f32 = @intToFloat(f32, src.w) / @intToFloat(f32, atlas.width);
    const h: f32 = @intToFloat(f32, src.h) / @intToFloat(f32, atlas.height);
    tex_buf[texvert_idx + 0] = x;
    tex_buf[texvert_idx + 1] = y;
    tex_buf[texvert_idx + 2] = x + w;
    tex_buf[texvert_idx + 3] = y;
    tex_buf[texvert_idx + 4] = x;
    tex_buf[texvert_idx + 5] = y + h;
    tex_buf[texvert_idx + 6] = x + w;
    tex_buf[texvert_idx + 7] = y + h;

    // Update vertex buffer
    vert_buf[texvert_idx + 0] = @intToFloat(f32, dst.x);
    vert_buf[texvert_idx + 1] = @intToFloat(f32, dst.y);
    vert_buf[texvert_idx + 2] = @intToFloat(f32, dst.x + dst.w);
    vert_buf[texvert_idx + 3] = @intToFloat(f32, dst.y);
    vert_buf[texvert_idx + 4] = @intToFloat(f32, dst.x);
    vert_buf[texvert_idx + 5] = @intToFloat(f32, dst.y + dst.h);
    vert_buf[texvert_idx + 6] = @intToFloat(f32, dst.x + dst.w);
    vert_buf[texvert_idx + 7] = @intToFloat(f32, dst.y + dst.h);

    // Update color buffer
    @memcpy(@ptrCast([*]u8, &color_buf[color_idx + 0]), @ptrCast([*]const u8, &color), 4);
    @memcpy(@ptrCast([*]u8, &color_buf[color_idx + 4]), @ptrCast([*]const u8, &color), 4);
    @memcpy(@ptrCast([*]u8, &color_buf[color_idx + 8]), @ptrCast([*]const u8, &color), 4);
    @memcpy(@ptrCast([*]u8, &color_buf[color_idx + 12]), @ptrCast([*]const u8, &color), 4);

    // Update index buffer
    index_buf[index_idx + 0] = element_idx + 0;
    index_buf[index_idx + 1] = element_idx + 1;
    index_buf[index_idx + 2] = element_idx + 2;
    index_buf[index_idx + 3] = element_idx + 2;
    index_buf[index_idx + 4] = element_idx + 3;
    index_buf[index_idx + 5] = element_idx + 1;
}
