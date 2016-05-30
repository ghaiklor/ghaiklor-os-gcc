;; Implemenation for switching to x64 Long Mode
;; http://wiki.osdev.org/Setting_Up_Long_Mode#Entering_Long_Mode

[bits 32]

switch_to_lm:
  ;; Before we actually cover up the new paging used in x86-64
  ;; we should disable the old paging first set up in protected mode
  mov eax, cr0
  and eax, 01111111111111111111111111111111b
  mov cr0, eax

  ;; Clear the tables
  mov edi, 0x1000
  mov cr3, edi
  xor eax, eax
  mov ecx, 4096
  rep stosd
  mov edi, cr3

  ;; Set up the new tables
  mov DWORD [edi], 0x2003
  add edi, 0x1000
  mov DWORD [edi], 0x3003
  add edi, 0x1000
  mov DWORD [edi], 0x4003
  add edi, 0x1000
  mov ebx, 0x00000003
  mov ecx, 512

switch_to_lm_set_entry:
  mov DWORD [edi], ebx
  add ebx, 0x1000
  add edi, 8
  loop switch_to_lm_set_entry

;; Now, we need to enable PAE-paging
switch_to_lm_enable_paging:
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ;; Set the LM-bit
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ;; Enable paging
  mov eax, cr0
  or eax, 1 << 31
  mov cr0, eax

  ;; Load our GDT with the 64-bit flags
  ;; and make far jump to init_lm
  lgdt [gdt_descriptor]
  jmp CODE_SEG:init_lm

[bits 64]

init_lm:
  ;; update all segment registers
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ;; Update base and stack pointers
  mov ebp, 0x90000
  mov esp, ebp

  call begin_lm
