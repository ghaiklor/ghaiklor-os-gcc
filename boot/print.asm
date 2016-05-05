print_from_bx:
	;; get first char from address at bx
	;; if char is equal to null-terminating symbol
	;; jump to return
	mov al, [bx]
	cmp al, 0
	je return

	;; if char is exists
	;; prepare BIOS interrupt 0x0E for print
	mov ah, 0x0E
	int 0x10

	;; offset at bx + 1
	;; so we have the next char from string
	add bx, 1
	jmp print_from_bx

return:
	popa
	ret

print:
	pusha
	jmp print_from_bx
