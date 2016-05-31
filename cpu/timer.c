// Implementation for Programmable Interval Timer
// http://wiki.osdev.org/Programmable_Interval_Timer

#include "timer.h"
#include "isr.h"
#include "../drivers/screen.h"
#include "../libc/mem.h"
#include "../libc/string.h"

uint32_t tick = 0;

// Callback for timer
// Triggers each time when hardware interrupt occurred
static void timer_callback(registers_t regs) {
  tick++;

  print("Tick: ");

  char tick_ascii[256];
  itoa(tick, tick_ascii);
  print(tick_ascii);
  print("\n");
}

// Initialize PIC
// http://wiki.osdev.org/Programmable_Interval_Timer#PIT_Channel_0_Example_Code
void init_timer(uint32_t freq) {
  register_interrupt_handler(IRQ0, timer_callback);

  uint32_t divisor = 1193180 / freq;
  uint8_t low = (uint8_t)(divisor & 0xFF);
  uint8_t high = (uint8_t)((divisor >> 8) & 0xFF);

  port_byte_out(0x43, 0x36);
  port_byte_out(0x40, low);
  port_byte_out(0x40, high);
}
