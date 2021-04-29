const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("zig_microui_example", "src/main.zig");
    exe.setBuildMode(mode);
    exe.linkSystemLibrary("OpenGL32");
    exe.linkSystemLibrary("SDL2");
    exe.linkSystemLibrary("SDL2_image");
    exe.linkSystemLibrary("c");
    exe.addIncludeDir("lib/microui/src");
    exe.addCSourceFile("lib/microui/src/microui.c", &[_][]const u8{
        "-std=c99",
        "-fno-sanitize=undefined", // To avoid "illegal instruction" errors
    });
    exe.install();

    const run = b.step("run", "Run the tool");
    const run_cmd = exe.run();
    run.dependOn(&run_cmd.step);
}
