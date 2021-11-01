#include"UART.h"
#include"Led.h"
#include"Tube.h"
#include"Keyboard.h"
#include"Interrupt.h"

#define IDLE 0
#define Wait 1
#define Ret  2

#define blink1 2500
#define blink2 50000

char KeyFlag;
char KeyNum;


void main()
{
    char state;
    unsigned money,price,change;
    const unsigned menu[3] = {50,35,10};
    const unsigned currency[4] = {5,10,50,100};

    IntInit();
    TubeClear();
    state = IDLE;
    KeyFlag = 0;
    while(1)
    {
        while(!KeyFlag);
        switch(state)
        {
            case IDLE:
                if(KeyNum < 3)
                {
                    price = menu[KeyNum];
                    state = Wait;
                    LedBlink(blink1);
                    TubeShowHigh(price,1);
                    money = 0;
                }
            break;
            case Wait:
                if(KeyNum >=4 && KeyNum <= 7)
                {
                    money += currency[KeyNum - 4];
                    if(money > price)
                    {
                        change = money - price;
                        TubeClear();
                        TubeShowLow(change,1);
                        LedBlink(blink2);
                        state = Ret;
                        change = 0;
                        money = 0;
                        price = 0;
                    }
                    else if(money == price)
                    {
                        TubeClear();
                        LedOn();
                        state = Ret;
                        change = 0;
                        money = 0;
                        price = 0;
                    }
                    else if(money < price)
                    {
                        TubeShowLow(money,1);
                        LedBlink(blink1);
                    }
                }
            break;
            case Ret:
                TubeClear();
                LedOff();
                state = IDLE;
            break;
        }
        KeyFlag = 0;
    }
}

void KeyIntFunc()
{
    KeyFlag = 1;
    unsigned temp;
    temp = KEYBOARD->Value;
    int i;
    for(i=0;i<16;i++)
    {
        if(temp & (1 << i)) KeyNum = i;
    }
}