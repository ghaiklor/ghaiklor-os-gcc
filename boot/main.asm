[org 0x7C00]

mov bx, HELLO
call print

mov bx, GOODBYE
call print

jmp $

%include "boot/print.asm"

HELLO: db "Hello, World", 0
GOODBYE: db "Goodbye", 0

times 510 - ($-$$) db 0
dw 0xAA55
