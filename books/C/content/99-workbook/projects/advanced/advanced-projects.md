# Advanced Projects

These projects are designed for experienced C programmers who want to tackle complex challenges involving system programming, networking, multithreading, and advanced data structures.

## Project 1: Concurrent Web Server

### Description
Create a multithreaded web server that can handle multiple client requests concurrently and serve static files.

### Learning Objectives
- Network programming with sockets
- Multithreading and synchronization
- HTTP protocol implementation
- File I/O operations
- Error handling and logging

### Requirements
1. Handle multiple concurrent client connections
2. Serve static HTML, CSS, JavaScript, and image files
3. Implement basic HTTP/1.1 protocol
4. Support GET and POST requests
5. Handle 404 errors gracefully
6. Log requests and responses
7. Support basic authentication (optional)
8. Implement connection pooling

### Implementation Steps
1. Set up socket programming for server
2. Implement HTTP request parsing
3. Create thread pool for handling connections
4. Add file serving functionality
5. Implement error handling and logging
6. Add support for different HTTP methods
7. Create configuration system
8. Test with various clients

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>
#include <time.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <dirent.h>

#define PORT 8080
#define MAX_CLIENTS 100
#define BUFFER_SIZE 4096
#define THREAD_POOL_SIZE 10

typedef struct {
    int socket;
    struct sockaddr_in address;
} client_info_t;

typedef struct {
    pthread_t threads[THREAD_POOL_SIZE];
    int thread_count;
    pthread_mutex_t queue_mutex;
    pthread_cond_t queue_cond;
    client_info_t *queue;
    int queue_size;
    int queue_front;
    int queue_rear;
    int shutdown;
} thread_pool_t;

// Function prototypes
void init_thread_pool(thread_pool_t *pool);
void destroy_thread_pool(thread_pool_t *pool);
void *worker_thread(void *arg);
void enqueue_client(thread_pool_t *pool, client_info_t client);
client_info_t dequeue_client(thread_pool_t *pool);
void handle_client(client_info_t client);
void send_response(int client_socket, const char *status, const char *content_type, const char *body);
void send_file(int client_socket, const char *filepath);
void log_request(const char *method, const char *path, int status_code);
int parse_http_request(const char *request, char *method, char *path, char *version);
char* get_content_type(const char *filepath);
void *server_thread(void *arg);

int main() {
    int server_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    thread_pool_t pool;
    
    // Initialize thread pool
    init_thread_pool(&pool);
    
    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                   &opt, sizeof(opt))) {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }
    
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for connections
    if (listen(server_fd, 10) < 0) {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d\n", PORT);
    
    // Main server loop
    while (1) {
        client_info_t client;
        if ((client.socket = accept(server_fd, (struct sockaddr *)&client.address,
                                   (socklen_t*)&addrlen)) < 0) {
            perror("accept failed");
            continue;
        }
        
        // Add client to thread pool queue
        enqueue_client(&pool, client);
    }
    
    // Cleanup
    destroy_thread_pool(&pool);
    close(server_fd);
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Thread safety issues with shared resources
2. Memory leaks from improper resource management
3. Not handling partial reads/writes correctly
4. Buffer overflows in request parsing
5. Not properly closing socket connections
6. Race conditions in thread pool implementation

### Best Practices
1. Use proper synchronization primitives (mutexes, condition variables)
2. Always validate input and handle errors gracefully
3. Implement proper resource cleanup
4. Use connection pooling for efficiency
5. Log important events for debugging
6. Handle edge cases in HTTP protocol implementation
7. Use appropriate buffer sizes to prevent overflows

## Project 2: Memory Allocator

### Description
Implement a custom memory allocator that provides dynamic memory management similar to malloc/free.

### Learning Objectives
- Low-level memory management
- Pointer arithmetic
- Data structure design
- Performance optimization
- System programming concepts

### Requirements
1. Implement malloc, free, calloc, and realloc functions
2. Handle memory fragmentation
3. Support different allocation strategies (first-fit, best-fit, worst-fit)
4. Provide memory usage statistics
5. Handle alignment requirements
6. Detect memory leaks and corruption (optional)
7. Support multi-threading (optional)
8. Implement garbage collection (optional)

### Implementation Steps
1. Design internal data structures for memory blocks
2. Implement basic allocation and deallocation
3. Add different allocation strategies
4. Handle memory fragmentation
5. Implement memory statistics
6. Add alignment support
7. Test with various allocation patterns
8. Optimize for performance

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>

#define ALIGNMENT 8
#define ALIGN(size) (((size) + (ALIGNMENT-1)) & ~(ALIGNMENT-1))
#define BLOCK_SIZE sizeof(block_header_t)

typedef enum {
    ALLOC_FIRST_FIT,
    ALLOC_BEST_FIT,
    ALLOC_WORST_FIT
} alloc_strategy_t;

typedef struct block_header {
    size_t size;
    int free;
    struct block_header *next;
    struct block_header *prev;
} block_header_t;

typedef struct {
    block_header_t *head;
    size_t total_size;
    size_t used_size;
    size_t free_size;
    alloc_strategy_t strategy;
    pthread_mutex_t mutex;
} memory_pool_t;

static memory_pool_t g_pool = {0};

// Function prototypes
void init_memory_pool(size_t size, alloc_strategy_t strategy);
void destroy_memory_pool();
void *my_malloc(size_t size);
void my_free(void *ptr);
void *my_calloc(size_t nmemb, size_t size);
void *my_realloc(void *ptr, size_t size);
void print_memory_stats();
block_header_t *find_free_block(size_t size);
block_header_t *split_block(block_header_t *block, size_t size);
void coalesce_blocks();
size_t align_size(size_t size);

void *my_malloc(size_t size) {
    if (size == 0) return NULL;
    
    pthread_mutex_lock(&g_pool.mutex);
    
    size_t aligned_size = align_size(size);
    block_header_t *block = find_free_block(aligned_size);
    
    if (block) {
        // Split block if it's larger than needed
        if (block->size > aligned_size + BLOCK_SIZE + ALIGNMENT) {
            block = split_block(block, aligned_size);
        }
        
        block->free = 0;
        g_pool.used_size += block->size;
        g_pool.free_size -= block->size;
        
        pthread_mutex_unlock(&g_pool.mutex);
        return (void*)(block + 1);
    }
    
    pthread_mutex_unlock(&g_pool.mutex);
    return NULL;  // Out of memory
}

void my_free(void *ptr) {
    if (!ptr) return;
    
    pthread_mutex_lock(&g_pool.mutex);
    
    block_header_t *block = (block_header_t*)ptr - 1;
    block->free = 1;
    g_pool.used_size -= block->size;
    g_pool.free_size += block->size;
    
    // Coalesce adjacent free blocks
    coalesce_blocks();
    
    pthread_mutex_unlock(&g_pool.mutex);
}

// Implement all other functions here
```

### Common Pitfalls to Avoid
1. Memory leaks from improper block management
2. Buffer overflows in block headers
3. Not handling alignment requirements
4. Incorrect coalescing of free blocks
5. Thread safety issues in multi-threaded version
6. Not validating pointers in free() function

### Best Practices
1. Use proper data structures for efficient block management
2. Handle edge cases in allocation and deallocation
3. Implement proper alignment for performance
4. Use synchronization for thread safety
5. Validate all input pointers
6. Provide detailed memory statistics
7. Test with various allocation patterns

## Project 3: Real-time Data Processing System

### Description
Create a system that processes real-time data streams with configurable filters and transformations.

### Learning Objectives
- Multithreading and inter-thread communication
- Data pipeline design
- Performance optimization
- Configuration management
- Error handling in real-time systems

### Requirements
1. Process multiple data streams concurrently
2. Apply configurable filters and transformations
3. Support real-time data ingestion
4. Provide monitoring and statistics
5. Handle backpressure and buffering
6. Support plugin architecture for custom processors
7. Implement fault tolerance
8. Provide REST API for configuration (optional)

### Implementation Steps
1. Design data pipeline architecture
2. Implement data source connectors
3. Create processor framework
4. Add filtering and transformation capabilities
5. Implement threading and synchronization
6. Add monitoring and statistics
7. Handle backpressure and buffering
8. Test with real-world data scenarios

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>
#include <sys/queue.h>

#define MAX_PROCESSORS 100
#define BUFFER_SIZE 1024
#define MAX_PIPELINE_DEPTH 10

typedef struct {
    char *data;
    size_t size;
    time_t timestamp;
    int priority;
} data_packet_t;

typedef enum {
    FILTER_TYPE_NONE,
    FILTER_TYPE_REGEX,
    FILTER_TYPE_RANGE,
    FILTER_TYPE_CUSTOM
} filter_type_t;

typedef struct {
    filter_type_t type;
    void *config;
    int (*apply)(data_packet_t *packet, void *config);
} filter_t;

typedef struct {
    char name[50];
    int (*process)(data_packet_t *input, data_packet_t *output, void *config);
    void *config;
    filter_t *filters;
    int filter_count;
} processor_t;

typedef struct pipeline_node {
    processor_t *processor;
    struct pipeline_node *next;
} pipeline_node_t;

typedef struct {
    pipeline_node_t *head;
    int depth;
    pthread_mutex_t mutex;
    pthread_cond_t data_available;
    data_packet_t buffer[BUFFER_SIZE];
    int head_idx;
    int tail_idx;
    int count;
} pipeline_t;

typedef struct {
    char source_name[50];
    pthread_t thread;
    int running;
    pipeline_t *pipeline;
    void *source_config;
    int (*read_data)(data_packet_t *packet, void *config);
} data_source_t;

// Function prototypes
pipeline_t* create_pipeline();
void destroy_pipeline(pipeline_t *pipeline);
int add_processor(pipeline_t *pipeline, processor_t *processor);
int remove_processor(pipeline_t *pipeline, const char *name);
void process_data(pipeline_t *pipeline, data_packet_t *input);
data_source_t* create_data_source(const char *name, 
                                 int (*read_func)(data_packet_t*, void*),
                                 void *config);
void start_data_source(data_source_t *source, pipeline_t *pipeline);
void stop_data_source(data_source_t *source);
void *data_source_thread(void *arg);
int apply_filters(data_packet_t *packet, filter_t *filters, int filter_count);
void monitor_pipeline(pipeline_t *pipeline);

int main() {
    // Create pipeline
    pipeline_t *pipeline = create_pipeline();
    if (!pipeline) {
        fprintf(stderr, "Failed to create pipeline\n");
        return 1;
    }
    
    // Add processors to pipeline
    // ... add processors ...
    
    // Create data sources
    data_source_t *source1 = create_data_source("sensor1", read_sensor_data, NULL);
    data_source_t *source2 = create_data_source("network", read_network_data, NULL);
    
    // Start data sources
    start_data_source(source1, pipeline);
    start_data_source(source2, pipeline);
    
    // Monitor pipeline
    while (1) {
        monitor_pipeline(pipeline);
        sleep(5);
    }
    
    // Cleanup
    stop_data_source(source1);
    stop_data_source(source2);
    destroy_pipeline(pipeline);
    
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Deadlocks in threading implementation
2. Buffer overflows in data packets
3. Not handling backpressure properly
4. Memory leaks in dynamic data structures
5. Race conditions in shared data access
6. Not validating data packet integrity

### Best Practices
1. Use proper synchronization primitives
2. Implement efficient buffering strategies
3. Handle backpressure with appropriate mechanisms
4. Validate all data packets
5. Provide detailed monitoring and logging
6. Use configuration files for flexibility
7. Implement graceful shutdown procedures

## Project 4: Embedded System Simulator

### Description
Create a simulator for an embedded system with hardware components like GPIO, UART, timers, and interrupts.

### Learning Objectives
- Embedded systems programming concepts
- Hardware simulation
- Interrupt handling
- Real-time constraints
- Memory-mapped I/O

### Requirements
1. Simulate GPIO pins with input/output capabilities
2. Implement UART communication
3. Simulate timer functionality
4. Handle interrupts and interrupt priorities
5. Support memory-mapped I/O
6. Provide debugging interface
7. Simulate real-time constraints
8. Support multiple peripheral devices

### Implementation Steps
1. Design hardware simulation architecture
2. Implement GPIO simulation
3. Add UART communication simulation
4. Create timer simulation
5. Implement interrupt controller
6. Add memory-mapped I/O support
7. Create debugging interface
8. Test with sample embedded applications

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <time.h>

#define GPIO_PINS 32
#define UART_BUFFER_SIZE 256
#define MAX_INTERRUPTS 256

// Memory-mapped addresses
#define GPIO_BASE_ADDR    0x40000000
#define UART_BASE_ADDR    0x40001000
#define TIMER_BASE_ADDR   0x40002000
#define INTERRUPT_ADDR    0x40003000

typedef enum {
    GPIO_MODE_INPUT,
    GPIO_MODE_OUTPUT,
    GPIO_MODE_AF,
    GPIO_MODE_ANALOG
} gpio_mode_t;

typedef struct {
    unsigned int moder;     // Mode register
    unsigned int otyper;    // Output type register
    unsigned int ospeedr;   // Output speed register
    unsigned int pupdr;     // Pull-up/pull-down register
    unsigned int idr;       // Input data register
    unsigned int odr;       // Output data register
    unsigned int bsrr;      // Bit set/reset register
    unsigned int lckr;      // Configuration lock register
    unsigned int afr[2];    // Alternate function registers
} gpio_registers_t;

typedef struct {
    unsigned int sr;        // Status register
    unsigned int dr;        // Data register
    unsigned int brr;       // Baud rate register
    unsigned int cr1;       // Control register 1
    unsigned int cr2;       // Control register 2
    unsigned int cr3;       // Control register 3
    unsigned int gtpr;      // Guard time and prescaler register
} uart_registers_t;

typedef struct {
    unsigned int cr1;       // Control register 1
    unsigned int cr2;       // Control register 2
    unsigned int smcr;      // Slave mode control register
    unsigned int dier;      // DMA/interrupt enable register
    unsigned int sr;        // Status register
    unsigned int egr;       // Event generation register
    unsigned int ccmr1;     // Capture/compare mode register 1
    unsigned int ccmr2;     // Capture/compare mode register 2
    unsigned int ccer;      // Capture/compare enable register
    unsigned int cnt;       // Counter
    unsigned int psc;       // Prescaler
    unsigned int arr;       // Auto-reload register
} timer_registers_t;

typedef struct {
    unsigned int isr;       // Interrupt set register
    unsigned int ier;       // Interrupt enable register
    unsigned int icr;       // Interrupt clear register
    unsigned int ipr[8];    // Interrupt priority registers
} interrupt_registers_t;

typedef struct {
    gpio_registers_t gpio;
    uart_registers_t uart;
    timer_registers_t timer;
    interrupt_registers_t interrupt;
    unsigned char *memory;
    size_t memory_size;
    pthread_t cpu_thread;
    int running;
    unsigned long long cycles;
    time_t start_time;
} embedded_system_t;

// Function prototypes
embedded_system_t* create_embedded_system(size_t memory_size);
void destroy_embedded_system(embedded_system_t *system);
void* cpu_thread(void *arg);
unsigned int read_memory(embedded_system_t *system, unsigned int addr);
void write_memory(embedded_system_t *system, unsigned int addr, unsigned int value);
void gpio_write_pin(embedded_system_t *system, int pin, int value);
int gpio_read_pin(embedded_system_t *system, int pin);
void uart_transmit(embedded_system_t *system, unsigned char data);
unsigned char uart_receive(embedded_system_t *system);
void timer_start(embedded_system_t *system);
void timer_stop(embedded_system_t *system);
void interrupt_set(embedded_system_t *system, int irq);
void interrupt_clear(embedded_system_t *system, int irq);
void handle_interrupt(embedded_system_t *system, int irq);
void load_program(embedded_system_t *system, const char *filename);
void run_system(embedded_system_t *system);
void stop_system(embedded_system_t *system);

int main() {
    // Create embedded system
    embedded_system_t *system = create_embedded_system(64 * 1024);  // 64KB memory
    if (!system) {
        fprintf(stderr, "Failed to create embedded system\n");
        return 1;
    }
    
    // Load sample program
    load_program(system, "sample_program.bin");
    
    // Run system
    run_system(system);
    
    // Let it run for a while
    sleep(10);
    
    // Stop and cleanup
    stop_system(system);
    destroy_embedded_system(system);
    
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Incorrect memory-mapped I/O implementation
2. Race conditions in interrupt handling
3. Not simulating real-time constraints properly
4. Memory leaks in dynamic structures
5. Buffer overflows in peripheral simulations
6. Incorrect bit manipulation in hardware registers

### Best Practices
1. Use proper data structures for hardware registers
2. Implement accurate timing simulation
3. Handle interrupts with proper priority levels
4. Validate all memory accesses
5. Provide debugging interfaces for development
6. Use bit manipulation macros for register access
7. Implement proper error handling for hardware operations

## Tips for Success

1. **Understand the Domain**: Research the problem domain thoroughly before implementation
2. **Design First**: Create detailed designs and architectures before coding
3. **Incremental Development**: Build and test components incrementally
4. **Performance Considerations**: Profile and optimize critical paths
5. **Error Handling**: Implement comprehensive error handling and recovery
6. **Testing**: Create thorough test cases including edge cases
7. **Documentation**: Document complex algorithms and architectures
8. **Security**: Consider security implications in networked applications
9. **Scalability**: Design for scalability from the beginning
10. **Maintainability**: Write clean, modular code that's easy to maintain

These advanced projects will challenge you to apply sophisticated C programming techniques while solving complex real-world problems. Focus on robustness, performance, and maintainability in your implementations.