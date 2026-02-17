/*
 * Module 2 Demonstration Program
 * This program demonstrates all the key concepts from Module 2:
 * - Fundamental data types and their characteristics
 * - Variable declaration and initialization
 * - Constants using different methods
 * - Storage classes
 * - Type conversions
 * - Operators and expressions
 */

#include <stdio.h>
#include <limits.h>
#include <float.h>
#include <stdint.h>
#include <stdbool.h>

// Global variable with extern storage class example
int global_counter = 0;

// Function prototypes
void demonstrate_data_types(void);
void demonstrate_variables_constants(void);
void demonstrate_storage_classes(void);
void demonstrate_type_conversions(void);
void demonstrate_operators(void);
void demonstrate_bitwise_operations(void);

/*
 * Main function - entry point of the program
 */
int main() {
    printf("=====================================\n");
    printf("  Module 2: Data Types and Variables  \n");
    printf("         Comprehensive Demo           \n");
    printf("=====================================\n\n");
    
    demonstrate_data_types();
    demonstrate_variables_constants();
    demonstrate_storage_classes();
    demonstrate_type_conversions();
    demonstrate_operators();
    demonstrate_bitwise_operations();
    
    printf("\n=====================================\n");
    printf("  Module 2 Demo Completed Successfully \n");
    printf("=====================================\n");
    
    return 0;
}

/*
 * Demonstrate fundamental data types and their characteristics
 */
void demonstrate_data_types() {
    printf("--- Fundamental Data Types ---\n");
    
    // Integer types
    printf("Integer Types:\n");
    printf("char: %zu bytes, range %d to %d\n", sizeof(char), CHAR_MIN, CHAR_MAX);
    printf("short: %zu bytes, range %d to %d\n", sizeof(short), SHRT_MIN, SHRT_MAX);
    printf("int: %zu bytes, range %d to %d\n", sizeof(int), INT_MIN, INT_MAX);
    printf("long: %zu bytes, range %ld to %ld\n", sizeof(long), LONG_MIN, LONG_MAX);
    printf("long long: %zu bytes, range %lld to %lld\n", sizeof(long long), LLONG_MIN, LLONG_MAX);
    
    // Unsigned integer types
    printf("\nUnsigned Integer Types:\n");
    printf("unsigned char: %zu bytes, range 0 to %u\n", sizeof(unsigned char), UCHAR_MAX);
    printf("unsigned short: %zu bytes, range 0 to %u\n", sizeof(unsigned short), USHRT_MAX);
    printf("unsigned int: %zu bytes, range 0 to %u\n", sizeof(unsigned int), UINT_MAX);
    printf("unsigned long: %zu bytes, range 0 to %lu\n", sizeof(unsigned long), ULONG_MAX);
    printf("unsigned long long: %zu bytes, range 0 to %llu\n", sizeof(unsigned long long), ULLONG_MAX);
    
    // Floating-point types
    printf("\nFloating-Point Types:\n");
    printf("float: %zu bytes, precision %d digits\n", sizeof(float), FLT_DIG);
    printf("double: %zu bytes, precision %d digits\n", sizeof(double), DBL_DIG);
    printf("long double: %zu bytes, precision %d digits\n", sizeof(long double), LDBL_DIG);
    
    // Fixed-width integer types
    printf("\nFixed-Width Integer Types:\n");
    printf("int8_t: %zu bytes, range %d to %d\n", sizeof(int8_t), INT8_MIN, INT8_MAX);
    printf("int16_t: %zu bytes, range %d to %d\n", sizeof(int16_t), INT16_MIN, INT16_MAX);
    printf("int32_t: %zu bytes, range %d to %d\n", sizeof(int32_t), INT32_MIN, INT32_MAX);
    printf("int64_t: %zu bytes, range %lld to %lld\n", sizeof(int64_t), INT64_MIN, INT64_MAX);
    
    // Boolean type
    printf("\nBoolean Type:\n");
    bool is_complete = true;
    bool is_valid = false;
    printf("true: %d, false: %d\n", is_complete, is_valid);
    
    printf("\n");
}

/*
 * Demonstrate variables and constants
 */
void demonstrate_variables_constants() {
    printf("--- Variables and Constants ---\n");
    
    // Variable declaration and initialization
    int age = 25;
    float height = 5.9f;
    double weight = 150.5;
    char initial = 'J';
    char name[] = "John Doe";
    
    printf("Variables:\n");
    printf("Age: %d\n", age);
    printf("Height: %.1f feet\n", height);
    printf("Weight: %.1f pounds\n", weight);
    printf("Initial: %c\n", initial);
    printf("Name: %s\n", name);
    
    // Constants using #define
    #define COMPANY_NAME "TechCorp"
    #define MAX_EMPLOYEES 1000
    #define PI 3.14159
    
    printf("\nConstants (#define):\n");
    printf("Company: %s\n", COMPANY_NAME);
    printf("Max Employees: %d\n", MAX_EMPLOYEES);
    printf("PI: %.5f\n", PI);
    
    // Constants using const
    const int tax_rate = 8;
    const float bonus_multiplier = 1.5f;
    const char department[] = "Engineering";
    
    printf("\nConstants (const):\n");
    printf("Tax Rate: %d%%\n", tax_rate);
    printf("Bonus Multiplier: %.1f\n", bonus_multiplier);
    printf("Department: %s\n", department);
    
    // Constants using enum
    enum Weekday {
        MONDAY = 1,
        TUESDAY,
        WEDNESDAY,
        THURSDAY,
        FRIDAY,
        SATURDAY,
        SUNDAY
    };
    
    enum Status {
        INACTIVE = 0,
        ACTIVE = 1,
        PENDING = 2
    };
    
    enum Weekday today = WEDNESDAY;
    enum Status user_status = ACTIVE;
    
    printf("\nConstants (enum):\n");
    printf("Today is day %d of the week\n", today);
    printf("User status: %d\n", user_status);
    
    printf("\n");
}

/*
 * Demonstrate storage classes
 */
void demonstrate_storage_classes() {
    printf("--- Storage Classes ---\n");
    
    // auto storage class (default for local variables)
    auto int auto_var = 100;
    printf("Auto variable: %d\n", auto_var);
    
    // register storage class
    register int reg_var = 200;
    printf("Register variable: %d\n", reg_var);
    
    // static storage class
    static int static_counter = 0;
    static_counter++;
    printf("Static counter: %d (retains value between calls)\n", static_counter);
    
    // extern storage class (declared at global scope)
    global_counter++;
    printf("Global counter: %d (accessible across files)\n", global_counter);
    
    printf("\n");
}

/*
 * Demonstrate type conversions
 */
void demonstrate_type_conversions() {
    printf("--- Type Conversions ---\n");
    
    // Implicit conversions
    int int_val = 10;
    float float_val = 3.14f;
    double double_val = 2.71828;
    
    printf("Implicit conversions:\n");
    printf("int + float = %.2f (float)\n", int_val + float_val);
    printf("float + double = %.5f (double)\n", float_val + double_val);
    
    // Explicit conversions (casting)
    double pi = 3.14159;
    int int_pi = (int)pi;
    printf("\nExplicit conversions:\n");
    printf("Original double: %.5f\n", pi);
    printf("Casted to int: %d (truncated)\n", int_pi);
    
    // Integer to floating-point conversion
    int total = 100;
    int count = 3;
    float average1 = total / count;        // Integer division
    float average2 = (float)total / count; // Floating-point division
    
    printf("\nInteger vs Float division:\n");
    printf("Integer division: %d / %d = %.1f\n", total, count, average1);
    printf("Float division: %.1f / %d = %.2f\n", (float)total, count, average2);
    
    // Character conversions
    char letter = 'A';
    int ascii_val = (int)letter;
    printf("\nCharacter conversions:\n");
    printf("Character: %c\n", letter);
    printf("ASCII value: %d\n", ascii_val);
    
    printf("\n");
}

/*
 * Demonstrate operators and expressions
 */
void demonstrate_operators() {
    printf("--- Operators and Expressions ---\n");
    
    // Arithmetic operators
    int a = 15, b = 4;
    printf("Arithmetic operations (a=%d, b=%d):\n", a, b);
    printf("a + b = %d\n", a + b);
    printf("a - b = %d\n", a - b);
    printf("a * b = %d\n", a * b);
    printf("a / b = %d (integer division)\n", a / b);
    printf("a %% b = %d (modulus)\n", a % b);
    
    // Relational operators
    printf("\nRelational operations:\n");
    printf("a == b: %d\n", a == b);
    printf("a != b: %d\n", a != b);
    printf("a > b: %d\n", a > b);
    printf("a < b: %d\n", a < b);
    printf("a >= b: %d\n", a >= b);
    printf("a <= b: %d\n", a <= b);
    
    // Logical operators
    bool x = true, y = false;
    printf("\nLogical operations (x=%d, y=%d):\n", x, y);
    printf("x && y: %d\n", x && y);
    printf("x || y: %d\n", x || y);
    printf("!x: %d\n", !x);
    printf("!y: %d\n", !y);
    
    // Assignment operators
    int c = 10;
    printf("\nAssignment operations (c=%d):\n", c);
    printf("c += 5: %d\n", c += 5);
    printf("c -= 3: %d\n", c -= 3);
    printf("c *= 2: %d\n", c *= 2);
    printf("c /= 4: %d\n", c /= 4);
    
    // Increment/decrement operators
    int d = 5;
    printf("\nIncrement/Decrement (d=%d):\n", d);
    printf("++d: %d (pre-increment)\n", ++d);
    printf("d: %d\n", d);
    printf("d++: %d (post-increment)\n", d++);
    printf("d: %d\n", d);
    
    // Conditional operator
    int max = (a > b) ? a : b;
    printf("\nConditional operator:\n");
    printf("Max of %d and %d is %d\n", a, b, max);
    
    printf("\n");
}

/*
 * Demonstrate bitwise operations
 */
void demonstrate_bitwise_operations() {
    printf("--- Bitwise Operations ---\n");
    
    unsigned int x = 12;  // Binary: 1100
    unsigned int y = 10;  // Binary: 1010
    
    printf("x = %u (binary: 1100)\n", x);
    printf("y = %u (binary: 1010)\n", y);
    
    printf("\nBitwise operations:\n");
    printf("x & y = %u (AND)\n", x & y);
    printf("x | y = %u (OR)\n", x | y);
    printf("x ^ y = %u (XOR)\n", x ^ y);
    printf("~x = %u (NOT)\n", ~x);
    printf("x << 1 = %u (Left shift)\n", x << 1);
    printf("x >> 1 = %u (Right shift)\n", x >> 1);
    
    // Practical bit manipulation
    unsigned char flags = 0b00001010;  // 10 in decimal
    printf("\nFlag manipulation (initial: %08b):\n", flags);
    
    // Set bit 2
    flags |= (1 << 2);
    printf("After setting bit 2: %08b\n", flags);
    
    // Clear bit 3
    flags &= ~(1 << 3);
    printf("After clearing bit 3: %08b\n", flags);
    
    // Toggle bit 1
    flags ^= (1 << 1);
    printf("After toggling bit 1: %08b\n", flags);
    
    // Check if bit 2 is set
    bool is_bit2_set = (flags & (1 << 2)) != 0;
    printf("Is bit 2 set? %s\n", is_bit2_set ? "Yes" : "No");
    
    printf("\n");
}