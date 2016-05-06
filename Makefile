all: os-image.bin

run: all
	qemu-system-x86_64 -fda os-image.bin

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf

os-image.bin: boot.bin kernel.bin
	cat $^ > os-image.bin

boot.bin: boot/boot.asm
	nasm $< -f bin -o $@

kernel.o: kernel/main.c
	gcc -ffreestanding -c $< -o $@

kernel.bin: kernel.o
	gobjcopy -O binary $< $@
