#include"Interrupt.h"

void IntInit()
{
    MTIMECMPLO = 0xffffffff;
    MTIMECMPHI = 0xffffffff;
    INTERRUPT->CLICCFG |= 3 << 1;
    INTERRUPT->MINTTHRESH = 0;
    CLIC[0].CLICINTATTR |= 3;
    CLIC[0].CLICINTCTRL = 255;
    CLIC[0].CLICINTIE   = 1;
}