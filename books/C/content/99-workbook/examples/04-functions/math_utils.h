#ifndef MATH_UTILS_H
#define MATH_UTILS_H

// Function prototypes
int add(int a, int b);
int subtract(int a, int b);
int multiply(int a, int b);
double divide(double a, double b);
int divide_int(int a, int b);
int factorial(int n);
int fibonacci(int n);
int is_prime(int num);
int gcd(int a, int b);
int lcm(int a, int b);
int *generate_fibonacci(int n);
int sum_array(int arr[], int size);
void print_current_time(void);

// Inline functions (C99)
inline int max(int a, int b) {
    return (a > b) ? a : b;
}

inline int min(int a, int b) {
    return (a < b) ? a : b;
}

// Macros
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MIN(a, b) ((a) < (b) ? (a) : (b))

#endif // MATH_UTILS_H