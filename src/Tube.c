#include"Tube.h"

void TubeClear()
{
    TUBE->Value = 0;
    TUBE->Enb   = 0;
}

int TubeShowHigh(uint8_t num, uint8_t point)
{
    if(num >= 999 || point >= 3)
    {
        return -1;
    }
    else
    {
        uint32_t val,enb;
        val = TUBE->Value;
        enb = TUBE->Enb;
        val = val & 0x7FFFL;
        enb = enb & 7;

        val |= 1 << (point*BitInt + PointBias + HighBias);
        val &= ~(15 << (point*BitInt + HighBias));
        enb |= 1 << (point+3);

        int i,temp;
        for(i=0;i<3;i++)
        {
            temp = num % 10;
            num /= 10;
            val |= (temp << (i*BitInt + HighBias));
            enb |= 1 << (i+3);
            if(num == 0) break;
        }
        
        TUBE->Value = val;
        TUBE->Enb   = enb;
    }
}

int TubeShowLow(uint8_t num, uint8_t point)
{
    if(num >= 999 || point >= 3)
    {
        return -1;
    }
    else
    {
        uint32_t val,enb;
        val = TUBE->Value;
        enb = TUBE->Enb;
        val = val & 0x3FFF8000L;
        enb = enb & 56;

        val |= 1 << (point*BitInt + PointBias);
        val &= ~(15 << (point*BitInt));
        enb |= 1 << (point);

        int i,temp;
        for(i=0;i<3;i++)
        {
            temp = num % 10;
            num /= 10;
            val |= (temp << (i*BitInt));
            enb |= 1 << i;
            if(num == 0) break;
        }

        TUBE->Value = val;
        TUBE->Enb   = enb;
    }
}
