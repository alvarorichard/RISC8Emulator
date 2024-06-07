
const std = @import("std");

pub fn build(b: *std.Build) void {
    
    const target = b.standardTargetOptions(.{});

    
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "RISC8Emulator",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    
    b.installArtifact(exe);
    exe.linkSystemLibrary("SDL2");
    exe.linkLibC();
  

    
    const run_cmd = b.addRunArtifact(exe);

    
    run_cmd.step.dependOn(b.getInstallStep());

    
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    
    const unit_tests = b.addTest(.{
        .root_source_file =  b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
