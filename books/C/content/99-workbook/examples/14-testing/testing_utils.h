#ifndef TESTING_UTILS_H
#define TESTING_UTILS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Test framework structures
typedef struct TestCase {
    const char* name;
    void (*test_func)(void);
    bool passed;
    char* error_message;
    struct TestCase* next;
} TestCase;

typedef struct TestSuite {
    const char* name;
    TestCase* test_cases;
    int passed_count;
    int total_count;
    struct TestSuite* next;
} TestSuite;

// Global test registry
extern TestSuite* test_suites;

// Test framework functions
TestSuite* create_test_suite(const char* name);
TestCase* add_test_case(TestSuite* suite, const char* name, void (*test_func)(void));
void run_test_suite(TestSuite* suite);
void run_all_tests(void);
void print_test_results(void);

// Assertion macros
#define ASSERT_TRUE(condition) \
    do { \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed at %s:%d: Expected true, got false\n", __FILE__, __LINE__); \
            exit(1); \
        } \
    } while(0)

#define ASSERT_FALSE(condition) \
    do { \
        if (condition) { \
            fprintf(stderr, "Assertion failed at %s:%d: Expected false, got true\n", __FILE__, __LINE__); \
            exit(1); \
        } \
    } while(0)

#define ASSERT_EQUAL(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            fprintf(stderr, "Assertion failed at %s:%d: Expected %ld, got %ld\n", __FILE__, __LINE__, (long)(expected), (long)(actual)); \
            exit(1); \
        } \
    } while(0)

#define ASSERT_STRING_EQUAL(expected, actual) \
    do { \
        if (strcmp((expected), (actual)) != 0) { \
            fprintf(stderr, "Assertion failed at %s:%d: Expected \"%s\", got \"%s\"\n", __FILE__, __LINE__, (expected), (actual)); \
            exit(1); \
        } \
    } while(0)

#define ASSERT_NOT_NULL(ptr) \
    do { \
        if ((ptr) == NULL) { \
            fprintf(stderr, "Assertion failed at %s:%d: Expected non-NULL pointer\n", __FILE__, __LINE__); \
            exit(1); \
        } \
    } while(0)

// Mocking utilities
typedef struct MockCall {
    const char* function_name;
    int call_count;
    struct MockCall* next;
} MockCall;

extern MockCall* mock_calls;

void mock_function_called(const char* function_name);
int get_mock_call_count(const char* function_name);
void reset_mocks(void);

#endif // TESTING_UTILS_H