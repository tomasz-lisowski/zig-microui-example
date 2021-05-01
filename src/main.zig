const std = @import("std");
pub const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_opengl.h");
    @cInclude("SDL2/SDL_image.h");
    @cInclude("microui.h");
});
const renderer = @import("renderer.zig");
const gui = @import("gui.zig");

var alloc: *std.mem.Allocator = undefined;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    alloc = &arena.allocator;

    try renderer.init();
    defer renderer.deinit();

    try gui.init(alloc);
    defer gui.deinit();
    {
        while (!renderer.handleEvents()) {
            gui.processFrame();

            renderer.clear();
            gui.draw();
            renderer.present();
        }
    }
}
