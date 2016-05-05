;; Routine for printing new line
	
print_nl:
	;; store all register values
	pusha

	;; prepare for BIOS interrupt
	;; write new line and carriage return
	mov ah, 0x0E
	mov al, 0x0A
	int 0x10
	mov al, 0x0D
	int 0x10

	;; restore all registers
	popa
	ret
