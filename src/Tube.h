#ifndef _TUBE_H_
#define _TUBE_H_

#include<stdint.h>

#define HighBias 15
#define PointBias 4
#define BitInt 5

typedef struct
{
    uint32_t Value;
    uint32_t Enb;
}TUBEStr;

#define TUBE_BASE 0x80002000
#define TUBE ((TUBEStr *)TUBE_BASE)

void TubeClear();
int  TubeShowHigh(uint8_t num, uint8_t point);
int  TubeShowLow(uint8_t num, uint8_t point);

#endif
