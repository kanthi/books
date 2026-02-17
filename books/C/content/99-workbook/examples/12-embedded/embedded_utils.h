#ifndef EMBEDDED_UTILS_H
#define EMBEDDED_UTILS_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

// Type definitions for embedded systems
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef int8_t   s8;
typedef int16_t  s16;
typedef int32_t  s32;

// Bit manipulation macros
#define SET_BIT(reg, bit)      ((reg) |= (1 << (bit)))
#define CLEAR_BIT(reg, bit)    ((reg) &= ~(1 << (bit)))
#define TOGGLE_BIT(reg, bit)   ((reg) ^= (1 << (bit)))
#define CHECK_BIT(reg, bit)    (((reg) >> (bit)) & 1)

// Memory-mapped I/O simulation
#define MMIO32(addr)  (*((volatile u32 *)(addr)))
#define MMIO16(addr)  (*((volatile u16 *)(addr)))
#define MMIO8(addr)   (*((volatile u8 *)(addr)))

// Register definitions (simulated)
#define GPIO_BASE      0x40020000
#define GPIOA_MODER    MMIO32(GPIO_BASE + 0x00)
#define GPIOA_OTYPER   MMIO32(GPIO_BASE + 0x04)
#define GPIOA_ODR      MMIO32(GPIO_BASE + 0x14)

// Function prototypes for embedded utilities
void delay_ms(unsigned int ms);
void gpio_init(void);
void gpio_set_pin(int pin, bool state);
bool gpio_get_pin(int pin);
void uart_init(int baud_rate);
void uart_send_char(char ch);
void uart_send_string(const char* str);
char uart_receive_char(void);
void spi_init(void);
void spi_send_receive(u8* data, int length);
void i2c_init(void);
bool i2c_write(u8 device_addr, u8 reg_addr, u8* data, int length);
bool i2c_read(u8 device_addr, u8 reg_addr, u8* data, int length);

#endif // EMBEDDED_UTILS_H