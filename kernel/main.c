void main() {
  char* video_memory_ptr = 0xB8000;
  *video_memory_ptr = 'X';
}
