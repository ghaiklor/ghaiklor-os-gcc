loop:
	jmp loop

times 510-($-$$) db 0
dw 0xAA55
