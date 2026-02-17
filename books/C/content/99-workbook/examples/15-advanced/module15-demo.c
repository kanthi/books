/*
 * Module 15 Demonstration Program
 * This program demonstrates all the key concepts from Module 15:
 * - Advanced C features (variadic functions, complex declarations)
 * - System programming (processes, signals, IPC)
 * - Interfacing with other languages
 * - Advanced preprocessor techniques
 * - Best practices and idioms
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <setjmp.h>
#include <signal.h>
#include <unistd.h>

// Include our custom header files
#include "advanced_utils.h"

// Function prototypes for demonstration functions
void demonstrate_advanced_c_features(void);
void demonstrate_system_programming(void);
void demonstrate_language_interfacing(void);
void demonstrate_advanced_preprocessor(void);
void demonstrate_best_practices(void);

// Example functions for demonstrations
void example_callback(void* data);
int compare_ints(const void* a, const void* b);
void variadic_function_example(const char* format, ...);
void signal_handler(int sig);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 15: Advanced Topics Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_advanced_c_features();
    demonstrate_system_programming();
    demonstrate_language_interfacing();
    demonstrate_advanced_preprocessor();
    demonstrate_best_practices();
    
    printf("\n========================================\n");
    printf("  Module 15 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate advanced C features
 */
void demonstrate_advanced_c_features() {
    print_separator("Advanced C Features");
    
    printf("1. Variadic Functions:\n");
    printf("  Functions that accept variable number of arguments\n");
    printf("  Example: printf, scanf\n");
    
    // Demonstrate variadic function
    printf("\n  Variadic function demonstration:\n");
    variadic_function_example("Integer: %d, String: %s, Double: %.2f", 42, "Hello", 3.14);
    
    printf("\n2. Complex Declarations:\n");
    printf("  Function pointers:\n");
    printf("    int (*func_ptr)(int, int) - Pointer to function taking two ints and returning int\n");
    printf("    int *(*func_ptr)(int) - Pointer to function taking int and returning int pointer\n");
    printf("  Arrays of pointers:\n");
    printf("    int *arr[10] - Array of 10 int pointers\n");
    printf("  Pointer to array:\n");
    printf("    int (*ptr)[10] - Pointer to array of 10 ints\n");
    printf("  Function returning pointer to array:\n");
    printf("    int (*func(int))[10] - Function taking int, returning pointer to array of 10 ints\n");
    
    printf("\n3. Volatile and Const Qualifiers:\n");
    printf("  volatile: Prevents compiler optimizations\n");
    printf("  const: Read-only data\n");
    printf("  volatile const: Read-only but can change externally\n");
    
    printf("\n4. Restrict Keyword (C99):\n");
    printf("  Hint to compiler that pointer is not aliased\n");
    printf("  Example: void copy(int *restrict dest, const int *restrict src, size_t n)\n");
    
    printf("\n5. Designated Initializers (C99):\n");
    printf("  Initialize structure members by name\n");
    printf("  Example: struct Point p = {.x = 10, .y = 20};\n");
    
    printf("\n6. Compound Literals (C99):\n");
    printf("  Create anonymous objects\n");
    printf("  Example: int *arr = (int[]){1, 2, 3, 4, 5};\n");
}

/*
 * Demonstrate system programming
 */
void demonstrate_system_programming() {
    print_separator("System Programming");
    
    printf("1. Process Management:\n");
    printf("  fork(): Create new process\n");
    printf("  exec(): Replace process image\n");
    printf("  wait(): Wait for child process\n");
    printf("  getpid(): Get process ID\n");
    
    printf("\n2. Signal Handling:\n");
    printf("  Signals: Asynchronous notifications\n");
    printf("  Common signals:\n");
    printf("    SIGINT: Interrupt (Ctrl+C)\n");
    printf("    SIGTERM: Termination request\n");
    printf("    SIGKILL: Kill signal (cannot be caught)\n");
    printf("    SIGSEGV: Segmentation violation\n");
    
    // Demonstrate signal handling
    printf("\n  Signal handling demonstration:\n");
    signal(SIGINT, signal_handler);
    printf("  Signal handler registered for SIGINT (Ctrl+C)\n");
    printf("  Press Ctrl+C to test (demo will continue after)\n");
    sleep(2); // Give time to press Ctrl+C
    
    printf("\n3. Inter-Process Communication (IPC):\n");
    printf("  Pipes: Unidirectional data channel\n");
    printf("  FIFOs: Named pipes\n");
    printf("  Message Queues: Structured message passing\n");
    printf("  Shared Memory: Shared memory segments\n");
    printf("  Semaphores: Process synchronization\n");
    
    printf("\n4. File System Operations:\n");
    printf("  File permissions and ownership\n");
    printf("  Directory operations\n");
    printf("  Hard links and symbolic links\n");
    printf("  File locking\n");
    
    printf("\n5. Memory Management:\n");
    printf("  brk() and sbrk(): Change data segment size\n");
    printf("  mmap(): Map files or devices into memory\n");
    printf("  mprotect(): Change memory protection\n");
}

/*
 * Demonstrate language interfacing
 */
void demonstrate_language_interfacing() {
    print_separator("Language Interfacing");
    
    printf("1. Calling Assembly from C:\n");
    printf("  Inline assembly with GCC:\n");
    printf("    int result;\n");
    printf("    __asm__ (\"movl %%eax, %%ebx\" : \"=b\" (result) : \"a\" (42));\n");
    
    printf("\n2. Creating C Libraries:\n");
    printf("  Static libraries (.a files)\n");
    printf("  Shared libraries (.so files on Linux, .dll on Windows)\n");
    printf("  Position Independent Code (PIC)\n");
    
    printf("\n3. Interfacing with Python:\n");
    printf("  Python C API\n");
    printf("  Example:\n");
    printf("    static PyMethodDef methods[] = {\n");
    printf("      {\"function_name\", c_function, METH_VARARGS, \"Description\"},\n");
    printf("      {NULL, NULL, 0, NULL}\n");
    printf("    };\n");
    
    printf("\n4. Interfacing with Java (JNI):\n");
    printf("  Java Native Interface\n");
    printf("  Example function signature:\n");
    printf("    JNIEXPORT jint JNICALL Java_Class_method\n");
    printf("      (JNIEnv *env, jobject obj, jint param);\n");
    
    printf("\n5. Foreign Function Interface (FFI):\n");
    printf("  Call C functions from other languages\n");
    printf("  Libraries: libffi\n");
}

/*
 * Demonstrate advanced preprocessor techniques
 */
void demonstrate_advanced_preprocessor() {
    print_separator("Advanced Preprocessor");
    
    printf("1. Token Concatenation:\n");
    printf("  ## operator combines tokens\n");
    printf("  Example:\n");
    printf("    #define DECLARE_VAR(type, name) type var_##name\n");
    printf("    DECLARE_VAR(int, count); // Expands to: int var_count;\n");
    
    printf("\n2. Stringification:\n");
    printf("  # operator converts token to string\n");
    printf("  Example:\n");
    printf("    #define PRINT_VAR(var) printf(#var \" = %%d\\n\", var)\n");
    printf("    int x = 42;\n");
    printf("    PRINT_VAR(x); // Expands to: printf(\"x\" \" = %%d\\n\", x);\n");
    
    printf("\n3. Conditional Compilation:\n");
    printf("  #if, #ifdef, #ifndef directives\n");
    printf("  Example:\n");
    printf("    #ifdef DEBUG\n");
    printf("      printf(\"Debug information\\n\");\n");
    printf("    #endif\n");
    
    printf("\n4. Include Guards:\n");
    printf("  Prevent multiple inclusion of headers\n");
    printf("  Example:\n");
    printf("    #ifndef HEADER_H\n");
    printf("    #define HEADER_H\n");
    printf("    // Header content\n");
    printf("    #endif\n");
    
    printf("\n5. Pragma Directives:\n");
    printf("  Compiler-specific instructions\n");
    printf("  Examples:\n");
    printf("    #pragma once // Include guard alternative\n");
    printf("    #pragma pack(1) // Structure packing\n");
    printf("    #pragma warning(disable: 4996) // Disable specific warnings\n");
    
    // Demonstrate macro features
    demonstrate_macros_and_preprocessor();
}

/*
 * Demonstrate best practices
 */
void demonstrate_best_practices() {
    print_separator("Best Practices and Idioms");
    
    printf("1. RAII (Resource Acquisition Is Initialization):\n");
    printf("  Although not native to C, can be implemented with macros\n");
    printf("  Example:\n");
    printf("    #define SCOPE_EXIT(code) \\\n");
    printf("      for (int _i = 1; _i--; code)\n");
    
    printf("\n2. Error Handling Patterns:\n");
    printf("  Return codes:\n");
    printf("    int result = function();\n");
    printf("    if (result != SUCCESS) { handle_error(); }\n");
    printf("  goto for cleanup:\n");
    printf("    if (allocation_fails) goto cleanup;\n");
    printf("    // ... normal execution ...\n");
    printf("    cleanup:\n");
    printf("      free(resources);\n");
    printf("      return result;\n");
    
    printf("\n3. Defensive Programming:\n");
    printf("  Validate all inputs\n");
    printf("  Use assertions for debugging\n");
    printf("  Initialize variables\n");
    printf("  Check return values\n");
    
    printf("\n4. Code Organization:\n");
    printf("  Modular design\n");
    printf("  Clear interfaces\n");
    printf("  Separation of concerns\n");
    printf("  Consistent naming conventions\n");
    
    printf("\n5. Performance Considerations:\n");
    printf("  Profile before optimizing\n");
    printf("  Algorithmic improvements over micro-optimizations\n");
    printf("  Understand compiler optimizations\n");
    printf("  Memory access patterns\n");
    
    printf("\n6. Portability:\n");
    printf("  Use standard library functions\n");
    printf("  Conditional compilation for platform-specific code\n");
    printf("  Avoid implementation-defined behavior\n");
    printf("  Test on multiple platforms\n");
    
    // Demonstrate callback mechanism
    printf("\n  Callback mechanism demonstration:\n");
    int data = 123;
    demonstrate_callback_mechanism(example_callback, &data);
    
    // Demonstrate bit manipulation
    printf("\n  Bit manipulation demonstration:\n");
    demonstrate_bit_manipulation();
}

// Example functions for demonstrations
void example_callback(void* data) {
    int* int_data = (int*)data;
    printf("    Callback called with data: %d\n", *int_data);
}

int compare_ints(const void* a, const void* b) {
    int int_a = *(const int*)a;
    int int_b = *(const int*)b;
    
    if (int_a == int_b) return 0;
    else if (int_a < int_b) return -1;
    else return 1;
}

void variadic_function_example(const char* format, ...) {
    va_list args;
    va_start(args, format);
    
    printf("    ");
    vprintf(format, args);
    printf("\n");
    
    va_end(args);
}

void signal_handler(int sig) {
    printf("    Signal %d received!\n", sig);
    // Reset signal handler for next time
    signal(SIGINT, signal_handler);
}