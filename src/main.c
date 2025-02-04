#include <stdio.h>

// Preserve zero page to make it possible to return to BASIC
#pragma require __preserve_zp

int main () {
  printf("HELLO WORLD!\n");
  return 0;
}
