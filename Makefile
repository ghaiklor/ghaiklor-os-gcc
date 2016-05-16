SOURCES = $(shell find kernel drivers -name '*.c')
HEADERS = $(shell find kernel drivers -name '*.h')
OBJ = ${SOURCES:.c=.o}

ASM = nasm
CC = x86_64-pc-elf-gcc
LD = x86_64-pc-elf-ld
GDB = gdb

all: os-image.bin

run: all
	qemu-system-i386 -fda os-image.bin

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o

debug: os-image.bin kernel.elf
	qemu-system-i386 -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

os-image.bin: boot/boot.bin kernel/kernel.bin
	cat $^ > os-image.bin

boot/boot.bin: boot/boot.asm
	${ASM} $< -f bin -o $@

kernel/kernel.bin: boot/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^

%.o: %.c ${HEADERS}
	${CC} -ffreestanding -c $< -o $@

%.o: %.asm
	${ASM} $< -f elf64 -o $@

%.bin: %.asm
	${ASM} $< -f bin -o $@
