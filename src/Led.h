#ifndef _LED_H_
#define _LED_H_

#include<stdint.h>

typedef struct
{
    uint32_t Value;
}LEDStr;

#define LED_BASE 0x80003000
#define LED ((LEDStr *)LED_BASE)

void LedOn();
void LedOff();
void LedBlink(uint32_t cycle);


#endif
