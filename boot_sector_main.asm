[org 0x7C00]

mov bx, HELLO
call print
call print_nl

mov bx, GOODBYE
call print
call print_nl

mov dx, 0x12FE
call print_hex

jmp $

%include "boot_sector_print.asm"
%include "boot_sector_print_hex.asm"

HELLO:
	db "Hello, World", 0

GOODBYE:
	db "Goodbye", 0

times 510 - ($-$$) db 0
dw 0xAA55
