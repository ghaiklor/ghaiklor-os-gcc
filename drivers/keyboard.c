// Implementation for keyboard
// When key is pressed, keyboard controller triggers IRQ1
// http://wiki.osdev.org/Interrupts#From_the_keyboard.27s_perspective
// We need to handle this interrupt and do something

#include "keyboard.h"
#include "screen.h"
#include "../cpu/ports.h"
#include "../cpu/isr.h"
#include "../libc/function.h"
#include "../libc/string.h"
#include "../kernel/kernel.h"

#define BACKSPACE 0x0E
#define ENTER 0x1C

static char key_buffer[256];

#define SC_MAX 57

const char *sc_name[] = {
  "ERROR",
  "Esc",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
  "-",
  "=",
  "Backspace",
  "Tab",
  "Q",
  "W",
  "E",
  "R",
  "T",
  "Y",
  "U",
  "I",
  "O",
  "P",
  "[",
  "]",
  "Enter",
  "Lctrl",
  "A",
  "S",
  "D",
  "F",
  "G",
  "H",
  "J",
  "K",
  "L",
  ";",
  "'",
  "`",
  "LShift",
  "\\",
  "Z",
  "X",
  "C",
  "V",
  "B",
  "N",
  "M",
  ",",
  ".",
  "/",
  "RShift",
  "Keypad *",
  "LAlt",
  "Spacebar"
};

const char sc_ascii[] = {
  '?',
  '?',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '0',
  '-',
  '=',
  '?',
  '?',
  'Q',
  'W',
  'E',
  'R',
  'T',
  'Y',
  'U',
  'I',
  'O',
  'P',
  '[',
  ']',
  '?',
  '?',
  'A',
  'S',
  'D',
  'F',
  'G',
  'H',
  'J',
  'K',
  'L',
  ';',
  '\'',
  '`',
  '?',
  '\\',
  'Z',
  'X',
  'C',
  'V',
  'B',
  'N',
  'M',
  ',',
  '.',
  '/',
  '?',
  '?',
  '?',
  ' '
};

// Calls each time when key is pressed
static void keyboard_callback(registers_t regs) {
  // The PIC leaves us the scancode in port 0x60
  uint8_t scancode = port_byte_in(0x60);

  if (scancode > SC_MAX) return;
  if (scancode == BACKSPACE) {
    backspace(key_buffer);
    print_backspace();
  } else if (scancode == ENTER) {
    print("\n");
    user_input(key_buffer);
    key_buffer[0] = '\0';
  } else {
    char letter = sc_ascii[(int)scancode];
    char str[2] = {letter, '\0'};
    append(key_buffer, letter);
    print(str);
  }

  UNUSED(regs);
}

// Maps keyboard_callback() to IRQ1 interrupt
void init_keyboard() {
  register_interrupt_handler(IRQ1, keyboard_callback);
}
