const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("zig_microui_example", "src/main.zig");
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.linkSystemLibrary("OpenGL32");
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2_image");
    exe.linkLibC();
    exe.addIncludeDir("lib/microui/src");
    exe.addCSourceFile("lib/microui/src/microui.c", &[_][]const u8{
        "-std=c99",
        "-fno-sanitize=undefined", // To avoid "illegal instruction" errors
    });
    exe.install();

    const run: *std.build.Step = b.step("run", "Run the tool");
    const run_cmd: *std.build.RunStep = exe.run();
    // Forward cmd arguments to the program
    if (b.args) |args| run_cmd.addArgs(args);
    run.dependOn(&run_cmd.step);
}
