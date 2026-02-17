/*
 * Module 12 Demonstration Program
 * This program demonstrates all the key concepts from Module 12:
 * - Embedded systems basics (microcontrollers, memory organization)
 * - Low-level programming (bit manipulation, memory-mapped I/O)
 * - Embedded C techniques (volatile, inline assembly, interrupt handling)
 * - Real-time programming (timing, scheduling, RTOS concepts)
 * - Hardware interfaces (GPIO, UART, SPI, I2C)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>
#include <signal.h>
#include <unistd.h>

// Include our custom header files
#include "embedded_utils.h"

// Function prototypes for demonstration functions
void demonstrate_embedded_basics(void);
void demonstrate_low_level_programming(void);
void demonstrate_embedded_c_techniques(void);
void demonstrate_realtime_programming(void);
void demonstrate_hardware_interfaces(void);

// Global variables for interrupt simulation
volatile bool interrupt_flag = false;
volatile uint32_t system_ticks = 0;

// Signal handler for interrupt simulation
void interrupt_handler(int sig) {
    interrupt_flag = true;
    system_ticks++;
    printf("Interrupt occurred! System ticks: %u\n", system_ticks);
}

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 12: Embedded Systems Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_embedded_basics();
    demonstrate_low_level_programming();
    demonstrate_embedded_c_techniques();
    demonstrate_realtime_programming();
    demonstrate_hardware_interfaces();
    
    printf("\n========================================\n");
    printf("  Module 12 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate embedded systems basics
 */
void demonstrate_embedded_basics() {
    print_separator("Embedded Systems Basics");
    
    printf("1. Microcontroller Architecture:\n");
    printf("  CPU Core: Executes instructions\n");
    printf("  Memory:\n");
    printf("    - Flash: Non-volatile program storage\n");
    printf("    - RAM: Volatile data storage\n");
    printf("    - ROM: Fixed data (bootloader, constants)\n");
    printf("  Peripherals:\n");
    printf("    - GPIO: General Purpose Input/Output\n");
    printf("    - UART: Serial communication\n");
    printf("    - SPI: Serial Peripheral Interface\n");
    printf("    - I2C: Inter-Integrated Circuit\n");
    printf("    - ADC: Analog-to-Digital Converter\n");
    printf("    - Timers: Time measurement and generation\n");
    
    printf("\n2. Memory Organization:\n");
    printf("  Harvard Architecture:\n");
    printf("    - Separate buses for program and data memory\n");
    printf("    - Allows simultaneous access to program and data\n");
    printf("  Von Neumann Architecture:\n");
    printf("    - Single bus for program and data\n");
    printf("    - Simpler but potentially slower\n");
    
    printf("\n3. Development Process:\n");
    printf("  1. Write source code (C/C++)\n");
    printf("  2. Compile to object files\n");
    printf("  3. Link to create executable\n");
    printf("  4. Convert to hex/bin format\n");
    printf("  5. Flash to microcontroller\n");
    printf("  6. Debug and test\n");
    
    printf("\n4. Embedded System Constraints:\n");
    printf("  - Limited memory (RAM/Flash)\n");
    printf("  - Limited processing power\n");
    printf("  - Real-time requirements\n");
    printf("  - Power consumption considerations\n");
    printf("  - Reliability and robustness\n");
}

/*
 * Demonstrate low-level programming
 */
void demonstrate_low_level_programming() {
    print_separator("Low-Level Programming");
    
    printf("1. Bit Manipulation:\n");
    uint8_t reg = 0b10101010;
    printf("  Original register: 0b%08b (0x%02X)\n", reg, reg);
    
    // Set bit 3
    SET_BIT(reg, 3);
    printf("  After setting bit 3: 0b%08b (0x%02X)\n", reg, reg);
    
    // Clear bit 7
    CLEAR_BIT(reg, 7);
    printf("  After clearing bit 7: 0b%08b (0x%02X)\n", reg, reg);
    
    // Toggle bit 1
    TOGGLE_BIT(reg, 1);
    printf("  After toggling bit 1: 0b%08b (0x%02X)\n", reg, reg);
    
    // Check bit 5
    bool bit5 = CHECK_BIT(reg, 5);
    printf("  Bit 5 state: %s\n", bit5 ? "SET" : "CLEAR");
    
    printf("\n2. Memory-Mapped I/O:\n");
    printf("  Accessing hardware registers as memory locations\n");
    printf("  Example: GPIOA_ODR = 0x40020014\n");
    printf("  Writing to this address controls GPIO pins\n");
    
    // Simulate memory-mapped I/O
    volatile uint32_t* gpio_odr = &GPIOA_ODR;
    *gpio_odr = 0x000000FF; // Set lower 8 bits
    printf("  Simulated GPIO output register set to: 0x%08X\n", *gpio_odr);
    
    printf("\n3. Register-Level Programming:\n");
    printf("  Direct manipulation of hardware registers\n");
    printf("  Example register operations:\n");
    printf("    SET_REG(REG, MASK)    // Set bits in register\n");
    printf("    CLEAR_REG(REG, MASK)  // Clear bits in register\n");
    printf("    READ_REG(REG)         // Read register value\n");
    
    printf("\n4. Endianness:\n");
    printf("  Little Endian: LSB stored at lowest address\n");
    printf("  Big Endian: MSB stored at lowest address\n");
    printf("  Example 0x12345678:\n");
    printf("    Little Endian: 78 56 34 12\n");
    printf("    Big Endian: 12 34 56 78\n");
}

/*
 * Demonstrate embedded C techniques
 */
void demonstrate_embedded_c_techniques() {
    print_separator("Embedded C Techniques");
    
    printf("1. Volatile Keyword:\n");
    printf("  Tells compiler not to optimize variable access\n");
    printf("  Used for:\n");
    printf("    - Hardware registers\n");
    printf("    - Variables modified by interrupts\n");
    printf("    - Memory-mapped I/O\n");
    
    // Example of volatile usage
    volatile int sensor_value = 0;
    printf("  volatile int sensor_value = %d;\n", sensor_value);
    
    printf("\n2. Inline Assembly:\n");
    printf("  Embed assembly code within C code\n");
    printf("  Example (ARM Cortex-M):\n");
    printf("    __asm volatile (\n");
    printf("      \"mov r0, #42\\n\\t\"\n");
    printf("      \"mov r1, r0\"\n");
    printf("    );\n");
    
    printf("\n3. Interrupt Handling:\n");
    printf("  Special functions that execute when hardware events occur\n");
    printf("  Example interrupt service routine:\n");
    printf("    void USART1_IRQHandler(void) {\n");
    printf("      if (USART_GetITStatus(USART1, USART_IT_RXNE)) {\n");
    printf("        // Handle received data\n");
    printf("      }\n");
    printf("    }\n");
    
    // Simulate interrupt handling
    printf("\n  Simulating interrupt handling:\n");
    signal(SIGINT, interrupt_handler); // Use Ctrl+C to trigger
    printf("  Press Ctrl+C to simulate interrupt (demo will continue after)\n");
    sleep(2); // Give time to press Ctrl+C
    
    printf("\n4. Static and Const Qualifiers:\n");
    printf("  static: Internal linkage, persistent storage\n");
    printf("  const: Read-only data, can be stored in flash\n");
    
    static const uint8_t lookup_table[16] = {
        0x00, 0x01, 0x04, 0x09, 0x10, 0x19, 0x24, 0x31,
        0x40, 0x51, 0x64, 0x79, 0x90, 0xA9, 0xC4, 0xE1
    };
    
    printf("  Lookup table example:\n");
    for (int i = 0; i < 16; i++) {
        printf("    table[%d] = 0x%02X\n", i, lookup_table[i]);
    }
}

/*
 * Demonstrate real-time programming
 */
void demonstrate_realtime_programming() {
    print_separator("Real-Time Programming");
    
    printf("1. Timing Requirements:\n");
    printf("  Hard Real-Time: Missed deadlines cause system failure\n");
    printf("  Soft Real-Time: Occasional missed deadlines acceptable\n");
    
    printf("\n2. Delay Functions:\n");
    printf("  Blocking delays:\n");
    printf("    for (volatile int i = 0; i < 1000000; i++); // Busy wait\n");
    printf("  Timer-based delays:\n");
    printf("    delay_ms(1000); // Wait 1 second\n");
    
    // Demonstrate delay
    printf("\n  Demonstrating 100ms delay...\n");
    unsigned long start_time = time(NULL);
    delay_ms(100);
    unsigned long end_time = time(NULL);
    printf("  Delay completed in approximately %lu seconds\n", end_time - start_time);
    
    printf("\n3. Scheduling:\n");
    printf("  Round Robin: Each task gets equal time slice\n");
    printf("  Priority-Based: Higher priority tasks run first\n");
    printf("  Rate Monotonic: Periodic tasks scheduled by period\n");
    
    printf("\n4. RTOS (Real-Time Operating System):\n");
    printf("  Task Management:\n");
    printf("    - Task creation and deletion\n");
    printf("    - Task scheduling\n");
    printf("    - Task synchronization\n");
    printf("  Inter-Task Communication:\n");
    printf("    - Queues\n");
    printf("    - Semaphores\n");
    printf("    - Mutexes\n");
    printf("    - Event flags\n");
    
    printf("\n5. Watchdog Timers:\n");
    printf("  Hardware timer that resets system if not periodically refreshed\n");
    printf("  Prevents system lockup\n");
    printf("  Example usage:\n");
    printf("    IWDG_WriteAccessCmd(IWDG_WriteAccess_Enable);\n");
    printf("    IWDG_SetPrescaler(IWDG_Prescaler_32);\n");
    printf("    IWDG_SetReload(0xFFF);\n");
    printf("    IWDG_ReloadCounter(); // Refresh watchdog\n");
}

/*
 * Demonstrate hardware interfaces
 */
void demonstrate_hardware_interfaces() {
    print_separator("Hardware Interfaces");
    
    printf("1. GPIO (General Purpose Input/Output):\n");
    gpio_init();
    gpio_set_pin(5, true);  // Set pin 5 HIGH
    gpio_set_pin(6, false); // Set pin 6 LOW
    bool pin_state = gpio_get_pin(5); // Read pin 5
    
    printf("\n2. UART (Universal Asynchronous Receiver/Transmitter):\n");
    uart_init(9600);
    uart_send_string("Hello, Embedded World!\n");
    
    printf("\n3. SPI (Serial Peripheral Interface):\n");
    spi_init();
    u8 spi_data[] = {0x01, 0x02, 0x03, 0x04};
    spi_send_receive(spi_data, sizeof(spi_data));
    
    printf("\n4. I2C (Inter-Integrated Circuit):\n");
    i2c_init();
    u8 write_data[] = {0xAA, 0xBB};
    i2c_write(0x50, 0x00, write_data, sizeof(write_data));
    
    u8 read_data[4];
    i2c_read(0x50, 0x00, read_data, sizeof(read_data));
    
    printf("\n5. ADC (Analog-to-Digital Converter):\n");
    printf("  Converts analog signals to digital values\n");
    printf("  Example: 0-3.3V input mapped to 0-4095 (12-bit)\n");
    printf("  Conversion: digital_value = (analog_voltage / 3.3) * 4095\n");
    
    printf("\n6. PWM (Pulse Width Modulation):\n");
    printf("  Generates variable duty cycle signals\n");
    printf("  Applications: Motor speed control, LED brightness\n");
    printf("  Duty Cycle = (pulse_width / period) * 100%%\n");
    
    printf("\n7. Interrupts:\n");
    printf("  External Interrupts: GPIO pin changes\n");
    printf("  Timer Interrupts: Periodic events\n");
    printf("  Communication Interrupts: UART, SPI, I2C\n");
    printf("  ADC Interrupts: Conversion complete\n");
}