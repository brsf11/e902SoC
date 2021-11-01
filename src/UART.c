#include"UART.h"
#include<stdint.h>

void UART_Init(void)
{
    uint32_t ctrl;
    ctrl = 1 | 2 | 8;

    UART->CTRL = 0;
    UART->BAUDDIV = 50000000 / 115200;
    UART->CTRL = ctrl;
}

void UART_putc(char txchar)
{
    while(UART->STATE & 1);
    UART->DATA = (uint32_t)txchar;
}

char UART_getc(void)
{
    while(!(UART->STATE & 2));
    return (char)UART->DATA;
}
