#include "../drivers/screen.h"
#include "util.h"
#include "cpu/isr.h"
#include "cpu/idt.h"

void main() {
  clear_screen();
  isr_install();

  __asm__ __volatile__("int $2");
  __asm__ __volatile__("int $3");
}
