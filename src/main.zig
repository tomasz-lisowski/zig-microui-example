const std = @import("std");
pub const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_opengl.h");
    @cInclude("SDL2/SDL_image.h");
    @cInclude("microui.h");
});
const r = @import("renderer.zig");
const g = @import("gui.zig");

var alloc: *std.mem.Allocator = undefined;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    alloc = &arena.allocator;

    try r.init();
    defer r.deinit();

    try g.init(alloc);
    defer g.deinit();
    {
        var quit = false;
        while (!quit) {
            quit = r.handleEvents(g.ctx);
            g.processFrame();

            r.clear();
            g.draw();
            r.present();
        }
    }
}
