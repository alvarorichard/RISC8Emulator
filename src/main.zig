const std = @import("std");
const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;    
const Device = @import("device.zig").Device;
const CPU = @import("cpu.zig").CPU;  

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const allocator = gpa.allocator();
  defer {
    const leaked = gpa.deinit();
    if(leaked == .leak) {
      @panic("MEMORY LEAK");
    }
  }

    var device = try Device.create(allocator);
defer device.free();

if(!device.loadROM("/home/krone/RISC8Emulator/src/roms/tetris.rom")) {
  std.debug.print("Erro ao carregar  CHIP-8 ROM\n", .{});
  return;
}

  // Novo
  var bitmap = try Bitmap.create(allocator, 64,32);
  defer bitmap.free();
  //_ = bitmap.setPixel(5,5);

  var display = try Display.create("CHIP-8", 800,400, bitmap.width,bitmap.height);
  defer display.free();
  var cpu = CPU.create(&device.memory, &bitmap,&display);

  // Display loop
const fps: f32 = 60.0;
const fpsInterval = 1000.0 / fps;
var previousTime = std.time.milliTimestamp();
var currentTime = std.time.milliTimestamp();

while(display.open) {
  display.input();

  currentTime = std.time.milliTimestamp();
  if(@as(f32, @floatFromInt(currentTime - previousTime)) > fpsInterval) {
    previousTime = currentTime;

    cpu.cycle();

    display.draw(&bitmap);
  }
}



}