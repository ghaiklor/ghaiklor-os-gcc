# ghaiklor-os-gcc

This is not a **REAL** operation system.
It's just a simple operation system created in educational purposes.

The main goal I'm following is to learn how OS is working from the ground up.
Starting from the own boot sector, hardware and software interrupts, own drivers.

Repository is suffixed with gcc because I'm planning to write another one simple OS with Rust.
So, I hope, there will be _ghaiklor-os-gcc_ and _ghaiklor-os-rustc_.

## Demo

| Hello, World                                                                                                |
| ----------------------------------------------------------------------------------------------------------- |
| ![OS](https://cloud.githubusercontent.com/assets/3625244/15702861/fcdd8794-27ea-11e6-8e42-1700f8ba3905.gif) |

## Roadmap

- Boot sector:
  - Reads the kernel from disk into memory (**DONE**)
  - Describes Global Descriptor Table (**DONE**)
  - Switches to 32-bit Protected Mode (**DONE**)
  - Checks if CPU support 64-bit Long Mode and switches into (**DONE**)
  - In case, if 64-bit Long Mode isn't supported, fallback into 32-bit (**DONE**)
  - Gives execution to kernel (**DONE**)
- Kernel:
  - Kernel entry in assembly, which calls extern kernel_main() in C (**DONE**)
  - Low-level I/O functions: _port_byte_in_, _port_byte_out_ and similar (**DONE**)
  - Interrupt Descriptor Table (**DONE**)
  - Interrupt Service Routines and their mapping to IDT (**DONE**)
  - Handling Interrupt Requests (IRQ) (**DONE**)
  - Handling IRQ0 of Programmable Interval Timer (**DONE**)
- Drivers:
  - _screen_ driver implements printing to the screen (**DONE**)
  - _keyboard_ driver listen for IRQ1 interrupt and handle it (**DONE**)
- Shell:
  - Implement simple echo shell (**DONE**)

## Project Structure

- [__boot__](./boot) - source code related to boot sector
- [__cpu__](./cpu) - source code related to specific CPU architecture
- [__drivers__](./drivers) - source code related to drivers implementation
- [__include__](./include) - header files for common cases
- [__kernel__](./kernel) - source code related to kernel
- [__libc__](./libc) - source code of common libraries

## Makefile

_ghaiklor-os-gcc_ consists of two files in raw binary format: _boot.bin_ and _kernel.bin_.
They are located in _boot/boot.bin_ and _kernel/kernel.bin_ accordingly after compile.

_boot.bin_ is compiled via _nasm_.
Makefile takes _boot/boot.asm_ and calls `nasm boot/boot.asm -f bin -o boot/boot.bin`.
_nasm_ handles includes from sub-folders itself, so __all__ assembly files will be compiled to binary.
Nothing else, simple.

_kernel.bin_ is compiled via cross-compiler _gcc_ and _ld_ that you must install.
Take a look into [Development Environment](#development-environment) section.
After cross-compiler is installed, we can take sources from _cpu_, _drivers_, _include_, _kernel_ and _libc_ folders recursively.
All *.c* files are compiled via `gcc`.
Compiled object files are used for compiling _kernel.bin_ then, via _ld_ -
`ld -o kernel/kernel.bin -Ttext 0x1000 <OBJ_FILES> --oformat binary`.

_os-image.bin_ is ~~compiled~~ concatenate of _boot.bin_ and _kernel.bin_.
Easily achieved with `cat boot/boot.bin kernel/kernel.bin > os-image.bin`.

## Development Environment

I'd wrote `bootstrap.sh` script, that you can run.
It will install all the needed dependencies for your host machine.

```shell
bash bootstrap.sh
```

## How it works?

### BIOS

When a computer is switched on or reset, it runs through a series of diagnostics called POST - Power-On-Self-Test.
This sequence culminates in locating a bootable device, such as a floppy, cdrom or a hard disk.

A device is bootable if it carries a boot sector with the byte sequence `0x55`, `0xAA` in bytes 511 and 512 respectively.
When the BIOS finds such a boot sector, it is loaded into memory at `0x0000:0x7C00`.

### Boot Sector

#### Boot Signature

A simple implementation of bootable device:

```asm
jmp $

times 510 - ($-$$) db 0
dw 0xAA55
```

`$ - $$` results in `CURRENT_POINTER - START_POINTER`.
That way we are calculating how long our boot record is.
Afterwards, we are substract 510 from it and filling with zeros, getting the 512 bytes boot record with boot sector signature.

For instance, we have `$ - $$` equal to 100.
So, we have `510 - 100 = 410` free bytes.
We are filling these 410 bytes with zeros.
And the last two bytes 511 and 512 are bootable signature which we are filling with `dw 0xAA55`.

Done! We have our bootable device and can replace our `jmp $` with any code you like.

[Boot Sector Implementation](./boot/boot.asm)

#### Real Mode

At the beginning our code is running in Real Mode.

Real Mode is a simplistic 16-bit mode that is present on all x86 processors.
Real Mode was the first x86 mode design and was used by many early operating systems.
For compatibility purposes, all x86 processors begin execution in Real Mode.

What's bad and good in Real Mode?

Cons
- Less than 1 MB of RAM is available for use.
- There is no hardware-based memory protection (GDT), nor virtual memory.
- There is no built in security mechanisms to protect against buggy or malicious applications.
- The default CPU operand length is only 16 bits.
- The memory addressing modes provided are more restrictive than other CPU modes.
- Accessing more than 64k requires the use of segment register that are difficult to work with.

Pros
- The BIOS installs device drivers to control devices and handle interrupt.
- BIOS functions provide operating systems with a advanced collection of low level API functions.
- Memory access is faster due to the lack of descriptor tables to check and smaller registers.

Due to the many limitations and problems that Real Mode has, we need to switch to Protected Mode.

#### Protected Mode

Protected Mode is the main operating mode of modern Intel processors since the 80286.
It allows working with several virtual address spaces, each of which has a maximum of 4 GB of addressable memory.

Since CPU initialized by the BIOS starts in Real Mode, switching to Protected Mode prevents you from using most of the BIOS interrupts.
Before switching to Protected Mode, you have to disable interrupts, including NMI, enable A20 line and load Global Descriptor Table.

Algorithm for switching to Protected Mode:

```asm
cli
lgdt [gdt_descriptor]
mov eax, cr0
or eax, 0x1
mov cr0, eax
jmp CODE_SEG:init_pm
```

[Implementation for switching to PM](./boot/pm/switch_to_pm.asm)

[Global Descriptor Table](./boot/pm/gdt.asm)

But, we can go further...

#### Long Mode

What is long mode and why set it up?

Since the introduction of the x86-64 processors a new mode has been introduced as well, which is called Long Mode.
Long Mode basically consists out of two sub modes which are the actual 64-bit mode and compatibility mode (32-bit).

What we are interested in is simply the 64-bit mode as this mode provides a lot of new features such as:

- Registers being extended to 64-bit (rax, rcx, rdx, etc...);
- Eight new general-purpose registers (r8 - r15);
- Eight new multimedia registers (xmm8 - xmm15);

Before switching into Long Mode, we **must** check if CPU supports this mode.
In case, if CPU doesn't support Long Mode, we need to fallback to Protected Mode.

[Detect if Long Mode supports](./boot/lm/detect_lm.asm)

[If so, switch to Long Mode](./boot/lm/switch_to_lm.asm)

#### Loading the Kernel

All these modes are great, but we can't write an operating system in 512 bytes.
So, our boot sector **must** know how to load our compiled kernel from hard disk.

When we are in Real Mode, we can use BIOS interrupts for reading from the disk.
In our case, is `INT 13,2 - Read Disk Sectors`.

How to use it?

```asm
;; al = number of sectors to read (1 - 128)
;; ch = track/cylinder number
;; cl = sector number
;; dh = head number
;; dl = drive number
;; bx = pointer to buffer
mov ah, 0x02
mov al, 15
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
mov dl, 0
mov bx, KERNEL_OFFSET_IN_MEMORY
int 0x13
```

This code results into reading from hard disk into address `KERNEL_OFFSET_IN_MEMORY`.
It reads 15 sectors starting from the second one and stores it by address `KERNEL_OFFSET_IN_MEMORY`.

Since our compiled OS image is a concatenation of boot sector and kernel,
and we know that our boot sector is 512 bytes, we can be sure, that our kernel starts in second sector.

When reading is successfully completed, we can call instruction at our `KERNEL_OFFSET_IN_MEMORY` and give execution to the kernel.

```asm
call KERNEL_OFFSET_IN_MEMORY
jmp $
```

[Implementation for Disk Read](./boot/disk/disk_read.asm)

#### Summary about Boot Sector

We can draw a line here about our boot sector.
The flow is simple:

- BIOS detects our image as bootable since [boot signature](#boot-signature);
- Load the kernel from disk into memory via [INT 13,2](#loading-the-kernel);
- Switch to [Protected Mode](#protected-mode);
- Check if we can switch into [Long Mode](#long-mode) with fallback into Protected Mode;
- Give execution to kernel via simple `call` instruction;

At this step, our boot sector finished its work and starts working with the kernel.

You can navigate through [boot sources](./boot) and try to get how it works.

### Kernel

#### Kernel Entry in Assembly

When we are calling instruction by address, we can got a few problems.
We can't sure, that instruction by address is a `kernel_main()`.
Solution is simple.

We can write a sub-routine that is attached to the start of the kernel code.
This sub-routine call extern function of our kernel - `kernel_main()`.
When object files will be linked together, this call will be translated into call of our `kernel_main()`.

```asm
global _start

[bits 32]
[extern kernel_main]

_start:
  call kernel_main
  jmp $
```

[Kernel Entry Implementation](./boot/kernel_entry.asm)

#### Kernel Entry in C

At this step, we have an entry-point to our `kernel_main()` method.
And that is our entry-point for entire kernel.

I think, is boring to explain how `#include` works and what happens in our `kernel_main()`.
You easily can follow the methods that I'm calling from it.

[Kernel Entry in C](./kernel/kernel.c)

### Building

#### Building the Boot Sector

That is the simplest part.

We need to build `boot/boot.bin` image in raw binary format.
To do so, we call `nasm` assembler with special flags.

```shell
nasm boot/boot.asm -f bin -o boot/boot.bin
```

It results into raw binary format that you can run via qemu.

At this step, we have working compiled boot sector.

#### Building the Kernel

We need to build the all sources from all folders recursively, except the `boot` folder.

All C files are compiled to object files via `gcc` and Assembly files via `nasm`:

```shell
gcc -g -ffreestanding -Wall -Wextra -fno-exceptions -m32 -std=c11 -c <SOURCE> -o <OBJ_FILE>
nasm <SOURCE> -f elf -o <OBJ_FILE>
```

It results into all needed object files for linking to raw binary format.
All what's left to do is link them together via `ld`:

```shell
ld -o kernel/kernel.bin -Ttext 0x1000 kernel/kernel_entry.o <OBJ_FILES> --oformat binary
```

Note that `kernel/kernel_entry.o` at first place since we have an issue with calling the `kernel_main()`.
This way, we guarantee that first instruction will be called from our `boot/kernel_entry.asm`.

After all, we have compiled kernel image in raw binary format.

#### Building the OS image

Since, our boot sector and kernel is raw binary formats, we can just concatenate them.

```shell
cat boot/boot.bin kernel/kernel.bin > os-image.bin
```

Now, we can run `os-image.bin` via `qemu-system-i386`.
BIOS trying to locate bootable sector, find out our `boot/boot.bin` and sees signature.
Starts executing our Assembly code at `boot/boot.bin` which loads our `kernel/kernel.bin` via INT 13,2 into memory and executes it.

That's how it all works together.
Feel free to navigate through the [project](#project-structure), thanks :smiley_cat:

## License

The MIT License (MIT)

Copyright (c) 2016 Eugene Obrezkov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
