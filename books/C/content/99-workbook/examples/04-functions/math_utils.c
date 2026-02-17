#include "math_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Static variables (internal linkage)
static int internal_counter = 0;

// Function implementations
int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

int multiply(int a, int b) {
    return a * b;
}

double divide(double a, double b) {
    if (b == 0.0) {
        printf("Error: Division by zero\n");
        return 0.0;
    }
    return a / b;
}

int divide_int(int a, int b) {
    if (b == 0) {
        printf("Error: Division by zero\n");
        return 0;
    }
    return a / b;
}

int factorial(int n) {
    if (n < 0) return -1;  // Error case
    if (n == 0 || n == 1) return 1;
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    
    int prev = 0, curr = 1;
    for (int i = 2; i <= n; i++) {
        int next = prev + curr;
        prev = curr;
        curr = next;
    }
    return curr;
}

int is_prime(int num) {
    if (num <= 1) return 0;
    if (num <= 3) return 1;
    if (num % 2 == 0 || num % 3 == 0) return 0;
    
    for (int i = 5; i * i <= num; i += 6) {
        if (num % i == 0 || num % (i + 2) == 0) {
            return 0;
        }
    }
    return 1;
}

int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

int *generate_fibonacci(int n) {
    if (n <= 0) return NULL;
    
    int *fib = (int*)malloc(n * sizeof(int));
    if (fib == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    if (n >= 1) fib[0] = 0;
    if (n >= 2) fib[1] = 1;
    
    for (int i = 2; i < n; i++) {
        fib[i] = fib[i-1] + fib[i-2];
    }
    
    return fib;
}

int sum_array(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

void print_current_time(void) {
    time_t rawtime;
    time(&rawtime);
    printf("Current time: %s", ctime(&rawtime));
}

// Functions to demonstrate static variables
int get_internal_counter(void) {
    return internal_counter;
}

void increment_internal_counter(void) {
    internal_counter++;
}