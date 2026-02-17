# Module 12: Embedded Systems Programming Exercises

## Exercise 1: Bit Manipulation and Register Operations
Write a program that demonstrates fundamental bit manipulation operations commonly used in embedded systems:
- Implement functions for setting, clearing, and toggling individual bits
- Create macros for bit manipulation operations
- Demonstrate bit field usage for hardware register access
- Implement functions for reading and writing hardware registers
- Show how to handle endianness in register operations

**Requirements:**
- Implement bit manipulation functions without using built-in bit operations
- Create reusable macros for common bit operations
- Demonstrate proper handling of volatile variables for hardware registers
- Include examples of bit field structures for hardware register mapping
- Provide clear documentation for all bit manipulation functions

## Exercise 2: Memory-Mapped I/O Implementation
Create a program that simulates memory-mapped I/O operations:
- Implement functions for reading and writing to memory-mapped registers
- Create a simple GPIO (General Purpose Input/Output) simulation
- Demonstrate proper use of volatile pointers for hardware access
- Implement interrupt handling for I/O operations
- Show how to handle memory alignment requirements

**Requirements:**
- Use appropriate data types for memory-mapped registers
- Implement proper error checking for I/O operations
- Include examples of direct memory access patterns
- Demonstrate proper handling of memory barriers if needed
- Provide clear examples of GPIO configuration and control

## Exercise 3: Interrupt Service Routines
Develop a program that implements interrupt service routines (ISRs):
- Create a framework for registering and handling interrupts
- Implement a simple timer interrupt simulation
- Demonstrate proper context saving and restoration
- Show how to handle nested interrupts
- Implement interrupt prioritization mechanisms

**Requirements:**
- Follow proper ISR coding practices (minimal code, no blocking operations)
- Include examples of interrupt enable/disable functions
- Demonstrate proper use of atomic operations in ISRs
- Implement interrupt vector tables or similar dispatch mechanisms
- Provide clear documentation of interrupt handling flow

## Exercise 4: Real-Time Constraints Implementation
Write a program that demonstrates handling real-time constraints:
- Implement a simple real-time scheduler
- Create functions with guaranteed execution time limits
- Demonstrate proper handling of timing-critical sections
- Implement watchdog timer functionality
- Show how to measure and optimize code execution time

**Requirements:**
- Use appropriate timing functions for the target platform
- Include examples of critical section protection
- Demonstrate proper use of hardware timers
- Implement timeout mechanisms for blocking operations
- Provide clear examples of real-time performance measurement

## Exercise 5: Low-Power Programming Techniques
Create a program that implements low-power programming techniques:
- Implement sleep and power-down modes
- Create functions for dynamic clock scaling
- Demonstrate proper handling of wake-up sources
- Show how to optimize code for power consumption
- Implement power management state machines

**Requirements:**
- Include examples of different power-saving modes
- Demonstrate proper handling of sleep/wake cycles
- Show how to preserve state during power transitions
- Implement power consumption measurement and reporting
- Provide clear documentation of power management strategies

## Exercise 6: Hardware Abstraction Layer (HAL)
Write a program that implements a simple Hardware Abstraction Layer:
- Create a unified interface for different hardware platforms
- Implement device driver interfaces for common peripherals
- Demonstrate proper error handling in HAL functions
- Show how to handle hardware initialization and configuration
- Implement version control for HAL interfaces

**Requirements:**
- Use consistent naming conventions across all HAL functions
- Include proper error codes and return value handling
- Demonstrate proper initialization and cleanup sequences
- Provide clear documentation for all HAL interfaces
- Include examples of platform-specific implementations

## Exercise 7: Embedded Debugging and Monitoring
Create a program that provides debugging and monitoring capabilities for embedded systems:
- Implement a simple logging system with minimal resource usage
- Create functions for runtime system monitoring
- Demonstrate proper use of assertions in embedded environments
- Show how to implement non-intrusive debugging techniques
- Implement memory usage tracking and reporting

**Requirements:**
- Include configurable logging levels and output destinations
- Demonstrate proper handling of limited memory resources
- Show how to implement circular buffers for logging
- Provide examples of runtime error detection and reporting
- Include clear documentation of debugging techniques

## Exercise 8: Comprehensive Embedded Application
Design a complete embedded application that integrates all concepts:
- Implement a simple embedded system with multiple components
- Create a state machine for system control
- Demonstrate proper handling of hardware and software components
- Include comprehensive error handling and recovery mechanisms
- Provide clear documentation and testing procedures

**Requirements:**
- Use modular design with clear separation of concerns
- Include proper initialization and shutdown sequences
- Demonstrate proper resource management throughout the application
- Implement robust error handling and recovery mechanisms
- Provide clear examples and test cases for all components

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdint.h>

// Bit manipulation macros
#define SET_BIT(reg, bit)       ((reg) |= (1U << (bit)))
#define CLEAR_BIT(reg, bit)     ((reg) &= ~(1U << (bit)))
#define TOGGLE_BIT(reg, bit)    ((reg) ^= (1U << (bit)))
#define CHECK_BIT(reg, bit)     (((reg) >> (bit)) & 1U)

// Bit manipulation functions
void set_bit(uint32_t *reg, int bit) {
    *reg |= (1U << bit);
}

void clear_bit(uint32_t *reg, int bit) {
    *reg &= ~(1U << bit);
}

void toggle_bit(uint32_t *reg, int bit) {
    *reg ^= (1U << bit);
}

int check_bit(uint32_t reg, int bit) {
    return (reg >> bit) & 1U;
}

// Bit field structure for hardware register
typedef struct {
    uint32_t enable    : 1;  // Bit 0
    uint32_t direction : 1;  // Bit 1
    uint32_t reserved  : 2;  // Bits 2-3
    uint32_t mode      : 4;  // Bits 4-7
    uint32_t config    : 24; // Bits 8-31
} gpio_register_t;

// Volatile pointer for hardware register access
volatile gpio_register_t *gpio_reg = (volatile gpio_register_t *)0x40020000;

int main() {
    uint32_t test_reg = 0;
    
    // Test bit manipulation functions
    printf("Initial register value: 0x%08X\n", test_reg);
    
    set_bit(&test_reg, 5);
    printf("After setting bit 5: 0x%08X\n", test_reg);
    
    toggle_bit(&test_reg, 5);
    printf("After toggling bit 5: 0x%08X\n", test_reg);
    
    clear_bit(&test_reg, 5);
    printf("After clearing bit 5: 0x%08X\n", test_reg);
    
    // Test bit manipulation macros
    SET_BIT(test_reg, 3);
    printf("After setting bit 3 with macro: 0x%08X\n", test_reg);
    
    if (CHECK_BIT(test_reg, 3)) {
        printf("Bit 3 is set\n");
    }
    
    // Test bit field structure
    gpio_reg->enable = 1;
    gpio_reg->direction = 1;
    gpio_reg->mode = 0xF;
    
    printf("GPIO Register - Enable: %d, Direction: %d, Mode: 0x%X\n",
           gpio_reg->enable, gpio_reg->direction, gpio_reg->mode);
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

// Memory-mapped I/O simulation
#define GPIO_BASE_ADDR 0x40020000
#define GPIO_DIR_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x00))
#define GPIO_DATA_REG  (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x04))
#define GPIO_SET_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x08))
#define GPIO_CLR_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x0C))

// GPIO pin definitions
#define GPIO_PIN_0  (1U << 0)
#define GPIO_PIN_1  (1U << 1)
#define GPIO_PIN_2  (1U << 2)
#define GPIO_PIN_3  (1U << 3)

// Simple GPIO simulation structure
typedef struct {
    uint32_t direction;  // 0 = input, 1 = output
    uint32_t data;       // Current pin states
} gpio_sim_t;

// Global GPIO simulation instance
static gpio_sim_t gpio_sim = {0};

// Function to initialize GPIO
void gpio_init(void) {
    gpio_sim.direction = 0;
    gpio_sim.data = 0;
    printf("GPIO initialized\n");
}

// Function to set GPIO direction
void gpio_set_direction(uint32_t pins, int direction) {
    if (direction) {
        gpio_sim.direction |= pins;  // Set as output
    } else {
        gpio_sim.direction &= ~pins; // Set as input
    }
    
    // Update hardware register
    GPIO_DIR_REG = gpio_sim.direction;
    printf("GPIO direction set: 0x%08X (pins: 0x%08X, direction: %s)\n",
           gpio_sim.direction, pins, direction ? "output" : "input");
}

// Function to write to GPIO pins
void gpio_write(uint32_t pins, int value) {
    if (value) {
        gpio_sim.data |= pins;
        GPIO_SET_REG = pins;  // Hardware register for setting pins
    } else {
        gpio_sim.data &= ~pins;
        GPIO_CLR_REG = pins;  // Hardware register for clearing pins
    }
    
    GPIO_DATA_REG = gpio_sim.data;  // Update data register
    printf("GPIO write: pins 0x%08X set to %d\n", pins, value);
}

// Function to read from GPIO pins
uint32_t gpio_read(uint32_t pins) {
    uint32_t value = GPIO_DATA_REG & pins;  // Read from hardware register
    printf("GPIO read: pins 0x%08X = 0x%08X\n", pins, value);
    return value;
}

// Function to simulate external input change
void gpio_simulate_input(uint32_t pins, int value) {
    if (value) {
        gpio_sim.data |= pins;
    } else {
        gpio_sim.data &= ~pins;
    }
    printf("Simulated input change: pins 0x%08X set to %d\n", pins, value);
}

int main() {
    // Initialize GPIO
    gpio_init();
    
    // Configure pins 0-1 as outputs, pins 2-3 as inputs
    gpio_set_direction(GPIO_PIN_0 | GPIO_PIN_1, 1);  // Output
    gpio_set_direction(GPIO_PIN_2 | GPIO_PIN_3, 0);  // Input
    
    // Write to output pins
    gpio_write(GPIO_PIN_0, 1);
    gpio_write(GPIO_PIN_1, 0);
    
    // Simulate input changes
    gpio_simulate_input(GPIO_PIN_2, 1);
    gpio_simulate_input(GPIO_PIN_3, 0);
    
    // Read input pins
    uint32_t input_value = gpio_read(GPIO_PIN_2 | GPIO_PIN_3);
    printf("Input pins value: 0x%08X\n", input_value);
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Volatile keyword misuse**: Always use volatile for hardware registers
2. **Endianness issues**: Handle byte order correctly in multi-byte registers
3. **Timing constraints**: Avoid blocking operations in time-critical code
4. **Memory alignment**: Ensure proper alignment for memory-mapped I/O
5. **Interrupt safety**: Protect critical sections in interrupt-driven code

### Best Practices:
1. **Hardware abstraction**: Use consistent interfaces for hardware access
2. **Error handling**: Implement proper error checking for all operations
3. **Resource management**: Carefully manage memory and other resources
4. **Documentation**: Provide clear documentation for hardware interactions
5. **Testing**: Include comprehensive testing for embedded functionality

Complete these exercises to solidify your understanding of embedded systems programming in C. Each exercise builds upon the previous ones, gradually increasing in complexity.