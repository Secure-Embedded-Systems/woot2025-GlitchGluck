//#include <stdio.h>
#include <stdint.h>
#include "hal.h"

// initialize pt
uint8_t pt[16] = {0x95,0x75,0x18,0x0d,0x95,0x75,0x18,0x0d,0xfb,0xc2,0x18,0x0f,0xfb,0xc2,0x18,0x0f};



// initialize key
uint8_t key[16] = {0x50,0x12,0xdc,0x4c,0x50,0x12,0xdc,0x4c,0x4f,0xa7,0xd3,0xa8,0x4f,0xa7,0xd3,0xa8};

void error_handler() {
    // Set a limit on how many iterations the loop should run
    int count = 5;  // For example, 1 million iterations
    
    while (count > 0) {
        count--;  // Decrement the counter
    }
   
trigger_low(); 
    // Exit the error handler after the loop
    // You can add any necessary cleanup here if needed
}


//void error_handler() {
    // Enter an infinite loop to handle the error
//    while (1) {
        // Do nothing, just loop forever
//    }
//}


void runbench() {

    trigger_high();

asm (
    // Load back the stored values into a6 and a7
    "lw a2, 0(%0)\n"          // Load first XORed value into a6
    "lw a3, 0(%0)\n"          // Load second XORed value into a7 (assuming pt is a pointer to an array or structure)

    // Branch if not equal (bnez), jump to error handler if a8 != 0
    "bne a2, a3, error_handler\n" // If a8 is non-zero, jump to error_handler
    :                         // No outputs
    : "r" (pt)                // Input: pointer to the memory
    : "a1", "a2", "a3"        // Clobbered registers
);

    // Continue with other operations if no error
    // Trigger low
    trigger_low();

}



int main(){

  platform_init();

  runbench();

  trigger_low();

  return 0;

}
