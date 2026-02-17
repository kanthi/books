#include "testing_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Global test registry
TestSuite* test_suites = NULL;

// Mock call tracking
MockCall* mock_calls = NULL;

// Create a test suite
TestSuite* create_test_suite(const char* name) {
    TestSuite* suite = (TestSuite*)malloc(sizeof(TestSuite));
    if (suite == NULL) {
        fprintf(stderr, "Failed to allocate memory for test suite\n");
        return NULL;
    }
    
    suite->name = name;
    suite->test_cases = NULL;
    suite->passed_count = 0;
    suite->total_count = 0;
    suite->next = test_suites;
    test_suites = suite;
    
    return suite;
}

// Add a test case to a suite
TestCase* add_test_case(TestSuite* suite, const char* name, void (*test_func)(void)) {
    if (suite == NULL || test_func == NULL) {
        return NULL;
    }
    
    TestCase* test_case = (TestCase*)malloc(sizeof(TestCase));
    if (test_case == NULL) {
        fprintf(stderr, "Failed to allocate memory for test case\n");
        return NULL;
    }
    
    test_case->name = name;
    test_case->test_func = test_func;
    test_case->passed = false;
    test_case->error_message = NULL;
    test_case->next = suite->test_cases;
    suite->test_cases = test_case;
    suite->total_count++;
    
    return test_case;
}

// Run a single test suite
void run_test_suite(TestSuite* suite) {
    if (suite == NULL) {
        return;
    }
    
    printf("Running test suite: %s\n", suite->name);
    printf("========================\n");
    
    TestCase* test_case = suite->test_cases;
    while (test_case != NULL) {
        printf("  Running test: %s ... ", test_case->name);
        
        // Run the test
        test_case->test_func();
        
        // If we reach here, the test passed
        test_case->passed = true;
        suite->passed_count++;
        printf("PASSED\n");
        
        test_case = test_case->next;
    }
    
    printf("\n  Results: %d/%d tests passed\n\n", suite->passed_count, suite->total_count);
}

// Run all test suites
void run_all_tests(void) {
    TestSuite* suite = test_suites;
    while (suite != NULL) {
        run_test_suite(suite);
        suite = suite->next;
    }
}

// Print overall test results
void print_test_results(void) {
    int total_passed = 0;
    int total_tests = 0;
    
    TestSuite* suite = test_suites;
    while (suite != NULL) {
        total_passed += suite->passed_count;
        total_tests += suite->total_count;
        suite = suite->next;
    }
    
    printf("========================================\n");
    printf("Overall Test Results: %d/%d tests passed\n", total_passed, total_tests);
    if (total_passed == total_tests) {
        printf("All tests PASSED!\n");
    } else {
        printf("%d tests FAILED!\n", total_tests - total_passed);
    }
    printf("========================================\n");
}

// Mock function call tracking
void mock_function_called(const char* function_name) {
    MockCall* call = mock_calls;
    
    // Check if we already have a record for this function
    while (call != NULL) {
        if (strcmp(call->function_name, function_name) == 0) {
            call->call_count++;
            return;
        }
        call = call->next;
    }
    
    // Create a new record
    call = (MockCall*)malloc(sizeof(MockCall));
    if (call == NULL) {
        fprintf(stderr, "Failed to allocate memory for mock call\n");
        return;
    }
    
    call->function_name = function_name;
    call->call_count = 1;
    call->next = mock_calls;
    mock_calls = call;
}

// Get mock call count for a function
int get_mock_call_count(const char* function_name) {
    MockCall* call = mock_calls;
    while (call != NULL) {
        if (strcmp(call->function_name, function_name) == 0) {
            return call->call_count;
        }
        call = call->next;
    }
    return 0;
}

// Reset all mocks
void reset_mocks(void) {
    MockCall* call = mock_calls;
    while (call != NULL) {
        MockCall* next = call->next;
        free(call);
        call = next;
    }
    mock_calls = NULL;
}