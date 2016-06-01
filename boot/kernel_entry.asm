;; We can't be sure we are executing the main() method in kernel
;; boot sector and kernel are combined together
;; boot calls the instruction at 0x7C00 + 0x1000
;; no matter what in there
;; A trick here is to write a simple sub-routine
;; that is attached to the start of the kernel code
;; and calls the entry function of the kernel
;; When object files will be linked together
;; this call will be translated to the address of the main()

global _start

[bits 32]
[extern kernel_main]

_start:
  call kernel_main
  jmp $
