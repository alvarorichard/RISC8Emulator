# RISC8Emulator

## Overview
**RISC8Emulator** is a software recreation of the CHIP-8 system, a simple computer from the mid-1970s primarily used for playing video games. Written in Zig, a modern programming language, this emulator replicates the architecture and functionality of the original CHIP-8, offering a unique experience for retro gaming and computer history enthusiasts.

## Features
- **Memory**: Emulates the CHIP-8's 4 KB RAM.
- **Display**: Simulates the 64x32 pixel monochrome display.
- **Program Counter (PC)**: Manages the flow of the program.
- **Index Register (I)**: A 16-bit register for pointing to memory locations.
- **Stack**: Utilized for storing 16-bit addresses for function calls and returns.
- **Delay Timer**: An 8-bit timer decrementing at a rate of 60 Hz.
- **Sound Timer**: Similar to the delay timer but emits a beep when not zero.
- **Registers**: Comprises 16 8-bit general-purpose registers (V0-VF).

## File Structure
- `main.zig`: Entry point of the application, initializing the emulator.
- `display.zig`: Handles the CHIP-8's monochrome display.
- `device.zig`: Integrates components like memory and display.
- `cpu.zig`: Responsible for the CPU functionality and instruction execution.
- **ROM Requirement**: To run a game, a CHIP-8 ROM file must be added. This emulator does not come with any preloaded games, so you need to provide your own ROM.
- **`c.zig` File**: This file is used to import the SDL2 library from C, facilitating graphical output and input handling.
- `bitmap.zig`: Manages bitmap operations for graphics.

## Prerequisites
- Zig programming language version 0.11 installed on your system.
- Familiarity with Zig language and CHIP-8 architecture.

## Installation
1. Clone the repository:
```bash
git clone https://github.com/alvarorichard/RISC8Emulator.git
 ```

1. Navigate to the project directory:
```bash
cd RISC8Emulator
```

## Running the Emulator

Execute the main.zig file with the Zig compiler to run the emulator:

```bash 
zig run main.zig
```
 or just run :

 ```c
 zig build
 ```



## Contributing

Contributions to improve or enhance the emulator are always welcome. Please adhere to the standard pull request process for contributions.




