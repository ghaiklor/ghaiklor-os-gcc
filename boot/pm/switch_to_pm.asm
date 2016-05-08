;; Sub-routine to switch on Protected Mode
;; A CPU that is initialized by the BIOS starts in Real Mode
;; Enabling Protected Mode unleashes the real power of your CPU
;; http://wiki.osdev.org/Protected_Mode

[bits 16]

switch_to_pm:
	;; clear all interrupts
	cli

	;; load our Global Descriptor Table
	lgdt [gdt_descriptor]

	;; switch to protected mode
	;; set PE (Protection Enable) bit in CR0
	;; CR0 is a Control Register 0
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	;; far jump to 32 bit instructions
	;; so we can be sure processor has done
	;; all other operations before switch
	;; at this moment we can say bye to 16-bit Real Mode
	jmp CODE_SEG:init_pm

[bits 32]

init_pm:
	;; update all segment registers
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	;; update base and stack pointers
	mov ebp, 0x90000
	mov esp, ebp

	;; start protected mode
	;; begin_pm is located in boot.asm
	;; that is the last step in our journey
	;; before we are give execution to our kernel
	call begin_pm
