// Implementation for Interrupt Descriptor Table
// http://wiki.osdev.org/Interrupt_Descriptor_Table

#include "idt.h"

// Register gate in Interrupt Descriptor Table
// It stores in declared in idt.h variable called idt
void set_idt_gate(int n, uint32_t handler) {
  idt[n].low_offset = LOW_16(handler);
  idt[n].sel = KERNEL_CS;
  idt[n].always0 = 0;
  idt[n].flags = 0x8E;
  idt[n].high_offset = HIGH_16(handler);
}

// Set base address where IDT starts in idt_reg.base
// Set the length of the IDT in bytes into idt_reg.limit
// Call lidtl (Load Interrupt Descriptor Table) instruction
// And set address of our IDT header
void set_idt() {
  idt_reg.base = (uint32_t)&idt;
  idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;
  __asm__ __volatile__("lidtl (%0)" : : "r" (&idt_reg));
}
