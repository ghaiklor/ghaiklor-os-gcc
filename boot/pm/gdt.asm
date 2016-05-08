;; Global Descriptor Table
;; It contains entries telling the CPU about memory segments
;; In sake of simplicity I declare two memory segments:
;; code segment and data segment
;; both of them takes 4 Gb of overlapping memory
;; http://wiki.osdev.org/Global_Descriptor_Table

[bits 16]

gdt_start:
gdt_null:
	dd 0x0
	dd 0x0

;; Code Segment
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

;; Data Segment
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
