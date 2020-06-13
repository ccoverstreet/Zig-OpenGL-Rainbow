const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();

    var exe = b.addExecutable("Rainbows for Days", "src/main.zig");
    exe.linkSystemLibrary("c");
    exe.linkSystemLibrary("gl");
    exe.linkSystemLibrary("glfw");
    exe.install();


    const run_option = b.step("run", "Start OpenGL Rainbow");
    const run = exe.run();
    run.step.dependOn(b.getInstallStep());
    run_option.dependOn(&run.step);

    
}
