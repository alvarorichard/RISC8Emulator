const std = @import("std");
const Bitmap = @import("bitmap.zig").Bitmap;
const Display = @import("display.zig").Display;

pub const CPU = struct{

const Self = @This();

memory: *[]u8,
bitmap: *Bitmap,
display: *Display,
pc: u16,
i:u16,
dtimer:u8,
stimer:u8,
v: [16]u8,
stack: [16]u16,
stack_idx: u8,
paused:bool,
paused_x:u8,
speed:u8,

pub fn create(
    memory: *[]u8,
    bitmap: *Bitmap,
    display: *Display,
)Self {
    return Self{
        .memory = memory,
        .bitmap = bitmap,
        .display = display,
        .pc = 0x200,
        .i = 0,
        .dtimer = 0,
        .stimer = 0,
        .v = std.mem.zeroes([16]u8),
        .stack = std.mem.zeroes([16]u16),
        .stack_idx = 0,
        .paused = false,
        .paused_x = 0,
        .speed = 10,
    };
}


pub fn cycle(self:*Self) void{
    if (self.paused) {
        var i: u8 = 0;
        while (i < 16) :(i  += 1){
            if(self.display.keys[i]){
                self.paused = false;
                self.v[self.paused_x] = i;
            }
        }
    }
}

  var i: u8 = 0;
    while(i < self.speed) : (i += 1) {
     // Não estamos executando instruções
    // se o emulador estiver pausado
    if(!self.paused) {
         // Os opcodes do CHIP-8 têm dois bytes de comprimento
        // .* é usado para desreferenciar ponteiros em Zig
        var opcode: u16 = (@as(u16, self.memory.*[self.pc]) << 8 | @as(u16, self.memory.*[self.pc+1]));
        self.executeInstruction(opcode);
      }
    
    }

    if(!self.paused) {
      self.updateTimers();
    }

    self.playSound();
     
     // autaliza o timers 
    fn updateTimers(self: *Self) void {
    if(self.dtimer > 0) self.dtimer -= 1;
    if(self.stimer > 0) self.stimer -= 1;
  }
    
  };











