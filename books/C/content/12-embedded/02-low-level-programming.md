# Low-Level Programming

## Introduction

Low-level programming in embedded systems involves direct interaction with hardware components through memory-mapped I/O, bit manipulation, and precise control of system resources. This chapter explores advanced techniques for accessing hardware peripherals, managing memory at the register level, and optimizing code for resource-constrained environments.

## Memory-Mapped I/O

Memory-mapped I/O allows software to interact with hardware peripherals by reading from and writing to specific memory addresses that correspond to hardware registers.

### Direct Register Access

```c
#include <stdint.h>

// Example register definitions for a microcontroller
#define PERIPH_BASE       0x40000000
#define GPIOA_BASE        (PERIPH_BASE + 0x00000)
#define USART1_BASE       (PERIPH_BASE + 0x10000)

// GPIOA registers
#define GPIOA_MODER       (*(volatile uint32_t*)(GPIOA_BASE + 0x00))
#define GPIOA_OTYPER      (*(volatile uint32_t*)(GPIOA_BASE + 0x04))
#define GPIOA_OSPEEDR     (*(volatile uint32_t*)(GPIOA_BASE + 0x08))
#define GPIOA_PUPDR       (*(volatile uint32_t*)(GPIOA_BASE + 0x0C))
#define GPIOA_IDR         (*(volatile uint32_t*)(GPIOA_BASE + 0x10))
#define GPIOA_ODR         (*(volatile uint32_t*)(GPIOA_BASE + 0x14))
#define GPIOA_BSRR        (*(volatile uint32_t*)(GPIOA_BASE + 0x18))
#define GPIOA_LCKR        (*(volatile uint32_t*)(GPIOA_BASE + 0x1C))

// USART1 registers
#define USART1_SR         (*(volatile uint32_t*)(USART1_BASE + 0x00))
#define USART1_DR         (*(volatile uint32_t*)(USART1_BASE + 0x04))
#define USART1_BRR        (*(volatile uint32_t*)(USART1_BASE + 0x08))
#define USART1_CR1        (*(volatile uint32_t*)(USART1_BASE + 0x0C))
#define USART1_CR2        (*(volatile uint32_t*)(USART1_BASE + 0x10))
#define USART1_CR3        (*(volatile uint32_t*)(USART1_BASE + 0x14))

// Configure GPIO pin as output
void gpio_config_output(uint8_t pin) {
    // Set pin mode to output (01)
    GPIOA_MODER &= ~(3UL << (pin * 2));    // Clear mode bits
    GPIOA_MODER |= (1UL << (pin * 2));     // Set output mode
    
    // Set output type to push-pull (0)
    GPIOA_OTYPER &= ~(1UL << pin);
    
    // Set output speed to high (11)
    GPIOA_OSPEEDR |= (3UL << (pin * 2));
    
    // Set pull-up/pull-down to no pull (00)
    GPIOA_PUPDR &= ~(3UL << (pin * 2));
}

// Set GPIO pin high
void gpio_set(uint8_t pin) {
    GPIOA_BSRR = (1UL << pin);
}

// Clear GPIO pin (set low)
void gpio_clear(uint8_t pin) {
    GPIOA_BSRR = (1UL << (pin + 16));
}

// Toggle GPIO pin
void gpio_toggle(uint8_t pin) {
    GPIOA_ODR ^= (1UL << pin);
}

// Read GPIO pin state
uint8_t gpio_read(uint8_t pin) {
    return (GPIOA_IDR & (1UL << pin)) ? 1 : 0;
}
```

## Bit Manipulation Techniques

Bit manipulation is fundamental in embedded programming for efficient hardware control.

### Advanced Bit Operations

```c
#include <stdint.h>

// Bit manipulation macros
#define BIT(n)                    (1UL << (n))
#define BIT_MASK(len)             (BIT(len) - 1)
#define BIT_FIELD(val, pos, len)  (((val) & BIT_MASK(len)) << (pos))

#define SET_BIT(reg, bit)         ((reg) |= BIT(bit))
#define CLEAR_BIT(reg, bit)       ((reg) &= ~BIT(bit))
#define TOGGLE_BIT(reg, bit)      ((reg) ^= BIT(bit))
#define CHECK_BIT(reg, bit)       (((reg) & BIT(bit)) != 0)

#define SET_BITS(reg, pos, len, val) \
    ((reg) = ((reg) & ~(BIT_MASK(len) << (pos))) | BIT_FIELD(val, pos, len))

#define GET_BITS(reg, pos, len) \
    (((reg) >> (pos)) & BIT_MASK(len))

// Example usage
void example_bit_operations(void) {
    volatile uint32_t register_value = 0;
    
    // Set bit 5
    SET_BIT(register_value, 5);
    
    // Clear bits 2-3
    CLEAR_BITS(register_value, 2, 2);
    
    // Set bits 8-11 to value 0xA
    SET_BITS(register_value, 8, 4, 0xA);
    
    // Get value of bits 8-11
    uint32_t extracted_value = GET_BITS(register_value, 8, 4);
    
    // Check if bit 5 is set
    if (CHECK_BIT(register_value, 5)) {
        // Bit 5 is set
    }
}
```

### Bit Fields

Bit fields provide a convenient way to access specific bits within a structure:

```c
#include <stdint.h>

// GPIO register structure using bit fields
typedef struct {
    volatile uint32_t MODER   : 32;  // Port mode register
    volatile uint32_t OTYPER  : 16;  // Port output type register
    volatile uint32_t OSPEEDR : 32;  // Port output speed register
    volatile uint32_t PUPDR   : 32;  // Port pull-up/pull-down register
    volatile uint32_t IDR     : 16;  // Port input data register
    volatile uint32_t ODR     : 16;  // Port output data register
    volatile uint32_t BSRR    : 32;  // Port bit set/reset register
    volatile uint32_t LCKR    : 32;  // Port configuration lock register
    // ... other registers
} GPIO_TypeDef;

// Access GPIO registers using bit fields
#define GPIOA_BASE_ADDR  0x40020000
#define GPIOA            ((GPIO_TypeDef *)GPIOA_BASE_ADDR)

void gpio_bitfield_example(void) {
    // Configure pin 0 as output using bit fields
    GPIOA->MODER &= ~(3UL << 0);    // Clear mode bits for pin 0
    GPIOA->MODER |= (1UL << 0);     // Set output mode for pin 0
    
    // Set pin 0 high
    GPIOA->BSRR = (1UL << 0);
}
```

## Inline Assembly

Inline assembly allows embedding assembly code directly within C functions for maximum performance and hardware control.

### Basic Inline Assembly

```c
#include <stdint.h>

// Simple inline assembly example
void nop_instruction(void) {
    __asm__ volatile ("nop");
}

// Inline assembly with input/output operands
uint32_t rotate_left(uint32_t value, uint32_t shift) {
    uint32_t result;
    
    __asm__ volatile (
        "ror %0, %1, %2"
        : "=r" (result)           // Output operand
        : "r" (value), "r" (shift) // Input operands
    );
    
    return result;
}

// Memory barrier using inline assembly
void memory_barrier(void) {
    __asm__ volatile ("" ::: "memory");
}
```

### Advanced Inline Assembly

```c
// Atomic increment using inline assembly
int32_t atomic_increment(volatile int32_t *value) {
    int32_t result;
    
    __asm__ volatile (
        "1: ldrex  %0, [%1]     \n"  // Load exclusive
        "   add    %0, %0, #1   \n"  // Increment
        "   strex  r1, %0, [%1] \n"  // Store exclusive
        "   cmp    r1, #0       \n"  // Check if successful
        "   bne    1b           \n"  // Retry if not successful
        : "=&r" (result)
        : "r" (value)
        : "r1", "cc", "memory"
    );
    
    return result;
}

// Disable interrupts
void disable_interrupts(void) {
    __asm__ volatile (
        "cpsid i"
        ::: "memory"
    );
}

// Enable interrupts
void enable_interrupts(void) {
    __asm__ volatile (
        "cpsie i"
        ::: "memory"
    );
}
```

## Memory Management

Efficient memory management is critical in resource-constrained embedded systems.

### Custom Memory Allocator

```c
#include <stdint.h>
#include <stddef.h>

#define HEAP_SIZE 4096
static uint8_t heap[HEAP_SIZE];
static size_t heap_top = 0;

// Simple memory allocator
void* simple_malloc(size_t size) {
    // Align to 4-byte boundary
    size = (size + 3) & ~3;
    
    if (heap_top + size > HEAP_SIZE) {
        return NULL;  // Out of memory
    }
    
    void *ptr = &heap[heap_top];
    heap_top += size;
    
    return ptr;
}

// Simple memory deallocator (does nothing in this simple implementation)
void simple_free(void *ptr) {
    // In a real implementation, you would track allocated blocks
    // This simple version just ignores deallocation
    (void)ptr;
}

// Reset heap (for demonstration)
void heap_reset(void) {
    heap_top = 0;
}
```

### Memory Sections and Linker Scripts

Understanding memory sections and linker scripts is crucial for embedded development:

```c
// Example of placing variables in specific memory sections
__attribute__((section(".ramfunc"))) 
void fast_function(void) {
    // Function placed in RAM for faster execution
}

__attribute__((aligned(16)))
uint32_t aligned_buffer[32];  // 16-byte aligned buffer

// Place variable in specific memory region
__attribute__((section(".ccmram"))) 
uint32_t ccm_data[100];  // Placed in Core Coupled Memory

// Zero-initialize variable in .bss section
static uint32_t bss_variable;

// Initialize variable in .data section
static uint32_t data_variable = 0x12345678;

// Read-only variable in .rodata section
static const uint32_t rodata_variable = 0xABCDEF00;
```

## Hardware Abstraction Layer (HAL)

Creating a hardware abstraction layer improves code portability and maintainability.

### GPIO HAL Implementation

```c
#include <stdint.h>

// GPIO port enumeration
typedef enum {
    GPIO_PORT_A,
    GPIO_PORT_B,
    GPIO_PORT_C,
    // ... other ports
} gpio_port_t;

// GPIO pin enumeration
typedef enum {
    GPIO_PIN_0 = 0,
    GPIO_PIN_1,
    GPIO_PIN_2,
    GPIO_PIN_3,
    GPIO_PIN_4,
    GPIO_PIN_5,
    GPIO_PIN_6,
    GPIO_PIN_7,
    GPIO_PIN_8,
    GPIO_PIN_9,
    GPIO_PIN_10,
    GPIO_PIN_11,
    GPIO_PIN_12,
    GPIO_PIN_13,
    GPIO_PIN_14,
    GPIO_PIN_15
} gpio_pin_t;

// GPIO mode enumeration
typedef enum {
    GPIO_MODE_INPUT = 0,
    GPIO_MODE_OUTPUT,
    GPIO_MODE_AF,
    GPIO_MODE_ANALOG
} gpio_mode_t;

// GPIO output type enumeration
typedef enum {
    GPIO_OTYPE_PP = 0,  // Push-pull
    GPIO_OTYPE_OD       // Open-drain
} gpio_otype_t;

// GPIO speed enumeration
typedef enum {
    GPIO_SPEED_LOW = 0,
    GPIO_SPEED_MEDIUM,
    GPIO_SPEED_HIGH,
    GPIO_SPEED_VERY_HIGH
} gpio_speed_t;

// GPIO pull-up/pull-down enumeration
typedef enum {
    GPIO_PUPD_NONE = 0,
    GPIO_PUPD_UP,
    GPIO_PUPD_DOWN
} gpio_pupd_t;

// GPIO configuration structure
typedef struct {
    gpio_mode_t mode;
    gpio_otype_t otype;
    gpio_speed_t speed;
    gpio_pupd_t pupd;
} gpio_config_t;

// Base addresses for GPIO ports
#define GPIOA_BASE  0x40020000
#define GPIOB_BASE  0x40020400
#define GPIOC_BASE  0x40020800

// GPIO register structure
typedef struct {
    volatile uint32_t MODER;    // GPIO port mode register
    volatile uint32_t OTYPER;   // GPIO port output type register
    volatile uint32_t OSPEEDR;  // GPIO port output speed register
    volatile uint32_t PUPDR;    // GPIO port pull-up/pull-down register
    volatile uint32_t IDR;      // GPIO port input data register
    volatile uint32_t ODR;      // GPIO port output data register
    volatile uint32_t BSRR;     // GPIO port bit set/reset register
    volatile uint32_t LCKR;     // GPIO port configuration lock register
    volatile uint32_t AFR[2];   // GPIO alternate function registers
} gpio_reg_t;

// Get GPIO register pointer
static gpio_reg_t* get_gpio_reg(gpio_port_t port) {
    switch (port) {
        case GPIO_PORT_A: return (gpio_reg_t*)GPIOA_BASE;
        case GPIO_PORT_B: return (gpio_reg_t*)GPIOB_BASE;
        case GPIO_PORT_C: return (gpio_reg_t*)GPIOC_BASE;
        default: return NULL;
    }
}

// Configure GPIO pin
int gpio_init(gpio_port_t port, gpio_pin_t pin, const gpio_config_t *config) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio == NULL || config == NULL) {
        return -1;
    }
    
    uint32_t pin_pos = (uint32_t)pin * 2;
    
    // Configure mode
    gpio->MODER &= ~(3UL << pin_pos);
    gpio->MODER |= ((uint32_t)config->mode << pin_pos);
    
    // Configure output type (only for output modes)
    if (config->mode == GPIO_MODE_OUTPUT || config->mode == GPIO_MODE_AF) {
        gpio->OTYPER &= ~(1UL << pin);
        gpio->OTYPER |= ((uint32_t)config->otype << pin);
    }
    
    // Configure speed
    gpio->OSPEEDR &= ~(3UL << pin_pos);
    gpio->OSPEEDR |= ((uint32_t)config->speed << pin_pos);
    
    // Configure pull-up/pull-down
    gpio->PUPDR &= ~(3UL << pin_pos);
    gpio->PUPDR |= ((uint32_t)config->pupd << pin_pos);
    
    return 0;
}

// Set GPIO pin high
void gpio_set(gpio_port_t port, gpio_pin_t pin) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio != NULL) {
        gpio->BSRR = (1UL << pin);
    }
}

// Clear GPIO pin (set low)
void gpio_clear(gpio_port_t port, gpio_pin_t pin) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio != NULL) {
        gpio->BSRR = (1UL << (pin + 16));
    }
}

// Toggle GPIO pin
void gpio_toggle(gpio_port_t port, gpio_pin_t pin) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio != NULL) {
        gpio->ODR ^= (1UL << pin);
    }
}

// Read GPIO pin state
int gpio_read(gpio_port_t port, gpio_pin_t pin) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio != NULL) {
        return (gpio->IDR & (1UL << pin)) ? 1 : 0;
    }
    return -1;
}
```

## Interrupt Management

Proper interrupt management is essential for responsive embedded systems.

### Nested Vectored Interrupt Controller (NVIC)

```c
// NVIC registers
#define NVIC_BASE  0xE000E100
#define NVIC_ISER  ((volatile uint32_t*)(NVIC_BASE + 0x000))  // Interrupt set-enable
#define NVIC_ICER  ((volatile uint32_t*)(NVIC_BASE + 0x080))  // Interrupt clear-enable
#define NVIC_ISPR  ((volatile uint32_t*)(NVIC_BASE + 0x100))  // Interrupt set-pending
#define NVIC_ICPR  ((volatile uint32_t*)(NVIC_BASE + 0x180))  // Interrupt clear-pending
#define NVIC_IPR   ((volatile uint8_t*)(NVIC_BASE + 0x300))   // Interrupt priority

// Enable interrupt
void nvic_enable_irq(uint8_t irq_number) {
    NVIC_ISER[irq_number >> 5] = (1UL << (irq_number & 0x1F));
}

// Disable interrupt
void nvic_disable_irq(uint8_t irq_number) {
    NVIC_ICER[irq_number >> 5] = (1UL << (irq_number & 0x1F));
}

// Set interrupt priority
void nvic_set_priority(uint8_t irq_number, uint8_t priority) {
    NVIC_IPR[irq_number] = (priority << 4) & 0xFF;
}

// Global interrupt enable/disable
void enable_irq(void) {
    __asm__ volatile ("cpsie i" ::: "memory");
}

void disable_irq(void) {
    __asm__ volatile ("cpsid i" ::: "memory");
}
```

## Practical Examples

### UART Driver Implementation

```c
#include <stdint.h>

// UART registers
typedef struct {
    volatile uint32_t SR;    // Status register
    volatile uint32_t DR;    // Data register
    volatile uint32_t BRR;   // Baud rate register
    volatile uint32_t CR1;   // Control register 1
    volatile uint32_t CR2;   // Control register 2
    volatile uint32_t CR3;   // Control register 3
    volatile uint32_t GTPR;  // Guard time and prescaler register
} uart_reg_t;

#define USART1_BASE  0x40011000
#define USART1       ((uart_reg_t*)USART1_BASE)

// UART status flags
#define UART_FLAG_TXE   (1UL << 7)  // Transmit data register empty
#define UART_FLAG_RXNE  (1UL << 5)  // Read data register not empty
#define UART_FLAG_TC    (1UL << 6)  // Transmission complete

// UART control bits
#define UART_CR1_TE     (1UL << 3)  // Transmitter enable
#define UART_CR1_RE     (1UL << 2)  // Receiver enable
#define UART_CR1_UE     (1UL << 0)  // UART enable

// Initialize UART
int uart_init(uint32_t baudrate, uint32_t peripheral_clock) {
    // Enable UART clock (implementation-specific)
    // RCC->APB2ENR |= RCC_APB2ENR_USART1EN;
    
    // Configure baud rate
    uint32_t baud_div = (peripheral_clock + (baudrate / 2)) / baudrate;
    USART1->BRR = baud_div;
    
    // Configure UART (8N1, no flow control)
    USART1->CR1 = UART_CR1_TE | UART_CR1_RE | UART_CR1_UE;
    
    return 0;
}

// Send character
void uart_putc(char c) {
    // Wait for transmit data register to be empty
    while (!(USART1->SR & UART_FLAG_TXE));
    
    // Send character
    USART1->DR = c;
}

// Send string
void uart_puts(const char *str) {
    while (*str) {
        uart_putc(*str++);
    }
}

// Receive character
char uart_getc(void) {
    // Wait for receive data register to be not empty
    while (!(USART1->SR & UART_FLAG_RXNE));
    
    // Read character
    return (char)(USART1->DR & 0xFF);
}

// Check if data is available
int uart_available(void) {
    return (USART1->SR & UART_FLAG_RXNE) ? 1 : 0;
}

// Example usage
int main(void) {
    // Initialize UART for 115200 baud
    uart_init(115200, 16000000);  // 16MHz peripheral clock
    
    uart_puts("Hello, Embedded World!\r\n");
    
    while (1) {
        if (uart_available()) {
            char c = uart_getc();
            uart_putc(c);  // Echo character
        }
    }
    
    return 0;
}
```

## Summary

Low-level programming in embedded systems involves:

1. **Memory-Mapped I/O** - Direct hardware register access
2. **Bit Manipulation** - Efficient control of individual bits and bit fields
3. **Inline Assembly** - Maximum performance and hardware control
4. **Memory Management** - Custom allocators and memory section control
5. **Hardware Abstraction** - Portable and maintainable code
6. **Interrupt Management** - Responsive system behavior
7. **Peripheral Drivers** - Interface with hardware components

These techniques enable developers to create efficient, reliable embedded applications that make optimal use of limited system resources while maintaining precise control over hardware behavior.