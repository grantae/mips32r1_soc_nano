#include "drivers/led.h"

void dead_loop(void)
{
	LED_write(LED_7 | LED_0);
	for (;;) {}
}

void mips32_handler_AdEL(void)
{
	dead_loop();
}

void mips32_handler_AdES(void)
{
	dead_loop();
}

void mips32_handler_Bp(void)
{
	dead_loop();
}

void mips32_handler_CpU(void)
{
	dead_loop();
}

void mips32_handler_Ov(void)
{
	dead_loop();
}

void mips32_handler_RI(void)
{
	dead_loop();
}

void mips32_handler_Sys(void)
{
	dead_loop();
}

void mips32_handler_Tr(void)
{
	dead_loop();
}

/* Timer */
void mips32_handler_HwInt5(void)
{
    /* There are eight LEDs in a 16-bit field: 
     *
     *          ....xxxxxxxx....
     * 
     * Only a single bit is hot and it swashes from left to right
     * by one position each time the timer interrupt occurs.
     */
    static uint16_t light_field = 0x0010;
    static uint32_t move_left = 1;

    LED_write((light_field >> 4) & 0xff);
    if (move_left) {
        light_field <<= 1;
        if (light_field > 0x0400) {
            move_left = 0;
        }
    }
    else {
        light_field >>= 1;
        if (light_field < 0x0020) {
            move_left = 1;
        }
    }

    /* The timer period is handled in os/exceptions.asm. */
}

void mips32_handler_HwInt4(void)
{
}

void mips32_handler_HwInt3(void)
{
}

void mips32_handler_HwInt2(void)
{
}

void mips32_handler_HwInt1(void)
{
}

void mips32_handler_HwInt0(void)
{
}

void mips32_handler_SwInt1(void)
{
}

void mips32_handler_SwInt0(void)
{
}

