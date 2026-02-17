#include "embedded_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> // For usleep

// Delay function (simulated for demonstration)
void delay_ms(unsigned int ms) {
    // In real embedded systems, this would use hardware timers
    // For simulation, we use usleep (microseconds)
    usleep(ms * 1000);
}

// GPIO initialization (simulated)
void gpio_init(void) {
    // In real embedded systems, this would configure GPIO registers
    printf("GPIO initialized\n");
}

// Set GPIO pin state (simulated)
void gpio_set_pin(int pin, bool state) {
    // In real embedded systems, this would modify GPIO registers
    if (state) {
        SET_BIT(GPIOA_ODR, pin);
        printf("GPIO pin %d set to HIGH\n", pin);
    } else {
        CLEAR_BIT(GPIOA_ODR, pin);
        printf("GPIO pin %d set to LOW\n", pin);
    }
}

// Get GPIO pin state (simulated)
bool gpio_get_pin(int pin) {
    // In real embedded systems, this would read from GPIO registers
    bool state = CHECK_BIT(GPIOA_ODR, pin);
    printf("GPIO pin %d read as %s\n", pin, state ? "HIGH" : "LOW");
    return state;
}

// UART initialization (simulated)
void uart_init(int baud_rate) {
    // In real embedded systems, this would configure UART registers
    printf("UART initialized with baud rate %d\n", baud_rate);
}

// Send character via UART (simulated)
void uart_send_char(char ch) {
    // In real embedded systems, this would write to UART data register
    putchar(ch);
    fflush(stdout);
}

// Send string via UART (simulated)
void uart_send_string(const char* str) {
    // In real embedded systems, this would send each character
    while (*str) {
        uart_send_char(*str++);
    }
}

// Receive character via UART (simulated)
char uart_receive_char(void) {
    // In real embedded systems, this would read from UART data register
    return getchar();
}

// SPI initialization (simulated)
void spi_init(void) {
    // In real embedded systems, this would configure SPI registers
    printf("SPI initialized\n");
}

// SPI send/receive (simulated)
void spi_send_receive(u8* data, int length) {
    // In real embedded systems, this would use SPI hardware
    printf("SPI transaction: ");
    for (int i = 0; i < length; i++) {
        printf("0x%02X ", data[i]);
    }
    printf("\n");
}

// I2C initialization (simulated)
void i2c_init(void) {
    // In real embedded systems, this would configure I2C registers
    printf("I2C initialized\n");
}

// I2C write (simulated)
bool i2c_write(u8 device_addr, u8 reg_addr, u8* data, int length) {
    // In real embedded systems, this would perform I2C write transaction
    printf("I2C write to device 0x%02X, register 0x%02X: ", device_addr, reg_addr);
    for (int i = 0; i < length; i++) {
        printf("0x%02X ", data[i]);
    }
    printf("\n");
    return true; // Success
}

// I2C read (simulated)
bool i2c_read(u8 device_addr, u8 reg_addr, u8* data, int length) {
    // In real embedded systems, this would perform I2C read transaction
    printf("I2C read from device 0x%02X, register 0x%02X, length %d\n", 
           device_addr, reg_addr, length);
    
    // Simulate reading some data
    for (int i = 0; i < length; i++) {
        data[i] = 0x55 + i; // Dummy data
    }
    
    return true; // Success
}