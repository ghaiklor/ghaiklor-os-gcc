;; Routine to switch on Protected Mode
;; http://wiki.osdev.org/Protected_Mode
	
[bits 16]

switch_to_pm:
	;; clear all interrupts
	cli

	;; load our Global Descriptor Table
	lgdt [gdt_descriptor]

	;; switch to protected mode
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
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
	call begin_pm
