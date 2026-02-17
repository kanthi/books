# Hardware Interfaces

## Introduction

Embedded systems interact with the physical world through various hardware interfaces. Understanding how to properly interface with different types of hardware components is essential for developing functional embedded applications. This chapter covers the most common hardware interfaces used in embedded systems, including GPIO, SPI, I2C, UART, and other specialized interfaces.

## GPIO (General Purpose Input/Output)

GPIO pins are the most fundamental interface in embedded systems, providing direct digital input and output capabilities.

### GPIO Configuration and Control

```c
#include <stdint.h>
#include <stdbool.h>

// GPIO pin modes
typedef enum {
    GPIO_MODE_INPUT = 0,
    GPIO_MODE_OUTPUT,
    GPIO_MODE_AF,        // Alternate function
    GPIO_MODE_ANALOG
} gpio_mode_t;

// GPIO output types
typedef enum {
    GPIO_OTYPE_PP = 0,   // Push-pull
    GPIO_OTYPE_OD        // Open-drain
} gpio_otype_t;

// GPIO speed settings
typedef enum {
    GPIO_SPEED_LOW = 0,
    GPIO_SPEED_MEDIUM,
    GPIO_SPEED_HIGH,
    GPIO_SPEED_VERY_HIGH
} gpio_speed_t;

// GPIO pull-up/pull-down settings
typedef enum {
    GPIO_PUPD_NONE = 0,
    GPIO_PUPD_UP,
    GPIO_PUPD_DOWN
} gpio_pupd_t;

// GPIO port definitions
typedef enum {
    GPIO_PORT_A = 0,
    GPIO_PORT_B,
    GPIO_PORT_C,
    GPIO_PORT_D,
    GPIO_PORT_E,
    GPIO_PORT_F,
    GPIO_PORT_G,
    GPIO_PORT_H
} gpio_port_t;

// GPIO pin definitions
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

// GPIO register structure
typedef struct {
    volatile uint32_t MODER;    // Mode register
    volatile uint32_t OTYPER;   // Output type register
    volatile uint32_t OSPEEDR;  // Output speed register
    volatile uint32_t PUPDR;    // Pull-up/pull-down register
    volatile uint32_t IDR;      // Input data register
    volatile uint32_t ODR;      // Output data register
    volatile uint32_t BSRR;     // Bit set/reset register
    volatile uint32_t LCKR;     // Configuration lock register
    volatile uint32_t AFR[2];   // Alternate function registers
} gpio_reg_t;

// Base addresses for GPIO ports
#define GPIOA_BASE  0x40020000
#define GPIOB_BASE  0x40020400
#define GPIOC_BASE  0x40020800
#define GPIOD_BASE  0x40020C00
#define GPIOE_BASE  0x40021000
#define GPIOF_BASE  0x40021400
#define GPIOG_BASE  0x40021800
#define GPIOH_BASE  0x40021C00

// Get GPIO register pointer
static gpio_reg_t* get_gpio_reg(gpio_port_t port) {
    switch (port) {
        case GPIO_PORT_A: return (gpio_reg_t*)GPIOA_BASE;
        case GPIO_PORT_B: return (gpio_reg_t*)GPIOB_BASE;
        case GPIO_PORT_C: return (gpio_reg_t*)GPIOC_BASE;
        case GPIO_PORT_D: return (gpio_reg_t*)GPIOD_BASE;
        case GPIO_PORT_E: return (gpio_reg_t*)GPIOE_BASE;
        case GPIO_PORT_F: return (gpio_reg_t*)GPIOF_BASE;
        case GPIO_PORT_G: return (gpio_reg_t*)GPIOG_BASE;
        case GPIO_PORT_H: return (gpio_reg_t*)GPIOH_BASE;
        default: return NULL;
    }
}

// Configure GPIO pin
int gpio_init(gpio_port_t port, gpio_pin_t pin, gpio_mode_t mode,
              gpio_otype_t otype, gpio_speed_t speed, gpio_pupd_t pupd) {
    gpio_reg_t *gpio = get_gpio_reg(port);
    if (gpio == NULL) {
        return -1;
    }
    
    uint32_t pin_pos = (uint32_t)pin * 2;
    
    // Configure mode
    gpio->MODER &= ~(3UL << pin_pos);
    gpio->MODER |= ((uint32_t)mode << pin_pos);
    
    // Configure output type (only for output modes)
    if (mode == GPIO_MODE_OUTPUT || mode == GPIO_MODE_AF) {
        gpio->OTYPER &= ~(1UL << pin);
        gpio->OTYPER |= ((uint32_t)otype << pin);
    }
    
    // Configure speed
    gpio->OSPEEDR &= ~(3UL << pin_pos);
    gpio->OSPEEDR |= ((uint32_t)speed << pin_pos);
    
    // Configure pull-up/pull-down
    gpio->PUPDR &= ~(3UL << pin_pos);
    gpio->PUPDR |= ((uint32_t)pupd << pin_pos);
    
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

// Configure GPIO pin as input with pull-up
int gpio_config_input_pullup(gpio_port_t port, gpio_pin_t pin) {
    return gpio_init(port, pin, GPIO_MODE_INPUT, GPIO_OTYPE_PP, 
                     GPIO_SPEED_LOW, GPIO_PUPD_UP);
}

// Configure GPIO pin as output push-pull
int gpio_config_output(gpio_port_t port, gpio_pin_t pin) {
    return gpio_init(port, pin, GPIO_MODE_OUTPUT, GPIO_OTYPE_PP, 
                     GPIO_SPEED_HIGH, GPIO_PUPD_NONE);
}
```

## SPI (Serial Peripheral Interface)

SPI is a synchronous serial communication interface used for short-distance communication between microcontrollers and peripheral devices.

### SPI Driver Implementation

```c
#include <stdint.h>
#include <stdbool.h>

// SPI register structure
typedef struct {
    volatile uint32_t CR1;      // Control register 1
    volatile uint32_t CR2;      // Control register 2
    volatile uint32_t SR;       // Status register
    volatile uint32_t DR;       // Data register
    volatile uint32_t CRCPR;    // CRC polynomial register
    volatile uint32_t RXCRCR;   // RX CRC register
    volatile uint32_t TXCRCR;   // TX CRC register
    volatile uint32_t I2SCFGR;  // I2S configuration register
    volatile uint32_t I2SPR;    // I2S prescaler register
} spi_reg_t;

// SPI base addresses
#define SPI1_BASE  0x40013000
#define SPI2_BASE  0x40003800
#define SPI3_BASE  0x40003C00

#define SPI1  ((spi_reg_t*)SPI1_BASE)
#define SPI2  ((spi_reg_t*)SPI2_BASE)
#define SPI3  ((spi_reg_t*)SPI3_BASE)

// SPI control register bits
#define SPI_CR1_CPHA    (1UL << 0)   // Clock phase
#define SPI_CR1_CPOL    (1UL << 1)   // Clock polarity
#define SPI_CR1_MSTR    (1UL << 2)   // Master selection
#define SPI_CR1_BR      (7UL << 3)   // Baud rate control
#define SPI_CR1_SPE     (1UL << 6)   // SPI enable
#define SPI_CR1_LSBFIRST (1UL << 7)  // Frame format
#define SPI_CR1_SSI     (1UL << 8)   // Internal slave select
#define SPI_CR1_SSM     (1UL << 9)   // Software slave management
#define SPI_CR1_RXONLY  (1UL << 10)  // Receive only
#define SPI_CR1_DFF     (1UL << 11)  // Data frame format
#define SPI_CR1_CRCNEXT (1UL << 12)  // CRC transfer next
#define SPI_CR1_CRCEN   (1UL << 13)  // Hardware CRC calculation
#define SPI_CR1_BIDIOE  (1UL << 14)  // Output enable in bidirectional mode
#define SPI_CR1_BIDIMODE (1UL << 15) // Bidirectional data mode enable

// SPI status register bits
#define SPI_SR_RXNE     (1UL << 0)   // Receive buffer not empty
#define SPI_SR_TXE      (1UL << 1)   // Transmit buffer empty
#define SPI_SR_CHSIDE   (1UL << 2)   // Channel side
#define SPI_SR_UDR      (1UL << 3)   // Underrun flag
#define SPI_SR_CRCERR   (1UL << 4)   // CRC error flag
#define SPI_SR_MODF     (1UL << 5)   // Mode fault
#define SPI_SR_OVR      (1UL << 6)   // Overrun flag
#define SPI_SR_BSY      (1UL << 7)   // Busy flag

// SPI configuration structure
typedef struct {
    uint32_t baud_rate;         // Baud rate prescaler
    bool master;                // Master mode
    bool cpol;                  // Clock polarity
    bool cpha;                  // Clock phase
    bool lsb_first;             // LSB first
    bool bidirectional;         // Bidirectional mode
    uint8_t data_size;          // Data size (8 or 16 bits)
} spi_config_t;

// Initialize SPI peripheral
int spi_init(spi_reg_t *spi, const spi_config_t *config) {
    if (spi == NULL || config == NULL) {
        return -1;
    }
    
    // Disable SPI
    spi->CR1 &= ~SPI_CR1_SPE;
    
    // Configure SPI
    uint32_t cr1 = 0;
    
    // Set baud rate
    cr1 |= (config->baud_rate << 3) & SPI_CR1_BR;
    
    // Set master/slave mode
    if (config->master) {
        cr1 |= SPI_CR1_MSTR;
        cr1 |= SPI_CR1_SSI;  // Set internal slave select
    }
    
    // Set clock polarity and phase
    if (config->cpol) cr1 |= SPI_CR1_CPOL;
    if (config->cpha) cr1 |= SPI_CR1_CPHA;
    
    // Set data frame format
    if (config->data_size == 16) {
        cr1 |= SPI_CR1_DFF;
    }
    
    // Set frame format
    if (config->lsb_first) {
        cr1 |= SPI_CR1_LSBFIRST;
    }
    
    // Enable software slave management
    cr1 |= SPI_CR1_SSM;
    
    spi->CR1 = cr1;
    
    // Configure bidirectional mode
    if (config->bidirectional) {
        spi->CR1 |= SPI_CR1_BIDIMODE;
        spi->CR1 |= SPI_CR1_BIDIOE;  // Enable output
    }
    
    // Enable SPI
    spi->CR1 |= SPI_CR1_SPE;
    
    return 0;
}

// SPI transmit function
int spi_transmit(spi_reg_t *spi, const uint8_t *data, uint32_t length) {
    if (spi == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    for (uint32_t i = 0; i < length; i++) {
        // Wait for transmit buffer to be empty
        while (!(spi->SR & SPI_SR_TXE));
        
        // Send data
        spi->DR = data[i];
        
        // Wait for transmission to complete
        while (spi->SR & SPI_SR_BSY);
    }
    
    return 0;
}

// SPI receive function
int spi_receive(spi_reg_t *spi, uint8_t *data, uint32_t length) {
    if (spi == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    for (uint32_t i = 0; i < length; i++) {
        // Wait for receive buffer to be empty
        while (!(spi->SR & SPI_SR_TXE));
        
        // Send dummy data to initiate reception
        spi->DR = 0xFF;
        
        // Wait for data to be received
        while (!(spi->SR & SPI_SR_RXNE));
        
        // Read received data
        data[i] = spi->DR;
    }
    
    return 0;
}

// SPI transmit and receive function (full duplex)
int spi_transceive(spi_reg_t *spi, const uint8_t *tx_data, 
                   uint8_t *rx_data, uint32_t length) {
    if (spi == NULL || tx_data == NULL || rx_data == NULL || length == 0) {
        return -1;
    }
    
    for (uint32_t i = 0; i < length; i++) {
        // Wait for transmit buffer to be empty
        while (!(spi->SR & SPI_SR_TXE));
        
        // Send data
        spi->DR = tx_data[i];
        
        // Wait for data to be received
        while (!(spi->SR & SPI_SR_RXNE));
        
        // Read received data
        rx_data[i] = spi->DR;
    }
    
    return 0;
}

// SPI chip select control
void spi_select_device(gpio_port_t cs_port, gpio_pin_t cs_pin) {
    gpio_clear(cs_port, cs_pin);  // Active low CS
}

void spi_deselect_device(gpio_port_t cs_port, gpio_pin_t cs_pin) {
    gpio_set(cs_port, cs_pin);    // Inactive high CS
}
```

## I2C (Inter-Integrated Circuit)

I2C is a multi-master, multi-slave, packet-switched, single-ended, serial communication bus used for short-distance communication.

### I2C Driver Implementation

```c
#include <stdint.h>
#include <stdbool.h>

// I2C register structure
typedef struct {
    volatile uint32_t CR1;      // Control register 1
    volatile uint32_t CR2;      // Control register 2
    volatile uint32_t OAR1;     // Own address register 1
    volatile uint32_t OAR2;     // Own address register 2
    volatile uint32_t DR;       // Data register
    volatile uint32_t SR1;      // Status register 1
    volatile uint32_t SR2;      // Status register 2
    volatile uint32_t CCR;      // Clock control register
    volatile uint32_t TRISE;    // TRISE register
    volatile uint32_t FLTR;     // FLTR register
} i2c_reg_t;

// I2C base addresses
#define I2C1_BASE  0x40005400
#define I2C2_BASE  0x40005800
#define I2C3_BASE  0x40005C00

#define I2C1  ((i2c_reg_t*)I2C1_BASE)
#define I2C2  ((i2c_reg_t*)I2C2_BASE)
#define I2C3  ((i2c_reg_t*)I2C3_BASE)

// I2C control register 1 bits
#define I2C_CR1_PE      (1UL << 0)   // Peripheral enable
#define I2C_CR1_SMBUS   (1UL << 1)   // SMBus mode
#define I2C_CR1_SMBTYPE (1UL << 3)   // SMBus type
#define I2C_CR1_ENARP   (1UL << 4)   // ARP enable
#define I2C_CR1_ENPEC   (1UL << 5)   // PEC enable
#define I2C_CR1_ENGC    (1UL << 6)   // General call enable
#define I2C_CR1_NOSTRETCH (1UL << 7) // Clock stretching disable
#define I2C_CR1_START   (1UL << 8)   // Start generation
#define I2C_CR1_STOP    (1UL << 9)   // Stop generation
#define I2C_CR1_ACK     (1UL << 10)  // Acknowledge enable
#define I2C_CR1_POS     (1UL << 11)  // Acknowledge/PEC position
#define I2C_CR1_PEC     (1UL << 12)  // Packet error checking
#define I2C_CR1_ALERT   (1UL << 13)  // SMBus alert
#define I2C_CR1_SWRST   (1UL << 15)  // Software reset

// I2C status register 1 bits
#define I2C_SR1_SB      (1UL << 0)   // Start bit
#define I2C_SR1_ADDR    (1UL << 1)   // Address sent/matched
#define I2C_SR1_BTF     (1UL << 2)   // Byte transfer finished
#define I2C_SR1_ADD10   (1UL << 3)   // 10-bit header sent
#define I2C_SR1_STOPF   (1UL << 4)   // Stop detection
#define I2C_SR1_RXNE    (1UL << 6)   // Data register not empty
#define I2C_SR1_TXE     (1UL << 7)   // Data register empty
#define I2C_SR1_BERR    (1UL << 8)   // Bus error
#define I2C_SR1_ARLO    (1UL << 9)   // Arbitration lost
#define I2C_SR1_AF      (1UL << 10)  // Acknowledge failure
#define I2C_SR1_OVR     (1UL << 11)  // Overrun/underrun
#define I2C_SR1_PECERR  (1UL << 12)  // PEC error
#define I2C_SR1_TIMEOUT (1UL << 14)  // Timeout or Tlow error
#define I2C_SR1_SMBALERT (1UL << 15) // SMBus alert

// I2C configuration structure
typedef struct {
    uint32_t clock_speed;       // I2C clock speed in Hz
    bool master;                // Master mode
    uint16_t own_address;       // Own address (slave mode)
    bool ack_enable;            // Acknowledge enable
} i2c_config_t;

// Initialize I2C peripheral
int i2c_init(i2c_reg_t *i2c, const i2c_config_t *config) {
    if (i2c == NULL || config == NULL) {
        return -1;
    }
    
    // Disable I2C
    i2c->CR1 &= ~I2C_CR1_PE;
    
    // Configure I2C clock
    uint32_t freq_mhz = 0;  // Peripheral clock frequency in MHz
    // freq_mhz = get_pclk1_frequency() / 1000000;
    
    // Configure CR2 register (frequency)
    i2c->CR2 = freq_mhz & 0x3F;
    
    // Configure CCR register (clock control)
    uint32_t ccr_value = 0;
    if (config->clock_speed <= 100000) {
        // Standard mode (up to 100kHz)
        ccr_value = (freq_mhz * 1000000) / (config->clock_speed * 2);
        if (ccr_value < 4) ccr_value = 4;
    } else {
        // Fast mode (up to 400kHz)
        ccr_value = (freq_mhz * 1000000) / (config->clock_speed * 3);
        if (ccr_value < 1) ccr_value = 1;
        ccr_value |= (1UL << 15);  // Fast mode
    }
    i2c->CCR = ccr_value;
    
    // Configure TRISE register (rise time)
    if (config->clock_speed <= 100000) {
        // Standard mode
        i2c->TRISE = freq_mhz + 1;
    } else {
        // Fast mode
        i2c->TRISE = (freq_mhz * 300) / 1000 + 1;
    }
    
    // Configure own address (slave mode)
    if (!config->master) {
        i2c->OAR1 = (config->own_address << 1) | (1UL << 14);
    }
    
    // Enable acknowledge
    if (config->ack_enable) {
        i2c->CR1 |= I2C_CR1_ACK;
    }
    
    // Enable I2C
    i2c->CR1 |= I2C_CR1_PE;
    
    return 0;
}

// Generate start condition
static int i2c_start(i2c_reg_t *i2c) {
    // Generate start condition
    i2c->CR1 |= I2C_CR1_START;
    
    // Wait for start condition to be generated
    uint32_t timeout = 100000;
    while (!(i2c->SR1 & I2C_SR1_SB) && timeout--) {
        if (i2c->SR1 & (I2C_SR1_ARLO | I2C_SR1_BERR | I2C_SR1_AF)) {
            return -1;  // Error occurred
        }
    }
    
    if (timeout == 0) {
        return -2;  // Timeout
    }
    
    return 0;
}

// Generate stop condition
static void i2c_stop(i2c_reg_t *i2c) {
    i2c->CR1 |= I2C_CR1_STOP;
}

// Send address
static int i2c_send_address(i2c_reg_t *i2c, uint8_t address, bool read) {
    // Send address
    i2c->DR = (address << 1) | (read ? 1 : 0);
    
    // Wait for address to be sent
    uint32_t timeout = 100000;
    while (!(i2c->SR1 & I2C_SR1_ADDR) && timeout--) {
        if (i2c->SR1 & (I2C_SR1_ARLO | I2C_SR1_BERR | I2C_SR1_AF)) {
            return -1;  // Error occurred
        }
    }
    
    if (timeout == 0) {
        return -2;  // Timeout
    }
    
    // Clear ADDR flag by reading SR1 and SR2
    volatile uint32_t temp = i2c->SR1;
    temp = i2c->SR2;
    (void)temp;  // Prevent compiler warning
    
    return 0;
}

// Send data
static int i2c_send_data(i2c_reg_t *i2c, const uint8_t *data, uint32_t length) {
    for (uint32_t i = 0; i < length; i++) {
        // Wait for transmit buffer to be empty
        uint32_t timeout = 100000;
        while (!(i2c->SR1 & I2C_SR1_TXE) && timeout--) {
            if (i2c->SR1 & (I2C_SR1_ARLO | I2C_SR1_BERR | I2C_SR1_AF | I2C_SR1_OVR)) {
                return -1;  // Error occurred
            }
        }
        
        if (timeout == 0) {
            return -2;  // Timeout
        }
        
        // Send data
        i2c->DR = data[i];
    }
    
    // Wait for byte transfer to finish
    uint32_t timeout = 100000;
    while (!(i2c->SR1 & I2C_SR1_BTF) && timeout--) {
        if (i2c->SR1 & (I2C_SR1_ARLO | I2C_SR1_BERR | I2C_SR1_AF | I2C_SR1_OVR)) {
            return -1;  // Error occurred
        }
    }
    
    if (timeout == 0) {
        return -2;  // Timeout
    }
    
    return 0;
}

// Receive data
static int i2c_receive_data(i2c_reg_t *i2c, uint8_t *data, uint32_t length) {
    // Enable acknowledge for all bytes except the last one
    if (length > 1) {
        i2c->CR1 |= I2C_CR1_ACK;
    } else {
        i2c->CR1 &= ~I2C_CR1_ACK;
    }
    
    for (uint32_t i = 0; i < length; i++) {
        // For the last byte, generate stop condition before reading
        if (i == length - 1) {
            i2c->CR1 &= ~I2C_CR1_ACK;  // Disable acknowledge
            i2c_stop(i2c);             // Generate stop condition
        }
        
        // Wait for data to be received
        uint32_t timeout = 100000;
        while (!(i2c->SR1 & I2C_SR1_RXNE) && timeout--) {
            if (i2c->SR1 & (I2C_SR1_ARLO | I2C_SR1_BERR | I2C_SR1_AF | I2C_SR1_OVR)) {
                return -1;  // Error occurred
            }
        }
        
        if (timeout == 0) {
            return -2;  // Timeout
        }
        
        // Read data
        data[i] = i2c->DR;
    }
    
    return 0;
}

// I2C write function
int i2c_write(i2c_reg_t *i2c, uint8_t device_address, 
              const uint8_t *data, uint32_t length) {
    if (i2c == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Generate start condition
    if (i2c_start(i2c) != 0) {
        return -2;
    }
    
    // Send device address with write bit
    if (i2c_send_address(i2c, device_address, false) != 0) {
        i2c_stop(i2c);
        return -3;
    }
    
    // Send data
    if (i2c_send_data(i2c, data, length) != 0) {
        i2c_stop(i2c);
        return -4;
    }
    
    // Generate stop condition
    i2c_stop(i2c);
    
    return 0;
}

// I2C read function
int i2c_read(i2c_reg_t *i2c, uint8_t device_address, 
             uint8_t *data, uint32_t length) {
    if (i2c == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Generate start condition
    if (i2c_start(i2c) != 0) {
        return -2;
    }
    
    // Send device address with read bit
    if (i2c_send_address(i2c, device_address, true) != 0) {
        i2c_stop(i2c);
        return -3;
    }
    
    // Receive data
    if (i2c_receive_data(i2c, data, length) != 0) {
        return -4;
    }
    
    return 0;
}

// I2C write-read function (repeated start)
int i2c_write_read(i2c_reg_t *i2c, uint8_t device_address,
                   const uint8_t *write_data, uint32_t write_length,
                   uint8_t *read_data, uint32_t read_length) {
    if (i2c == NULL || write_data == NULL || read_data == NULL ||
        write_length == 0 || read_length == 0) {
        return -1;
    }
    
    // Generate start condition
    if (i2c_start(i2c) != 0) {
        return -2;
    }
    
    // Send device address with write bit
    if (i2c_send_address(i2c, device_address, false) != 0) {
        i2c_stop(i2c);
        return -3;
    }
    
    // Send write data
    if (i2c_send_data(i2c, write_data, write_length) != 0) {
        i2c_stop(i2c);
        return -4;
    }
    
    // Generate repeated start condition
    if (i2c_start(i2c) != 0) {
        i2c_stop(i2c);
        return -5;
    }
    
    // Send device address with read bit
    if (i2c_send_address(i2c, device_address, true) != 0) {
        i2c_stop(i2c);
        return -6;
    }
    
    // Receive read data
    if (i2c_receive_data(i2c, read_data, read_length) != 0) {
        return -7;
    }
    
    return 0;
}
```

## UART (Universal Asynchronous Receiver-Transmitter)

UART is used for asynchronous serial communication between devices.

### UART Driver Implementation

```c
#include <stdint.h>
#include <stdbool.h>

// UART register structure
typedef struct {
    volatile uint32_t SR;       // Status register
    volatile uint32_t DR;       // Data register
    volatile uint32_t BRR;      // Baud rate register
    volatile uint32_t CR1;      // Control register 1
    volatile uint32_t CR2;      // Control register 2
    volatile uint32_t CR3;      // Control register 3
    volatile uint32_t GTPR;     // Guard time and prescaler register
} uart_reg_t;

// UART base addresses
#define USART1_BASE  0x40011000
#define USART2_BASE  0x40004400
#define USART3_BASE  0x40004800
#define UART4_BASE   0x40004C00
#define UART5_BASE   0x40005000

#define USART1  ((uart_reg_t*)USART1_BASE)
#define USART2  ((uart_reg_t*)USART2_BASE)
#define USART3  ((uart_reg_t*)USART3_BASE)
#define UART4   ((uart_reg_t*)UART4_BASE)
#define UART5   ((uart_reg_t*)UART5_BASE)

// UART status register bits
#define UART_SR_PE      (1UL << 0)   // Parity error
#define UART_SR_FE      (1UL << 1)   // Framing error
#define UART_SR_NE      (1UL << 2)   // Noise error
#define UART_SR_ORE     (1UL << 3)   // Overrun error
#define UART_SR_IDLE    (1UL << 4)   // IDLE line detected
#define UART_SR_RXNE    (1UL << 5)   // Read data register not empty
#define UART_SR_TC      (1UL << 6)   // Transmission complete
#define UART_SR_TXE     (1UL << 7)   // Transmit data register empty
#define UART_SR_LBD     (1UL << 8)   // LIN break detection flag
#define UART_SR_CTS     (1UL << 9)   // CTS flag

// UART control register 1 bits
#define UART_CR1_SBK    (1UL << 0)   // Send break
#define UART_CR1_RWU    (1UL << 1)   // Receiver wakeup
#define UART_CR1_RE     (1UL << 2)   // Receiver enable
#define UART_CR1_TE     (1UL << 3)   // Transmitter enable
#define UART_CR1_IDLEIE (1UL << 4)   // IDLE interrupt enable
#define UART_CR1_RXNEIE (1UL << 5)   // RXNE interrupt enable
#define UART_CR1_TCIE   (1UL << 6)   // Transmission complete interrupt enable
#define UART_CR1_TXEIE  (1UL << 7)   // TXE interrupt enable
#define UART_CR1_PEIE   (1UL << 8)   // PE interrupt enable
#define UART_CR1_PS     (1UL << 9)   // Parity selection
#define UART_CR1_PCE    (1UL << 10)  // Parity control enable
#define UART_CR1_WAKE   (1UL << 11)  // Wakeup method
#define UART_CR1_M      (1UL << 12)  // Word length
#define UART_CR1_UE     (1UL << 13)  // USART enable
#define UART_CR1_OVER8  (1UL << 15)  // Oversampling mode

// UART configuration structure
typedef struct {
    uint32_t baud_rate;         // Baud rate
    uint8_t data_bits;          // Data bits (8 or 9)
    uint8_t stop_bits;          // Stop bits (1 or 2)
    bool parity_enable;         // Parity enable
    bool parity_even;           // Even parity (true) or odd parity (false)
    uint32_t peripheral_clock;   // Peripheral clock frequency
} uart_config_t;

// Initialize UART peripheral
int uart_init(uart_reg_t *uart, const uart_config_t *config) {
    if (uart == NULL || config == NULL) {
        return -1;
    }
    
    // Disable UART
    uart->CR1 &= ~UART_CR1_UE;
    
    // Configure baud rate
    uint32_t baud_div = 0;
    if (config->baud_rate != 0) {
        baud_div = (config->peripheral_clock + (config->baud_rate / 2)) / config->baud_rate;
    }
    uart->BRR = baud_div;
    
    // Configure data bits
    if (config->data_bits == 9) {
        uart->CR1 |= UART_CR1_M;
    } else {
        uart->CR1 &= ~UART_CR1_M;
    }
    
    // Configure parity
    if (config->parity_enable) {
        uart->CR1 |= UART_CR1_PCE;
        if (config->parity_even) {
            uart->CR1 &= ~UART_CR1_PS;  // Even parity
        } else {
            uart->CR1 |= UART_CR1_PS;   // Odd parity
        }
    } else {
        uart->CR1 &= ~UART_CR1_PCE;
    }
    
    // Configure stop bits
    uart->CR2 &= ~(3UL << 12);  // Clear stop bits
    if (config->stop_bits == 2) {
        uart->CR2 |= (2UL << 12);   // 2 stop bits
    } else {
        uart->CR2 |= (0UL << 12);   // 1 stop bit
    }
    
    // Enable transmitter and receiver
    uart->CR1 |= UART_CR1_TE | UART_CR1_RE;
    
    // Enable UART
    uart->CR1 |= UART_CR1_UE;
    
    return 0;
}

// Send character
int uart_putc(uart_reg_t *uart, char c) {
    if (uart == NULL) {
        return -1;
    }
    
    // Wait for transmit data register to be empty
    uint32_t timeout = 100000;
    while (!(uart->SR & UART_SR_TXE) && timeout--) {
        // Wait
    }
    
    if (timeout == 0) {
        return -2;  // Timeout
    }
    
    // Send character
    uart->DR = c;
    
    return 0;
}

// Send string
int uart_puts(uart_reg_t *uart, const char *str) {
    if (uart == NULL || str == NULL) {
        return -1;
    }
    
    while (*str) {
        if (uart_putc(uart, *str++) != 0) {
            return -2;
        }
    }
    
    return 0;
}

// Receive character
int uart_getc(uart_reg_t *uart, char *c) {
    if (uart == NULL || c == NULL) {
        return -1;
    }
    
    // Check if data is available
    if (!(uart->SR & UART_SR_RXNE)) {
        return -2;  // No data available
    }
    
    // Read character
    *c = (char)(uart->DR & 0xFF);
    
    // Check for errors
    if (uart->SR & (UART_SR_PE | UART_SR_FE | UART_SR_NE | UART_SR_ORE)) {
        return -3;  // Error occurred
    }
    
    return 0;
}

// Check if data is available
bool uart_available(uart_reg_t *uart) {
    if (uart == NULL) {
        return false;
    }
    return (uart->SR & UART_SR_RXNE) ? true : false;
}

// Flush UART receive buffer
void uart_flush(uart_reg_t *uart) {
    if (uart == NULL) {
        return;
    }
    
    // Read all available data
    while (uart->SR & UART_SR_RXNE) {
        volatile uint32_t temp = uart->DR;
        (void)temp;  // Prevent compiler warning
    }
}
```

## Practical Examples

### Sensor Interface Example

```c
#include <stdint.h>
#include <stdbool.h>

// Temperature sensor (I2C) driver
#define TEMP_SENSOR_ADDR  0x48

typedef struct {
    i2c_reg_t *i2c;
    uint8_t address;
} temp_sensor_t;

// Initialize temperature sensor
int temp_sensor_init(temp_sensor_t *sensor, i2c_reg_t *i2c) {
    if (sensor == NULL || i2c == NULL) {
        return -1;
    }
    
    sensor->i2c = i2c;
    sensor->address = TEMP_SENSOR_ADDR;
    
    // Configure sensor (example configuration)
    uint8_t config_data[] = {0x01, 0x60};  // Configuration register and value
    return i2c_write(sensor->i2c, sensor->address, config_data, 2);
}

// Read temperature
float temp_sensor_read(temp_sensor_t *sensor) {
    if (sensor == NULL) {
        return -1.0;
    }
    
    // Read temperature register
    uint8_t reg_addr = 0x00;  // Temperature register
    uint8_t data[2];
    
    if (i2c_write_read(sensor->i2c, sensor->address, 
                       &reg_addr, 1, data, 2) != 0) {
        return -1.0;
    }
    
    // Convert to temperature value
    int16_t raw_temp = (data[0] << 8) | data[1];
    float temperature = raw_temp / 256.0;
    
    return temperature;
}

// EEPROM (I2C) driver
#define EEPROM_ADDR  0x50

typedef struct {
    i2c_reg_t *i2c;
    uint8_t address;
} eeprom_t;

// Initialize EEPROM
int eeprom_init(eeprom_t *eeprom, i2c_reg_t *i2c) {
    if (eeprom == NULL || i2c == NULL) {
        return -1;
    }
    
    eeprom->i2c = i2c;
    eeprom->address = EEPROM_ADDR;
    
    return 0;
}

// Write data to EEPROM
int eeprom_write(eeprom_t *eeprom, uint16_t address, 
                 const uint8_t *data, uint32_t length) {
    if (eeprom == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Write data in chunks (EEPROM page size is typically 16-64 bytes)
    uint32_t written = 0;
    while (written < length) {
        uint32_t chunk_size = (length - written > 16) ? 16 : (length - written);
        
        // Prepare data with address
        uint8_t write_data[18];  // 2 bytes address + 16 bytes data
        write_data[0] = (address + written) >> 8;     // High byte of address
        write_data[1] = (address + written) & 0xFF;   // Low byte of address
        for (uint32_t i = 0; i < chunk_size; i++) {
            write_data[2 + i] = data[written + i];
        }
        
        // Write chunk
        if (i2c_write(eeprom->i2c, eeprom->address, 
                      write_data, 2 + chunk_size) != 0) {
            return -2;
        }
        
        written += chunk_size;
        
        // Wait for write to complete (EEPROM typical write time is 5ms)
        rt_delay_ms(5);
    }
    
    return 0;
}

// Read data from EEPROM
int eeprom_read(eeprom_t *eeprom, uint16_t address, 
                uint8_t *data, uint32_t length) {
    if (eeprom == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Send address
    uint8_t addr_data[2] = {(address >> 8) & 0xFF, address & 0xFF};
    if (i2c_write(eeprom->i2c, eeprom->address, addr_data, 2) != 0) {
        return -2;
    }
    
    // Read data
    return i2c_read(eeprom->i2c, eeprom->address, data, length);
}

// SPI Flash memory driver
typedef struct {
    spi_reg_t *spi;
    gpio_port_t cs_port;
    gpio_pin_t cs_pin;
} flash_t;

// Initialize flash memory
int flash_init(flash_t *flash, spi_reg_t *spi, 
               gpio_port_t cs_port, gpio_pin_t cs_pin) {
    if (flash == NULL || spi == NULL) {
        return -1;
    }
    
    flash->spi = spi;
    flash->cs_port = cs_port;
    flash->cs_pin = cs_pin;
    
    // Configure CS pin as output
    gpio_config_output(cs_port, cs_pin);
    gpio_set(cs_port, cs_pin);  // Deselect flash
    
    return 0;
}

// Send command to flash
static int flash_send_command(flash_t *flash, const uint8_t *cmd, uint32_t cmd_len,
                              const uint8_t *data_out, uint8_t *data_in, uint32_t data_len) {
    if (flash == NULL || cmd == NULL || cmd_len == 0) {
        return -1;
    }
    
    // Select flash
    spi_select_device(flash->cs_port, flash->cs_pin);
    
    // Send command
    if (spi_transmit(flash->spi, cmd, cmd_len) != 0) {
        spi_deselect_device(flash->cs_port, flash->cs_pin);
        return -2;
    }
    
    // Send/receive data
    if (data_out != NULL && data_in != NULL) {
        if (spi_transceive(flash->spi, data_out, data_in, data_len) != 0) {
            spi_deselect_device(flash->cs_port, flash->cs_pin);
            return -3;
        }
    } else if (data_out != NULL) {
        if (spi_transmit(flash->spi, data_out, data_len) != 0) {
            spi_deselect_device(flash->cs_port, flash->cs_pin);
            return -4;
        }
    } else if (data_in != NULL) {
        if (spi_receive(flash->spi, data_in, data_len) != 0) {
            spi_deselect_device(flash->cs_port, flash->cs_pin);
            return -5;
        }
    }
    
    // Deselect flash
    spi_deselect_device(flash->cs_port, flash->cs_pin);
    
    return 0;
}

// Read flash ID
int flash_read_id(flash_t *flash, uint8_t *id, uint32_t id_len) {
    if (flash == NULL || id == NULL || id_len == 0) {
        return -1;
    }
    
    uint8_t cmd = 0x9F;  // Read ID command
    return flash_send_command(flash, &cmd, 1, NULL, id, id_len);
}

// Read data from flash
int flash_read(flash_t *flash, uint32_t address, uint8_t *data, uint32_t length) {
    if (flash == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Prepare read command with address
    uint8_t cmd[4] = {0x03,                    // Read command
                      (address >> 16) & 0xFF,  // Address high byte
                      (address >> 8) & 0xFF,   // Address middle byte
                      address & 0xFF};         // Address low byte
    
    return flash_send_command(flash, cmd, 4, NULL, data, length);
}

// Write data to flash (page program)
int flash_write(flash_t *flash, uint32_t address, const uint8_t *data, uint32_t length) {
    if (flash == NULL || data == NULL || length == 0) {
        return -1;
    }
    
    // Prepare write command with address
    uint8_t cmd[4] = {0x02,                    // Page program command
                      (address >> 16) & 0xFF,  // Address high byte
                      (address >> 8) & 0xFF,   // Address middle byte
                      address & 0xFF};         // Address low byte
    
    return flash_send_command(flash, cmd, 4, data, NULL, length);
}
```

## Summary

Hardware interfaces are fundamental to embedded systems, enabling communication with various peripheral devices and sensors:

1. **GPIO** - Basic digital input/output for controlling LEDs, reading switches, etc.
2. **SPI** - High-speed synchronous communication for flash memory, displays, and sensors
3. **I2C** - Multi-master communication for EEPROMs, temperature sensors, and other devices
4. **UART** - Asynchronous serial communication for debug output and device communication

Key considerations for hardware interface implementation:
- Proper initialization and configuration of peripheral registers
- Error handling and timeout mechanisms
- Efficient data transfer methods
- Proper use of chip select signals for SPI devices
- Addressing schemes for I2C devices
- Baud rate configuration for UART communication
- Interrupt-driven vs. polling-based approaches
- Resource sharing and synchronization in multi-threaded environments

These interfaces form the foundation for connecting embedded systems to the physical world, enabling the development of sophisticated applications that interact with sensors, actuators, displays, storage devices, and communication modules.