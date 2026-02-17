# Module 15.3: Domain-Specific Applications in C

## Introduction

Domain-specific applications are software solutions designed to address particular problem domains with specialized requirements. In C programming, developing domain-specific applications requires leveraging the language's low-level capabilities while implementing domain-specific logic and algorithms. This module explores the development of applications in various domains including embedded systems, scientific computing, networking, and real-time systems.

## Learning Objectives

By the end of this module, you will be able to:
- Understand the characteristics of domain-specific applications
- Design and implement applications for specific domains
- Apply domain-specific algorithms and data structures
- Optimize performance for domain requirements
- Handle domain-specific constraints and requirements
- Integrate with domain-specific hardware or protocols

## 1. Characteristics of Domain-Specific Applications

### 1.1 Domain Requirements

Domain-specific applications have unique requirements that distinguish them from general-purpose software:

1. **Performance Constraints**: Real-time systems require deterministic response times
2. **Resource Limitations**: Embedded systems often have limited memory and processing power
3. **Reliability Requirements**: Safety-critical systems demand high reliability
4. **Domain-Specific Logic**: Specialized algorithms and data structures
5. **Integration Needs**: Interface with specific hardware or protocols

### 1.2 Design Considerations

When designing domain-specific applications in C:

1. **Modularity**: Separate domain logic from infrastructure code
2. **Abstraction**: Hide domain complexity behind clean interfaces
3. **Optimization**: Focus on domain-critical performance paths
4. **Testing**: Implement domain-specific test scenarios
5. **Documentation**: Provide domain-specific context and examples

## 2. Embedded Systems Applications

### 2.1 Microcontroller Programming

Programming for microcontrollers requires careful resource management:

```c
#include <stdint.h>
#include <stdbool.h>

// Hardware register definitions (example for ARM Cortex-M)
#define GPIO_BASE_ADDR    0x40020000
#define GPIO_MODER_REG    (*(volatile uint32_t*)(GPIO_BASE_ADDR + 0x00))
#define GPIO_ODR_REG      (*(volatile uint32_t*)(GPIO_BASE_ADDR + 0x14))

// GPIO pin configuration
typedef enum {
    GPIO_MODE_INPUT = 0,
    GPIO_MODE_OUTPUT = 1,
    GPIO_MODE_AF = 2,
    GPIO_MODE_ANALOG = 3
} gpio_mode_t;

typedef enum {
    GPIO_SPEED_LOW = 0,
    GPIO_SPEED_MEDIUM = 1,
    GPIO_SPEED_HIGH = 2,
    GPIO_SPEED_VERY_HIGH = 3
} gpio_speed_t;

typedef struct {
    uint8_t pin;
    gpio_mode_t mode;
    gpio_speed_t speed;
    bool pull_up;
    bool pull_down;
} gpio_config_t;

// GPIO driver functions
void gpio_init(const gpio_config_t *config) {
    // Configure pin mode
    uint32_t mode_mask = 0x3 << (config->pin * 2);
    GPIO_MODER_REG = (GPIO_MODER_REG & ~mode_mask) | 
                     ((config->mode & 0x3) << (config->pin * 2));
    
    // Configure output speed (simplified)
    // Additional configuration for pull-up/pull-down would go here
}

void gpio_write(uint8_t pin, bool value) {
    if (value) {
        GPIO_ODR_REG |= (1 << pin);
    } else {
        GPIO_ODR_REG &= ~(1 << pin);
    }
}

bool gpio_read(uint8_t pin) {
    return (GPIO_ODR_REG & (1 << pin)) != 0;
}

// Example application: LED blinker
void led_blinker_task(void) {
    static uint32_t counter = 0;
    const uint32_t BLINK_PERIOD = 1000;  // ms
    
    gpio_config_t led_config = {
        .pin = 13,  // Assuming LED on pin 13
        .mode = GPIO_MODE_OUTPUT,
        .speed = GPIO_SPEED_LOW,
        .pull_up = false,
        .pull_down = false
    };
    
    gpio_init(&led_config);
    
    // Main loop (typically called by RTOS or timer interrupt)
    while (1) {
        if (counter % BLINK_PERIOD == 0) {
            static bool led_state = false;
            led_state = !led_state;
            gpio_write(13, led_state);
        }
        counter++;
        
        // In a real system, this would be a delay function
        // or the function would be called periodically
    }
}
```

### 2.2 Real-Time Operating System Integration

Integrating with RTOS for deterministic behavior:

```c
#include <stdint.h>
#include <stddef.h>

// Simplified RTOS API (similar to FreeRTOS)
typedef void* TaskHandle_t;
typedef void* QueueHandle_t;
typedef void* SemaphoreHandle_t;

// Task function prototype
typedef void (*TaskFunction_t)(void* pvParameters);

// RTOS function declarations
TaskHandle_t xTaskCreate(TaskFunction_t pvTaskCode,
                        const char * const pcName,
                        const uint16_t usStackDepth,
                        void * const pvParameters,
                        uint32_t uxPriority,
                        TaskHandle_t * const pxCreatedTask);

QueueHandle_t xQueueCreate(uint32_t uxQueueLength,
                          uint32_t uxItemSize);

uint32_t xQueueSend(QueueHandle_t xQueue,
                   const void * const pvItemToQueue,
                   uint32_t xTicksToWait);

uint32_t xQueueReceive(QueueHandle_t xQueue,
                      void * const pvBuffer,
                      uint32_t xTicksToWait);

SemaphoreHandle_t xSemaphoreCreateBinary(void);
void xSemaphoreTake(SemaphoreHandle_t xSemaphore, uint32_t xBlockTime);
void xSemaphoreGive(SemaphoreHandle_t xSemaphore);

// Domain-specific application: Sensor data processing
typedef struct {
    uint16_t temperature;
    uint16_t humidity;
    uint32_t timestamp;
} sensor_data_t;

// Task handles
TaskHandle_t sensor_task_handle;
TaskHandle_t processing_task_handle;
TaskHandle_t communication_task_handle;

// Communication queue
QueueHandle_t sensor_queue;

// Synchronization semaphore
SemaphoreHandle_t data_ready_semaphore;

// Sensor reading task
void sensor_task(void* pvParameters) {
    sensor_data_t sensor_data;
    
    while (1) {
        // Simulate sensor reading
        sensor_data.temperature = 250 + (rand() % 20);  // 25.0°C ± 1.0°C
        sensor_data.humidity = 500 + (rand() % 100);    // 50.0% ± 5.0%
        sensor_data.timestamp = 0;  // In real system, use actual timestamp
        
        // Send data to processing task
        if (xQueueSend(sensor_queue, &sensor_data, 100) != 0) {
            // Handle queue full error
        }
        
        // Signal that data is ready
        xSemaphoreGive(data_ready_semaphore);
        
        // Delay for 1 second (1000ms)
        // In real RTOS, use vTaskDelay() or similar
    }
}

// Data processing task
void processing_task(void* pvParameters) {
    sensor_data_t sensor_data;
    
    while (1) {
        // Wait for data to be ready
        xSemaphoreTake(data_ready_semaphore, 0xFFFFFFFF);  // Wait indefinitely
        
        // Receive sensor data
        if (xQueueReceive(sensor_queue, &sensor_data, 0) == 0) {
            // Process sensor data
            float temp_celsius = sensor_data.temperature / 10.0f;
            float humidity_percent = sensor_data.humidity / 10.0f;
            
            // Apply calibration or filtering if needed
            // ... processing logic ...
            
            // Forward processed data to communication task
            // ... communication logic ...
        }
    }
}

// Application initialization
void application_init(void) {
    // Create communication queue
    sensor_queue = xQueueCreate(10, sizeof(sensor_data_t));
    
    // Create synchronization semaphore
    data_ready_semaphore = xSemaphoreCreateBinary();
    
    // Create tasks
    sensor_task_handle = xTaskCreate(sensor_task,
                                    "SensorTask",
                                    256,    // Stack size
                                    NULL,   // Parameters
                                    1,      // Priority
                                    NULL);  // Task handle
    
    processing_task_handle = xTaskCreate(processing_task,
                                       "ProcessingTask",
                                       512,    // Stack size
                                       NULL,   // Parameters
                                       2,      // Priority
                                       NULL);  // Task handle
    
    // In a real system, you would also create communication task
    // and start the scheduler
}
```

## 3. Scientific Computing Applications

### 3.1 Numerical Libraries Integration

Integrating with numerical libraries for scientific computing:

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

// Matrix operations for scientific computing
typedef struct {
    size_t rows;
    size_t cols;
    double *data;
} matrix_t;

// Create matrix
matrix_t* matrix_create(size_t rows, size_t cols) {
    matrix_t *mat = malloc(sizeof(matrix_t));
    if (!mat) return NULL;
    
    mat->rows = rows;
    mat->cols = cols;
    mat->data = calloc(rows * cols, sizeof(double));
    
    if (!mat->data) {
        free(mat);
        return NULL;
    }
    
    return mat;
}

// Free matrix
void matrix_destroy(matrix_t *mat) {
    if (mat) {
        free(mat->data);
        free(mat);
    }
}

// Get element at (row, col)
double matrix_get(const matrix_t *mat, size_t row, size_t col) {
    if (row >= mat->rows || col >= mat->cols) return 0.0;
    return mat->data[row * mat->cols + col];
}

// Set element at (row, col)
void matrix_set(matrix_t *mat, size_t row, size_t col, double value) {
    if (row < mat->rows && col < mat->cols) {
        mat->data[row * mat->cols + col] = value;
    }
}

// Matrix multiplication
matrix_t* matrix_multiply(const matrix_t *a, const matrix_t *b) {
    if (a->cols != b->rows) return NULL;
    
    matrix_t *result = matrix_create(a->rows, b->cols);
    if (!result) return NULL;
    
    for (size_t i = 0; i < a->rows; i++) {
        for (size_t j = 0; j < b->cols; j++) {
            double sum = 0.0;
            for (size_t k = 0; k < a->cols; k++) {
                sum += matrix_get(a, i, k) * matrix_get(b, k, j);
            }
            matrix_set(result, i, j, sum);
        }
    }
    
    return result;
}

// Solve linear system using Gaussian elimination
int matrix_solve_linear_system(matrix_t *a, matrix_t *b) {
    if (a->rows != a->cols || a->rows != b->rows || b->cols != 1) {
        return -1;  // Invalid dimensions
    }
    
    size_t n = a->rows;
    
    // Forward elimination
    for (size_t i = 0; i < n; i++) {
        // Find pivot
        size_t max_row = i;
        for (size_t k = i + 1; k < n; k++) {
            if (fabs(matrix_get(a, k, i)) > fabs(matrix_get(a, max_row, i))) {
                max_row = k;
            }
        }
        
        // Swap rows if needed
        if (max_row != i) {
            for (size_t j = 0; j < n; j++) {
                double temp = matrix_get(a, i, j);
                matrix_set(a, i, j, matrix_get(a, max_row, j));
                matrix_set(a, max_row, j, temp);
            }
            double temp = matrix_get(b, i, 0);
            matrix_set(b, i, 0, matrix_get(b, max_row, 0));
            matrix_set(b, max_row, 0, temp);
        }
        
        // Check for singular matrix
        if (fabs(matrix_get(a, i, i)) < 1e-10) {
            return -2;  // Singular matrix
        }
        
        // Eliminate column
        for (size_t k = i + 1; k < n; k++) {
            double factor = matrix_get(a, k, i) / matrix_get(a, i, i);
            for (size_t j = i; j < n; j++) {
                double new_value = matrix_get(a, k, j) - factor * matrix_get(a, i, j);
                matrix_set(a, k, j, new_value);
            }
            double new_b = matrix_get(b, k, 0) - factor * matrix_get(b, i, 0);
            matrix_set(b, k, 0, new_b);
        }
    }
    
    // Back substitution
    for (int i = n - 1; i >= 0; i--) {
        double sum = matrix_get(b, i, 0);
        for (size_t j = i + 1; j < n; j++) {
            sum -= matrix_get(a, i, j) * matrix_get(b, j, 0);
        }
        matrix_set(b, i, 0, sum / matrix_get(a, i, i));
    }
    
    return 0;  // Success
}

// Example: Solve a system of linear equations
void example_linear_system(void) {
    // Solve:
    // 2x + 3y + z = 1
    // x + 4y + 2z = 2
    // 3x + y + 5z = 3
    
    matrix_t *a = matrix_create(3, 3);
    matrix_t *b = matrix_create(3, 1);
    
    if (!a || !b) {
        printf("Memory allocation failed\n");
        return;
    }
    
    // Coefficient matrix A
    matrix_set(a, 0, 0, 2.0); matrix_set(a, 0, 1, 3.0); matrix_set(a, 0, 2, 1.0);
    matrix_set(a, 1, 0, 1.0); matrix_set(a, 1, 1, 4.0); matrix_set(a, 1, 2, 2.0);
    matrix_set(a, 2, 0, 3.0); matrix_set(a, 2, 1, 1.0); matrix_set(a, 2, 2, 5.0);
    
    // Constants vector B
    matrix_set(b, 0, 0, 1.0);
    matrix_set(b, 1, 0, 2.0);
    matrix_set(b, 2, 0, 3.0);
    
    printf("Solving linear system:\n");
    printf("2x + 3y + z = 1\n");
    printf("x + 4y + 2z = 2\n");
    printf("3x + y + 5z = 3\n\n");
    
    int result = matrix_solve_linear_system(a, b);
    
    if (result == 0) {
        printf("Solution:\n");
        printf("x = %.6f\n", matrix_get(b, 0, 0));
        printf("y = %.6f\n", matrix_get(b, 1, 0));
        printf("z = %.6f\n", matrix_get(b, 2, 0));
    } else {
        printf("Failed to solve system (error code: %d)\n", result);
    }
    
    matrix_destroy(a);
    matrix_destroy(b);
}
```

### 3.2 Fast Fourier Transform (FFT)

Implementing FFT for signal processing:

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

// Complex number type
typedef double complex complex_t;

// FFT implementation using Cooley-Tukey algorithm
void fft_recursive(complex_t *x, size_t n, size_t step) {
    if (step < n) {
        fft_recursive(x, n, step * 2);
        fft_recursive(x + step, n, step * 2);
        
        for (size_t i = 0; i < n; i += step * 2) {
            complex_t t = cexp(-I * M_PI * i / n) * x[i + step];
            x[i + step] = x[i] - t;
            x[i] += t;
        }
    }
}

void fft(complex_t *x, size_t n) {
    // Make sure n is a power of 2
    if (n & (n - 1)) {
        fprintf(stderr, "FFT size must be a power of 2\n");
        return;
    }
    
    // Bit-reversal permutation
    size_t j = 0;
    for (size_t i = 0; i < n; i++) {
        if (i < j) {
            complex_t temp = x[i];
            x[i] = x[j];
            x[j] = temp;
        }
        
        size_t k = n >> 1;
        while (k <= j) {
            j -= k;
            k >>= 1;
        }
        j += k;
    }
    
    // Recursive FFT
    fft_recursive(x, n, 1);
}

// Inverse FFT
void ifft(complex_t *x, size_t n) {
    // Conjugate the input
    for (size_t i = 0; i < n; i++) {
        x[i] = conj(x[i]);
    }
    
    // Apply FFT
    fft(x, n);
    
    // Conjugate and normalize
    for (size_t i = 0; i < n; i++) {
        x[i] = conj(x[i]) / n;
    }
}

// Generate a test signal
void generate_test_signal(complex_t *signal, size_t n, double frequency) {
    for (size_t i = 0; i < n; i++) {
        double t = (double)i / n;
        // Composite signal: sum of sine waves
        double value = sin(2 * M_PI * frequency * t) +
                      0.5 * sin(2 * M_PI * 3 * frequency * t) +
                      0.3 * sin(2 * M_PI * 5 * frequency * t);
        signal[i] = value + 0.0 * I;  // Real signal
    }
}

// Example: FFT analysis of a signal
void example_fft_analysis(void) {
    const size_t N = 64;  // Must be power of 2
    const double sample_rate = 1000.0;  // Hz
    const double signal_frequency = 50.0;  // Hz
    
    complex_t *signal = malloc(N * sizeof(complex_t));
    if (!signal) {
        fprintf(stderr, "Memory allocation failed\n");
        return;
    }
    
    // Generate test signal
    generate_test_signal(signal, N, signal_frequency);
    
    printf("Original signal samples:\n");
    for (size_t i = 0; i < 8; i++) {  // Show first 8 samples
        printf("Sample[%zu] = %.3f\n", i, creal(signal[i]));
    }
    
    // Apply FFT
    fft(signal, N);
    
    printf("\nFrequency domain representation:\n");
    printf("Frequency (Hz)\tMagnitude\tPhase (rad)\n");
    
    // Analyze frequency components
    for (size_t i = 0; i <= N/2; i++) {
        double frequency = i * sample_rate / N;
        double magnitude = cabs(signal[i]) / N;
        double phase = carg(signal[i]);
        
        // Only show significant components
        if (magnitude > 0.01) {
            printf("%.1f\t\t%.3f\t\t%.3f\n", frequency, magnitude, phase);
        }
    }
    
    // Apply inverse FFT to verify
    ifft(signal, N);
    
    printf("\nReconstructed signal (first 8 samples):\n");
    for (size_t i = 0; i < 8; i++) {
        printf("Sample[%zu] = %.3f\n", i, creal(signal[i]));
    }
    
    free(signal);
}
```

## 4. Networking Applications

### 4.1 Protocol Implementation

Implementing custom network protocols:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <arpa/inet.h>

// Custom protocol packet structure
typedef struct {
    uint16_t magic;        // Protocol identifier
    uint16_t version;      // Protocol version
    uint32_t sequence;     // Packet sequence number
    uint32_t timestamp;    // Timestamp (seconds since epoch)
    uint16_t type;         // Packet type
    uint16_t length;       // Payload length
    uint8_t payload[0];    // Variable length payload
} __attribute__((packed)) protocol_packet_t;

#define PROTOCOL_MAGIC 0xCAFE
#define PROTOCOL_VERSION 1

// Packet types
#define PACKET_TYPE_DATA 1
#define PACKET_TYPE_ACK 2
#define PACKET_TYPE_NACK 3
#define PACKET_TYPE_HEARTBEAT 4

// Protocol error codes
typedef enum {
    PROTOCOL_SUCCESS = 0,
    PROTOCOL_ERROR_INVALID_MAGIC = -1,
    PROTOCOL_ERROR_INVALID_VERSION = -2,
    PROTOCOL_ERROR_BUFFER_TOO_SMALL = -3,
    PROTOCOL_ERROR_INVALID_LENGTH = -4
} protocol_error_t;

// Create a protocol packet
protocol_packet_t* protocol_create_packet(uint16_t type, 
                                         const void *payload, 
                                         uint16_t payload_length) {
    size_t packet_size = sizeof(protocol_packet_t) + payload_length;
    protocol_packet_t *packet = malloc(packet_size);
    
    if (!packet) {
        return NULL;
    }
    
    // Initialize packet header
    packet->magic = htons(PROTOCOL_MAGIC);
    packet->version = htons(PROTOCOL_VERSION);
    packet->sequence = 0;  // Would be set by sequence manager
    packet->timestamp = htonl((uint32_t)time(NULL));
    packet->type = htons(type);
    packet->length = htons(payload_length);
    
    // Copy payload
    if (payload && payload_length > 0) {
        memcpy(packet->payload, payload, payload_length);
    }
    
    return packet;
}

// Validate a received packet
protocol_error_t protocol_validate_packet(const protocol_packet_t *packet, 
                                         size_t buffer_size) {
    // Check buffer size
    if (buffer_size < sizeof(protocol_packet_t)) {
        return PROTOCOL_ERROR_BUFFER_TOO_SMALL;
    }
    
    // Check magic number
    if (ntohs(packet->magic) != PROTOCOL_MAGIC) {
        return PROTOCOL_ERROR_INVALID_MAGIC;
    }
    
    // Check version
    if (ntohs(packet->version) != PROTOCOL_VERSION) {
        return PROTOCOL_ERROR_INVALID_VERSION;
    }
    
    // Check payload length
    uint16_t payload_length = ntohs(packet->length);
    size_t total_size = sizeof(protocol_packet_t) + payload_length;
    
    if (buffer_size < total_size) {
        return PROTOCOL_ERROR_BUFFER_TOO_SMALL;
    }
    
    return PROTOCOL_SUCCESS;
}

// Parse packet payload based on type
void protocol_parse_payload(const protocol_packet_t *packet) {
    uint16_t type = ntohs(packet->type);
    uint16_t length = ntohs(packet->length);
    
    printf("Packet Type: %u, Length: %u\n", type, length);
    
    switch (type) {
        case PACKET_TYPE_DATA:
            printf("Data packet received: ");
            if (length > 0) {
                // Print first 32 bytes of payload as hex
                for (int i = 0; i < length && i < 32; i++) {
                    printf("%02x ", packet->payload[i]);
                }
                if (length > 32) printf("...");
            }
            printf("\n");
            break;
            
        case PACKET_TYPE_ACK:
            printf("Acknowledgment packet\n");
            break;
            
        case PACKET_TYPE_NACK:
            printf("Negative acknowledgment packet\n");
            break;
            
        case PACKET_TYPE_HEARTBEAT:
            printf("Heartbeat packet\n");
            break;
            
        default:
            printf("Unknown packet type\n");
            break;
    }
}

// Example: Protocol usage
void example_protocol_usage(void) {
    printf("Creating protocol packets...\n");
    
    // Create data packet
    const char *message = "Hello, Protocol World!";
    protocol_packet_t *data_packet = protocol_create_packet(
        PACKET_TYPE_DATA, message, strlen(message));
    
    if (data_packet) {
        printf("Created data packet:\n");
        protocol_parse_payload(data_packet);
        
        // Validate the packet
        protocol_error_t result = protocol_validate_packet(
            data_packet, sizeof(protocol_packet_t) + strlen(message));
        
        if (result == PROTOCOL_SUCCESS) {
            printf("Packet validation successful\n");
        } else {
            printf("Packet validation failed: %d\n", result);
        }
        
        free(data_packet);
    }
    
    // Create heartbeat packet
    protocol_packet_t *heartbeat_packet = protocol_create_packet(
        PACKET_TYPE_HEARTBEAT, NULL, 0);
    
    if (heartbeat_packet) {
        printf("\nCreated heartbeat packet:\n");
        protocol_parse_payload(heartbeat_packet);
        free(heartbeat_packet);
    }
}
```

### 4.2 HTTP Client Implementation

Simple HTTP client for web services:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

// HTTP request structure
typedef struct {
    char method[16];
    char host[256];
    int port;
    char path[512];
    char *headers;
    char *body;
    size_t body_length;
} http_request_t;

// HTTP response structure
typedef struct {
    int status_code;
    char status_text[64];
    char *headers;
    char *body;
    size_t body_length;
} http_response_t;

// Create HTTP request
http_request_t* http_create_request(const char *method, 
                                   const char *host, 
                                   int port, 
                                   const char *path) {
    http_request_t *req = malloc(sizeof(http_request_t));
    if (!req) return NULL;
    
    strncpy(req->method, method, sizeof(req->method) - 1);
    strncpy(req->host, host, sizeof(req->host) - 1);
    req->port = port;
    strncpy(req->path, path, sizeof(req->path) - 1);
    
    req->headers = NULL;
    req->body = NULL;
    req->body_length = 0;
    
    return req;
}

// Add header to request
void http_add_header(http_request_t *req, const char *header) {
    size_t current_len = req->headers ? strlen(req->headers) : 0;
    size_t header_len = strlen(header);
    size_t new_len = current_len + header_len + 3;  // +3 for \r\n\0
    
    char *new_headers = realloc(req->headers, new_len);
    if (!new_headers) return;
    
    req->headers = new_headers;
    
    if (current_len == 0) {
        strcpy(req->headers, header);
    } else {
        strcat(req->headers, "\r\n");
        strcat(req->headers, header);
    }
}

// Set request body
void http_set_body(http_request_t *req, const char *body, size_t length) {
    req->body = malloc(length);
    if (req->body) {
        memcpy(req->body, body, length);
        req->body_length = length;
    }
}

// Build HTTP request string
char* http_build_request_string(const http_request_t *req) {
    size_t req_size = strlen(req->method) + strlen(req->path) + 16;  // Method + Path + HTTP/1.1
    req_size += strlen(req->host) + 16;  // Host header
    
    if (req->headers) {
        req_size += strlen(req->headers) + 2;  // Headers + \r\n
    }
    
    if (req->body) {
        req_size += req->body_length + 16;  // Content-Length header
    }
    
    req_size += 32;  // Extra space for safety
    
    char *request = malloc(req_size);
    if (!request) return NULL;
    
    // Build request line
    snprintf(request, req_size, "%s %s HTTP/1.1\r\n", req->method, req->path);
    
    // Add Host header
    char host_header[300];
    snprintf(host_header, sizeof(host_header), "Host: %s:%d", req->host, req->port);
    strcat(request, host_header);
    strcat(request, "\r\n");
    
    // Add custom headers
    if (req->headers) {
        strcat(request, req->headers);
        strcat(request, "\r\n");
    }
    
    // Add Content-Length if body exists
    if (req->body) {
        char content_length[32];
        snprintf(content_length, sizeof(content_length), "Content-Length: %zu\r\n", req->body_length);
        strcat(request, content_length);
    }
    
    // End headers
    strcat(request, "\r\n");
    
    // Add body
    if (req->body) {
        size_t current_len = strlen(request);
        memcpy(request + current_len, req->body, req->body_length);
        request[current_len + req->body_length] = '\0';
    }
    
    return request;
}

// Simple HTTP GET request
int http_get(const char *url, char **response_body, size_t *response_length) {
    // Parse URL (simplified - assumes http://host:port/path format)
    if (strncmp(url, "http://", 7) != 0) {
        fprintf(stderr, "Only HTTP URLs supported\n");
        return -1;
    }
    
    const char *host_start = url + 7;
    const char *port_start = strchr(host_start, ':');
    const char *path_start = strchr(host_start, '/');
    
    if (!path_start) {
        fprintf(stderr, "Invalid URL format\n");
        return -1;
    }
    
    char host[256];
    int port = 80;
    
    if (port_start && port_start < path_start) {
        // Extract host
        size_t host_len = port_start - host_start;
        if (host_len >= sizeof(host)) {
            fprintf(stderr, "Host name too long\n");
            return -1;
        }
        strncpy(host, host_start, host_len);
        host[host_len] = '\0';
        
        // Extract port
        port = atoi(port_start + 1);
    } else {
        // Extract host only
        size_t host_len = path_start - host_start;
        if (host_len >= sizeof(host)) {
            fprintf(stderr, "Host name too long\n");
            return -1;
        }
        strncpy(host, host_start, host_len);
        host[host_len] = '\0';
    }
    
    const char *path = path_start;
    
    // Create socket
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("socket creation failed");
        return -1;
    }
    
    // Resolve hostname
    struct hostent *server = gethostbyname(host);
    if (!server) {
        fprintf(stderr, "Failed to resolve hostname: %s\n", host);
        close(sock);
        return -1;
    }
    
    // Connect to server
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    memcpy(&server_addr.sin_addr.s_addr, server->h_addr, server->h_length);
    server_addr.sin_port = htons(port);
    
    if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("connection failed");
        close(sock);
        return -1;
    }
    
    // Create HTTP request
    http_request_t *req = http_create_request("GET", host, port, path);
    if (!req) {
        close(sock);
        return -1;
    }
    
    http_add_header(req, "Connection: close");
    http_add_header(req, "User-Agent: C-HTTP-Client/1.0");
    
    char *request_string = http_build_request_string(req);
    if (!request_string) {
        free(req);
        close(sock);
        return -1;
    }
    
    // Send request
    if (send(sock, request_string, strlen(request_string), 0) < 0) {
        perror("send failed");
        free(request_string);
        free(req);
        close(sock);
        return -1;
    }
    
    // Receive response
    char buffer[4096];
    ssize_t bytes_received;
    char *full_response = NULL;
    size_t total_received = 0;
    
    while ((bytes_received = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {
        char *new_response = realloc(full_response, total_received + bytes_received + 1);
        if (!new_response) {
            free(full_response);
            free(request_string);
            free(req);
            close(sock);
            return -1;
        }
        
        full_response = new_response;
        memcpy(full_response + total_received, buffer, bytes_received);
        total_received += bytes_received;
        full_response[total_received] = '\0';
    }
    
    close(sock);
    free(request_string);
    free(req);
    
    if (bytes_received < 0) {
        perror("recv failed");
        free(full_response);
        return -1;
    }
    
    // Parse response (simplified)
    *response_body = full_response;
    *response_length = total_received;
    
    return 0;
}

// Example: HTTP client usage
void example_http_client(void) {
    printf("Making HTTP GET request...\n");
    
    char *response_body;
    size_t response_length;
    
    // Make a simple HTTP request
    int result = http_get("http://httpbin.org/get", &response_body, &response_length);
    
    if (result == 0) {
        printf("HTTP request successful\n");
        printf("Response length: %zu bytes\n", response_length);
        
        // Print first 500 characters of response
        size_t print_length = (response_length < 500) ? response_length : 500;
        printf("Response (first %zu chars):\n", print_length);
        fwrite(response_body, 1, print_length, stdout);
        printf("\n");
        
        free(response_body);
    } else {
        printf("HTTP request failed\n");
    }
}
```

## 5. Best Practices for Domain-Specific Applications

### 5.1 Domain Analysis

1. **Requirements Gathering**: Understand domain-specific constraints and requirements
2. **Performance Analysis**: Identify critical performance paths
3. **Resource Constraints**: Account for memory, CPU, and I/O limitations
4. **Safety Considerations**: Implement appropriate error handling and recovery

### 5.2 Design Patterns

1. **Modular Architecture**: Separate domain logic from infrastructure
2. **Abstraction Layers**: Hide domain complexity behind clean interfaces
3. **Configuration Management**: Support domain-specific configuration
4. **Extensibility**: Design for future domain requirements

### 5.3 Testing Strategies

1. **Domain-Specific Tests**: Implement tests that validate domain requirements
2. **Edge Case Testing**: Test boundary conditions specific to the domain
3. **Performance Testing**: Validate performance under domain-specific loads
4. **Integration Testing**: Test integration with domain-specific systems

## Summary

Domain-specific applications in C require a deep understanding of both the programming language and the target domain. Key concepts covered in this module include:

- Characteristics and requirements of domain-specific applications
- Embedded systems programming with microcontroller integration
- Scientific computing with numerical libraries and algorithms
- Networking applications with custom protocols and HTTP clients
- Best practices for design, implementation, and testing

Developing domain-specific applications in C allows for highly optimized, efficient solutions that can take full advantage of system resources while meeting specialized requirements. Success in this area requires both strong C programming skills and domain expertise.