//#include <stdio.h>
#include <stdint.h>
#include "hal.h"

#include "interface.h"
#include "types.h"
#include "lazart.h"

extern UBYTE g_countermeasure;
extern BOOL g_authenticated;
extern SBYTE g_ptc;

BOOL verifyPIN(void);

void runbench() {

    initialize();

    trigger_high();

    uint8_t pin_verified = verifyPIN();
    asm ("mv a4, %0" : : "r"(pin_verified) : "a4");
    //verifyPIN();

    trigger_low();

}



int main(){

  platform_init();

  runbench();

  return 0;

}
