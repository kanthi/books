# Embedded C Techniques

## Introduction

Embedded C programming requires specialized techniques and language extensions to efficiently utilize limited resources while maintaining code reliability and performance. This chapter explores advanced C programming techniques specifically tailored for embedded systems, including compiler extensions, optimization strategies, and specialized language features.

## Compiler Extensions and Attributes

Modern embedded compilers provide extensions that enhance C's capabilities for embedded development.

### GCC Attributes

GCC provides numerous attributes to control code generation and optimization:

```c
#include <stdint.h>

// Align variable to specific boundary
__attribute__((aligned(16)))
uint32_t aligned_array[32];

// Place function in specific section
__attribute__((section(".ramfunc")))
void fast_function(void) {
    // Code placed in RAM for faster execution
}

// Never return function (noreturn)
__attribute__((noreturn))
void system_reset(void) {
    // Reset system
    // This function never returns
    while (1);
}

// Weak symbol (can be overridden)
__attribute__((weak))
void default_handler(void) {
    // Default interrupt handler
    while (1);
}

// Pack structure to minimize padding
__attribute__((packed))
struct packed_data {
    uint8_t byte1;
    uint16_t word1;
    uint8_t byte2;
};

// Always inline function
__attribute__((always_inline))
static inline uint32_t fast_multiply(uint32_t a, uint32_t b) {
    return a * b;
}

// Never inline function
__attribute__((noinline))
void critical_function(void) {
    // Function that should never be inlined
}

// Specify function call convention
__attribute__((long_call))
void far_function(void) {
    // Function that may be far away in memory
}
```

### IAR and Keil Extensions

Different compilers provide their own extensions:

```c
// IAR specific pragmas
#pragma location = "MY_SECTION"
__no_init uint32_t persistent_data;  // No initialization

// Keil specific attributes
__align(16)
uint32_t keil_aligned_array[32];

// ARM-specific intrinsics
#include <arm_acle.h>

void example_intrinsics(void) {
    // Count leading zeros
    uint32_t value = 0x00100000;
    uint32_t clz = __clz(value);  // Count leading zeros
    
    // Reverse bits
    uint32_t reversed = __rbit(value);
    
    // Byte-swap
    uint32_t swapped = __rev(value);
}
```

## Optimization Techniques

Embedded systems require careful optimization to balance performance, size, and power consumption.

### Compiler Optimization Levels

```c
// Optimization levels (GCC examples)
// -O0: No optimization (default for debugging)
// -O1: Basic optimization
// -O2: Full optimization
// -O3: Aggressive optimization
// -Os: Optimize for size
// -Ofast: Fastest possible (may violate standards)

// Function-specific optimization
__attribute__((optimize("O3")))
void optimized_function(void) {
    // This function will be optimized with -O3 regardless of global settings
}

__attribute__((optimize("Os")))
void size_optimized_function(void) {
    // This function will be optimized for size
}
```

### Manual Optimization Techniques

```c
#include <stdint.h>

// Loop unrolling
void manual_unroll_example(uint32_t *array, uint32_t size) {
    uint32_t i;
    
    // Unrolled loop (process 4 elements per iteration)
    for (i = 0; i < size - 3; i += 4) {
        array[i] += 1;
        array[i+1] += 1;
        array[i+2] += 1;
        array[i+3] += 1;
    }
    
    // Handle remaining elements
    for (; i < size; i++) {
        array[i] += 1;
    }
}

// Strength reduction
uint32_t strength_reduction_example(uint32_t x, uint32_t iterations) {
    // Instead of multiplication in loop
    uint32_t result = 0;
    uint32_t multiplier = x;
    
    for (uint32_t i = 0; i < iterations; i++) {
        result += multiplier;  // Addition instead of multiplication
        multiplier += x;       // Increment instead of multiplication
    }
    
    return result;
}

// Lookup tables for expensive calculations
static const uint8_t sine_table[256] = {
    // Pre-calculated sine values
    128, 131, 134, 137, 140, 143, 146, 149, 152, 155, 158, 161, 164, 167, 170, 173,
    176, 179, 182, 185, 188, 191, 194, 196, 199, 202, 205, 207, 210, 213, 215, 218,
    // ... more values
};

uint8_t fast_sine(uint8_t angle) {
    return sine_table[angle];
}
```

## Fixed-Point Arithmetic

Floating-point operations are expensive on many embedded processors. Fixed-point arithmetic provides an efficient alternative.

```c
#include <stdint.h>

// Fixed-point types (Q-format)
typedef int32_t q16_16;  // 16 integer bits, 16 fractional bits
typedef int16_t q8_8;    // 8 integer bits, 8 fractional bits

// Convert between integer and fixed-point
#define INT_TO_Q16_16(x) ((q16_16)((x) << 16))
#define Q16_16_TO_INT(x) ((int32_t)((x) >> 16))

// Fixed-point multiplication (Q16.16)
q16_16 q16_16_mul(q16_16 a, q16_16 b) {
    // Multiply and shift to maintain Q16.16 format
    return (q16_16)(((int64_t)a * b) >> 16);
}

// Fixed-point division (Q16.16)
q16_16 q16_16_div(q16_16 a, q16_16 b) {
    // Divide and shift to maintain Q16.16 format
    return (q16_16)(((int64_t)a << 16) / b);
}

// Fixed-point addition and subtraction (same format)
q16_16 q16_16_add(q16_16 a, q16_16 b) {
    return a + b;
}

q16_16 q16_16_sub(q16_16 a, q16_16 b) {
    return a - b;
}

// Example usage
void fixed_point_example(void) {
    q16_16 a = INT_TO_Q16_16(3);     // 3.0 in Q16.16
    q16_16 b = INT_TO_Q16_16(2) + (1 << 15);  // 2.5 in Q16.16
    
    q16_16 result = q16_16_mul(a, b);  // 3.0 * 2.5 = 7.5
    int32_t integer_result = Q16_16_TO_INT(result);  // Convert to integer
}
```

## Volatile Keyword and Memory-Mapped I/O

The volatile keyword is crucial for embedded programming to prevent compiler optimizations that could break hardware interaction.

```c
#include <stdint.h>

// Memory-mapped hardware registers
#define GPIOA_BASE  0x40020000
#define GPIOA_ODR   (*(volatile uint32_t*)(GPIOA_BASE + 0x14))
#define GPIOA_IDR   (*(volatile uint32_t*)(GPIOA_BASE + 0x10))

// Without volatile, compiler might optimize away repeated reads
void non_volatile_example(void) {
    uint32_t reg_value = GPIOA_IDR;  // Compiler might cache this value
    // ... some code ...
    reg_value = GPIOA_IDR;  // Compiler might use cached value instead of re-reading
}

// With volatile, compiler will always read from hardware
void volatile_example(void) {
    volatile uint32_t reg_value = GPIOA_IDR;  // Always read from hardware
    // ... some code ...
    reg_value = GPIOA_IDR;  // Always read from hardware again
}

// Volatile pointers
volatile uint32_t * const gpio_odr = (volatile uint32_t*)(GPIOA_BASE + 0x14);

void pointer_example(void) {
    *gpio_odr = 0x00000001;  // Set pin 0
    *gpio_odr = 0x00000002;  // Set pin 1
}
```

## Interrupt Service Routines

Properly written ISRs are critical for real-time embedded systems.

```c
#include <stdint.h>

// Global variables used in ISR should be volatile
volatile uint32_t isr_counter = 0;
volatile uint8_t data_ready = 0;
volatile uint8_t received_data = 0;

// Interrupt service routine
void USART1_IRQHandler(void) __attribute__((interrupt));
void USART1_IRQHandler(void) {
    // Read status register
    uint32_t status = USART1->SR;
    
    // Check for receive interrupt
    if (status & USART_SR_RXNE) {
        // Read received data
        received_data = USART1->DR;
        data_ready = 1;
        isr_counter++;
    }
    
    // Check for transmit interrupt
    if (status & USART_SR_TXE) {
        // Disable transmit interrupt
        USART1->CR1 &= ~USART_CR1_TXEIE;
    }
}

// Critical section management
uint32_t enter_critical_section(void) {
    uint32_t primask;
    __asm__ volatile ("mrs %0, primask" : "=r" (primask));
    __asm__ volatile ("cpsid i");
    return primask;
}

void exit_critical_section(uint32_t primask) {
    __asm__ volatile ("msr primask, %0" : : "r" (primask));
}

// Safe access to shared variables
uint32_t get_isr_counter(void) {
    uint32_t counter;
    uint32_t primask = enter_critical_section();
    counter = isr_counter;
    exit_critical_section(primask);
    return counter;
}
```

## Memory-Constrained Programming

Techniques for working with limited memory resources.

### Stack Management

```c
#include <stdint.h>

// Monitor stack usage
extern uint32_t _estack;      // End of stack (top)
extern uint32_t _stack_start; // Start of stack

// Stack pattern for usage monitoring
#define STACK_PATTERN  0xDEADBEEF

void init_stack_pattern(void) {
    uint32_t *stack_ptr = &_stack_start;
    while (stack_ptr < &_estack) {
        *stack_ptr++ = STACK_PATTERN;
    }
}

uint32_t get_stack_usage(void) {
    uint32_t *stack_ptr = &_stack_start;
    while (stack_ptr < &_estack && *stack_ptr == STACK_PATTERN) {
        stack_ptr++;
    }
    return (uint32_t)&_estack - (uint32_t)stack_ptr;
}

// Avoid large local variables
void bad_function(void) {
    uint8_t large_buffer[2048];  // Large stack allocation
    // ... use buffer ...
}

void good_function(void) {
    static uint8_t large_buffer[2048];  // Static allocation
    // ... use buffer ...
}

// Or use dynamic allocation with careful management
uint8_t *get_buffer(void) {
    static uint8_t buffer[2048];
    static uint8_t in_use = 0;
    
    if (!in_use) {
        in_use = 1;
        return buffer;
    }
    return NULL;  // Buffer in use
}

void release_buffer(void) {
    // In a real implementation, you'd track which buffer is released
}
```

### Code Size Optimization

```c
#include <stdint.h>

// Use smaller data types when possible
void size_optimized_loop(uint8_t count) {
    for (uint8_t i = 0; i < count; i++) {
        // Process data
    }
}

// Instead of:
void size_unoptimized_loop(uint32_t count) {
    for (uint32_t i = 0; i < count; i++) {
        // Process data
    }
}

// Use function pointers for common operations
typedef void (*handler_func_t)(void);

void handler_a(void) { /* ... */ }
void handler_b(void) { /* ... */ }
void handler_c(void) { /* ... */ }

static const handler_func_t handlers[] = {
    handler_a,
    handler_b,
    handler_c
};

void call_handler(uint8_t index) {
    if (index < sizeof(handlers) / sizeof(handlers[0])) {
        handlers[index]();
    }
}

// Use lookup tables instead of complex calculations
static const uint8_t crc8_table[256] = {
    0x00, 0x07, 0x0E, 0x09, 0x1C, 0x1B, 0x12, 0x15,
    0x38, 0x3F, 0x36, 0x31, 0x24, 0x23, 0x2A, 0x2D,
    // ... table values
};

uint8_t crc8(uint8_t *data, uint32_t length) {
    uint8_t crc = 0;
    for (uint32_t i = 0; i < length; i++) {
        crc = crc8_table[crc ^ data[i]];
    }
    return crc;
}
```

## Real-Time Considerations

Techniques for ensuring deterministic behavior in real-time systems.

### Timing Analysis

```c
#include <stdint.h>

// Measure execution time
uint32_t get_cycle_count(void) {
    uint32_t cycle_count;
    __asm__ volatile ("rdcycle %0" : "=r" (cycle_count));
    return cycle_count;
}

void timing_analysis_example(void) {
    uint32_t start_time = get_cycle_count();
    
    // Code to measure
    complex_calculation();
    
    uint32_t end_time = get_cycle_count();
    uint32_t execution_time = end_time - start_time;
    
    // Store or report execution time
}

// Avoid operations with variable execution time
void deterministic_delay(uint32_t cycles) {
    // Use timer instead of loop with unknown iterations
    uint32_t start = get_cycle_count();
    while ((get_cycle_count() - start) < cycles) {
        // Wait
    }
}

// Use constant-time operations when possible
uint32_t constant_time_compare(const uint8_t *a, const uint8_t *b, uint32_t len) {
    uint32_t result = 0;
    for (uint32_t i = 0; i < len; i++) {
        result |= a[i] ^ b[i];  // Always compare all bytes
    }
    return result;  // 0 if equal, non-zero if different
}
```

## Hardware-Specific Features

Leveraging processor-specific features for maximum efficiency.

### ARM Cortex-M Specific Features

```c
#include <stdint.h>

// Use Cortex-M specific instructions
void cortex_m_optimizations(void) {
    // Count leading zeros
    uint32_t value = 0x00100000;
    uint32_t clz;
    __asm__ volatile ("clz %0, %1" : "=r" (clz) : "r" (value));
    
    // Reverse bits
    uint32_t reversed;
    __asm__ volatile ("rbit %0, %1" : "=r" (reversed) : "r" (value));
    
    // Byte-reverse word
    uint32_t rev;
    __asm__ volatile ("rev %0, %1" : "=r" (rev) : "r" (value));
}

// Use bit-band region for atomic bit operations
#define BITBAND_SRAM_REF   0x20000000
#define BITBAND_SRAM_BASE  0x22000000
#define BITBAND_SRAM(a,b)  ((BITBAND_SRAM_BASE + (a-BITBAND_SRAM_REF)*32 + (b*4)))

// Atomic bit manipulation using bit-band
void bitband_example(volatile uint32_t *reg, uint8_t bit) {
    // Create bit-band alias
    volatile uint32_t *bit_alias = (volatile uint32_t*)BITBAND_SRAM((uint32_t)reg, bit);
    
    *bit_alias = 1;  // Atomically set bit
    *bit_alias = 0;  // Atomically clear bit
}
```

## Practical Examples

### Efficient Sensor Data Processing

```c
#include <stdint.h>

// Circular buffer for sensor data
#define BUFFER_SIZE 64

typedef struct {
    uint16_t buffer[BUFFER_SIZE];
    uint8_t head;
    uint8_t tail;
    uint8_t count;
} circular_buffer_t;

static circular_buffer_t sensor_buffer;

// Initialize circular buffer
void buffer_init(circular_buffer_t *buf) {
    buf->head = 0;
    buf->tail = 0;
    buf->count = 0;
}

// Add data to buffer
int buffer_put(circular_buffer_t *buf, uint16_t data) {
    if (buf->count >= BUFFER_SIZE) {
        return -1;  // Buffer full
    }
    
    buf->buffer[buf->head] = data;
    buf->head = (buf->head + 1) % BUFFER_SIZE;
    buf->count++;
    
    return 0;
}

// Get data from buffer
int buffer_get(circular_buffer_t *buf, uint16_t *data) {
    if (buf->count == 0) {
        return -1;  // Buffer empty
    }
    
    *data = buf->buffer[buf->tail];
    buf->tail = (buf->tail + 1) % BUFFER_SIZE;
    buf->count--;
    
    return 0;
}

// Moving average filter
#define AVERAGE_WINDOW 8

uint16_t moving_average(uint16_t new_value) {
    static uint16_t window[AVERAGE_WINDOW];
    static uint8_t index = 0;
    static uint32_t sum = 0;
    static uint8_t count = 0;
    
    // Remove oldest value from sum
    sum -= window[index];
    
    // Add new value to sum and window
    window[index] = new_value;
    sum += new_value;
    
    // Update index
    index = (index + 1) % AVERAGE_WINDOW;
    
    // Update count
    if (count < AVERAGE_WINDOW) {
        count++;
    }
    
    // Return average
    return (uint16_t)(sum / count);
}
```

### Power Management

```c
#include <stdint.h>

// Power management states
typedef enum {
    POWER_STATE_ACTIVE,
    POWER_STATE_SLEEP,
    POWER_STATE_DEEP_SLEEP
} power_state_t;

// Enter sleep mode
void enter_sleep_mode(void) {
    // Disable unnecessary peripherals
    // RCC->APB1ENR &= ~RCC_APB1ENR_TIM2EN;  // Disable timer
    
    // Configure wake-up sources
    // EXTI->IMR |= EXTI_IMR_MR0;  // Enable EXTI line 0
    
    // Enter sleep mode
    __asm__ volatile ("wfi");  // Wait for interrupt
}

// Enter deep sleep mode
void enter_deep_sleep_mode(void) {
    // Save critical data to retention memory
    
    // Configure deep sleep
    // SCB->SCR |= SCB_SCR_SLEEPDEEP_Msk;
    
    // Enter deep sleep
    __asm__ volatile ("wfi");
}

// Dynamic frequency scaling
void set_performance_level(uint8_t level) {
    switch (level) {
        case 0:  // Low power
            // SystemClock_Config_LowPower();
            break;
        case 1:  // Medium power
            // SystemClock_Config_Medium();
            break;
        case 2:  // High performance
            // SystemClock_Config_High();
            break;
    }
}
```

## Summary

Embedded C techniques involve specialized programming approaches to maximize efficiency in resource-constrained environments:

1. **Compiler Extensions** - Using attributes and pragmas for optimal code generation
2. **Optimization Techniques** - Balancing performance, size, and power consumption
3. **Fixed-Point Arithmetic** - Efficient alternative to floating-point operations
4. **Volatile Keyword** - Proper handling of hardware registers and shared variables
5. **Interrupt Management** - Writing efficient and safe ISRs
6. **Memory-Constrained Programming** - Techniques for limited RAM and Flash
7. **Real-Time Considerations** - Ensuring deterministic behavior
8. **Hardware-Specific Features** - Leveraging processor capabilities

These techniques enable developers to create efficient, reliable embedded applications that make optimal use of limited system resources while maintaining real-time performance requirements.