#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

#include<stdint.h>

typedef struct
{
    uint32_t Value;
}KEYBOARDStr;

#define KEYBOARD_BASE 0x80001000
#define KEYBOARD ((KEYBOARDStr *)KEYBOARD_BASE)

void KeyIntFunc();
void KeyInit();

#endif
