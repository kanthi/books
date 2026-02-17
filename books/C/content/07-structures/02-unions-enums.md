# Unions and Enumerations

## Introduction

Unions and enumerations are two important features in C that complement structures by providing additional ways to define and work with data types. Unions allow different data types to share the same memory location, making them useful for memory optimization and type-generic programming. Enumerations provide a way to define named integer constants, improving code readability and maintainability.

## Unions

### Union Declaration and Basics
A union is a special data type that allows storing different data types in the same memory location. Unlike structures where each member has its own memory, all members of a union share the same memory space.

```c
#include <stdio.h>

union Data {
    int i;
    float f;
    char str[20];
};

int main() {
    union Data data;
    
    printf("Memory size occupied by data: %zu\n", sizeof(data));
    
    data.i = 10;
    printf("data.i: %d\n", data.i);
    
    data.f = 220.5;
    printf("data.f: %f\n", data.f);
    
    // Note: Previous value of data.i is lost
    printf("data.i after setting data.f: %d\n", data.i);
    
    strcpy(data.str, "C Programming");
    printf("data.str: %s\n", data.str);
    
    return 0;
}
```

### Union Memory Layout
All members of a union occupy the same memory location, so the size of a union is the size of its largest member:

```c
#include <stdio.h>

union Example {
    char c;        // 1 byte
    int i;         // 4 bytes (typically)
    double d;      // 8 bytes (typically)
    char str[20];  // 20 bytes
};

int main() {
    union Example ex;
    
    printf("Size of char: %zu bytes\n", sizeof(char));
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of double: %zu bytes\n", sizeof(double));
    printf("Size of char[20]: %zu bytes\n", sizeof(char[20]));
    printf("Size of union Example: %zu bytes\n", sizeof(ex));
    
    // All members share the same memory address
    printf("Address of ex.c: %p\n", (void*)&ex.c);
    printf("Address of ex.i: %p\n", (void*)&ex.i);
    printf("Address of ex.d: %p\n", (void*)&ex.d);
    printf("Address of ex.str: %p\n", (void*)ex.str);
    
    return 0;
}
```

### Practical Union Usage

#### 1. Memory Optimization
Unions are useful when you need to store different types of data but only one at a time:

```c
#include <stdio.h>
#include <string.h>

typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STRING
} DataType;

typedef struct {
    DataType type;
    union {
        int i;
        float f;
        char str[50];
    } data;
} Variant;

void print_variant(const Variant *v) {
    switch (v->type) {
        case TYPE_INT:
            printf("Integer: %d\n", v->data.i);
            break;
        case TYPE_FLOAT:
            printf("Float: %.2f\n", v->data.f);
            break;
        case TYPE_STRING:
            printf("String: %s\n", v->data.str);
            break;
    }
}

int main() {
    Variant var1 = {TYPE_INT, .data.i = 42};
    Variant var2 = {TYPE_FLOAT, .data.f = 3.14f};
    Variant var3 = {TYPE_STRING, .data = {.str = "Hello, World!"}};
    
    print_variant(&var1);
    print_variant(&var2);
    print_variant(&var3);
    
    return 0;
}
```

#### 2. Hardware Register Representation
Unions are commonly used in embedded programming to represent hardware registers:

```c
#include <stdio.h>
#include <stdint.h>

// 32-bit register with bit fields
typedef union {
    uint32_t value;
    struct {
        uint32_t enable : 1;
        uint32_t mode : 2;
        uint32_t reserved : 5;
        uint32_t frequency : 8;
        uint32_t address : 16;
    } bits;
} Register;

int main() {
    Register reg;
    
    // Set register value
    reg.value = 0x12345678;
    printf("Register value: 0x%08X\n", reg.value);
    printf("Enable: %d\n", reg.bits.enable);
    printf("Mode: %d\n", reg.bits.mode);
    printf("Frequency: %d\n", reg.bits.frequency);
    printf("Address: 0x%04X\n", reg.bits.address);
    
    // Modify individual bits
    reg.bits.enable = 1;
    reg.bits.mode = 2;
    printf("Modified register: 0x%08X\n", reg.value);
    
    return 0;
}
```

### Anonymous Unions (C11)
C11 introduced anonymous unions, which allow direct access to union members without specifying the union name:

```c
#include <stdio.h>

typedef struct {
    int type;
    union {
        int integer_value;
        float float_value;
        char string_value[20];
    };  // Anonymous union
} DataRecord;

int main() {
    DataRecord record;
    
    record.type = 1;
    record.integer_value = 42;  // Direct access to union member
    printf("Integer value: %d\n", record.integer_value);
    
    record.type = 2;
    record.float_value = 3.14f;  // Direct access to union member
    printf("Float value: %.2f\n", record.float_value);
    
    return 0;
}
```

## Enumerations

### Basic Enumeration Declaration
Enumerations provide a way to define named integer constants, making code more readable and maintainable:

```c
#include <stdio.h>

// Basic enumeration
enum Color {
    RED,
    GREEN,
    BLUE
};

// Enumeration with typedef
typedef enum {
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
} Day;

int main() {
    enum Color favorite_color = BLUE;
    Day today = WEDNESDAY;
    
    printf("Favorite color: %d\n", favorite_color);
    printf("Today is day: %d\n", today);
    
    // Using in switch statements
    switch (today) {
        case MONDAY:
            printf("It's Monday\n");
            break;
        case WEDNESDAY:
            printf("It's Wednesday\n");
            break;
        case FRIDAY:
            printf("It's Friday\n");
            break;
        default:
            printf("It's another day\n");
    }
    
    return 0;
}
```

### Explicit Enumeration Values
Enumeration constants can be assigned specific values:

```c
#include <stdio.h>

typedef enum {
    HTTP_OK = 200,
    HTTP_BAD_REQUEST = 400,
    HTTP_UNAUTHORIZED = 401,
    HTTP_FORBIDDEN = 403,
    HTTP_NOT_FOUND = 404,
    HTTP_INTERNAL_SERVER_ERROR = 500
} HttpStatusCode;

typedef enum {
    FLAG_NONE = 0,
    FLAG_READ = 1,
    FLAG_WRITE = 2,
    FLAG_EXECUTE = 4,
    FLAG_DELETE = 8
} FilePermission;

int main() {
    HttpStatusCode status = HTTP_NOT_FOUND;
    FilePermission permissions = FLAG_READ | FLAG_WRITE;
    
    printf("HTTP Status: %d\n", status);
    printf("Permissions: %d\n", permissions);
    
    // Check permissions using bitwise operations
    if (permissions & FLAG_READ) {
        printf("Read permission granted\n");
    }
    
    if (permissions & FLAG_EXECUTE) {
        printf("Execute permission granted\n");
    } else {
        printf("Execute permission denied\n");
    }
    
    return 0;
}
```

### Enumeration with Negative Values
Enumerations can include negative values:

```c
#include <stdio.h>

typedef enum {
    TEMPERATURE_FREEZING = 0,
    TEMPERATURE_COLD = 10,
    TEMPERATURE_WARM = 20,
    TEMPERATURE_HOT = 30,
    TEMPERATURE_BOILING = 100
} Temperature;

typedef enum {
    DIRECTION_NORTH = 0,
    DIRECTION_EAST = 90,
    DIRECTION_SOUTH = 180,
    DIRECTION_WEST = 270
} Direction;

// Enumeration with negative values
typedef enum {
    STATUS_ERROR = -1,
    STATUS_UNKNOWN = 0,
    STATUS_SUCCESS = 1
} Status;

int main() {
    Temperature temp = TEMPERATURE_HOT;
    Direction dir = DIRECTION_EAST;
    Status result = STATUS_SUCCESS;
    
    printf("Temperature: %d°C\n", temp);
    printf("Direction: %d°\n", dir);
    printf("Status: %d\n", result);
    
    return 0;
}
```

### Enumeration Size and Type Specification (C23)
C23 introduces more control over enumeration types:

```c
#include <stdio.h>

// Specify underlying type (C23 feature)
typedef enum : unsigned char {
    SMALL_RED,
    SMALL_GREEN,
    SMALL_BLUE
} SmallColor;

typedef enum : long long {
    LARGE_VALUE1 = 1000000000000LL,
    LARGE_VALUE2 = 2000000000000LL
} LargeEnum;

int main() {
    SmallColor color = SMALL_GREEN;
    LargeEnum large = LARGE_VALUE2;
    
    printf("Size of SmallColor: %zu bytes\n", sizeof(color));
    printf("Size of LargeEnum: %zu bytes\n", sizeof(large));
    printf("SmallColor value: %d\n", color);
    printf("LargeEnum value: %lld\n", large);
    
    return 0;
}
```

## Combining Unions and Enumerations

### Tagged Union Pattern
A common pattern combines unions with enumerations to create type-safe variant types:

```c
#include <stdio.h>
#include <string.h>

typedef enum {
    VALUE_INTEGER,
    VALUE_FLOAT,
    VALUE_STRING,
    VALUE_BOOLEAN
} ValueType;

typedef struct {
    ValueType type;
    union {
        int integer_value;
        float float_value;
        char string_value[100];
        int boolean_value;  // 0 = false, 1 = true
    } data;
} Value;

// Constructor functions
Value create_integer(int value) {
    Value v = {VALUE_INTEGER, .data.integer_value = value};
    return v;
}

Value create_float(float value) {
    Value v = {VALUE_FLOAT, .data.float_value = value};
    return v;
}

Value create_string(const char *value) {
    Value v = {VALUE_STRING};
    strncpy(v.data.string_value, value, sizeof(v.data.string_value) - 1);
    v.data.string_value[sizeof(v.data.string_value) - 1] = '\0';
    return v;
}

Value create_boolean(int value) {
    Value v = {VALUE_BOOLEAN, .data.boolean_value = value ? 1 : 0};
    return v;
}

// Print function
void print_value(const Value *v) {
    switch (v->type) {
        case VALUE_INTEGER:
            printf("Integer: %d\n", v->data.integer_value);
            break;
        case VALUE_FLOAT:
            printf("Float: %.2f\n", v->data.float_value);
            break;
        case VALUE_STRING:
            printf("String: %s\n", v->data.string_value);
            break;
        case VALUE_BOOLEAN:
            printf("Boolean: %s\n", v->data.boolean_value ? "true" : "false");
            break;
    }
}

int main() {
    Value values[] = {
        create_integer(42),
        create_float(3.14f),
        create_string("Hello, World!"),
        create_boolean(1)
    };
    
    int count = sizeof(values) / sizeof(values[0]);
    
    for (int i = 0; i < count; i++) {
        print_value(&values[i]);
    }
    
    return 0;
}
```

### Configuration Structure with Unions
Using unions and enumerations for flexible configuration:

```c
#include <stdio.h>
#include <string.h>

typedef enum {
    CONFIG_TYPE_INT,
    CONFIG_TYPE_FLOAT,
    CONFIG_TYPE_STRING,
    CONFIG_TYPE_BOOL
} ConfigType;

typedef struct {
    char key[50];
    ConfigType type;
    union {
        int int_value;
        float float_value;
        char string_value[100];
        int bool_value;
    } value;
} ConfigItem;

typedef struct {
    ConfigItem *items;
    int count;
    int capacity;
} Config;

Config* create_config() {
    Config *config = malloc(sizeof(Config));
    if (config != NULL) {
        config->items = malloc(10 * sizeof(ConfigItem));
        if (config->items != NULL) {
            config->count = 0;
            config->capacity = 10;
        } else {
            free(config);
            config = NULL;
        }
    }
    return config;
}

void add_int_config(Config *config, const char *key, int value) {
    if (config->count >= config->capacity) {
        // Resize array
        ConfigItem *new_items = realloc(config->items, 
                                       (config->capacity + 10) * sizeof(ConfigItem));
        if (new_items != NULL) {
            config->items = new_items;
            config->capacity += 10;
        } else {
            return;  // Allocation failed
        }
    }
    
    ConfigItem *item = &config->items[config->count];
    strncpy(item->key, key, sizeof(item->key) - 1);
    item->key[sizeof(item->key) - 1] = '\0';
    item->type = CONFIG_TYPE_INT;
    item->value.int_value = value;
    
    config->count++;
}

void print_config(const Config *config) {
    for (int i = 0; i < config->count; i++) {
        const ConfigItem *item = &config->items[i];
        printf("Key: %s, ", item->key);
        
        switch (item->type) {
            case CONFIG_TYPE_INT:
                printf("Value: %d (int)\n", item->value.int_value);
                break;
            case CONFIG_TYPE_FLOAT:
                printf("Value: %.2f (float)\n", item->value.float_value);
                break;
            case CONFIG_TYPE_STRING:
                printf("Value: %s (string)\n", item->value.string_value);
                break;
            case CONFIG_TYPE_BOOL:
                printf("Value: %s (bool)\n", item->value.bool_value ? "true" : "false");
                break;
        }
    }
}

int main() {
    Config *config = create_config();
    if (config == NULL) {
        printf("Failed to create config\n");
        return 1;
    }
    
    add_int_config(config, "window_width", 800);
    add_int_config(config, "window_height", 600);
    
    print_config(config);
    
    // Clean up
    free(config->items);
    free(config);
    
    return 0;
}
```

## Practical Examples

### Network Packet Header
Using unions and enumerations for network protocol implementation:

```c
#include <stdio.h>
#include <stdint.h>

typedef enum {
    PACKET_TYPE_DATA = 0x01,
    PACKET_TYPE_ACK = 0x02,
    PACKET_TYPE_NACK = 0x03,
    PACKET_TYPE_CONTROL = 0x04
} PacketType;

typedef enum {
    CONTROL_START = 0x01,
    CONTROL_STOP = 0x02,
    CONTROL_RESET = 0x03
} ControlType;

typedef struct {
    uint8_t version : 4;
    uint8_t type : 4;
    uint16_t length;
    uint32_t sequence;
    union {
        struct {
            uint8_t data[1024];
        } data_packet;
        
        struct {
            uint32_t ack_sequence;
        } ack_packet;
        
        struct {
            uint8_t control_type;
            uint8_t reserved[3];
        } control_packet;
    } payload;
} NetworkPacket;

void print_packet_info(const NetworkPacket *packet) {
    printf("Packet Version: %d\n", packet->version);
    printf("Packet Type: 0x%02X\n", packet->type);
    printf("Packet Length: %d\n", packet->length);
    printf("Sequence Number: %u\n", packet->sequence);
    
    switch (packet->type) {
        case PACKET_TYPE_DATA:
            printf("Data Packet\n");
            break;
        case PACKET_TYPE_ACK:
            printf("ACK for sequence: %u\n", packet->payload.ack_packet.ack_sequence);
            break;
        case PACKET_TYPE_CONTROL:
            printf("Control Type: 0x%02X\n", packet->payload.control_packet.control_type);
            break;
        default:
            printf("Unknown Packet Type\n");
    }
}

int main() {
    NetworkPacket packet = {
        .version = 1,
        .type = PACKET_TYPE_CONTROL,
        .length = sizeof(packet.payload.control_packet),
        .sequence = 1000,
        .payload.control_packet = {
            .control_type = CONTROL_RESET,
            .reserved = {0}
        }
    };
    
    print_packet_info(&packet);
    
    return 0;
}
```

### Mathematical Expression Evaluator
Using unions and enumerations for a simple expression evaluator:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    TOKEN_NUMBER,
    TOKEN_OPERATOR,
    TOKEN_VARIABLE
} TokenType;

typedef enum {
    OP_ADD = '+',
    OP_SUBTRACT = '-',
    OP_MULTIPLY = '*',
    OP_DIVIDE = '/',
    OP_ASSIGN = '='
} Operator;

typedef struct {
    TokenType type;
    union {
        double number_value;
        Operator operator_value;
        char variable_name[20];
    } data;
} Token;

typedef struct {
    Token *tokens;
    int count;
    int capacity;
} Expression;

Expression* create_expression() {
    Expression *expr = malloc(sizeof(Expression));
    if (expr != NULL) {
        expr->tokens = malloc(10 * sizeof(Token));
        if (expr->tokens != NULL) {
            expr->count = 0;
            expr->capacity = 10;
        } else {
            free(expr);
            expr = NULL;
        }
    }
    return expr;
}

void add_number_token(Expression *expr, double value) {
    if (expr->count >= expr->capacity) {
        Token *new_tokens = realloc(expr->tokens, 
                                   (expr->capacity + 10) * sizeof(Token));
        if (new_tokens != NULL) {
            expr->tokens = new_tokens;
            expr->capacity += 10;
        } else {
            return;
        }
    }
    
    Token *token = &expr->tokens[expr->count];
    token->type = TOKEN_NUMBER;
    token->data.number_value = value;
    expr->count++;
}

void add_operator_token(Expression *expr, Operator op) {
    if (expr->count >= expr->capacity) {
        Token *new_tokens = realloc(expr->tokens, 
                                   (expr->capacity + 10) * sizeof(Token));
        if (new_tokens != NULL) {
            expr->tokens = new_tokens;
            expr->capacity += 10;
        } else {
            return;
        }
    }
    
    Token *token = &expr->tokens[expr->count];
    token->type = TOKEN_OPERATOR;
    token->data.operator_value = op;
    expr->count++;
}

void print_expression(const Expression *expr) {
    for (int i = 0; i < expr->count; i++) {
        const Token *token = &expr->tokens[i];
        
        switch (token->type) {
            case TOKEN_NUMBER:
                printf("%.2f ", token->data.number_value);
                break;
            case TOKEN_OPERATOR:
                printf("%c ", token->data.operator_value);
                break;
            case TOKEN_VARIABLE:
                printf("%s ", token->data.variable_name);
                break;
        }
    }
    printf("\n");
}

int main() {
    Expression *expr = create_expression();
    if (expr == NULL) {
        printf("Failed to create expression\n");
        return 1;
    }
    
    // Create expression: 3.14 + 2.5 * x
    add_number_token(expr, 3.14);
    add_operator_token(expr, OP_ADD);
    add_number_token(expr, 2.5);
    add_operator_token(expr, OP_MULTIPLY);
    // For simplicity, we'll represent variable as a number
    add_number_token(expr, 0);  // Placeholder for variable x
    
    printf("Expression: ");
    print_expression(expr);
    
    // Clean up
    free(expr->tokens);
    free(expr);
    
    return 0;
}
```

## Summary

Unions and enumerations are powerful features that extend the capabilities of C programming:

1. **Unions**: Allow different data types to share the same memory location, useful for memory optimization and type-generic programming
2. **Memory Sharing**: All union members occupy the same memory space, with size equal to the largest member
3. **Practical Applications**: Hardware register representation, variant types, and memory-efficient data storage
4. **Anonymous Unions**: C11 feature enabling direct access to union members (C11)
5. **Enumerations**: Provide named integer constants for improved code readability and maintainability
6. **Explicit Values**: Enumerations can have specific values, including negative numbers
7. **Type Safety**: Combining unions with enumerations creates type-safe variant types
8. **Advanced Features**: C23 introduces more control over enumeration types

Understanding unions and enumerations enables programmers to write more efficient, readable, and maintainable C code, particularly in systems programming, embedded development, and protocol implementation.