const std = @import("std");
const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;    // New
const Device = @import("device.zig").Device;  

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  const allocator = gpa.allocator();
  defer {
    const leaked = gpa.deinit();
    if(leaked == .leak) {
      @panic("MEMORY LEAK");
    }
  }

  // New
  var bitmap = try Bitmap.create(allocator, 64,32);
  defer bitmap.free();
  _ = bitmap.setPixel(5,5);

  var display = try Display.create("CHIP-8", 800,400, bitmap.width,bitmap.height);
  defer display.free();

  // Display loop
  while(display.open) {
    display.input();
    display.draw(&bitmap); // New
  }

  var device = try Device.create(allocator);
defer device.free();

if(!device.loadROM("./roms/blitz.rom")) {
  std.debug.print("Failed to load CHIP-8 ROM\n", .{});
  return;
}

}