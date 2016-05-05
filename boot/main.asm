[org 0x7C00]

mov bx, BOOT_FOUND_MESSAGE
call print_string

jmp $

%include "boot/print_string.asm"
%include "boot/print_hex.asm"

BOOT_FOUND_MESSAGE: db "Found boot sector, loading...", 0

times 510 - ($-$$) db 0
dw 0xAA55
