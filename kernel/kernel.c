#include "kernel.h"
#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "../libc/string.h"

void kernel_main() {
  clear_screen();
  isr_install();
  irq_install();

  print("Type something, it will go through the kernel\n");
  print("Type END to halt the CPU\n> ");
}

void user_input(char *input) {
  if (strcmp(input, "END") == 0) {
    print("Stopping the CPU. Bye!\n");
    __asm__ __volatile__("hlt");
  }

  print("You said: ");
  print(input);
  print("\n> ");
}
