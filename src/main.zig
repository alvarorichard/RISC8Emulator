const std = @import("std");
const Display = @import("display.zig").Display;

pub fn main() !void {
   
   var display = try Display.create("RISC8Emulator", 800, 400);
   defer display.free();

   while (display.open) {
       display.input(); 
   }
}

