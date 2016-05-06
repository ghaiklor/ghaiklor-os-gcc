all: kernel.bin

run: all
	qemu-system-x86_64 os-image

clean:
	rm -rf *.bin *.dis *.o os-image *.map *~

os-image: boot.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel_entry.o kernel.o
	ld -o kernel.bin -Ttext 0x1000 $^ --oformat binary

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@

boot.bin: boot.asm
	nasm $< -f bin -I "../../16bit" -o $@
