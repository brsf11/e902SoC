#ifndef _INTERRUPT_H_
#define _INTERRUPT_H_

#include<stdint.h>

#define MTIMECMPLO (*(volatile unsigned *)0xE0004000)
#define MTIMECMPHI (*(volatile unsigned *)0xE0004004)

typedef struct
{
    uint8_t CLICINTIP;
    uint8_t CLICINTIE;
    uint8_t CLICINTATTR;
    uint8_t CLICINTCTRL;
}CLICStr;

typedef struct
{
    uint8_t  CLICCFG;
    uint32_t CLICINFO;
    uint32_t MINTTHRESH;
}INTERRUPTStr;

#define INTERRUPT_BASE 0xE0800000
#define INTERRUPT ((INTERRUPTStr *)INTERRUPT_BASE)

#define CLIC_BASE 0xE0801040
#define CLIC ((CLICStr *)CLIC_BASE)

void IntInit();


#endif
