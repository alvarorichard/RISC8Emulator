const std = @import("std");
const c = @import("c.zig");
const Bitmap = @import("bitmap.zig").Bitmap;

pub const Display = struct{
 
const Self = @This();

window: *c.SDL_Window,
open: bool,
renderer: *c.SDL_Renderer,
framebuffer: *c.SDL_Texture,
framebuffer_width: u8,
framebuffer_height: u8,
keys: [16]bool,

pub fn create(
    title: [*]const u8,
    width: i32,height: i32,
    framebuffer_width: u8,framebuffer_height: u8,
) !Self {
if(c.SDL_Init(c.SDL_INIT_VIDEO | c.SDL_INIT_AUDIO) != 0) {
  return error.SDLInitializationFailed;
}
  var window = c.SDL_CreateWindow(
  title,
  c.SDL_WINDOWPOS_UNDEFINED,c.SDL_WINDOWPOS_UNDEFINED,
  width,height,
  c.SDL_WINDOW_SHOWN,
) orelse {
  c.SDL_Quit();
  return error.SDLWindowCreationFailed;
};

var renderer = c.SDL_CreateRenderer(window,-1,c.SDL_RENDERER_ACCELERATED) orelse {
c.SDL_DestroyWindow(window);
c.SDL_Quit();
return error.SDLRendererCreationFailed;
};
var framebuffer = c.SDL_CreateTexture(
    renderer,
    c.SDL_PIXELFORMAT_ARGB8888,
    c.SDL_TEXTUREACCESS_STREAMING,
    framebuffer_width,framebuffer_height,
) orelse {
    c.SDL_DestroyRenderer(renderer);
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
    return error.SDLTextureNull;
};


return Self {
  .window = window,
  .renderer = renderer,
  .framebuffer = framebuffer,
  .framebuffer_width = framebuffer_width,
  .framebuffer_height = framebuffer_height,
  .open = true,
  .keys = std.mem.zeroes([16]bool), // New
};

}
//display livre 
pub fn free(self: *Self) void {
    c.SDL_DestroyWindow(self.window);
    c.SDL_Quit();
}

pub fn input(self: *Self) void {
    var event: c.SDL_Event = undefined;
    while(c.SDL_PollEvent(&event) != 0) {
      switch(event.@"type") {
        c.SDL_QUIT => {
          self.open = false;
        },
        c.SDL_KEYDOWN => {
          switch(event.@"key".@"keysym".@"scancode") {
            c.SDL_SCANCODE_1 => { self.keys[0x1] = true; },
            c.SDL_SCANCODE_2 => { self.keys[0x2] = true; },
            c.SDL_SCANCODE_3 => { self.keys[0x3] = true; },
            c.SDL_SCANCODE_4 => { self.keys[0xC] = true; },
            c.SDL_SCANCODE_Q => { self.keys[0x4] = true; },
            c.SDL_SCANCODE_W => { self.keys[0x5] = true; },
            c.SDL_SCANCODE_E => { self.keys[0x6] = true; },
            c.SDL_SCANCODE_R => { self.keys[0xD] = true; },
            c.SDL_SCANCODE_A => { self.keys[0x7] = true; },
            c.SDL_SCANCODE_S => { self.keys[0x8] = true; },
            c.SDL_SCANCODE_D => { self.keys[0x9] = true; },
            c.SDL_SCANCODE_F => { self.keys[0xE] = true; },
            c.SDL_SCANCODE_Z => { self.keys[0xA] = true; },
            c.SDL_SCANCODE_X => { self.keys[0x0] = true; },
            c.SDL_SCANCODE_C => { self.keys[0xB] = true; },
            c.SDL_SCANCODE_V => { self.keys[0xF] = true; },
            else => {},
          }
        },
        c.SDL_KEYUP => {
          switch(event.@"key".@"keysym".@"scancode") {
            c.SDL_SCANCODE_1 => { self.keys[0x1] = false; },
            c.SDL_SCANCODE_2 => { self.keys[0x2] = false; },
            c.SDL_SCANCODE_3 => { self.keys[0x3] = false; },
            c.SDL_SCANCODE_4 => { self.keys[0xC] = false; },
            c.SDL_SCANCODE_Q => { self.keys[0x4] = false; },
            c.SDL_SCANCODE_W => { self.keys[0x5] = false; },
            c.SDL_SCANCODE_E => { self.keys[0x6] = false; },
            c.SDL_SCANCODE_R => { self.keys[0xD] = false; },
            c.SDL_SCANCODE_A => { self.keys[0x7] = false; },
            c.SDL_SCANCODE_S => { self.keys[0x8] = false; },
            c.SDL_SCANCODE_D => { self.keys[0x9] = false; },
            c.SDL_SCANCODE_F => { self.keys[0xE] = false; },
            c.SDL_SCANCODE_Z => { self.keys[0xA] = false; },
            c.SDL_SCANCODE_X => { self.keys[0x0] = false; },
            c.SDL_SCANCODE_C => { self.keys[0xB] = false; },
            c.SDL_SCANCODE_V => { self.keys[0xF] = false; },
            else => {},
          }
        },
        else => {},
      }
    }
  }
pub fn draw(self: *Self, bitmap: *Bitmap) void {
  if(bitmap.width != self.framebuffer_width) return;
  if(bitmap.height != self.framebuffer_height) return;

  // You can use whatever colors you want
  const clear_value = c.SDL_Color {
    .r = 0,
    .g = 0,
    .b = 0,
    .a = 255,
  };
  const color_value = c.SDL_Color {
    .r = 255,
    .g = 255,
    .b = 255,
    .a = 255,
  };

  var pixels: ?*anyopaque = null;
  var pitch: i32 = 0;

  // Lock framebuffer so we can write pixel data to it
  if(c.SDL_LockTexture(self.framebuffer, null, &pixels, &pitch) != 0) {
    c.SDL_Log("Failed to lock texture: %s\n", c.SDL_GetError());
    return;
  }

  // Cast pixels pointer so that we can use offsets
  var upixels: [*]u32 = @ptrCast(@alignCast(pixels.?));

  // Copy pixel loop
  var y:u8 = 0;
  while(y < self.framebuffer_height) : (y += 1) {
    var x:u8 = 0;
    while(x < self.framebuffer_width) : (x += 1) {
      var index: usize = @as(usize, y) * @divExact(@as(usize, @intCast(pitch)), @sizeOf(u32)) + @as(usize, x);
      var color = if(bitmap.getPixel(x,y) == 1) color_value else clear_value;

      // It would probably be better to
      // use SDL_MapRGBA here but it was
      // giving me errors for some reason
      // and I'm too lazy to figure it out
      var r: u32 = @as(u32, color.r) << 24;
      var g: u32 = @as(u32, color.g) << 16;
      var b: u32 = @as(u32, color.b) << 8;
      var a: u32 = @as(u32, color.a) << 0;

      upixels[index] = r | g | b | a;
    }
  }

  _ = c.SDL_UnlockTexture(self.framebuffer);

  _ = c.SDL_RenderClear(self.renderer);
  _ = c.SDL_RenderCopy(self.renderer, self.framebuffer, null,null);
  _ = c.SDL_RenderPresent(self.renderer);
}

};










