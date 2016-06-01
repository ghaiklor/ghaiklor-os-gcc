#include "../include/stdint.h"

// Address in memory which is mapped to video
#define VIDEO_ADDRESS 0xB8000

// Terminal sizes by default
#define MAX_ROWS 25
#define MAX_COLS 80

// Attribute byte for text
// Foreground color is in its lowest 4 bits
// Background color is in its highest 3 bits
#define WHITE_ON_BLACK 0x0F

// Indexed registers for read\write from\in port
#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

// Public API
void print(char *message);
void print_at(char *message, int col, int row);
void print_backspace();
void clear_screen();
