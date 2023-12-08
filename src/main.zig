const std = @import("std");
const Display = @import("display.zig").Display;
const Bitmap = @import("bitmap.zig").Bitmap;

pub fn main() !void {
   
   var display = try Display.create("RISC8Emulator", 800, 400);
   defer display.free();

   while (display.open) {
       display.input(); 
   }

   var gpa = std.heap.GeneralPurposeAllocator(.{}){};
   const allocator = gpa.allocator();
   defer{
    const leaked = gpa.deinit();
    if (leaked == .leak) {
        @panic("VAZAMENTO DE MEMORIA");
    }
}
    var bitmap = try Bitmap.create(allocator,64,32);
    defer bitmap.free();
}



