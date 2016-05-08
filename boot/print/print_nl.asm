;; Sub-routine for printing new line
;; using BIOS interrupts print two ASCII symbols:
;; new line = 0x0A
;; carriage return = 0x0D

[bits 16]

print_nl:
	;; store all register values
	pusha

	;; prepare for BIOS interrupt
	mov ah, 0x0E
	mov al, 0x0A
	int 0x10
	mov al, 0x0D
	int 0x10

	;; restore all registers
	popa
	ret
