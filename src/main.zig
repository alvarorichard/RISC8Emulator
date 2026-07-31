const std = @import("std");
const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;
const Device = @import("device.zig").Device;
const CPU = @import("cpu.zig").CPU;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;

    var device = try Device.create(gpa, io);
    defer device.free();

    // Carrega a ROM: primeiro tenta o argumento de linha de comando,
    // senao pede o caminho de forma interativa.
    if (!loadRom(&device, io, init.minimal.args)) {
        std.debug.print("Nenhuma ROM carregada. Encerrando.\n", .{});
        return;
    }

    var bitmap = try Bitmap.create(gpa, 64, 32);
    defer bitmap.free();

    var display = try Display.create("CHIP-8", 800, 400, bitmap.width, bitmap.height);
    defer display.free();
    var cpu = CPU.create(&device.memory, &bitmap, &display, io);

    // Display loop
    const fps: f32 = 60.0;
    const frameInterval: i96 = @intFromFloat(1_000_000_000.0 / fps); // ns por frame
    var previousTime = std.Io.Clock.awake.now(io);

    while (display.open) {
        display.input();

        const currentTime = std.Io.Clock.awake.now(io);
        if (previousTime.durationTo(currentTime).nanoseconds > frameInterval) {
            previousTime = currentTime;

            cpu.cycle();

            display.draw(&bitmap);
        }
    }
}

/// Tenta carregar a ROM. Usa o argumento da linha de comando se presente;
/// caso contrario abre um prompt interativo. Retorna true se carregou.
fn loadRom(device: *Device, io: std.Io, args: std.process.Args) bool {
    var it = args.iterate();
    _ = it.skip(); // nome do programa

    // 1) Caminho passado como argumento: RISC8Emulator <rom>
    if (it.next()) |arg| {
        const path = std.mem.trim(u8, arg, " \t\r\n\"'");
        if (device.loadROM(path)) {
            std.debug.print("ROM carregada: {s}\n", .{path});
            return true;
        }
        std.debug.print("Nao foi possivel carregar a ROM: {s}\n", .{path});
        // cai para o modo interativo
    }

    // 2) Modo interativo: pede o caminho ao usuario.
    return promptRom(device, io);
}

/// Pergunta o caminho da ROM pelo terminal, com novas tentativas.
/// Enter vazio cancela. Retorna true se carregou.
fn promptRom(device: *Device, io: std.Io) bool {
    var buf: [4096]u8 = undefined;
    var stdin = std.Io.File.stdin().readerStreaming(io, &buf);
    const reader = &stdin.interface;

    std.debug.print(
        \\
        \\=== RISC8Emulator (CHIP-8) ===
        \\Digite o caminho de uma ROM e pressione Enter.
        \\(Enter vazio para sair; voce pode arrastar o arquivo para o terminal.)
        \\
    , .{});

    while (true) {
        std.debug.print("ROM> ", .{});

        const line = reader.takeDelimiterExclusive('\n') catch {
            // EOF (Ctrl-D) ou erro de leitura: encerra.
            std.debug.print("\n", .{});
            return false;
        };

        const path = std.mem.trim(u8, line, " \t\r\n\"'");
        if (path.len == 0) return false; // Enter vazio: cancela

        if (device.loadROM(path)) {
            std.debug.print("ROM carregada: {s}\n", .{path});
            return true;
        }
        std.debug.print("Arquivo invalido ou nao encontrado: {s}\nTente novamente.\n", .{path});
    }
}
