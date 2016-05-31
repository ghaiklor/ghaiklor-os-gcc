#include "../drivers/keyboard.h"
#include "../drivers/screen.h"
#include "../libc/mem.h"
#include "cpu/isr.h"
#include "cpu/idt.h"
#include "cpu/timer.h"

void main() {
  clear_screen();
  isr_install();

  __asm__ __volatile__("sti");

  init_timer(50);
  init_keyboard();
}
