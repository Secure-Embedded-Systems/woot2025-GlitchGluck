#include "shared/omsp_system.h"
#include <stdint.h>
#include <string.h>
#include <stdio.h>


#define ASSERT(condition)                              \
        if (!(condition)) {                           \
            handle_error(__FILE__, __LINE__);       \
        }                                             \


void handle_error(const char *file, int line) {
    //printf("ERROR\n");
    while (1) {}
}


void hello_world(void) {
    memcpy((uint8_t *)0x200, "hello world!", 12);
    while(1);
}


char large_string[19];

int main() {
    WDTCTL = WDTPW | WDTHOLD;
    char buffer[16];
    int i;
    for( i = 0; i < 15; i++)
      large_string[i] = 'A';
    large_string[15] = 'B';
    large_string[16] = 0x22;
    large_string[17] = 0xf0;
    large_string[18] = '\0';
    ASSERT(sizeof(buffer) > strlen(large_string));
    strcpy(buffer,large_string);
    //printf("Copied string: %s\n", buffer);
    return 0;
}
