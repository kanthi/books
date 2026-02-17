# Module 15.4: Capstone Project

## Introduction

The capstone project represents the culmination of your C programming journey, integrating all the concepts, techniques, and best practices you've learned throughout this course. This project challenges you to design, implement, and document a substantial application that demonstrates mastery of advanced C programming concepts while solving a real-world problem.

## Learning Objectives

By completing this capstone project, you will demonstrate the ability to:
- Design and implement a complex, multi-module C application
- Apply advanced programming techniques including multithreading, memory management, and system programming
- Integrate domain-specific knowledge with C programming skills
- Follow professional software development practices including documentation, testing, and version control
- Debug and optimize complex applications
- Present technical work effectively

## Project Requirements

### 1. Technical Requirements

Your capstone project must include:

1. **Multi-file Structure**: Organized into logical modules with proper header files
2. **Advanced C Features**: Use of at least three advanced C concepts (e.g., multithreading, memory mapping, signal handling, etc.)
3. **Error Handling**: Comprehensive error handling with appropriate recovery mechanisms
4. **Memory Management**: Proper dynamic memory allocation and deallocation
5. **Input/Output**: Robust file I/O and/or network communication
6. **Data Structures**: Implementation of appropriate data structures for the problem domain
7. **Testing**: Unit tests and integration tests for critical components
8. **Documentation**: Complete documentation including user guide and API reference

### 2. Project Scope

The project should be substantial enough to demonstrate advanced skills but manageable within the timeframe. Consider projects that:

- Solve a real-world problem or fill a gap in existing tools
- Demonstrate integration of multiple concepts from the course
- Include both algorithmic complexity and systems programming aspects
- Have clear requirements and measurable outcomes

### 3. Deliverables

1. **Source Code**: Complete, well-organized C source code
2. **Documentation**: 
   - README with project overview, installation, and usage instructions
   - Technical documentation explaining design decisions
   - API documentation for any libraries or modules created
3. **Testing**: Test suite with clear test cases and expected outcomes
4. **Presentation**: A presentation (written or oral) explaining the project
5. **Reflection**: A written reflection on the development process and lessons learned

## Project Ideas

### 1. System Monitoring Tool

Create a comprehensive system monitoring application that collects and displays system metrics:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <sys/sysinfo.h>
#include <sys/statvfs.h>

// Data structures for system metrics
typedef struct {
    double cpu_usage;
    unsigned long memory_total;
    unsigned long memory_free;
    unsigned long memory_available;
    double load_average[3];
    time_t timestamp;
} system_metrics_t;

typedef struct {
    char filesystem[256];
    unsigned long total_space;
    unsigned long free_space;
    unsigned long available_space;
} disk_metrics_t;

// Thread-safe metrics storage
typedef struct {
    system_metrics_t *metrics;
    size_t count;
    size_t capacity;
    pthread_mutex_t mutex;
} metrics_storage_t;

// Global metrics storage
static metrics_storage_t g_metrics = {
    .metrics = NULL,
    .count = 0,
    .capacity = 0,
    .mutex = PTHREAD_MUTEX_INITIALIZER
};

// Function to collect CPU usage
double get_cpu_usage() {
    static unsigned long long prev_idle = 0;
    static unsigned long long prev_total = 0;
    
    FILE *fp = fopen("/proc/stat", "r");
    if (!fp) return -1.0;
    
    char buffer[1024];
    fgets(buffer, sizeof(buffer), fp);
    fclose(fp);
    
    unsigned long long user, nice, system, idle, iowait, irq, softirq, steal;
    sscanf(buffer, "cpu %llu %llu %llu %llu %llu %llu %llu %llu",
           &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal);
    
    unsigned long long total = user + nice + system + idle + iowait + irq + softirq + steal;
    unsigned long long total_idle = idle + iowait;
    
    double cpu_usage = 0.0;
    if (prev_total != 0) {
        unsigned long long total_diff = total - prev_total;
        unsigned long long idle_diff = total_idle - prev_idle;
        cpu_usage = 100.0 * (total_diff - idle_diff) / total_diff;
    }
    
    prev_idle = total_idle;
    prev_total = total;
    
    return cpu_usage;
}

// Function to collect memory information
void get_memory_info(unsigned long *total, unsigned long *free, unsigned long *available) {
    struct sysinfo si;
    if (sysinfo(&si) == 0) {
        *total = si.totalram * si.mem_unit;
        *free = si.freeram * si.mem_unit;
        *available = si.freeram * si.mem_unit + si.bufferram * si.mem_unit;
    }
}

// Function to collect disk space information
int get_disk_info(const char *path, disk_metrics_t *disk) {
    struct statvfs buf;
    if (statvfs(path, &buf) != 0) {
        return -1;
    }
    
    strncpy(disk->filesystem, path, sizeof(disk->filesystem) - 1);
    disk->total_space = buf.f_blocks * buf.f_frsize;
    disk->free_space = buf.f_bfree * buf.f_frsize;
    disk->available_space = buf.f_bavail * buf.f_frsize;
    
    return 0;
}

// Function to collect system load average
void get_load_average(double loadavg[3]) {
    FILE *fp = fopen("/proc/loadavg", "r");
    if (fp) {
        fscanf(fp, "%lf %lf %lf", &loadavg[0], &loadavg[1], &loadavg[2]);
        fclose(fp);
    }
}

// Metrics collection thread function
void* metrics_collection_thread(void* arg) {
    while (1) {
        system_metrics_t metrics = {0};
        metrics.timestamp = time(NULL);
        
        // Collect metrics
        metrics.cpu_usage = get_cpu_usage();
        get_memory_info(&metrics.memory_total, &metrics.memory_free, &metrics.memory_available);
        get_load_average(metrics.load_average);
        
        // Store metrics safely
        pthread_mutex_lock(&g_metrics.mutex);
        
        // Expand storage if needed
        if (g_metrics.count >= g_metrics.capacity) {
            size_t new_capacity = (g_metrics.capacity == 0) ? 10 : g_metrics.capacity * 2;
            system_metrics_t *new_metrics = realloc(g_metrics.metrics, 
                                                   new_capacity * sizeof(system_metrics_t));
            if (new_metrics) {
                g_metrics.metrics = new_metrics;
                g_metrics.capacity = new_capacity;
            }
        }
        
        // Add new metrics
        if (g_metrics.count < g_metrics.capacity) {
            g_metrics.metrics[g_metrics.count] = metrics;
            g_metrics.count++;
        }
        
        pthread_mutex_unlock(&g_metrics.mutex);
        
        // Wait for 5 seconds before next collection
        sleep(5);
    }
    
    return NULL;
}

// Function to display current metrics
void display_current_metrics() {
    pthread_mutex_lock(&g_metrics.mutex);
    
    if (g_metrics.count > 0) {
        system_metrics_t *latest = &g_metrics.metrics[g_metrics.count - 1];
        
        printf("=== System Metrics ===\n");
        printf("Timestamp: %s", ctime(&latest->timestamp));
        printf("CPU Usage: %.2f%%\n", latest->cpu_usage);
        printf("Memory Total: %lu MB\n", latest->memory_total / (1024 * 1024));
        printf("Memory Free: %lu MB\n", latest->memory_free / (1024 * 1024));
        printf("Memory Available: %lu MB\n", latest->memory_available / (1024 * 1024));
        printf("Load Average: %.2f, %.2f, %.2f\n", 
               latest->load_average[0], latest->load_average[1], latest->load_average[2]);
        
        // Display disk information
        disk_metrics_t disk;
        if (get_disk_info("/", &disk) == 0) {
            printf("Disk (/): %.2f GB total, %.2f GB free, %.2f GB available\n",
                   disk.total_space / (1024.0 * 1024 * 1024),
                   disk.free_space / (1024.0 * 1024 * 1024),
                   disk.available_space / (1024.0 * 1024 * 1024));
        }
    }
    
    pthread_mutex_unlock(&g_metrics.mutex);
}

// Main function for system monitor
int main_system_monitor() {
    printf("Starting System Monitor...\n");
    
    // Create metrics collection thread
    pthread_t collector_thread;
    if (pthread_create(&collector_thread, NULL, metrics_collection_thread, NULL) != 0) {
        perror("Failed to create metrics collection thread");
        return 1;
    }
    
    // Main loop - display metrics and handle user input
    char command[10];
    while (1) {
        printf("\nCommands: [d]isplay metrics, [q]uit: ");
        if (fgets(command, sizeof(command), stdin)) {
            if (command[0] == 'd' || command[0] == 'D') {
                display_current_metrics();
            } else if (command[0] == 'q' || command[0] == 'Q') {
                break;
            }
        }
    }
    
    // Clean up
    pthread_cancel(collector_thread);
    pthread_join(collector_thread, NULL);
    
    if (g_metrics.metrics) {
        free(g_metrics.metrics);
    }
    
    printf("System Monitor stopped.\n");
    return 0;
}
```

### 2. Custom Database Engine

Implement a simple embedded database with basic SQL-like functionality:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

// Data types
typedef enum {
    TYPE_INTEGER,
    TYPE_STRING,
    TYPE_FLOAT
} column_type_t;

// Column definition
typedef struct {
    char name[64];
    column_type_t type;
    size_t offset;
} column_t;

// Table definition
typedef struct {
    char name[64];
    column_t *columns;
    size_t column_count;
    size_t row_size;
    void *data;
    size_t row_count;
    size_t capacity;
} table_t;

// Database structure
typedef struct {
    table_t *tables;
    size_t table_count;
    size_t capacity;
} database_t;

// Global database instance
static database_t g_db = {0};

// Create a new table
table_t* db_create_table(const char *name, size_t column_count) {
    // Expand tables array if needed
    if (g_db.table_count >= g_db.capacity) {
        size_t new_capacity = (g_db.capacity == 0) ? 4 : g_db.capacity * 2;
        table_t *new_tables = realloc(g_db.tables, new_capacity * sizeof(table_t));
        if (!new_tables) return NULL;
        
        g_db.tables = new_tables;
        g_db.capacity = new_capacity;
    }
    
    // Initialize new table
    table_t *table = &g_db.tables[g_db.table_count];
    strncpy(table->name, name, sizeof(table->name) - 1);
    table->columns = calloc(column_count, sizeof(column_t));
    table->column_count = column_count;
    table->row_size = 0;
    table->data = NULL;
    table->row_count = 0;
    table->capacity = 0;
    
    g_db.table_count++;
    return table;
}

// Add a column to a table
int table_add_column(table_t *table, const char *name, column_type_t type) {
    if (table->column_count >= 64) return -1;  // Max columns reached
    
    column_t *column = &table->columns[table->column_count - 1];
    strncpy(column->name, name, sizeof(column->name) - 1);
    
    // Calculate offset based on previous columns
    size_t offset = 0;
    for (size_t i = 0; i < table->column_count - 1; i++) {
        switch (table->columns[i].type) {
            case TYPE_INTEGER:
                offset = (offset + sizeof(int) - 1) & ~(sizeof(int) - 1);
                offset += sizeof(int);
                break;
            case TYPE_FLOAT:
                offset = (offset + sizeof(double) - 1) & ~(sizeof(double) - 1);
                offset += sizeof(double);
                break;
            case TYPE_STRING:
                offset = (offset + sizeof(char*) - 1) & ~(sizeof(char*) - 1);
                offset += sizeof(char*);
                break;
        }
    }
    
    column->type = type;
    column->offset = offset;
    
    // Update row size
    switch (type) {
        case TYPE_INTEGER:
            table->row_size = (offset + sizeof(int) - 1) & ~(sizeof(int) - 1);
            table->row_size += sizeof(int);
            break;
        case TYPE_FLOAT:
            table->row_size = (offset + sizeof(double) - 1) & ~(sizeof(double) - 1);
            table->row_size += sizeof(double);
            break;
        case TYPE_STRING:
            table->row_size = (offset + sizeof(char*) - 1) & ~(sizeof(char*) - 1);
            table->row_size += sizeof(char*);
            break;
    }
    
    return 0;
}

// Insert a row into a table
int table_insert_row(table_t *table, void *row_data) {
    // Expand data array if needed
    if (table->row_count >= table->capacity) {
        size_t new_capacity = (table->capacity == 0) ? 16 : table->capacity * 2;
        void *new_data = realloc(table->data, new_capacity * table->row_size);
        if (!new_data) return -1;
        
        table->data = new_data;
        table->capacity = new_capacity;
    }
    
    // Copy row data
    void *dest = (char*)table->data + table->row_count * table->row_size;
    memcpy(dest, row_data, table->row_size);
    table->row_count++;
    
    return 0;
}

// Simple query execution
void db_execute_query(const char *query) {
    printf("Executing query: %s\n", query);
    
    // Simple parser for demonstration
    if (strncmp(query, "CREATE TABLE", 12) == 0) {
        // Parse table creation
        char table_name[64];
        if (sscanf(query, "CREATE TABLE %63s", table_name) == 1) {
            table_t *table = db_create_table(table_name, 4);  // Max 4 columns for demo
            if (table) {
                printf("Table '%s' created successfully\n", table_name);
            } else {
                printf("Failed to create table '%s'\n", table_name);
            }
        }
    } else if (strncmp(query, "INSERT INTO", 11) == 0) {
        printf("Insert operation executed\n");
    } else if (strncmp(query, "SELECT", 6) == 0) {
        printf("Select query executed\n");
    } else {
        printf("Unsupported query\n");
    }
}

// Database initialization
void db_init() {
    g_db.tables = NULL;
    g_db.table_count = 0;
    g_db.capacity = 0;
    printf("Database initialized\n");
}

// Database cleanup
void db_cleanup() {
    for (size_t i = 0; i < g_db.table_count; i++) {
        table_t *table = &g_db.tables[i];
        free(table->columns);
        free(table->data);
    }
    free(g_db.tables);
    g_db.tables = NULL;
    g_db.table_count = 0;
    g_db.capacity = 0;
    printf("Database cleaned up\n");
}

// Main function for database engine
int main_database_engine() {
    db_init();
    
    printf("Custom Database Engine\n");
    printf("Enter SQL-like commands (type 'quit' to exit):\n");
    
    char query[256];
    while (1) {
        printf("> ");
        if (!fgets(query, sizeof(query), stdin)) break;
        
        // Remove newline
        query[strcspn(query, "\n")] = 0;
        
        if (strcmp(query, "quit") == 0) break;
        
        db_execute_query(query);
    }
    
    db_cleanup();
    return 0;
}
```

### 3. Network File Transfer System

Create a secure file transfer system with client-server architecture:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <pthread.h>

#define PORT 8080
#define BUFFER_SIZE 4096
#define MAX_FILENAME 256

// Protocol commands
#define CMD_UPLOAD 1
#define CMD_DOWNLOAD 2
#define CMD_LIST 3
#define CMD_QUIT 4

// Protocol packet structure
typedef struct {
    uint32_t command;
    uint32_t data_length;
    char filename[MAX_FILENAME];
} __attribute__((packed)) protocol_header_t;

// Thread arguments for client handling
typedef struct {
    int client_socket;
    struct sockaddr_in client_addr;
} client_args_t;

// Function to send a file to client
int send_file(int client_socket, const char *filename) {
    int file_fd = open(filename, O_RDONLY);
    if (file_fd < 0) {
        perror("Failed to open file");
        return -1;
    }
    
    // Get file size
    struct stat st;
    if (fstat(file_fd, &st) < 0) {
        perror("Failed to get file stats");
        close(file_fd);
        return -1;
    }
    
    // Send file size to client
    uint32_t file_size = htonl(st.st_size);
    if (send(client_socket, &file_size, sizeof(file_size), 0) < 0) {
        perror("Failed to send file size");
        close(file_fd);
        return -1;
    }
    
    // Send file data
    char buffer[BUFFER_SIZE];
    ssize_t bytes_read;
    while ((bytes_read = read(file_fd, buffer, BUFFER_SIZE)) > 0) {
        if (send(client_socket, buffer, bytes_read, 0) < 0) {
            perror("Failed to send file data");
            close(file_fd);
            return -1;
        }
    }
    
    close(file_fd);
    return 0;
}

// Function to receive a file from client
int receive_file(int client_socket, const char *filename) {
    // Receive file size
    uint32_t file_size;
    if (recv(client_socket, &file_size, sizeof(file_size), 0) < 0) {
        perror("Failed to receive file size");
        return -1;
    }
    
    file_size = ntohl(file_size);
    
    // Create file
    int file_fd = open(filename, O_CREAT | O_WRONLY | O_TRUNC, 0644);
    if (file_fd < 0) {
        perror("Failed to create file");
        return -1;
    }
    
    // Receive file data
    char buffer[BUFFER_SIZE];
    size_t total_received = 0;
    
    while (total_received < file_size) {
        size_t to_receive = (file_size - total_received < BUFFER_SIZE) ? 
                           (file_size - total_received) : BUFFER_SIZE;
        
        ssize_t bytes_received = recv(client_socket, buffer, to_receive, 0);
        if (bytes_received < 0) {
            perror("Failed to receive file data");
            close(file_fd);
            return -1;
        }
        
        if (write(file_fd, buffer, bytes_received) < 0) {
            perror("Failed to write file data");
            close(file_fd);
            return -1;
        }
        
        total_received += bytes_received;
    }
    
    close(file_fd);
    return 0;
}

// Function to list files in directory
void list_files(int client_socket) {
    FILE *fp = popen("ls -1", "r");
    if (!fp) {
        perror("Failed to execute ls command");
        return;
    }
    
    char buffer[BUFFER_SIZE];
    size_t total_size = 0;
    
    // First pass: calculate total size
    while (fgets(buffer, sizeof(buffer), fp)) {
        total_size += strlen(buffer);
    }
    
    // Send total size
    uint32_t size = htonl(total_size);
    send(client_socket, &size, sizeof(size), 0);
    
    // Second pass: send file list
    rewind(fp);
    while (fgets(buffer, sizeof(buffer), fp)) {
        send(client_socket, buffer, strlen(buffer), 0);
    }
    
    pclose(fp);
}

// Client handling thread
void* handle_client(void* arg) {
    client_args_t *client_args = (client_args_t*)arg;
    int client_socket = client_args->client_socket;
    
    printf("Client connected: %s:%d\n", 
           inet_ntoa(client_args->client_addr.sin_addr),
           ntohs(client_args->client_addr.sin_port));
    
    free(client_args);
    
    // Handle client requests
    while (1) {
        protocol_header_t header;
        ssize_t bytes_received = recv(client_socket, &header, sizeof(header), 0);
        
        if (bytes_received <= 0) {
            break;  // Client disconnected or error
        }
        
        header.command = ntohl(header.command);
        header.data_length = ntohl(header.data_length);
        
        switch (header.command) {
            case CMD_UPLOAD:
                printf("Upload request for file: %s\n", header.filename);
                if (receive_file(client_socket, header.filename) == 0) {
                    printf("File uploaded successfully: %s\n", header.filename);
                } else {
                    printf("Failed to upload file: %s\n", header.filename);
                }
                break;
                
            case CMD_DOWNLOAD:
                printf("Download request for file: %s\n", header.filename);
                if (send_file(client_socket, header.filename) == 0) {
                    printf("File sent successfully: %s\n", header.filename);
                } else {
                    printf("Failed to send file: %s\n", header.filename);
                }
                break;
                
            case CMD_LIST:
                printf("File list request\n");
                list_files(client_socket);
                break;
                
            case CMD_QUIT:
                printf("Client requested to quit\n");
                goto cleanup;
                
            default:
                printf("Unknown command: %u\n", header.command);
                break;
        }
    }
    
cleanup:
    close(client_socket);
    printf("Client disconnected\n");
    return NULL;
}

// Server main function
int main_file_transfer_server() {
    int server_fd;
    struct sockaddr_in address;
    int opt = 1;
    
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
    if (listen(server_fd, 3) < 0) {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }
    
    printf("File transfer server listening on port %d\n", PORT);
    
    // Accept connections
    while (1) {
        int client_socket;
        struct sockaddr_in client_addr;
        socklen_t client_addr_len = sizeof(client_addr);
        
        if ((client_socket = accept(server_fd, (struct sockaddr *)&client_addr,
                                   &client_addr_len)) < 0) {
            perror("accept failed");
            continue;
        }
        
        // Create thread to handle client
        client_args_t *client_args = malloc(sizeof(client_args_t));
        client_args->client_socket = client_socket;
        client_args->client_addr = client_addr;
        
        pthread_t client_thread;
        if (pthread_create(&client_thread, NULL, handle_client, client_args) != 0) {
            perror("Failed to create client thread");
            free(client_args);
            close(client_socket);
        } else {
            pthread_detach(client_thread);  // Automatically clean up thread
        }
    }
    
    close(server_fd);
    return 0;
}

// Client main function
int main_file_transfer_client(const char *server_ip) {
    int client_fd;
    struct sockaddr_in serv_addr;
    
    // Create socket
    if ((client_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Socket creation error");
        return -1;
    }
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    
    // Convert IPv4 address from text to binary
    if (inet_pton(AF_INET, server_ip, &serv_addr.sin_addr) <= 0) {
        printf("Invalid address/ Address not supported\n");
        return -1;
    }
    
    // Connect to server
    if (connect(client_fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Connection Failed");
        return -1;
    }
    
    printf("Connected to server %s:%d\n", server_ip, PORT);
    
    // Simple client interface
    char command[10];
    while (1) {
        printf("\nCommands: [u]pload, [d]ownload, [l]ist, [q]uit: ");
        if (fgets(command, sizeof(command), stdin)) {
            if (command[0] == 'u' || command[0] == 'U') {
                char filename[MAX_FILENAME];
                printf("Enter filename to upload: ");
                if (fgets(filename, sizeof(filename), stdin)) {
                    filename[strcspn(filename, "\n")] = 0;  // Remove newline
                    
                    protocol_header_t header = {0};
                    header.command = htonl(CMD_UPLOAD);
                    strncpy(header.filename, filename, sizeof(header.filename) - 1);
                    
                    send(client_fd, &header, sizeof(header), 0);
                    if (receive_file(client_fd, filename) == 0) {
                        printf("File uploaded successfully\n");
                    } else {
                        printf("Failed to upload file\n");
                    }
                }
            } else if (command[0] == 'd' || command[0] == 'D') {
                char filename[MAX_FILENAME];
                printf("Enter filename to download: ");
                if (fgets(filename, sizeof(filename), stdin)) {
                    filename[strcspn(filename, "\n")] = 0;  // Remove newline
                    
                    protocol_header_t header = {0};
                    header.command = htonl(CMD_DOWNLOAD);
                    strncpy(header.filename, filename, sizeof(header.filename) - 1);
                    
                    send(client_fd, &header, sizeof(header), 0);
                    if (send_file(client_fd, filename) == 0) {
                        printf("File downloaded successfully\n");
                    } else {
                        printf("Failed to download file\n");
                    }
                }
            } else if (command[0] == 'l' || command[0] == 'L') {
                protocol_header_t header = {0};
                header.command = htonl(CMD_LIST);
                send(client_fd, &header, sizeof(header), 0);
                
                // Receive file list
                uint32_t list_size;
                recv(client_fd, &list_size, sizeof(list_size), 0);
                list_size = ntohl(list_size);
                
                char *list_buffer = malloc(list_size + 1);
                if (list_buffer) {
                    recv(client_fd, list_buffer, list_size, 0);
                    list_buffer[list_size] = '\0';
                    printf("Files on server:\n%s", list_buffer);
                    free(list_buffer);
                }
            } else if (command[0] == 'q' || command[0] == 'Q') {
                protocol_header_t header = {0};
                header.command = htonl(CMD_QUIT);
                send(client_fd, &header, sizeof(header), 0);
                break;
            }
        }
    }
    
    close(client_fd);
    return 0;
}
```

## Project Development Process

### 1. Planning Phase

1. **Project Selection**: Choose a project that interests you and matches your skill level
2. **Requirements Analysis**: Define clear, measurable requirements
3. **Design Documentation**: Create architecture and design documents
4. **Technology Selection**: Choose appropriate libraries, tools, and frameworks
5. **Timeline Planning**: Create a realistic development timeline

### 2. Implementation Phase

1. **Environment Setup**: Configure development environment and tools
2. **Version Control**: Initialize Git repository and establish branching strategy
3. **Modular Development**: Implement features incrementally
4. **Testing**: Write and execute tests for each module
5. **Documentation**: Maintain documentation throughout development

### 3. Testing and Debugging Phase

1. **Unit Testing**: Test individual functions and modules
2. **Integration Testing**: Test module interactions
3. **System Testing**: Test complete system functionality
4. **Performance Testing**: Validate performance requirements
5. **Debugging**: Identify and fix issues

### 4. Deployment and Presentation Phase

1. **Final Testing**: Conduct comprehensive testing
2. **Documentation Finalization**: Complete all documentation
3. **Packaging**: Package application for distribution
4. **Presentation Preparation**: Prepare presentation materials
5. **Project Submission**: Submit all deliverables

## Evaluation Criteria

Your capstone project will be evaluated based on:

### Technical Excellence (40%)
- Code quality and organization
- Proper use of C programming concepts
- Error handling and robustness
- Performance optimization
- Security considerations

### Design and Architecture (25%)
- System design quality
- Modularity and maintainability
- Appropriate use of data structures and algorithms
- Scalability considerations

### Documentation (20%)
- Code comments and readability
- User documentation
- Technical documentation
- API documentation

### Testing (10%)
- Test coverage
- Test quality
- Bug identification and resolution

### Presentation (5%)
- Clarity of presentation
- Technical depth
- Professionalism

## Best Practices

### 1. Code Quality
- Follow consistent coding standards
- Use meaningful variable and function names
- Write modular, reusable code
- Include comprehensive error handling
- Document complex algorithms and decisions

### 2. Project Management
- Use version control effectively
- Break project into manageable milestones
- Track progress and adjust plans as needed
- Seek feedback regularly
- Maintain regular backups

### 3. Collaboration
- If working in a team, establish clear roles
- Use collaborative tools effectively
- Communicate regularly with team members
- Review each other's code
- Resolve conflicts constructively

## Resources and Support

### Tools and Libraries
- **Development Environment**: GCC, Clang, or preferred C compiler
- **Debugging**: GDB, Valgrind
- **Version Control**: Git
- **Documentation**: Doxygen for API documentation
- **Testing**: CUnit, Unity, or custom testing framework

### Learning Resources
- **Books**: "The C Programming Language" by Kernighan and Ritchie
- **Online**: C standard documentation, man pages
- **Communities**: Stack Overflow, C programming forums
- **Tutorials**: System programming tutorials, networking guides

## Conclusion

The capstone project is your opportunity to demonstrate mastery of C programming and apply it to solve real-world problems. Choose a project that challenges you but is achievable within the timeframe. Focus on writing clean, well-documented code and following professional software development practices.

Remember that the goal is not just to complete a project, but to learn and grow as a developer. Take the time to understand the concepts you're implementing, and don't hesitate to explore beyond the basic requirements. Good luck with your capstone project!