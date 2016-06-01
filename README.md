# ghaiklor-os-gcc

This is not a **REAL** operation system.
It's just a simple operation system created in educational purposes.

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
