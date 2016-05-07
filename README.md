# ghaiklor-os

This is not a **REAL** operation system.
It's just a simple operation system created in educational purposes.

## Structure

- /boot - source code related to boot sector
- /kernel - source code related to kernel
- /drivers - source code related to drivers implementation

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
