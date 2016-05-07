;; Kernel entry point
;; Call main() in kernel explicitly
;; so we can be sure we are not messing with addresses
;; It compiles to object file and links with kernel

[bits 32]
[extern main]
call main
jmp $
