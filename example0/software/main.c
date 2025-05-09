#include "../shared/omsp_system.h"
#include <stdint.h>
#include <string.h>
#include <stdio.h>


void hello_world(void) {
    memcpy((uint8_t *)0x200, "hello world!", 12);
    while(1);
}

char large_string[20];

int main() {
  WDTCTL = WDTPW | WDTHOLD;
  char buffer[16];
  int i;
  for( i = 0; i < 15; i++)
    large_string[i] = 'A';
  large_string[15] = '\0';
  //large_string[16] = 'B';
  large_string[16] = 0x20;
  large_string[17] = 0xf0;
  large_string[18] = '\0';

  strcpy(buffer,large_string);
  
  return 0;
}
