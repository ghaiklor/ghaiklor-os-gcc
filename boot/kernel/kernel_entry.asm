;; Routine that jump direct into main() in kernel
;; This routine is linked with kernel main.c file
;; at kernel folder, so we can call main() explicitly

[bits 32]
[extern main]
call main
jmp $
