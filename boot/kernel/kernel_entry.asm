;; Routine that jump direct into main() in kernel

[bits 32]
[extern main]
call main
jmp $
