;; Boot sector
;; Loads kernel from the disk into memory
;; Switches processor to 32-bit Protected Mode
;; Executes loaded kernel

[org 0x7C00]
[bits 16]

;; memory offset where our kernel is located
KERNEL_OFFSET equ 0x1000

;; print message that boot sector is loaded
mov bx, BOOT_SECTOR_FOUND_MSG
call print_string
call print_nl

;; save the boot drive number
mov [BOOT_DRIVE], dl

;; update base and stack pointers
mov bp, 0x9000
mov sp, bp

;; say that we have started in Real Mode
mov bx, BOOT_SECTOR_REAL_MODE_MSG
call print_string
call print_nl

;; also, notify that we are reading the kernel into memory
mov bx, BOOT_SECTOR_LOADING_KERNEL_INTO_MEMORY_MSG
call print_string
call print_nl

;; call routine that loads kernel into memory
call load_kernel_into_memory

;; notify that we are trying to load Protected Mode
mov bx, BOOT_SECTOR_START_PROTECTED_MODE_MSG
call print_string
call print_nl

;; switch to Protected Mode
call switch_to_pm

jmp $

;; routine reads kernel from disk into memory
load_kernel_into_memory:
	;; store all register values
	pusha

	;; set up parameters for disk_read routine
	mov bx, KERNEL_OFFSET
	mov dh, 15
	mov dl, [BOOT_DRIVE]
	call disk_read

	;; restore register values and ret
	popa
	ret

[bits 32]

begin_pm:
	;; call our loaded kernel
	call KERNEL_OFFSET
	jmp $

%include "boot/disk/disk_read.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/switch_to_pm.asm"
%include "boot/print/print_hex.asm"
%include "boot/print/print_nl.asm"
%include "boot/print/print_string.asm"
%include "boot/print/print_string_pm.asm"

BOOT_DRIVE: db 0
BOOT_SECTOR_FOUND_MSG: db "Found boot sector, loading...", 0
BOOT_SECTOR_REAL_MODE_MSG: db "Started in 16-bit Real Mode", 0
BOOT_SECTOR_LOADING_KERNEL_INTO_MEMORY_MSG: db "Loading kernel into the memory...", 0
BOOT_SECTOR_START_PROTECTED_MODE_MSG: db "Trying to load 32-bit Protected Mode...", 0

times 510 - ($-$$) db 0
dw 0xAA55
