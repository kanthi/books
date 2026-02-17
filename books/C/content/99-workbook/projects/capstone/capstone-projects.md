# Capstone Projects

These capstone projects are designed to integrate all the skills and knowledge you've gained throughout the C programming course. They represent substantial, real-world applications that demonstrate mastery of advanced C programming concepts.

## Project 1: Distributed Chat Application

### Description
Create a distributed chat application with multiple servers, clients, and advanced features like encryption, file sharing, and user authentication.

### Learning Objectives
- Network programming with TCP/IP and UDP
- Multithreading and concurrency
- Cryptography and security
- Distributed systems concepts
- Protocol design and implementation
- Database integration
- User interface design

### Requirements
1. **Server Components**:
   - Multiple chat servers with load balancing
   - User authentication and session management
   - Message routing between servers
   - Persistent message storage
   - Administration interface

2. **Client Features**:
   - User registration and login
   - Real-time messaging with multiple users
   - Private messaging
   - Group chats
   - File sharing capability
   - Message history
   - Presence indication (online/offline)
   - Emoticons and rich text support

3. **Advanced Features**:
   - End-to-end encryption
   - Message queuing for offline users
   - Voice messaging (optional)
   - Video calling (optional)
   - Plugin architecture for extensions
   - Mobile client compatibility

### Implementation Steps
1. Design system architecture and communication protocols
2. Implement core server infrastructure
3. Create client application with user interface
4. Add authentication and security features
5. Implement message routing and storage
6. Add advanced features like file sharing
7. Create administration tools
8. Test with multiple users and servers
9. Optimize for performance and scalability

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
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <sqlite3.h>

#define MAX_CLIENTS 1000
#define MAX_MESSAGE_LENGTH 1024
#define SERVER_PORT 8080
#define DATABASE_FILE "chat.db"

// Message types
typedef enum {
    MSG_TEXT,
    MSG_FILE,
    MSG_JOIN,
    MSG_LEAVE,
    MSG_AUTH,
    MSG_ERROR
} message_type_t;

// User structure
typedef struct {
    int id;
    char username[50];
    char password_hash[64];
    int socket_fd;
    SSL *ssl;
    int authenticated;
    time_t last_activity;
} user_t;

// Message structure
typedef struct {
    message_type_t type;
    int sender_id;
    int receiver_id;  // 0 for broadcast
    char content[MAX_MESSAGE_LENGTH];
    time_t timestamp;
    int encrypted;
} message_t;

// Server structure
typedef struct {
    int server_fd;
    SSL_CTX *ssl_ctx;
    sqlite3 *db;
    user_t clients[MAX_CLIENTS];
    int client_count;
    pthread_mutex_t clients_mutex;
    pthread_t worker_threads[10];
    int thread_count;
    int running;
} chat_server_t;

// Client structure
typedef struct {
    int socket_fd;
    SSL *ssl;
    char username[50];
    int authenticated;
    pthread_t receive_thread;
    pthread_t send_thread;
    int connected;
} chat_client_t;

// Function prototypes
chat_server_t* create_chat_server(int port);
void destroy_chat_server(chat_server_t *server);
int start_server(chat_server_t *server);
void stop_server(chat_server_t *server);
void* client_handler(void *arg);
int authenticate_user(chat_server_t *server, const char *username, const char *password);
int register_user(chat_server_t *server, const char *username, const char *password);
int send_message(chat_server_t *server, message_t *msg);
int broadcast_message(chat_server_t *server, message_t *msg);
int store_message(chat_server_t *server, message_t *msg);
message_t* retrieve_message_history(chat_server_t *server, int user_id, int limit);
int init_database(chat_server_t *server);
SSL_CTX* create_ssl_context();
int create_user_table(chat_server_t *server);
void* server_worker_thread(void *arg);
void log_message(const char *format, ...);

// Client functions
chat_client_t* create_chat_client(const char *server_ip, int port);
void destroy_chat_client(chat_client_t *client);
int connect_to_server(chat_client_t *client);
void disconnect_from_server(chat_client_t *client);
int login(chat_client_t *client, const char *username, const char *password);
int send_chat_message(chat_client_t *client, const char *message, int receiver_id);
void* receive_messages(void *arg);
void* send_messages(void *arg);

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s [server|client]\n", argv[0]);
        return 1;
    }
    
    if (strcmp(argv[1], "server") == 0) {
        chat_server_t *server = create_chat_server(SERVER_PORT);
        if (!server) {
            fprintf(stderr, "Failed to create server\n");
            return 1;
        }
        
        if (start_server(server) != 0) {
            fprintf(stderr, "Failed to start server\n");
            destroy_chat_server(server);
            return 1;
        }
        
        printf("Chat server started on port %d\n", SERVER_PORT);
        
        // Keep server running
        while (1) {
            sleep(1);
        }
        
        stop_server(server);
        destroy_chat_server(server);
    } else if (strcmp(argv[1], "client") == 0) {
        chat_client_t *client = create_chat_client("127.0.0.1", SERVER_PORT);
        if (!client) {
            fprintf(stderr, "Failed to create client\n");
            return 1;
        }
        
        if (connect_to_server(client) != 0) {
            fprintf(stderr, "Failed to connect to server\n");
            destroy_chat_client(client);
            return 1;
        }
        
        // Login process
        char username[50], password[50];
        printf("Enter username: ");
        scanf("%s", username);
        printf("Enter password: ");
        scanf("%s", password);
        
        if (login(client, username, password) != 0) {
            fprintf(stderr, "Login failed\n");
            disconnect_from_server(client);
            destroy_chat_client(client);
            return 1;
        }
        
        printf("Login successful! Starting chat...\n");
        
        // Start message threads
        pthread_create(&client->receive_thread, NULL, receive_messages, client);
        pthread_create(&client->send_thread, NULL, send_messages, client);
        
        // Wait for threads
        pthread_join(client->receive_thread, NULL);
        pthread_join(client->send_thread, NULL);
        
        disconnect_from_server(client);
        destroy_chat_client(client);
    } else {
        fprintf(stderr, "Invalid mode. Use 'server' or 'client'\n");
        return 1;
    }
    
    return 0;
}

// Implement all functions here
```

### Key Challenges
1. **Concurrency**: Managing multiple clients and threads safely
2. **Security**: Implementing robust encryption and authentication
3. **Scalability**: Designing for thousands of concurrent users
4. **Reliability**: Ensuring message delivery and system stability
5. **Performance**: Optimizing database queries and network operations
6. **Protocol Design**: Creating efficient communication protocols

### Evaluation Criteria
- **Functionality**: All required features implemented correctly
- **Security**: Proper encryption and authentication mechanisms
- **Performance**: Efficient handling of multiple connections
- **Robustness**: Error handling and recovery mechanisms
- **Code Quality**: Clean, well-documented, maintainable code
- **Testing**: Comprehensive test suite with edge cases
- **Documentation**: Clear user and developer documentation

## Project 2: Operating System Kernel

### Description
Implement a basic operating system kernel that can boot, manage processes, handle interrupts, and provide system calls.

### Learning Objectives
- Low-level system programming
- Memory management
- Process scheduling
- Interrupt handling
- Device drivers
- File system implementation
- Boot process understanding

### Requirements
1. **Boot Process**:
   - Custom bootloader
   - Kernel loading and initialization
   - Basic hardware detection

2. **Memory Management**:
   - Physical memory management
   - Virtual memory with paging
   - Heap allocation
   - Memory protection

3. **Process Management**:
   - Process creation and termination
   - Process scheduling (round-robin, priority-based)
   - Inter-process communication
   - Process synchronization

4. **Interrupt Handling**:
   - Interrupt descriptor table (IDT)
   - Exception handling
   - Hardware interrupt processing
   - System call interface

5. **Device Drivers**:
   - Keyboard driver
   - Display driver (VGA text mode)
   - Timer driver
   - Storage driver (optional)

6. **File System**:
   - Simple file system implementation
   - File operations (create, read, write, delete)
   - Directory management

### Implementation Steps
1. Set up development environment with cross-compiler
2. Implement bootloader and kernel entry point
3. Set up GDT, IDT, and basic interrupt handling
4. Implement memory management system
5. Create process management and scheduling
6. Add device drivers for basic I/O
7. Implement file system
8. Create system call interface
9. Develop user-space programs
10. Test and debug the complete system

### Sample Code Structure
```c
// kernel.h
#ifndef KERNEL_H
#define KERNEL_H

#include <stdint.h>
#include <stddef.h>

// Basic types
typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

// Kernel entry point
void kernel_main();

// Hardware abstraction
void outb(u16 port, u8 val);
u8 inb(u16 port);
void outw(u16 port, u16 val);
u16 inw(u16 port);

#endif

// gdt.h
#ifndef GDT_H
#define GDT_H

#include "kernel.h"

typedef struct {
    u16 limit_low;
    u16 base_low;
    u8 base_middle;
    u8 access;
    u8 granularity;
    u8 base_high;
} __attribute__((packed)) gdt_entry_t;

typedef struct {
    u16 limit;
    u32 base;
} __attribute__((packed)) gdt_ptr_t;

void init_gdt();
void gdt_set_gate(int num, u32 base, u32 limit, u8 access, u8 gran);

#endif

// idt.h
#ifndef IDT_H
#define IDT_H

#include "kernel.h"

typedef struct {
    u16 base_low;
    u16 sel;
    u8 always0;
    u8 flags;
    u16 base_high;
} __attribute__((packed)) idt_entry_t;

typedef struct {
    u16 limit;
    u32 base;
} __attribute__((packed)) idt_ptr_t;

void init_idt();
void idt_set_gate(u8 num, u32 base, u16 sel, u8 flags);

#endif

// memory.h
#ifndef MEMORY_H
#define MEMORY_H

#include "kernel.h"

#define PAGE_SIZE 4096

typedef struct {
    u32 present    : 1;
    u32 rw         : 1;
    u32 user       : 1;
    u32 writethru  : 1;
    u32 cached     : 1;
    u32 accessed   : 1;
    u32 dirty      : 1;
    u32 pat        : 1;
    u32 global     : 1;
    u32 available  : 3;
    u32 frame      : 20;
} __attribute__((packed)) page_t;

typedef struct {
    page_t pages[1024];
} __attribute__((packed)) page_table_t;

typedef struct {
    page_table_t *tables[1024];
    u32 tables_physical[1024];
    u32 physical_address;
} __attribute__((packed)) page_directory_t;

void init_paging();
void switch_page_directory(page_directory_t *dir);
page_t *get_page(u32 address, int make, page_directory_t *dir);
void alloc_frame(page_t *page, int is_kernel, int is_writeable);
void free_frame(page_t *page);

#endif

// process.h
#ifndef PROCESS_H
#define PROCESS_H

#include "kernel.h"
#include "memory.h"

#define MAX_PROCESSES 256
#define KERNEL_STACK_SIZE 4096

typedef enum {
    PROCESS_RUNNING,
    PROCESS_READY,
    PROCESS_BLOCKED,
    PROCESS_TERMINATED
} process_state_t;

typedef struct {
    u32 esp, ebp, esi, edi, eax, ebx, ecx, edx;
    u32 eip, eflags;
    u32 cr3;  // Page directory
    u32 kernel_stack;
    process_state_t state;
    u32 pid;
    char name[32];
} __attribute__((packed)) process_t;

typedef struct {
    process_t *processes[MAX_PROCESSES];
    u32 current_process;
    u32 process_count;
} process_manager_t;

void init_process_manager();
process_t *create_process(const char *name, u32 entry_point);
void switch_to_process(process_t *process);
void schedule();
void yield();

#endif

// syscall.h
#ifndef SYSCALL_H
#define SYSCALL_H

#include "kernel.h"

#define SYSCALL_WRITE 1
#define SYSCALL_READ  2
#define SYSCALL_EXIT  3
#define SYSCALL_FORK  4

void init_syscalls();
void syscall_handler(registers_t *regs);

#endif

// main kernel implementation
void kernel_main() {
    // Initialize hardware
    init_gdt();
    init_idt();
    
    // Initialize memory management
    init_paging();
    
    // Initialize process management
    init_process_manager();
    
    // Initialize system calls
    init_syscalls();
    
    // Create initial processes
    process_t *init = create_process("init", (u32)init_process);
    switch_to_process(init);
    
    // Start scheduler
    while (1) {
        schedule();
        __asm__ __volatile__("hlt");
    }
}

// Implement all other components here
```

### Key Challenges
1. **Low-level Programming**: Working directly with hardware
2. **Memory Management**: Implementing virtual memory and paging
3. **Concurrency**: Managing processes and threads safely
4. **Interrupt Handling**: Properly handling hardware interrupts
5. **Boot Process**: Understanding and implementing the boot sequence
6. **Debugging**: Debugging at the kernel level

### Evaluation Criteria
- **Boot Process**: Successful kernel loading and initialization
- **Memory Management**: Correct implementation of paging and allocation
- **Process Management**: Functional process creation and scheduling
- **Interrupt Handling**: Proper exception and interrupt processing
- **System Calls**: Working system call interface
- **Stability**: Kernel stability under various conditions
- **Documentation**: Clear explanation of kernel components

## Project 3: Database Management System

### Description
Create a full-featured relational database management system with SQL support, transactions, indexing, and optimization.

### Learning Objectives
- Data storage and retrieval
- Query processing and optimization
- Transaction management
- Concurrency control
- Indexing and search algorithms
- File system integration
- SQL parser and executor

### Requirements
1. **Storage Engine**:
   - Page-based storage system
   - Buffer pool management
   - Transaction log for recovery
   - Checkpointing mechanism

2. **SQL Support**:
   - DDL (CREATE, ALTER, DROP)
   - DML (SELECT, INSERT, UPDATE, DELETE)
   - Query optimization
   - Aggregation functions
   - Joins (INNER, LEFT, RIGHT, FULL)

3. **Transaction Management**:
   - ACID properties
   - Lock-based concurrency control
   - Deadlock detection and resolution
   - Transaction isolation levels

4. **Indexing**:
   - B+ tree implementation
   - Hash index support
   - Composite index support
   - Index maintenance

5. **Administration**:
   - Database creation and management
   - User authentication and permissions
   - Backup and recovery
   - Performance monitoring

### Implementation Steps
1. Design database architecture and storage format
2. Implement storage engine with page management
3. Create buffer pool and cache system
4. Develop SQL parser and query planner
5. Implement B+ tree and other index structures
6. Add transaction management and concurrency control
7. Create administration tools and utilities
8. Test with standard SQL benchmarks
9. Optimize for performance
10. Document the system architecture

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

#define PAGE_SIZE 4096
#define MAX_DATABASES 100
#define MAX_TABLES 1000
#define MAX_COLUMNS 50
#define MAX_INDEXES 100

// Data types
typedef enum {
    TYPE_INT,
    TYPE_BIGINT,
    TYPE_FLOAT,
    TYPE_DOUBLE,
    TYPE_VARCHAR,
    TYPE_TEXT,
    TYPE_DATE,
    TYPE_DATETIME
} data_type_t;

// Page structure
typedef struct {
    u32 page_id;
    u32 next_page;
    u32 prev_page;
    u16 free_space;
    u8 page_type;
    u8 data[PAGE_SIZE - sizeof(u32) * 3 - sizeof(u16) - sizeof(u8)];
} __attribute__((packed)) page_t;

// Table structure
typedef struct {
    u32 table_id;
    char name[64];
    u32 page_id;  // First page of table data
    u32 row_count;
    u32 column_count;
    struct {
        char name[32];
        data_type_t type;
        u16 size;
        u8 nullable;
    } columns[MAX_COLUMNS];
} table_t;

// Index structure
typedef struct {
    u32 index_id;
    char name[64];
    u32 table_id;
    u32 column_count;
    u32 columns[MAX_COLUMNS];
    u8 index_type;  // 0 = B+ tree, 1 = Hash
    u32 root_page;
} index_t;

// Transaction structure
typedef enum {
    TXN_ACTIVE,
    TXN_COMMITTED,
    TXN_ABORTED
} txn_state_t;

typedef struct {
    u32 txn_id;
    txn_state_t state;
    u64 start_time;
    u64 commit_time;
    pthread_mutex_t lock;
    // Undo/redo logs
    struct log_entry *undo_log;
    struct log_entry *redo_log;
} transaction_t;

// Database structure
typedef struct {
    char name[64];
    int fd;  // File descriptor
    u32 page_count;
    table_t tables[MAX_TABLES];
    u32 table_count;
    index_t indexes[MAX_INDEXES];
    u32 index_count;
    pthread_mutex_t lock;
    pthread_rwlock_t rw_lock;
} database_t;

// Buffer pool
typedef struct {
    page_t *pages;
    u32 *page_ids;
    u8 *dirty_flags;
    u64 *access_times;
    u32 capacity;
    u32 count;
    pthread_mutex_t lock;
} buffer_pool_t;

// SQL Parser structures
typedef enum {
    SQL_SELECT,
    SQL_INSERT,
    SQL_UPDATE,
    SQL_DELETE,
    SQL_CREATE_TABLE,
    SQL_DROP_TABLE,
    SQL_CREATE_INDEX,
    SQL_BEGIN_TRANSACTION,
    SQL_COMMIT,
    SQL_ROLLBACK
} sql_statement_type_t;

typedef struct {
    sql_statement_type_t type;
    char *table_name;
    struct {
        char *column_name;
        char *value;
    } *columns;
    u32 column_count;
    char *where_clause;
    char **order_by;
    u32 order_by_count;
    u32 limit;
} sql_statement_t;

// Query plan
typedef enum {
    PLAN_SCAN,
    PLAN_INDEX_SCAN,
    PLAN_JOIN,
    PLAN_SORT,
    PLAN_AGGREGATE
} plan_node_type_t;

typedef struct plan_node {
    plan_node_type_t type;
    struct plan_node *left;
    struct plan_node *right;
    void *data;  // Node-specific data
} plan_node_t;

// Database manager
typedef struct {
    database_t databases[MAX_DATABASES];
    u32 database_count;
    buffer_pool_t buffer_pool;
    transaction_t *active_transactions;
    u32 transaction_count;
    pthread_mutex_t txn_lock;
} db_manager_t;

// Function prototypes
db_manager_t* create_db_manager(u32 buffer_pool_size);
void destroy_db_manager(db_manager_t *manager);
database_t* create_database(db_manager_t *manager, const char *name);
int drop_database(db_manager_t *manager, const char *name);
table_t* create_table(database_t *db, const char *name, /* column definitions */);
int drop_table(database_t *db, const char *name);
index_t* create_index(database_t *db, const char *name, const char *table_name, /* column list */);
int drop_index(database_t *db, const char *name);
transaction_t* begin_transaction(db_manager_t *manager);
int commit_transaction(db_manager_t *manager, transaction_t *txn);
int rollback_transaction(db_manager_t *manager, transaction_t *txn);
sql_statement_t* parse_sql(const char *sql);
plan_node_t* create_query_plan(sql_statement_t *stmt, database_t *db);
int execute_query_plan(plan_node_t *plan, transaction_t *txn, /* result set */);
page_t* get_page(database_t *db, u32 page_id);
int write_page(database_t *db, page_t *page);
void* btree_insert(index_t *index, void *key, u32 page_id);
void* btree_search(index_t *index, void *key);
int btree_delete(index_t *index, void *key);
void lock_table(database_t *db, table_t *table, int exclusive);
void unlock_table(database_t *db, table_t *table);
void lock_row(database_t *db, table_t *table, u32 row_id, int exclusive);
void unlock_row(database_t *db, table_t *table, u32 row_id);

int main() {
    // Create database manager
    db_manager_t *manager = create_db_manager(1000);  // 1000 page buffer pool
    if (!manager) {
        fprintf(stderr, "Failed to create database manager\n");
        return 1;
    }
    
    // Create database
    database_t *db = create_database(manager, "testdb");
    if (!db) {
        fprintf(stderr, "Failed to create database\n");
        destroy_db_manager(manager);
        return 1;
    }
    
    // Example SQL execution
    const char *sql = "CREATE TABLE users (id INT PRIMARY KEY, name VARCHAR(50), email VARCHAR(100))";
    sql_statement_t *stmt = parse_sql(sql);
    if (stmt) {
        plan_node_t *plan = create_query_plan(stmt, db);
        if (plan) {
            transaction_t *txn = begin_transaction(manager);
            execute_query_plan(plan, txn, NULL);
            commit_transaction(manager, txn);
            // Free plan
        }
        // Free statement
    }
    
    // Cleanup
    destroy_db_manager(manager);
    return 0;
}

// Implement all functions here
```

### Key Challenges
1. **Data Consistency**: Ensuring ACID properties in transactions
2. **Concurrency Control**: Managing concurrent access to data
3. **Query Optimization**: Creating efficient execution plans
4. **Storage Management**: Efficiently managing disk and memory resources
5. **Index Implementation**: Implementing complex data structures like B+ trees
6. **SQL Parsing**: Creating a robust SQL parser

### Evaluation Criteria
- **SQL Compliance**: Support for standard SQL features
- **Performance**: Efficient query execution and optimization
- **Reliability**: Transaction safety and recovery mechanisms
- **Scalability**: Ability to handle large datasets
- **Concurrency**: Proper handling of concurrent operations
- **Code Quality**: Well-structured, maintainable code
- **Documentation**: Comprehensive system documentation

## Project 4: Game Engine

### Description
Create a 2D game engine with rendering, physics, audio, input handling, and scripting capabilities.

### Learning Objectives
- Graphics programming with OpenGL/DirectX
- Physics simulation
- Audio processing
- Input handling
- Entity-component system
- Resource management
- Cross-platform development

### Requirements
1. **Graphics System**:
   - 2D rendering pipeline
   - Sprite management
   - Animation system
   - Particle effects
   - Camera system

2. **Physics Engine**:
   - Collision detection (AABB, circle, polygon)
   - Collision response
   - Rigidbody physics
   - Constraints and joints

3. **Audio System**:
   - Sound loading and playback
   - Music streaming
   - 3D audio positioning
   - Audio effects

4. **Input Handling**:
   - Keyboard, mouse, gamepad support
   - Input mapping system
   - Gesture recognition

5. **Game Object System**:
   - Entity-component architecture
   - Scene management
   - Serialization system
   - Scripting interface

6. **Resource Management**:
   - Asset loading and caching
   - Texture compression
   - Memory pooling
   - Async loading

### Implementation Steps
1. Set up graphics rendering framework
2. Implement entity-component system
3. Create physics simulation engine
4. Add audio processing capabilities
5. Develop input handling system
6. Build resource management system
7. Create scripting interface
8. Develop tools and editor
9. Test with sample games
10. Optimize for performance

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <pthread.h>
#ifdef _WIN32
    #include <windows.h>
    #include <GL/gl.h>
#else
    #include <GL/gl.h>
    #include <unistd.h>
#endif

#define MAX_ENTITIES 10000
#define MAX_COMPONENTS 32
#define MAX_SYSTEMS 64

// Math structures
typedef struct {
    float x, y;
} vec2_t;

typedef struct {
    float x, y, z;
} vec3_t;

typedef struct {
    float x, y, z, w;
} vec4_t;

typedef struct {
    float m[16];  // 4x4 matrix
} mat4_t;

// Component types
typedef enum {
    COMPONENT_TRANSFORM,
    COMPONENT_SPRITE,
    COMPONENT_RIGIDBODY,
    COMPONENT_COLLIDER,
    COMPONENT_SCRIPT,
    COMPONENT_CAMERA,
    COMPONENT_AUDIO_SOURCE,
    COMPONENT_PARTICLE_SYSTEM
} component_type_t;

// Transform component
typedef struct {
    vec3_t position;
    vec3_t rotation;
    vec3_t scale;
    mat4_t world_matrix;
} transform_component_t;

// Sprite component
typedef struct {
    u32 texture_id;
    vec2_t size;
    vec4_t color;
    int visible;
} sprite_component_t;

// Rigidbody component
typedef struct {
    vec2_t velocity;
    vec2_t acceleration;
    float mass;
    float drag;
    int use_gravity;
} rigidbody_component_t;

// Collider component
typedef enum {
    COLLIDER_AABB,
    COLLIDER_CIRCLE,
    COLLIDER_POLYGON
} collider_type_t;

typedef struct {
    collider_type_t type;
    union {
        struct { vec2_t min, max; } aabb;
        struct { vec2_t center; float radius; } circle;
        struct { vec2_t *vertices; int vertex_count; } polygon;
    } shape;
    int is_trigger;
} collider_component_t;

// Entity structure
typedef struct {
    u32 id;
    u64 component_mask;  // Bitmask of components
    char name[64];
    int active;
} entity_t;

// Component arrays (structure of arrays for cache efficiency)
typedef struct {
    transform_component_t transforms[MAX_ENTITIES];
    sprite_component_t sprites[MAX_ENTITIES];
    rigidbody_component_t rigidbodies[MAX_ENTITIES];
    collider_component_t colliders[MAX_ENTITIES];
    // ... other component arrays
} component_arrays_t;

// System base structure
typedef struct {
    char name[32];
    void (*update)(float delta_time);
    void (*render)();
    int enabled;
} system_t;

// Renderer system
typedef struct {
    system_t base;
    u32 shader_program;
    u32 vao, vbo;
    mat4_t projection_matrix;
    mat4_t view_matrix;
} renderer_system_t;

// Physics system
typedef struct {
    system_t base;
    vec2_t gravity;
    float time_scale;
} physics_system_t;

// Collision system
typedef struct {
    system_t base;
    struct {
        u32 entity_a, entity_b;
        vec2_t contact_point;
        vec2_t normal;
        float penetration;
    } *contacts;
    u32 contact_count;
    u32 contact_capacity;
} collision_system_t;

// Scene structure
typedef struct {
    entity_t entities[MAX_ENTITIES];
    u32 entity_count;
    component_arrays_t components;
    system_t *systems[MAX_SYSTEMS];
    u32 system_count;
    float time_accumulator;
} scene_t;

// Game engine structure
typedef struct {
    scene_t *current_scene;
    int running;
    float delta_time;
    u64 frame_count;
    struct {
        int width, height;
        const char *title;
        void *window_handle;
    } window;
    struct {
        float master_volume;
        float sfx_volume;
        float music_volume;
    } audio_settings;
} game_engine_t;

// Function prototypes
game_engine_t* create_game_engine(const char *title, int width, int height);
void destroy_game_engine(game_engine_t *engine);
int initialize_engine(game_engine_t *engine);
void run_game_loop(game_engine_t *engine);
void shutdown_engine(game_engine_t *engine);

// Entity management
entity_t* create_entity(scene_t *scene, const char *name);
void destroy_entity(scene_t *scene, u32 entity_id);
int add_component(scene_t *scene, u32 entity_id, component_type_t type);
int remove_component(scene_t *scene, u32 entity_id, component_type_t type);
int has_component(scene_t *scene, u32 entity_id, component_type_t type);
void* get_component(scene_t *scene, u32 entity_id, component_type_t type);

// System management
int register_system(scene_t *scene, system_t *system);
int unregister_system(scene_t *scene, const char *system_name);
system_t* get_system(scene_t *scene, const char *system_name);

// Math functions
vec2_t vec2_add(vec2_t a, vec2_t b);
vec2_t vec2_subtract(vec2_t a, vec2_t b);
vec2_t vec2_multiply(vec2_t v, float scalar);
float vec2_length(vec2_t v);
vec2_t vec2_normalize(vec2_t v);
mat4_t mat4_identity();
mat4_t mat4_orthographic(float left, float right, float bottom, float top, float near, float far);
mat4_t mat4_transform(vec3_t position, vec3_t rotation, vec3_t scale);

// Renderer functions
renderer_system_t* create_renderer_system();
void destroy_renderer_system(renderer_system_t *renderer);
void renderer_update(float delta_time);
void renderer_render();
void renderer_draw_sprite(sprite_component_t *sprite, transform_component_t *transform);

// Physics functions
physics_system_t* create_physics_system();
void destroy_physics_system(physics_system_t *physics);
void physics_update(float delta_time);
void integrate_rigidbody(rigidbody_component_t *rb, transform_component_t *transform, float delta_time);

// Collision functions
collision_system_t* create_collision_system();
void destroy_collision_system(collision_system_t *collision);
void collision_update(float delta_time);
int check_collision_aabb_circle(vec2_t aabb_min, vec2_t aabb_max, vec2_t circle_center, float circle_radius);
int check_collision_circle_circle(vec2_t center1, float radius1, vec2_t center2, float radius2);
void resolve_collision(u32 entity_a, u32 entity_b, vec2_t contact_point, vec2_t normal, float penetration);

// Input functions
int is_key_pressed(int key);
int is_key_released(int key);
int is_key_held(int key);
vec2_t get_mouse_position();
int is_mouse_button_pressed(int button);

// Resource management
u32 load_texture(const char *filename);
void unload_texture(u32 texture_id);
void* load_shader(const char *vertex_shader, const char *fragment_shader);
void unload_shader(u32 shader_program);

int main() {
    // Create game engine
    game_engine_t *engine = create_game_engine("My Game Engine", 1024, 768);
    if (!engine) {
        fprintf(stderr, "Failed to create game engine\n");
        return 1;
    }
    
    // Initialize engine
    if (initialize_engine(engine) != 0) {
        fprintf(stderr, "Failed to initialize engine\n");
        destroy_game_engine(engine);
        return 1;
    }
    
    // Create sample scene
    scene_t *scene = engine->current_scene;
    
    // Create player entity
    entity_t *player = create_entity(scene, "Player");
    add_component(scene, player->id, COMPONENT_TRANSFORM);
    add_component(scene, player->id, COMPONENT_SPRITE);
    add_component(scene, player->id, COMPONENT_RIGIDBODY);
    add_component(scene, player->id, COMPONENT_COLLIDER);
    
    // Configure player components
    transform_component_t *player_transform = get_component(scene, player->id, COMPONENT_TRANSFORM);
    player_transform->position.x = 400;
    player_transform->position.y = 300;
    player_transform->scale.x = player_transform->scale.y = 2.0f;
    
    sprite_component_t *player_sprite = get_component(scene, player->id, COMPONENT_SPRITE);
    player_sprite->texture_id = load_texture("player.png");
    player_sprite->size.x = 32;
    player_sprite->size.y = 32;
    
    // Run game loop
    run_game_loop(engine);
    
    // Cleanup
    shutdown_engine(engine);
    destroy_game_engine(engine);
    
    return 0;
}

// Implement all functions here
```

### Key Challenges
1. **Performance**: Optimizing rendering and physics for real-time performance
2. **Memory Management**: Efficiently managing game assets and entities
3. **Cross-platform**: Supporting multiple operating systems and graphics APIs
4. **Architecture**: Designing a flexible, extensible system
5. **Mathematics**: Implementing complex mathematical operations for graphics and physics
6. **Resource Management**: Loading and managing game assets efficiently

### Evaluation Criteria
- **Functionality**: All required systems implemented and working
- **Performance**: Smooth gameplay with good frame rates
- **Flexibility**: Extensible architecture for adding new features
- **Code Quality**: Well-organized, maintainable code
- **Documentation**: Clear documentation of engine architecture
- **Sample Games**: Demonstrating engine capabilities with sample games
- **Tools**: Development tools for content creation

## Tips for Capstone Success

1. **Choose Wisely**: Select a project that matches your interests and skill level
2. **Plan Extensively**: Create detailed designs and specifications before coding
3. **Iterative Development**: Build and test components incrementally
4. **Focus on Core Features**: Implement essential functionality first
5. **Document Everything**: Maintain comprehensive documentation throughout
6. **Test Thoroughly**: Create extensive test cases including edge cases
7. **Seek Feedback**: Get regular feedback from peers and mentors
8. **Manage Time**: Create realistic timelines and stick to them
9. **Learn Continuously**: Research and learn new techniques as needed
10. **Enjoy the Process**: Take pride in creating something substantial and meaningful

These capstone projects represent the culmination of your C programming education. They require integrating multiple concepts and techniques while solving complex, real-world problems. Choose a project that excites you and demonstrates your mastery of C programming.