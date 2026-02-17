# Embedded Basics

## Introduction

Embedded systems are specialized computing systems designed to perform dedicated functions within larger mechanical or electrical systems. Unlike general-purpose computers, embedded systems are typically resource-constrained and optimized for specific tasks. Understanding the fundamentals of embedded systems is essential for developing efficient and reliable embedded applications in C.

## What are Embedded Systems?

An embedded system is a computer system with a dedicated function within a larger mechanical or electrical system, often with real-time computing constraints. These systems are embedded as part of a complete device, often including hardware and mechanical parts.

### Characteristics of Embedded Systems

1. **Dedicated Function** - Designed for specific tasks rather than general-purpose computing
2. **Resource Constraints** - Limited memory, processing power, and energy consumption
3. **Real-time Operation** - Often required to respond within strict time constraints
4. **Reliability** - Must operate continuously and reliably for extended periods
5. **Cost Sensitivity** - Optimized for low production costs
6. **Power Efficiency** - Often battery-powered with strict power consumption requirements

### Types of Embedded Systems

1. **Small-Scale Embedded Systems** - Simple 8-bit or 16-bit microcontrollers
2. **Medium-Scale Embedded Systems** - 16-bit or 32-bit processors with limited memory
3. **Sophisticated Embedded Systems** - Complex 32-bit or 64-bit processors with extensive memory

## Embedded System Architecture

### Microcontroller vs Microprocessor

**Microcontroller (MCU)**:
- Integrated CPU, memory, and I/O peripherals on a single chip
- Self-contained system with minimal external components
- Common in small-scale embedded applications

**Microprocessor (MPU)**:
- CPU only, requires external memory and peripherals
- More powerful but requires additional components
- Common in medium to large-scale embedded applications

### Typical Embedded System Components

1. **Processor** - Central processing unit (CPU)
2. **Memory** - RAM, ROM/Flash for program and data storage
3. **Input/Output Ports** - GPIO, serial interfaces, ADC/DAC
4. **Timers/Counters** - For timing and counting operations
5. **Interrupt Controller** - Manages interrupt requests
6. **Clock Circuit** - Provides timing reference
7. **Power Management** - Regulates power consumption

## Development Environments

### Cross-Compilation

Embedded development typically involves cross-compilation, where code is compiled on a host computer for a different target platform.

```bash
# Example cross-compilation for ARM Cortex-M
arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -o program.elf program.c
```

### Development Tools

1. **Cross-Compiler** - GCC, IAR, Keil
2. **Integrated Development Environment (IDE)** - Eclipse, Keil µVision, IAR Embedded Workbench
3. **Debugger** - JTAG/SWD debuggers, GDB
4. **Emulator/Simulator** - QEMU, Proteus
5. **Programmer** - Tools to flash code to target hardware

## Memory Organization

### Memory Types

1. **Flash/ROM** - Non-volatile storage for program code
2. **RAM** - Volatile storage for variables and stack
3. **EEPROM** - Non-volatile storage for configuration data
4. **Registers** - Memory-mapped hardware control registers

### Memory Map Example

```c
// Typical memory map for ARM Cortex-M3
// 0x00000000 - 0x0007FFFF: Code (Flash)
// 0x20000000 - 0x20007FFF: SRAM
// 0x40000000 - 0x400FFFFF: Peripheral registers
// 0xE0000000 - 0xE00FFFFF: Debug registers
```

## Basic Embedded C Programming

### Startup Code

Embedded programs require special startup code to initialize the system:

```c
// Minimal startup code example
extern unsigned int _etext;
extern unsigned int _data;
extern unsigned int _edata;
extern unsigned int _bss;
extern unsigned int _ebss;

void Reset_Handler(void) {
    unsigned int *src, *dst;
    
    // Copy initialized data from Flash to RAM
    src = &_etext;
    dst = &_data;
    while (dst < &_edata) {
        *dst++ = *src++;
    }
    
    // Clear BSS (zero-initialized data)
    dst = &_bss;
    while (dst < &_ebss) {
        *dst++ = 0;
    }
    
    // Call main function
    main();
    
    // Should never reach here
    while (1);
}
```

### Memory Sections

Understanding memory sections is crucial for embedded programming:

```c
// Example of variable placement in different memory sections

// Placed in .data section (initialized data)
int initialized_var = 42;

// Placed in .bss section (zero-initialized data)
int uninitialized_var;

// Placed in .rodata section (read-only data)
const int constant_var = 100;

// Placed in .text section (code)
void example_function(void) {
    static int static_var = 10;  // .data section
    static int static_uninit;    // .bss section
}
```

## Hardware Abstraction

### Register Definitions

Embedded programming often involves direct hardware register access:

```c
// Example register definitions for a hypothetical microcontroller
#define GPIO_BASE_ADDR    0x40020000
#define GPIO_PORTA_DIR    (*(volatile unsigned int*)(GPIO_BASE_ADDR + 0x00))
#define GPIO_PORTA_DATA   (*(volatile unsigned int*)(GPIO_BASE_ADDR + 0x04))
#define GPIO_PORTA_SET    (*(volatile unsigned int*)(GPIO_BASE_ADDR + 0x08))
#define GPIO_PORTA_CLEAR  (*(volatile unsigned int*)(GPIO_BASE_ADDR + 0x0C))

// Example usage
void gpio_init(void) {
    // Set PORTA pins 0-3 as outputs
    GPIO_PORTA_DIR = 0x0F;
}

void gpio_set_pin(int pin) {
    // Set specific pin
    GPIO_PORTA_SET = (1 << pin);
}

void gpio_clear_pin(int pin) {
    // Clear specific pin
    GPIO_PORTA_CLEAR = (1 << pin);
}
```

### Bit Manipulation

Bit manipulation is fundamental in embedded programming:

```c
#include <stdint.h>

// Bit manipulation macros
#define SET_BIT(reg, bit)      ((reg) |= (1U << (bit)))
#define CLEAR_BIT(reg, bit)    ((reg) &= ~(1U << (bit)))
#define TOGGLE_BIT(reg, bit)   ((reg) ^= (1U << (bit)))
#define CHECK_BIT(reg, bit)    (((reg) >> (bit)) & 1U)

// Example usage
volatile uint32_t gpio_port = 0;

void example_bit_operations(void) {
    // Set bit 3
    SET_BIT(gpio_port, 3);
    
    // Clear bit 1
    CLEAR_BIT(gpio_port, 1);
    
    // Toggle bit 2
    TOGGLE_BIT(gpio_port, 2);
    
    // Check if bit 3 is set
    if (CHECK_BIT(gpio_port, 3)) {
        // Bit 3 is set
    }
}
```

## Interrupt Handling

Interrupts are essential for real-time embedded systems:

```c
// Example interrupt handler
void UART_IRQHandler(void) {
    volatile unsigned int status;
    
    // Read interrupt status
    status = UART_STATUS_REG;
    
    // Check for receive interrupt
    if (status & UART_RX_INTERRUPT) {
        // Read received data
        char data = UART_DATA_REG;
        
        // Process received data
        process_received_data(data);
    }
    
    // Clear interrupt flag
    UART_STATUS_REG = UART_RX_INTERRUPT;
}

// Enable interrupt
void enable_uart_interrupt(void) {
    // Enable UART receive interrupt
    UART_CTRL_REG |= UART_RX_INTERRUPT_ENABLE;
    
    // Enable global interrupts
    __enable_irq();
}
```

## Timing and Delays

Precise timing is often required in embedded systems:

```c
#include <stdint.h>

// Simple software delay (blocking)
void delay_ms(uint32_t ms) {
    // Assuming 1MHz clock, adjust for your system
    for (uint32_t i = 0; i < ms * 1000; i++) {
        // Small delay loop
        for (int j = 0; j < 1000; j++) {
            __asm__("nop");  // No operation instruction
        }
    }
}

// Timer-based delay (non-blocking)
volatile uint32_t system_ticks = 0;

void SysTick_Handler(void) {
    system_ticks++;
}

void delay_ms_timer(uint32_t ms) {
    uint32_t start_ticks = system_ticks;
    while ((system_ticks - start_ticks) < ms) {
        // Wait for specified time
    }
}
```

## Practical Examples

### LED Blinker Program

```c
#include <stdint.h>

// Simplified register definitions
#define GPIO_PORT_ADDR    0x40020000
#define GPIO_DIR_REG      (*(volatile uint32_t*)(GPIO_PORT_ADDR + 0x00))
#define GPIO_DATA_REG     (*(volatile uint32_t*)(GPIO_PORT_ADDR + 0x04))

#define LED_PIN           0  // LED connected to pin 0

// Simple delay function
void delay(volatile uint32_t count) {
    while (count--) {
        __asm__("nop");
    }
}

// Initialize GPIO for LED
void led_init(void) {
    // Set pin as output
    GPIO_DIR_REG |= (1 << LED_PIN);
}

// Turn LED on
void led_on(void) {
    GPIO_DATA_REG |= (1 << LED_PIN);
}

// Turn LED off
void led_off(void) {
    GPIO_DATA_REG &= ~(1 << LED_PIN);
}

// Toggle LED
void led_toggle(void) {
    GPIO_DATA_REG ^= (1 << LED_PIN);
}

int main(void) {
    // Initialize LED
    led_init();
    
    // Main loop
    while (1) {
        led_on();
        delay(1000000);  // Delay
        
        led_off();
        delay(1000000);  // Delay
    }
    
    return 0;
}
```

### Button Input Handler

```c
#include <stdint.h>

// Register definitions
#define GPIO_PORT_ADDR    0x40020000
#define GPIO_DIR_REG      (*(volatile uint32_t*)(GPIO_PORT_ADDR + 0x00))
#define GPIO_DATA_REG     (*(volatile uint32_t*)(GPIO_PORT_ADDR + 0x04))

#define BUTTON_PIN        1  // Button connected to pin 1
#define LED_PIN           0  // LED connected to pin 0

// Button state
typedef enum {
    BUTTON_RELEASED,
    BUTTON_PRESSED
} button_state_t;

// Initialize GPIO
void gpio_init(void) {
    // Set LED pin as output
    GPIO_DIR_REG |= (1 << LED_PIN);
    
    // Set button pin as input
    GPIO_DIR_REG &= ~(1 << BUTTON_PIN);
}

// Read button state
button_state_t read_button(void) {
    // Active low button (0 when pressed)
    if ((GPIO_DATA_REG & (1 << BUTTON_PIN)) == 0) {
        return BUTTON_PRESSED;
    }
    return BUTTON_RELEASED;
}

// Simple debouncing
button_state_t debounce_button(void) {
    static button_state_t last_state = BUTTON_RELEASED;
    static uint32_t press_time = 0;
    static uint32_t release_time = 0;
    
    button_state_t current_state = read_button();
    
    if (current_state != last_state) {
        if (current_state == BUTTON_PRESSED) {
            press_time = 0;  // Reset timer
        } else {
            release_time = 0;  // Reset timer
        }
    } else {
        if (current_state == BUTTON_PRESSED) {
            press_time++;
            if (press_time > 50) {  // 50ms debounce
                return BUTTON_PRESSED;
            }
        } else {
            release_time++;
            if (release_time > 50) {  // 50ms debounce
                return BUTTON_RELEASED;
            }
        }
    }
    
    return last_state;
}

int main(void) {
    gpio_init();
    
    while (1) {
        button_state_t state = debounce_button();
        
        if (state == BUTTON_PRESSED) {
            // Turn LED on when button is pressed
            GPIO_DATA_REG |= (1 << LED_PIN);
        } else {
            // Turn LED off when button is released
            GPIO_DATA_REG &= ~(1 << LED_PIN);
        }
    }
    
    return 0;
}
```

## Summary

Embedded systems programming requires understanding of:

1. **System Architecture** - Microcontrollers vs microprocessors, memory organization
2. **Development Environment** - Cross-compilation, debugging tools
3. **Memory Management** - Different memory sections and their usage
4. **Hardware Interaction** - Direct register access, bit manipulation
5. **Interrupt Handling** - Real-time event processing
6. **Timing Considerations** - Delays, precise timing requirements

These fundamentals form the foundation for more advanced embedded programming topics. The next chapter will cover low-level programming techniques in greater detail.