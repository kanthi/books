/*
 * Module 14 Demonstration Program
 * This program demonstrates all the key concepts from Module 14:
 * - Testing fundamentals (unit testing, integration testing, system testing)
 * - Test-driven development (TDD)
 * - Debugging techniques (GDB, Valgrind, static analysis)
 * - Code quality tools (linters, formatters, coverage)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include our custom header files
#include "testing_utils.h"

// Function prototypes for demonstration functions
void demonstrate_testing_fundamentals(void);
void demonstrate_test_driven_development(void);
void demonstrate_debugging_techniques(void);
void demonstrate_code_quality_tools(void);

// Example functions to test
int add(int a, int b);
int factorial(int n);
char* reverse_string(char* str);

// Test cases
void test_add_positive_numbers(void);
void test_add_negative_numbers(void);
void test_factorial_zero(void);
void test_factorial_positive(void);
void test_reverse_string_basic(void);
void test_reverse_string_empty(void);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 14: Testing Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_testing_fundamentals();
    demonstrate_test_driven_development();
    demonstrate_debugging_techniques();
    demonstrate_code_quality_tools();
    
    // Run actual tests
    printf("\n========================================\n");
    printf("  Running Unit Tests\n");
    printf("========================================\n");
    
    TestSuite* math_suite = create_test_suite("Math Functions");
    add_test_case(math_suite, "Add Positive Numbers", test_add_positive_numbers);
    add_test_case(math_suite, "Add Negative Numbers", test_add_negative_numbers);
    add_test_case(math_suite, "Factorial of Zero", test_factorial_zero);
    add_test_case(math_suite, "Factorial of Positive Number", test_factorial_positive);
    
    TestSuite* string_suite = create_test_suite("String Functions");
    add_test_case(string_suite, "Reverse String Basic", test_reverse_string_basic);
    add_test_case(string_suite, "Reverse Empty String", test_reverse_string_empty);
    
    run_all_tests();
    print_test_results();
    
    return 0;
}

/*
 * Demonstrate testing fundamentals
 */
void demonstrate_testing_fundamentals() {
    print_separator("Testing Fundamentals");
    
    printf("1. Types of Testing:\n");
    printf("  Unit Testing:\n");
    printf("    - Test individual functions or methods\n");
    printf("    - Isolate units from dependencies\n");
    printf("    - Fast and focused\n");
    printf("  Integration Testing:\n");
    printf("    - Test interactions between units\n");
    printf("    - Verify interfaces and data flow\n");
    printf("  System Testing:\n");
    printf("    - Test complete integrated system\n");
    printf("    - Verify system requirements\n");
    printf("  Acceptance Testing:\n");
    printf("    - Validate system against user requirements\n");
    printf("    - Often user-driven\n");
    
    printf("\n2. Testing Principles:\n");
    printf("  - Test early and often\n");
    printf("  - Automate tests\n");
    printf("  - Use test coverage metrics\n");
    printf("  - Write testable code\n");
    printf("  - Maintain test suites\n");
    
    printf("\n3. Test Design Techniques:\n");
    printf("  Boundary Value Analysis:\n");
    printf("    - Test at boundaries of input ranges\n");
    printf("    - Example: For input 1-100, test 0, 1, 99, 100, 101\n");
    printf("  Equivalence Partitioning:\n");
    printf("    - Divide input into equivalent classes\n");
    printf("    - Test one value from each class\n");
    printf("  Error Guessing:\n");
    printf("    - Use experience to guess likely errors\n");
    printf("  State Transition Testing:\n");
    printf("    - Test system behavior in different states\n");
}

/*
 * Demonstrate test-driven development
 */
void demonstrate_test_driven_development() {
    print_separator("Test-Driven Development (TDD)");
    
    printf("1. TDD Cycle (Red-Green-Refactor):\n");
    printf("  Red: Write a failing test\n");
    printf("  Green: Write minimal code to pass test\n");
    printf("  Refactor: Improve code without changing behavior\n");
    
    printf("\n2. Benefits of TDD:\n");
    printf("  - Better code design\n");
    printf("  - Immediate feedback\n");
    printf("  - Living documentation\n");
    printf("  - Reduced debugging time\n");
    printf("  - Increased confidence in changes\n");
    
    printf("\n3. TDD Process Example:\n");
    printf("  Step 1: Write test for add(2, 3) == 5\n");
    printf("  Step 2: Implement minimal add function\n");
    printf("    int add(int a, int b) { return 5; } // Minimal implementation\n");
    printf("  Step 3: Add more tests to force real implementation\n");
    printf("  Step 4: Refactor to general solution\n");
    printf("    int add(int a, int b) { return a + b; }\n");
    
    printf("\n4. TDD Best Practices:\n");
    printf("  - Write tests before code\n");
    printf("  - Keep tests small and focused\n");
    printf("  - Use descriptive test names\n");
    printf("  - Test edge cases\n");
    printf("  - Maintain test quality\n");
}

/*
 * Demonstrate debugging techniques
 */
void demonstrate_debugging_techniques() {
    print_separator("Debugging Techniques");
    
    printf("1. Debugging Tools:\n");
    printf("  GDB (GNU Debugger):\n");
    printf("    - Set breakpoints\n");
    printf("    - Step through code\n");
    printf("    - Inspect variables\n");
    printf("    - Examine stack traces\n");
    printf("  Example GDB commands:\n");
    printf("    gdb ./program\n");
    printf("    (gdb) break main\n");
    printf("    (gdb) run\n");
    printf("    (gdb) step\n");
    printf("    (gdb) print variable\n");
    printf("    (gdb) continue\n");
    
    printf("\n2. Static Analysis Tools:\n");
    printf("  GCC with warnings:\n");
    printf("    gcc -Wall -Wextra -Werror program.c\n");
    printf("  Splint: C program checker\n");
    printf("  Cppcheck: Static analysis tool\n");
    printf("  Clang Static Analyzer\n");
    
    printf("\n3. Dynamic Analysis Tools:\n");
    printf("  Valgrind:\n");
    printf("    - Memory error detection\n");
    printf("    - Memory leak detection\n");
    printf("    - Cache profiling\n");
    printf("  Example:\n");
    printf("    valgrind --tool=memcheck --leak-check=full ./program\n");
    
    printf("\n4. Debugging Strategies:\n");
    printf("  - Reproduce the issue consistently\n");
    printf("  - Narrow down the problem location\n");
    printf("  - Use printf debugging for quick checks\n");
    printf("  - Check boundary conditions\n");
    printf("  - Verify assumptions\n");
    printf("  - Use version control to identify when bug was introduced\n");
    
    printf("\n5. Common Debugging Techniques:\n");
    printf("  Rubber duck debugging: Explain code to inanimate object\n");
    printf("  Binary search debugging: Narrow down problem location\n");
    printf("  Minimal reproducible example: Isolate the problem\n");
    printf("  Code review: Fresh eyes spot issues\n");
}

/*
 * Demonstrate code quality tools
 */
void demonstrate_code_quality_tools() {
    print_separator("Code Quality Tools");
    
    printf("1. Code Linters:\n");
    printf("  - Check for syntax and style issues\n");
    printf("  - Enforce coding standards\n");
    printf("  - Identify potential bugs\n");
    printf("  Examples:\n");
    printf("    - cppcheck: Static analysis\n");
    printf("    - splint: Annotation-based checking\n");
    printf("    - clang-tidy: Clang-based linting\n");
    
    printf("\n2. Code Formatters:\n");
    printf("  - Ensure consistent code style\n");
    printf("  - Automatic formatting\n");
    printf("  Examples:\n");
    printf("    - clang-format: Format C/C++ code\n");
    printf("    - astyle: Artistic Style formatter\n");
    
    printf("\n3. Test Coverage Tools:\n");
    printf("  - Measure how much code is tested\n");
    printf("  - Identify untested code paths\n");
    printf("  Examples:\n");
    printf("    - gcov: GNU coverage analysis\n");
    printf("    - lcov: HTML coverage reports\n");
    printf("  Usage:\n");
    printf("    gcc -fprofile-arcs -ftest-coverage program.c\n");
    printf("    ./program\n");
    printf("    gcov program.c\n");
    
    printf("\n4. Continuous Integration:\n");
    printf("  - Automated testing on code changes\n");
    printf("  - Build verification\n");
    printf("  - Quality gates\n");
    printf("  Examples:\n");
    printf("    - Jenkins\n");
    printf("    - Travis CI\n");
    printf("    - GitHub Actions\n");
    
    printf("\n5. Code Review Tools:\n");
    printf("  - Peer review of code changes\n");
    printf("  - Automated review tools\n");
    printf("  Examples:\n");
    printf("    - Gerrit\n");
    printf("    - GitHub Pull Requests\n");
    printf("    - Crucible\n");
}

// Example functions to test
int add(int a, int b) {
    return a + b;
}

int factorial(int n) {
    if (n < 0) return -1; // Error case
    if (n == 0 || n == 1) return 1;
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

char* reverse_string(char* str) {
    if (str == NULL) return NULL;
    
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
    return str;
}

// Test cases
void test_add_positive_numbers(void) {
    int result = add(2, 3);
    ASSERT_EQUAL(5, result);
}

void test_add_negative_numbers(void) {
    int result = add(-2, -3);
    ASSERT_EQUAL(-5, result);
}

void test_factorial_zero(void) {
    int result = factorial(0);
    ASSERT_EQUAL(1, result);
}

void test_factorial_positive(void) {
    int result = factorial(5);
    ASSERT_EQUAL(120, result);
}

void test_reverse_string_basic(void) {
    char str[] = "hello";
    char* result = reverse_string(str);
    ASSERT_STRING_EQUAL("olleh", result);
}

void test_reverse_string_empty(void) {
    char str[] = "";
    char* result = reverse_string(str);
    ASSERT_STRING_EQUAL("", result);
}