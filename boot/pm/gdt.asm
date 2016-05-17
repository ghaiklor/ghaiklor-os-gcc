;; Global Descriptor Table
;; It contains entries telling the CPU about memory segments
;; http://wiki.osdev.org/Global_Descriptor_Table

[bits 16]

gdt_start:
gdt_null:
	dd 0x0
	dd 0x0

;; Kernel Code Segment
gdt_kernel_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

;; Kernel Data Segment
gdt_kernel_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

;; Userland Code Segment
gdt_userland_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 11111010b
	db 11001111b
	db 0x0

;; Userland Data Segment
gdt_userland_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 11110010b
	db 11001111b
	db 0x0

gdt_end:
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_kernel_code - gdt_start
DATA_SEG equ gdt_kernel_data - gdt_start
