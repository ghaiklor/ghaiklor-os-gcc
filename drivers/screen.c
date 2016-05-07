#include "screen.h"

int print_char(char character, int col, int row, char attribute);
int get_cursor_offset();
void set_cursor_offset(int offset);
int get_offset(int col, int row);
int get_row_from_offset(int offset);
int get_col_from_offset(int offset);

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

  int i = 0;
  while (message[i] != 0) {
    offset = print_char(message[i++], col, row, WHITE_ON_BLACK);
    row = get_row_from_offset(offset);
    col = get_col_from_offset(offset);
  }
}

// Clear the entire screen
// and positioning cursor to (0, 0)
void clear_screen() {
  int screen_size = MAX_COLS * MAX_ROWS;
  char *screen = VIDEO_ADDRESS;

  for (int i = 0; i < screen_size; i++) {
    screen[i * 2] = ' ';
    screen[i * 2 + 1] = WHITE_ON_BLACK;
  }

  set_cursor_offset(get_offset(0, 0));
}

// Print char at specified column and row
int print_char(char character, int col, int row, char attribute) {
  unsigned char *video_memory_ptr = (unsigned char*) VIDEO_ADDRESS;

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
    video_memory_ptr[offset] = character;
    video_memory_ptr[offset + 1] = attribute;
    offset += 2;
  }

  set_cursor_offset(offset);
  return offset;
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
