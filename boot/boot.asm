;; Boot sector
;; Switches processor to 32-bit Protected Mode
;; Loads kernel from the disk

[org 0x7C00]
[bits 16]

mov bx, BOOT_SECTOR_FOUND_MSG
call print_string
call print_nl

mov bp, 0x9000
mov sp, bp

mov bx, BOOT_SECTOR_REAL_MODE_MSG
call print_string
call print_nl

mov bx, BOOT_SECTOR_START_PROTECTED_MODE_MSG
call print_string
call print_nl

call switch_to_pm

jmp $

[bits 32]

begin_pm:
	mov ebx, BOOT_SECTOR_PROTECTED_MODE_MSG
	call print_string_pm

	jmp $

%include "boot/disk/disk_read.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/switch_to_pm.asm"
%include "boot/print/print_hex.asm"
%include "boot/print/print_nl.asm"
%include "boot/print/print_string.asm"
%include "boot/print/print_string_pm.asm"

BOOT_SECTOR_FOUND_MSG: db "Found boot sector, loading...", 0
BOOT_SECTOR_REAL_MODE_MSG: db "Started in 16-bit Real Mode", 0
BOOT_SECTOR_START_PROTECTED_MODE_MSG: db "Trying to load 32-bit Protected Mode...", 0
BOOT_SECTOR_PROTECTED_MODE_MSG: db "Successfully landed in 32-bit Protected Mode", 0

times 510 - ($-$$) db 0
dw 0xAA55
