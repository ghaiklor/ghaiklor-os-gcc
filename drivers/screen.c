// Screen driver implementation
// http://wiki.osdev.org/Printing_To_Screen
// http://wiki.osdev.org/VGA_Hardware

#include "screen.h"
#include "../cpu/ports.h"
#include "../libc/mem.h"

int print_char(char character, int col, int row, int attribute);
int get_cursor_offset();
int set_cursor_offset(int offset);
int get_offset(int col, int row);
int get_row_from_offset(int offset);
int get_col_from_offset(int offset);

// Prints string at current position of the cursor
void print(char *message) {
  print_at(message, -1, -1);
}

// Prints string at the specified position
void print_at(char *message, int col, int row) {
  int offset;

  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    offset = get_cursor_offset();
  }

  while (*message) {
    offset = print_char(
      (char)*message,
      get_col_from_offset(offset),
      get_row_from_offset(offset),
      WHITE_ON_BLACK
    );

    message++;
  }
}

void print_backspace() {
  int offset = get_cursor_offset() - 2;
  int row = get_row_from_offset(offset);
  int col = get_col_from_offset(offset);
  print_char(0x08, col, row, WHITE_ON_BLACK);
}

// Clear the entire screen and positioning cursor to (0, 0)
void clear_screen() {
  for (int row = 0; row < MAX_ROWS; row++) {
    for (int col = 0; col < MAX_COLS; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }

  set_cursor_offset(get_offset(0, 0));
}

// Prints char at specified column and row
// Writes direct into video memory
// Handles scrolling and new-line character
int print_char(char character, int col, int row, int attribute) {
  if (!attribute) attribute = WHITE_ON_BLACK;

  char *video_memory_ptr = (char*)VIDEO_ADDRESS;

  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    offset = get_cursor_offset();
  }

  if (character == '\n') {
    row = get_row_from_offset(offset);
    offset = get_offset(0, row + 1);
  } else {
    video_memory_ptr[offset++] = character;
    video_memory_ptr[offset++] = attribute;
  }

  if (offset >= MAX_ROWS * MAX_COLS * 2) {
    // In case, if we out of bounds
    // Copy each line to a line above
    for (int i = 1; i < MAX_ROWS; i++) {
      memory_copy(
        (uint8_t*)(get_offset(0, i) + VIDEO_ADDRESS),
        (uint8_t*)(get_offset(0, i - 1) + VIDEO_ADDRESS),
        MAX_COLS * 2
      );
    }

    // Clear the last line after all lines were copied
    char* last_line = (char*)(get_offset(0, MAX_ROWS - 1) + VIDEO_ADDRESS);
    for (int i = 0; i < MAX_COLS * 2; i++) {
      last_line[i] = 0;
    }

    // Update current offset to (0, MAX_ROWS - 1)
    offset -= 2 * MAX_COLS;
  }

  // Update cursor position after all calcuations
  set_cursor_offset(offset);
  return offset;
}

// Get current cursor position
// Implementation based on low-level port I/O
// Write to CTRL register 14 (0xE) and read Hi byte
// Write to CTRL register 15 (0xF) and read Lo byte
// Adding these leads to current offset of cursor in memory
int get_cursor_offset() {
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);

  return offset * 2;
}

// Set cursor position
// The same implementation as in get_cursor_offset()
// Write to CTRL register 14 (0xE) and write Hi byte to DATA register
// Write to CTRL register 15 (0xF) and write Lo byte to DATA register
int set_cursor_offset(int offset) {
  offset /= 2;

  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xFF));

  return offset * 2;
}

// Get offset from column and row number
int get_offset(int col, int row) {
  return 2 * (row * MAX_COLS + col);
}

// Get row from offset in memory
int get_row_from_offset(int offset) {
  return offset / (2 * MAX_COLS);
}

// Get column from offset in memory
int get_col_from_offset(int offset) {
  return (offset - (get_row_from_offset(offset) * 2 * MAX_COLS)) / 2;
}
