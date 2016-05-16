#include "ports.h"
#include "screen.h"
#include "../kernel/util.h"

int print_char(char character, int col, int row, int attribute);
int handle_scrolling(int current_offset);
int get_cursor_offset();
void set_cursor_offset(int offset);
int get_offset(int col, int row);
int get_row_from_offset(int offset);
int get_col_from_offset(int offset);

// Public API
void print(char *message) {
  print_at(message, -1, -1);
}

void print_at(char *message, int col, int row) {
  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    offset = get_cursor_offset();
    col = get_col_from_offset(offset);
    row = get_row_from_offset(offset);
  }

  while (*message) {
    offset = print_char((char)*message, col, row, WHITE_ON_BLACK);
    row = get_row_from_offset(offset);
    col = get_col_from_offset(offset);
    message++;
  }
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

// Private API

// Print char at specified column and row
int print_char(char character, int col, int row, int attribute) {
  char *video_memory_ptr = (char*)VIDEO_ADDRESS;

  if (!attribute) {
    attribute = WHITE_ON_BLACK;
  }

  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_offset(col, row);
  } else {
    offset = get_cursor_offset();
  }

  if (character == '\n') {
    row = get_row_from_offset(row);
    offset = get_offset(0, row + 1);
  } else {
    video_memory_ptr[offset++] = character;
    video_memory_ptr[offset++] = attribute;
  }

  // FIXME: green line because of handle_scrolling()
  // offset = handle_scrolling(offset);
  set_cursor_offset(offset);
  return offset;
}

int handle_scrolling(int cursor_offset) {
  if (cursor_offset < MAX_ROWS * MAX_COLS * 2) {
    return cursor_offset;
  }

  for (int i = 1; i < MAX_ROWS; i++) {
    memory_copy(
      get_offset(0, i) + (char*) VIDEO_ADDRESS,
      get_offset(0, i - 1) + (char*) VIDEO_ADDRESS,
      MAX_COLS * 2
    );
  }

  char* last_line = get_offset(0, MAX_ROWS - 1) + (char*) VIDEO_ADDRESS;
  for (int i = 0; i < MAX_COLS * 2; i++) {
    last_line[i] = 0;
  }

  cursor_offset -= 2 * MAX_COLS;
  return cursor_offset;
}

// Get current cursor position
int get_cursor_offset() {
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);

  return offset * 2;
}

// Set cursor position based on offset in memory
void set_cursor_offset(int offset) {
  offset /= 2;

  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, (unsigned char)(offset & 0xFF));
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
