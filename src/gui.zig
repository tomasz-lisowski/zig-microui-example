const std = @import("std");
const assert = std.debug.assert;

const main = @import("main.zig");
const c = main.c;
const renderer = @import("renderer.zig");

pub var ctx: *c.mu_Context = undefined;

pub fn init(allocator: *std.mem.Allocator) !void {
    ctx = try allocator.create(c.mu_Context);
    c.mu_init(ctx);
    ctx.text_width = textWidthWrapper;
    ctx.text_height = textHeightWrapper;
}

pub fn deinit() void {}

/// What creates the UI layout and elements
pub fn processFrame() void {
    c.mu_begin(ctx);
    processMainWindow();
    c.mu_end(ctx);
}

pub fn draw() void {
    var cmd: ?*c.mu_Command = null;
    while (c.mu_next_command(ctx, &cmd) != 0) {
        if (cmd == null) {
            break; // No commands
        }
        switch (cmd.?.type) {
            c.MU_COMMAND_TEXT => {
                const text_orig: [*]u8 = @ptrCast([*]u8, &cmd.?.text.str);
                var text_len: u16 = 0;
                {
                    var char_idx: u16 = 0;
                    while (text_orig[char_idx] != 0) : (char_idx += 1) {}
                    text_len = char_idx;
                }
                renderer.drawText(text_orig[0..text_len], cmd.?.text.pos, cmd.?.text.color);
            },
            c.MU_COMMAND_RECT => {
                renderer.drawRect(cmd.?.rect.rect, cmd.?.rect.color);
            },
            c.MU_COMMAND_ICON => {
                const icon_id = @intCast(u32, cmd.?.icon.id);
                renderer.drawIcon(icon_id, cmd.?.icon.rect, cmd.?.icon.color);
            },
            c.MU_COMMAND_CLIP => {
                renderer.rectClip(cmd.?.clip.rect);
            },
            else => {},
        }
    }
}

fn textWidthWrapper(font: c.mu_Font, text: [*c]const u8, text_len: c_int) callconv(.C) c_int {
    if (text_len < -1) {
        return 0;
    }
    const text_len_u = if (text_len == -1) std.mem.len(text) else @intCast(u32, text_len);
    const text_arr: []const u8 = text[0..text_len_u];
    return @intCast(c_int, renderer.textWidth(text_arr));
}

fn textHeightWrapper(font: c.mu_Font) callconv(.C) c_int {
    return @intCast(c_int, renderer.textHeight());
}

fn processMainWindow() void {
    const width: u16 = renderer.win_width();
    const height: u16 = renderer.win_height();
    // Flags for a full screen window
    const window_flags = c.MU_OPT_NOINTERACT | c.MU_OPT_NORESIZE | c.MU_OPT_NOCLOSE | c.MU_OPT_NOTITLE;
    const text_padding_y: u16 = 2;
    const text_padding_x: u16 = 10;
    if (c.mu_begin_window_ex(ctx, "Main Window", c.mu_rect(0, 0, 0, 0), window_flags) != 0) {
        // Make window fill screen
        const container: *c.mu_Container = c.mu_get_current_container(ctx);
        container.rect.w = width;
        container.rect.h = height;

        c.mu_layout_row(ctx, 2, &[_]i32{ 120, -1 }, renderer.textHeight() + text_padding_y);

        c.mu_label(ctx, "First:");
        if (c.mu_button(ctx, "Button1") != 0) {
            std.debug.print("Button1 pressed\n", .{});
        }

        c.mu_label(ctx, "Second:");
        if (c.mu_button(ctx, "Button2") != 0) {
            c.mu_open_popup(ctx, "My Popup");
        }

        const popup_name = "My Popup";
        const popup_content = "Hello world!";
        if (c.mu_begin_popup(ctx, popup_name) != 0) {
            c.mu_layout_row(ctx, 1, &[_]i32{renderer.textWidth(popup_content) + text_padding_x}, renderer.textHeight() + text_padding_y);
            c.mu_label(ctx, popup_content);
            c.mu_end_popup(ctx);
        }
        c.mu_end_window(ctx);
    }
}
