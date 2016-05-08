# ghaiklor-os-gcc

This is not a **REAL** operation system.
It's just a simple operation system created in educational purposes.

Repository is suffixed with gcc because I'm planning to write another one simple OS with Rust.
So, I hope, there will be _ghaiklor-os-gcc_ and _ghaiklor-os-rustc_.

## Roadmap

- Boot sector:
  - Reads the kernel from disk into memory (**DONE**)
  - Describes Global Descriptor Table (**DONE**)
  - Switches to 32-bit Protected Mode (**DONE**)
  - Gives execution to kernel (**DONE**)
- Kernel:
  - Kernel entry in assembly, which calls extern main() in C (**DONE**)
  - Kernel methods like _memory_copy_ (*IN PROGRESS*)
  - Interrupt handling (_TODO_)
  - Memory management: physical and virtual (_TODO_)
  - DMA - Direct Memory Access (_TODO_)
  - Process Management (_TODO_)
- Drivers:
  - _ports_ driver for low-level I/O functions (**DONE**)
  - _screen_ driver (*IN PROGRESS*)
  - _keyboard_ driver (_TODO_)
  - _vfs_ driver (_TODO_)
  - _vga_ driver (_TODO_)

## Project Structure

- [__boot__](./boot) - source code related to boot sector
- [__drivers__](./drivers) - source code related to drivers implementation
- [__kernel__](./kernel) - source code related to kernel

## Makefile

_ghaiklor-os-gcc_ consists of two files in raw binary format: _boot.bin_ and _kernel.bin_.
They are located in _boot/boot.bin_ and _kernel/kernel.bin_ accordingly after compile.

_boot.bin_ is compiled via _nasm_.
Makefile takes _boot/boot.asm_ and calls `nasm boot/boot.asm -f bin -o boot/boot.bin`.
_nasm_ handles includes from sub-folders itself, so __all__ assembly files will be compiled to binary.
Nothing else, simple.

_kernel.bin_ is compiled via cross-compiler _gcc_ and _ld_ that you must install.
Take a look into [Development Environment](#development-environment) section.
After cross-compiler is installed, we can take sources from _kernel_ and _drivers_ folders recursively.
All *.c* files are compiled via `gcc -ffreestanding -c <FILE> -o <OBJ>`.
Compiled object files are used for compiling _kernel.bin_ then, via _ld_ -
`ld -o kernel/kernel.bin -Ttext 0x1000 <OBJ_FILES> --oformat binary`.

_os-image.bin_ is ~~compiled~~ concatenate of _boot.bin_ and _kernel.bin_.
Easily achieved with `cat boot/boot.bin kernel/kernel.bin > os-image.bin`.

## Development Environment

### Mac OS X

```shell
# Set environment variables
export PREFIX="$HOME/opt/"
export TARGET=x86_64-pc-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $HOME/src
mkdir -p $PREFIX

# Install dependencies via brew
brew install gmp mpfr libmpc autoconf automake nasm xorriso qemu

# Install binutils
cd $HOME/src
curl -O http://ftp.gnu.org/gnu/binutils/binutils-2.26.tar.gz
tar xfz binutils-2.26.tar.gz
rm binutils-2.26.tar.gz
mkdir -p build-binutils
cd build-binutils
../binutils-2.26/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

# Install cross-compiler gcc
cd $HOME/src
curl -O http://www.netgull.com/gcc/releases/gcc-5.3.0/gcc-5.3.0.tar.gz
tar xfz gcc-5.3.0.tar.gz
rm gcc-5.3.0.tar.gz
mkdir -p build-gcc
cd build-gcc
../gcc-5.3.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers --with-gmp=/usr/local/Cellar/gmp/6.1.0 --with-mpfr=/usr/local/Cellar/mpfr/3.1.3 --with-mpc=/usr/local/Cellar/libmpc/1.0.3
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc

# Install objconv
cd $HOME/src
curl http://www.agner.org/optimize/objconv.zip > objconv.zip
mkdir -p build-objconv
unzip objconv.zip -d build-objconv
cd build-objconv
unzip source.zip -d src
g++ -o objconv -O2 src/*.cpp --prefix="$PREFIX"
cp objconv $PREFIX/bin

# Install grub (optional)
# If you want to make boot with Multiboot support
cd $HOME/src
git clone --depth 1 git://git.savannah.gnu.org/grub.git
cd grub
sh autogen.sh
mkdir -p build-grub
cd build-grub
../configure --disable-werror TARGET_CC=$TARGET-gcc TARGET_OBJCOPY=$TARGET-objcopy TARGET_STRIP=$TARGET-strip TARGET_NM=$TARGET-nm TARGET_RANLIB=$TARGET-ranlib --target=$TARGET --prefix=$PREFIX
make
make install
```

### Linux

Debian:

```shell
sudo apt-get install nasm xorriso qemu build-essential
```

Arch:

```shell
sudo pacman -S binutils grub libisoburn nasm qemu
```

_NOTE: list of packages can vary, depending on your system._

### Windows

Delete Windows and install Linux.
Once you've done this, follow the [Linux](#linux) section.

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
