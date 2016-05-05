print_hex:
	;; HEX value must be in dx
	;; store all register values
	;; cx is our counter in the loop
	pusha
	xor cx, cx

print_hex_loop:
	;; if counter is equal to 4
	;; jump to return
	cmp cx, 4
	je print_hex_ret

	;; otherwise, process hex value as string
	;; get last char of HEX value
	mov al, dl
	and al, 0x0F

	;; convert the last char to ASCII code
	add al, 0x30

	;; if result is number [30-39]
	;; write ASCII code to ret value
	cmp al, 0x39
	jle print_hex_write_to_ret

	;; otherwise, add 7
	;; because we have letter, not the number
	add al, 7

print_hex_write_to_ret:
	;; store address of last char in ret value
	mov bx, PRINT_HEX_OUT + 5

	;; sub our index value
	;; write ASCII code to ret value
	sub bx, cx
	mov [bx], al

	;; cyclic shift our parameter
	;; so we can get the next last char
	ror dx, 4

	;; increment loop counter
	add cx, 1
	jmp print_hex_loop

print_hex_ret:
	;; get result of HEX -> ASCII
	;; and call usual print_string
	mov bx, PRINT_HEX_OUT
	call print_string
	popa
	ret

PRINT_HEX_OUT: db "0x0000", 0
