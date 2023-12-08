const std = @import("std");

pub const Bitmap = struct {
    
    const Self = @This();

    allocator: std.mem.Allocator,
    width: u8,
    height: u8,
    pixels: []u1,


    //cria bitmapa com tamanho especificado 
    pub fn create(allocator:std.mem.Allocator, width:u8, height:u8) !Self {
        //aloca pixel em array
        var pixels = try allocator.alloc(u1, @as(u16,width) * @as(u16,height));
        @memset(pixels, 0);

        return Self{
            .allocator = allocator,
            .width = width,
            .height = height,
            .pixels = pixels,
        };
      
    }

    // limpa bitmap

    pub fn free(self: *Self) void {
        self.allocator.free(self.pixels);
    }

    // limpar bitmap
     pub fn clear(self: *Self) void {
        @memset(self.pixels, 0);
    }


    // define pixel na posicao especificada

    pub fn setPixel(self: *Self, x:u8, y:u8 ) bool {

        if (x >= self.width or y >= self.height) {
            return false;
        }
    }

    // retorna pixel na posicao especificada

    pub fn getPixel(self: *Self, x:u8, y:u8 ) u1 {

        if (x >= self.width or y >= self.height) {
            return 0;
        }

        var  index = @as(u16,x) + @as(u16,y) * @as(u16,self.width);
        return self.pixels[index];
    }


};