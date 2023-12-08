const std = @import("std");

pub const Bitmap = struct {
    
    const Self = @This();

    allocator: std.mem.Allocator,
    width: u8,
    height: u8,
    pixels: []u1,


    //cria bitmapa com tamanho especificado 
    pub fn create(allocator:std.mem.Allocator, width:u8, height:u8) !Self {
        _ = height;
        _ = width;
        _ = allocator;
      
    }

    // limpa bitmap

    pub fn free(self: *Self) void {
        _ = self;
    }

    // define pixel na posicao especificada

    pub fn setPixel(self: *Self, x:u8, y:u8 ) bool {
        _ = self;
        _ = x;
        _ = y;
    }

    // retorna pixel na posicao especificada

    pub fn getPixel(self: *Self, x:u8, y:u8 ) u1 {
        _ = self;
        _ = x;
        _ = y;
    }


};