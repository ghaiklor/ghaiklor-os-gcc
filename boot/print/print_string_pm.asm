;; Routine for printing strings in Protected Mode
;; Accepts pointer to string in memory in ebx register

[bits 32]
	
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F

print_string_pm:
	;; store all registers values
	;; set edx to address of video memory
	pusha
	mov edx, VIDEO_MEMORY

print_string_pm_loop:
	;; get first char at address in ebx
	;; and append with display attribute
	mov al, [ebx]
	mov ah, WHITE_ON_BLACK

	;; if we got null-terminating symbol
	;; jump to ret
	cmp al, 0
	je print_string_pm_ret

	;; otherwise, write to video memory
	;; get next char = ebx + 1
	;; move to next cell in video memory = edx + 2
	mov [edx], ax
	inc ebx
	add edx, 2
	jmp print_string_pm_loop

print_string_pm_ret:
	;; restore all register values
	popa
	ret
