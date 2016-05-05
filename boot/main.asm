[org 0x7C00]

mov bx, BOOT_SECTOR_FOUND_MSG
call print_string

mov [BOOT_DRIVE], dl
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call disk_read

mov dx, [0x9000]
call print_hex

mov dx, [0x9000 + 512]
call print_hex

jmp $

%include "boot/print_string.asm"
%include "boot/print_hex.asm"
%include "boot/disk_read.asm"

BOOT_SECTOR_FOUND_MSG: db "Found boot sector, loading...", 0
BOOT_DRIVE: db 0

times 510 - ($-$$) db 0
dw 0xAA55

times 256 dw 0xdada
times 256 dw 0xface
