const std = @import("std");

pub const Bitmap = struct {
    
    const Self = @This();

    allocator: std.mem.Allocator,
    width: u8,
    height: u8,
    pixels: []u1,

pub fn create(allocator: std.mem.Allocator, width: u8,height: u8) !Self {
  // Allocate pixel array
  const pixels = try allocator.alloc(u1, @as(u16, width) * @as(u16, height));
  @memset(pixels, 0);

  return Self {
    // We save the allocator so we can free our allocated data with it later
    .allocator = allocator,
    .width = width,
    .height = height,
    .pixels = pixels,
  };
}

// Free Bitmap
pub fn free(self: *Self) void {
  // Free allocated data with allocator
  self.allocator.free(self.pixels);
}

// Clear Bitmap to specified value
pub fn clear(self: *Self, value: u1) void {
  @memset(self.pixels, value);
}

// Set pixel value at x,y coordinate
pub fn setPixel(self: *Self, x: u8,y: u8) bool {
  // Return if x or y is invalid
  if(x >= self.width or y >= self.height) return false;

  const index: u16 = @as(u16, x) + @as(u16, y) * @as(u16, self.width);
  self.pixels[index] ^= 1;
  return (self.pixels[index] == 0);
}

// Get pixel value at x,y coordinate
pub fn getPixel(self: *Self, x: u8,y: u8) u1 {
  // Return if x or y is invalid
  if(x >= self.width or y >= self.height) return 0;

  const index: u16 = @as(u16, x) + @as(u16, y) * @as(u16, self.width);
  return self.pixels[index];
}

};