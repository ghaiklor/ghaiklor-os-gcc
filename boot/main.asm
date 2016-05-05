[org 0x7C00]

mov bx, BOOT_SECTOR_FOUND_MSG
call print_string

mov bp, 0x9000
mov sp, bp

mov bx, BOOT_SECTOR_REAL_MODE_MSG
call print_string

call switch_to_pm

jmp $

%include "boot/print_string.asm"
%include "boot/print_string_pm.asm"
%include "boot/print_hex.asm"
%include "boot/disk_read.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_pm.asm"

[bits 32]

begin_pm:
	mov ebx, BOOT_SECTOR_PROTECTED_MODE_MSG
	call print_string_pm

	jmp $

BOOT_SECTOR_FOUND_MSG: db "Found boot sector, loading...", 0
BOOT_SECTOR_REAL_MODE_MSG: db "Started in 16-bit Real Mode", 0
BOOT_SECTOR_PROTECTED_MODE_MSG: db "Successfully landed in 32-bit Protected Mode", 0

times 510 - ($-$$) db 0
dw 0xAA55
