#include "mem.h"

void memory_copy(uint8_t *source, uint8_t *destination, int bytes) {
  for (int i = 0; i < bytes; i++) {
    *(destination + i) = *(source + i);
  }
}

void memory_set(uint8_t *destination, uint8_t value, uint32_t len) {
  uint8_t *temp = (uint8_t*)destination;
  for (; len != 0; len--) *temp++ = value;
}
