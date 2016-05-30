;; Implemenation for detecting if CPU supports x64 Long Mode
;; In case, if CPU is not support this, leave CPU in x32 Protected Mode
;; http://wiki.osdev.org/Setting_Up_Long_Mode#Detecting_the_Presence_of_Long_Mode

[bits 32]

;; Check if CPUID is supported by attempting to flip the ID bit
;; If we can flip it, CPUID is available
detect_lm:
  ;; Copy FLAGS in to EAX via stack
  pushfd
  pop eax

  ;; Copy to ECX as well for comparing later on
  mov ecx, eax

  ;; Flip the ID bit
  xor eax, 1 << 21

  ;; Copy EAX to FLAGS via the stack
  push eax
  popfd

  ;; Copy FLAGS back to EAX
  pushfd
  pop eax

  ;; Restore FLAGS from the old version stored in ECX
  push ecx
  popfd

  ;; Compare EAX and ECX
  ;; If they are equal then that means the bit wasn't flipped
  ;; so that, CPUID isn't supported
  xor eax, ecx
  jz detect_lm_no_cpuid

  ;; Otherwise, we have to check whether long mode can be used or not
  mov eax, 0x80000000
  cpuid
  cmp eax, 0x80000001
  jb detect_lm_no_long_mode

  ;; We can use extended function for detecting long mode now
  mov eax, 0x80000001
  cpuid
  test edx, 1 << 29
  jz detect_lm_no_long_mode

  ;; In case, if all check are successful, we can actually switch to Long Mode
  call switch_to_lm
  ret

detect_lm_no_cpuid:
  ;; In case, if CPUID isn't supported execute kernel in x32 Protected Mode
  call execute_kernel
  jmp $

detect_lm_no_long_mode:
  ;; In case, if Long Mode is not supported execute kernel in x32 Protected Mode
  call execute_kernel
  jmp $
