#include "idt.h"
#include "../util.h"

void set_idt_gate(int n, uint32_t handler) {
  idt[n].low_offset = LOW_16(handler);
  idt[n].sel = KERNEL_CS;
  idt[n].always0 = 0;
  idt[n].flags = 0x8E;
  idt[n].high_offset = HIGH_16(handler);
}

void set_idt() {
  idt_reg.base = (uint32_t)&idt;
  idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;
  __asm__ __volatile__("lidtl (%0)" : : "r" (&idt_reg));
}
