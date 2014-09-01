#ifndef DRIVERS_LED_H
#define DRIVERS_LED_H

#include <stdint.h>

#define LED_ADDRESS	0xC0000000
#define LED_MODE_DATA	0x00000000
#define LED_MODE_INTR	0x00000100
#define LED_0 0x00000001
#define LED_1 0x00000002
#define LED_2 0x00000004
#define LED_3 0x00000008
#define LED_4 0x00000010
#define LED_5 0x00000020
#define LED_6 0x00000040
#define LED_7 0x00000080

uint32_t LED_read(void);
void     LED_write(uint32_t data);
void     LED_setMode(uint32_t mode);

#endif /* DRIVERS_LED_H */

