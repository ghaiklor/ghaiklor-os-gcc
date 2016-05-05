[org 0x7C00]

mov bx, HELLO
call print_string

mov bx, GOODBYE
call print_string

mov dx, 0x1234
call print_hex

jmp $

%include "boot/print_string.asm"
%include "boot/print_hex.asm"

HELLO: db "Hello, World", 0
GOODBYE: db "Goodbye", 0

times 510 - ($-$$) db 0
dw 0xAA55
