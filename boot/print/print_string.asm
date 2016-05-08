;; Sub-routine for string printing
;; Accepts pointer where string is stored in bx register

[bits 16]

print_string:
	;; store all register values
	pusha

print_string_loop:
	;; get first char from address at bx
	;; if char is equal to null-terminating symbol
	;; jump to return
	mov al, [bx]
	cmp al, 0
	je print_string_ret

	;; if char is exists
	;; prepare BIOS interrupt
	mov ah, 0x0E
	int 0x10

	;; offset at bx + 1
	;; so we have the next char from string
	inc bx
	jmp print_string_loop

print_string_ret:
	;; restore register values and return
	popa
	ret
