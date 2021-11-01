#include"Led.h"

void LedOn()
{
    LED->Value = 1 << 30;
}

void LedOff()
{
    LED->Value = 0;
}

void LedBlink(uint32_t cycle)
{
    uint32_t temp = 0;
    uint32_t mask = 0x3fffffff;
    uint32_t enb  = 0x80000000;
    temp = cycle & mask;
    temp |= enb;
    LED->Value = temp;
}
