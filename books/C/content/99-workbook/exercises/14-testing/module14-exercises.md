# Module 14: Testing and Quality Assurance Exercises

## Exercise 1: Unit Testing Framework Implementation
Write a program that implements a simple unit testing framework:
- Create basic assertion functions for different data types
- Implement a test runner that executes test cases
- Develop a reporting system for test results
- Show how to organize test cases into test suites
- Demonstrate proper test fixture setup and teardown

**Requirements:**
- Implement assertions for common data types (int, float, string, etc.)
- Create a simple test registration and execution system
- Include detailed reporting with pass/fail counts and timing
- Show how to handle expected failures and skip conditions
- Provide clear examples of test organization

## Exercise 2: Mocking and Stubbing Techniques
Create a program that demonstrates mocking and stubbing techniques:
- Implement simple mock objects for function dependencies
- Show how to replace real implementations with test doubles
- Demonstrate proper use of function pointers for mocking
- Implement a simple mocking framework
- Show how to verify mock interactions

**Requirements:**
- Include examples of state-based and behavior-based testing
- Demonstrate proper isolation of units under test
- Show how to handle complex dependencies with mocks
- Implement proper mock verification mechanisms
- Provide clear documentation of mocking techniques

## Exercise 3: Integration Testing Implementation
Develop a program that implements integration testing:
- Create tests that verify interactions between multiple components
- Show how to set up and tear down integration test environments
- Demonstrate proper test data management for integration tests
- Implement tests for API interactions and data flow
- Show how to handle external dependencies in integration tests

**Requirements:**
- Include examples of component integration testing
- Demonstrate proper test environment setup and cleanup
- Show how to handle test data dependencies and isolation
- Implement tests for complex system interactions
- Provide clear documentation of integration testing strategies

## Exercise 4: Code Coverage Analysis
Write a program that demonstrates code coverage analysis:
- Implement instrumentation to track code execution
- Create a coverage reporting system
- Show how to measure different types of coverage (line, branch, path)
- Demonstrate proper coverage goal setting and tracking
- Show how to identify untested code paths

**Requirements:**
- Include examples of coverage instrumentation techniques
- Implement proper coverage measurement and reporting
- Show how to handle complex control flow in coverage analysis
- Demonstrate coverage-guided test development
- Provide clear documentation of coverage analysis results

## Exercise 5: Static Analysis and Linting
Create a program that demonstrates static analysis techniques:
- Implement simple static analysis checks for common issues
- Show how to integrate static analysis tools into the build process
- Demonstrate proper configuration of static analysis rules
- Implement custom static analysis checks
- Show how to handle static analysis findings

**Requirements:**
- Include examples of common static analysis checks
- Demonstrate proper integration with development workflow
- Show how to configure and customize analysis rules
- Implement proper handling of false positives
- Provide clear documentation of static analysis results

## Exercise 6: Fuzz Testing Implementation
Write a program that implements fuzz testing techniques:
- Create a simple fuzz testing framework
- Implement input generation strategies for fuzz testing
- Show how to monitor for crashes and unexpected behavior
- Demonstrate proper fuzz test case reduction
- Show how to integrate fuzz testing into the testing pipeline

**Requirements:**
- Include examples of different fuzzing strategies
- Implement proper crash detection and reporting
- Show how to generate meaningful test inputs
- Demonstrate proper handling of fuzz test results
- Provide clear documentation of fuzz testing techniques

## Exercise 7: Performance and Stress Testing
Create a program that implements performance and stress testing:
- Develop tests that verify performance requirements
- Implement stress tests that push system limits
- Show how to measure and report performance metrics
- Demonstrate proper test environment setup for performance testing
- Show how to identify performance bottlenecks

**Requirements:**
- Include examples of performance benchmarking
- Implement proper metrics collection and reporting
- Show how to handle performance test data analysis
- Demonstrate proper test environment configuration
- Provide clear documentation of performance test results

## Exercise 8: Comprehensive Testing Strategy
Design a complete testing strategy that integrates all testing techniques:
- Implement a comprehensive test suite covering all testing types
- Create a testing pipeline that executes different test categories
- Demonstrate proper test prioritization and execution ordering
- Show how to maintain test quality and reliability
- Provide clear documentation and reporting

**Requirements:**
- Use modular design with clear test organization
- Include comprehensive test coverage across all areas
- Demonstrate proper test maintenance and evolution
- Implement robust error handling throughout the testing system
- Provide clear examples and test documentation

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Simple unit testing framework

// Test result structure
typedef struct {
    int passed;
    int failed;
    int skipped;
    double total_time;
} test_result_t;

// Global test result tracker
static test_result_t g_test_result = {0};

// Assertion functions
#define ASSERT_TRUE(condition) \
    do { \
        if (!(condition)) { \
            printf("ASSERT_TRUE failed at %s:%d\n", __FILE__, __LINE__); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_FALSE(condition) \
    do { \
        if (condition) { \
            printf("ASSERT_FALSE failed at %s:%d\n", __FILE__, __LINE__); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_EQUAL(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            printf("ASSERT_EQUAL failed at %s:%d: expected %d, got %d\n", \
                   __FILE__, __LINE__, (expected), (actual)); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_STRING_EQUAL(expected, actual) \
    do { \
        if (strcmp((expected), (actual)) != 0) { \
            printf("ASSERT_STRING_EQUAL failed at %s:%d: expected '%s', got '%s'\n", \
                   __FILE__, __LINE__, (expected), (actual)); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

// Test function type
typedef void (*test_func_t)(void);

// Test case structure
typedef struct {
    const char *name;
    test_func_t function;
} test_case_t;

// Example functions to test
int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

const char* get_hello_message(void) {
    return "Hello, World!";
}

// Test cases
void test_add_positive(void) {
    ASSERT_EQUAL(5, add(2, 3));
}

void test_add_negative(void) {
    ASSERT_EQUAL(-1, add(2, -3));
}

void test_subtract(void) {
    ASSERT_EQUAL(2, subtract(5, 3));
}

void test_string_message(void) {
    ASSERT_STRING_EQUAL("Hello, World!", get_hello_message());
}

// Test suite
test_case_t test_suite[] = {
    {"test_add_positive", test_add_positive},
    {"test_add_negative", test_add_negative},
    {"test_subtract", test_subtract},
    {"test_string_message", test_string_message},
    {NULL, NULL}  // Sentinel
};

// Test runner
void run_tests(void) {
    printf("Running tests...\n");
    
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    
    for (int i = 0; test_suite[i].name != NULL; i++) {
        printf("Running %s... ", test_suite[i].name);
        
        // Reset test counters for each test
        int initial_passed = g_test_result.passed;
        int initial_failed = g_test_result.failed;
        
        test_suite[i].function();
        
        if (g_test_result.failed > initial_failed) {
            printf("FAILED\n");
        } else {
            printf("PASSED\n");
        }
    }
    
    clock_gettime(CLOCK_MONOTONIC, &end);
    g_test_result.total_time = (end.tv_sec - start.tv_sec) + 
                              (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Print summary
    printf("\nTest Results:\n");
    printf("Passed: %d\n", g_test_result.passed);
    printf("Failed: %d\n", g_test_result.failed);
    printf("Skipped: %d\n", g_test_result.skipped);
    printf("Total time: %.6f seconds\n", g_test_result.total_time);
    
    if (g_test_result.failed == 0) {
        printf("All tests passed!\n");
    } else {
        printf("Some tests failed!\n");
    }
}

int main() {
    run_tests();
    return g_test_result.failed > 0 ? 1 : 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Mocking framework example

// Real database interface
typedef struct {
    int (*connect)(const char *host, int port);
    int (*query)(const char *sql, char **result);
    void (*disconnect)(void);
} database_interface_t;

// Real database implementation
static int real_db_connect(const char *host, int port) {
    printf("Connecting to database at %s:%d\n", host, port);
    return 1; // Success
}

static int real_db_query(const char *sql, char **result) {
    printf("Executing query: %s\n", sql);
    *result = strdup("Mock query result");
    return 1; // Success
}

static void real_db_disconnect(void) {
    printf("Disconnecting from database\n");
}

database_interface_t real_database = {
    .connect = real_db_connect,
    .query = real_db_query,
    .disconnect = real_db_disconnect
};

// Mock database implementation
static int mock_connect_calls = 0;
static int mock_query_calls = 0;
static int mock_disconnect_calls = 0;
static int mock_connect_result = 1;
static int mock_query_result = 1;

static int mock_db_connect(const char *host, int port) {
    mock_connect_calls++;
    printf("Mock connect called (%d times)\n", mock_connect_calls);
    return mock_connect_result;
}

static int mock_db_query(const char *sql, char **result) {
    mock_query_calls++;
    printf("Mock query called (%d times): %s\n", mock_query_calls, sql);
    *result = strdup("Mock result");
    return mock_query_result;
}

static void mock_db_disconnect(void) {
    mock_disconnect_calls++;
    printf("Mock disconnect called (%d times)\n", mock_disconnect_calls);
}

database_interface_t mock_database = {
    .connect = mock_db_connect,
    .query = mock_db_query,
    .disconnect = mock_db_disconnect
};

// Function under test
int fetch_user_data(database_interface_t *db, const char *user_id, char **data) {
    if (!db->connect("localhost", 5432)) {
        return 0;
    }
    
    char sql[256];
    snprintf(sql, sizeof(sql), "SELECT * FROM users WHERE id = '%s'", user_id);
    
    int result = db->query(sql, data);
    db->disconnect();
    
    return result;
}

// Test with mock
void test_fetch_user_data_success(void) {
    // Reset mock counters
    mock_connect_calls = 0;
    mock_query_calls = 0;
    mock_disconnect_calls = 0;
    mock_connect_result = 1;
    mock_query_result = 1;
    
    char *data = NULL;
    int result = fetch_user_data(&mock_database, "123", &data);
    
    // Verify results
    if (result != 1) {
        printf("Test failed: Expected success, got failure\n");
        return;
    }
    
    if (mock_connect_calls != 1) {
        printf("Test failed: Expected 1 connect call, got %d\n", mock_connect_calls);
        return;
    }
    
    if (mock_query_calls != 1) {
        printf("Test failed: Expected 1 query call, got %d\n", mock_query_calls);
        return;
    }
    
    if (mock_disconnect_calls != 1) {
        printf("Test failed: Expected 1 disconnect call, got %d\n", mock_disconnect_calls);
        return;
    }
    
    printf("Test passed: All mock interactions verified\n");
    free(data);
}

void test_fetch_user_data_connection_failure(void) {
    // Reset mock counters
    mock_connect_calls = 0;
    mock_query_calls = 0;
    mock_disconnect_calls = 0;
    mock_connect_result = 0; // Simulate connection failure
    
    char *data = NULL;
    int result = fetch_user_data(&mock_database, "123", &data);
    
    // Verify results
    if (result != 0) {
        printf("Test failed: Expected failure, got success\n");
        return;
    }
    
    if (mock_connect_calls != 1) {
        printf("Test failed: Expected 1 connect call, got %d\n", mock_connect_calls);
        return;
    }
    
    // Should not call query or disconnect on connection failure
    if (mock_query_calls != 0) {
        printf("Test failed: Expected 0 query calls, got %d\n", mock_query_calls);
        return;
    }
    
    if (mock_disconnect_calls != 0) {
        printf("Test failed: Expected 0 disconnect calls, got %d\n", mock_disconnect_calls);
        return;
    }
    
    printf("Test passed: Connection failure handled correctly\n");
}

int main() {
    printf("Testing with mock database...\n");
    test_fetch_user_data_success();
    test_fetch_user_data_connection_failure();
    
    printf("\nFor comparison, running with real database:\n");
    char *data = NULL;
    fetch_user_data(&real_database, "123", &data);
    free(data);
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Testing implementation details**: Focus on behavior rather than implementation
2. **Insufficient test coverage**: Ensure adequate coverage of edge cases and error conditions
3. **Flaky tests**: Write deterministic tests that produce consistent results
4. **Over-mocking**: Don't mock everything; focus on complex or external dependencies
5. **Ignoring test maintenance**: Keep tests up-to-date with code changes

### Best Practices:
1. **Test pyramid**: Follow the testing pyramid (unit > integration > end-to-end)
2. **Descriptive test names**: Use clear, descriptive names for test cases
3. **Isolated tests**: Ensure tests don't depend on each other or shared state
4. **Fast feedback**: Keep tests fast to encourage frequent execution
5. **Continuous testing**: Integrate testing into the development workflow

Complete these exercises to solidify your understanding of testing and quality assurance in C. Each exercise builds upon the previous ones, gradually increasing in complexity.