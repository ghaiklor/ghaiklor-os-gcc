;; Boot sector
;; Loads kernel from the disk into memory
;; Switches processor to 32-bit Protected Mode
;; Executes loaded kernel

[org 0x7C00]
[bits 16]

;; memory offset where our kernel is located
KERNEL_OFFSET equ 0x1000

;; save the boot drive number
mov [BOOT_DRIVE], dl

;; update base and stack pointers
mov bp, 0x9000
mov sp, bp

;; call routine that loads kernel into memory
call load_kernel_into_memory

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
	;; Check if we can move from Protected Mode to Long Mode
	;; If something went wrong (detect_lm shouldn't return at all)
	;; we call execute_kernel in x32 Protected Mode
	call detect_lm
	call execute_kernel
	jmp $

[bits 64]

begin_lm:
	;; In case, if detect_lm and switch_to_lm works fine, call kernel in x64 mode
	call execute_kernel
	jmp $

execute_kernel:
	call KERNEL_OFFSET
	jmp $

%include "boot/disk/disk_read.asm"
%include "boot/lm/detect_lm.asm"
%include "boot/lm/switch_to_lm.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/switch_to_pm.asm"
%include "boot/print/print_nl.asm"
%include "boot/print/print_string.asm"

BOOT_DRIVE: db 0

times 510 - ($-$$) db 0
dw 0xAA55
