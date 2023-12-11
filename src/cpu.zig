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


  pub fn cycle(self: *Self) void {
    if(self.paused) {
      var i: u8 = 0;
      while(i < 16) : (i += 1) {
        if(self.display.keys[i]) {
          self.paused = false;
          self.v[self.paused_x] = i;
        }
      }
    }

  var i: u8 = 0;
while(i < self.speed) : (i += 1){
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
    }
      
     
     // autaliza o timers 
    fn updateTimers(self: *Self) void {
    if(self.dtimer > 0) self.dtimer -= 1;
    if(self.stimer > 0) self.stimer -= 1;
  }

  fn playSound(self: *Self) void {
    if(self.stimer > 0) {
      // TODO
    } else {
      // TODO
    }
  }
//Empilhar endereço na pilha

fn stackPush(self:*Self,address:u16) void{
    if (self.stack_idx > 15) return;


    self.stack[self.stack_idx] = address;
    self.stack_idx += 1; 
}

//Desempilhar endereço da pilha

fn stackPop(self:*Self) u16{
    if (self.stack_idx == 0) return 0;

   var value = self.stack[self.stack_idx-1];
    self.stack_idx -= 1;
    return value;

}

//Executar instrução 

    fn executeInstruction(self: *Self, opcode: u16) void {
    self.pc += 2;

    var x = (opcode & 0x0F00) >> 8;
    _ = x;
    var y = (opcode & 0x00F0) >> 4;
    _ = y;

    // Grande switch de opcodes
    switch(opcode & 0xF000) {
      0x0000 => {
        switch(opcode) {
          0x00E0 => {},
          0x00EE => {},
          else => {},
        }
      },
      0x1000 => {},
      0x2000 => {},
      0x3000 => {},
      0x4000 => {},
      0x5000 => {},
      0x6000 => {},
      0x7000 => {},
      0x8000 => {
        switch(opcode & 0xF) {
          0x0 => {},
          0x1 => {},
          0x2 => {},
          0x3 => {},
          0x4 => {},
          0x5 => {},
          0x6 => {},
          0x7 => {},
          0xE => {},
          else => {},
        }
      },
      0x9000 => {},
      0xA000 => {},
      0xB000 => {},
      0xC000 => {},
      0xD000 => {},
      0xE000 => {
        switch(opcode & 0xFF) {
          0x9E => {},
          0xA1 => {},
          else => {},
        }
      },
      0xF000 => {
        switch(opcode & 0xFF) {
          0x07 => {},
          0x0A => {},
          0x15 => {},
          0x18 => {},
          0x1E => {},
          0x29 => {},
          0x33 => {},
          0x55 => {},
          0x65 => {},
          else => {},
        }
      },
      else => {},
    }
  }
};











