# Arrays

## Introduction

Arrays store multiple values of the same type in a contiguous block of memory. They are the foundation of strings, buffers, tables, and many algorithms. This chapter covers declaration, indexing, traversal, passing arrays to functions, multidimensional layout, worked algorithm programs, common bugs, and a mini-lab.

Compile examples with:

```bash
gcc -std=c17 -Wall -Wextra program.c -o program
```

## Array Declaration and Initialization

### Basic Declaration

```c
int numbers[10];         /* 10 integers (uninitialized if local) */
float temperatures[7];
char letters[26];
```

### Initialization

```c
/* Full initializer list */
int numbers[5] = {1, 2, 3, 4, 5};

/* Partial — remaining elements are zero */
int values[10] = {1, 2, 3};

/* All zeros */
int zeros[5] = {0};

/* Designated initializers (C99+) */
int array[10] = {[0] = 1, [5] = 10, [9] = 5};

/* Size inferred from initializer */
int primes[] = {2, 3, 5, 7, 11, 13};
```

### Constant Arrays

```c
const int DAYS_IN_MONTH[] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
};
```

## Access and Indexing

Indexing is zero-based. Valid indices for `int a[n]` are `0` through `n - 1`.

```c
#include <stdio.h>

int main(void) {
    int numbers[5] = {10, 20, 30, 40, 50};

    printf("First: %d\n", numbers[0]);   /* 10 */
    printf("Third: %d\n", numbers[2]);   /* 30 */
    printf("Last:  %d\n", numbers[4]);   /* 50 */

    numbers[1] = 25;
    numbers[3] = numbers[0] + numbers[2];  /* 40 */
    return 0;
}
```

### No Automatic Bounds Checking

C does **not** check indices. Out-of-range access is undefined behavior:

```c
int array[5] = {1, 2, 3, 4, 5};
array[0] = 10;   /* OK */
array[4] = 50;   /* OK */
/* array[-1] = 5; */   /* UB — do not */
/* array[10] = 100; */ /* UB — do not */
```

## Traversal

```c
#include <stdio.h>

int main(void) {
    int numbers[5] = {1, 2, 3, 4, 5};
    int size = 5;

    for (int i = 0; i < size; i++) {
        printf("a[%d] = %d\n", i, numbers[i]);
    }

    for (int i = size - 1; i >= 0; i--) {
        printf("rev a[%d] = %d\n", i, numbers[i]);
    }
    return 0;
}
```

## `sizeof` and Array Length

```c
#include <stdio.h>

#define ARRAY_LEN(a) (sizeof(a) / sizeof((a)[0]))

int main(void) {
    int numbers[10];
    printf("len = %zu\n", ARRAY_LEN(numbers));  /* 10 */
    return 0;
}
```

**Critical:** `ARRAY_LEN` only works on a real array object, not on a pointer. After an array decays to a pointer (for example as a function parameter), `sizeof` yields the pointer size, not the array size. Always pass an explicit length.

## Passing Arrays to Functions

When you pass an array, the callee receives a pointer to the first element. **Always pass the size** (or a sentinel convention you document).

### Equivalent Parameter Declarations

These three mean the same thing for the callee — a pointer:

```c
void f(int arr[], int n);
void f(int arr[10], int n);   /* 10 is ignored by the compiler for type */
void f(int *arr, int n);
```

### Full Program: Size Parameter Pattern

```c
#include <stdio.h>

void print_ints(const int *arr, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%d%s", arr[i], (i + 1 < n) ? " " : "\n");
    }
}

int sum_ints(const int *arr, size_t n) {
    int s = 0;
    for (size_t i = 0; i < n; i++) {
        s += arr[i];
    }
    return s;
}

/* WRONG idea of "getting length inside the function" */
void wrong_len_demo(int arr[]) {
    /* sizeof(arr) is sizeof(int *), not the caller's array */
    printf("wrong \"length\" calculation: %zu\n",
           sizeof(arr) / sizeof(arr[0]));
}

int main(void) {
    int data[] = {3, 1, 4, 1, 5};
    size_t n = sizeof data / sizeof data[0];

    print_ints(data, n);
    printf("sum = %d\n", sum_ints(data, n));
    wrong_len_demo(data);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra pass_array.c -o pass_array
./pass_array
```

### Optional: Static Array Size Hints (C99+)

```c
/* Documents that arr should point to at least n elements;
   some compilers can warn on misuse with the right flags. */
void process(size_t n, int arr[static n]);
```

## Multidimensional Arrays and Row-Major Layout

### 2D Declaration

```c
int matrix[3][4];   /* 3 rows, 4 columns */
int m[2][3] = {
    {1, 2, 3},
    {4, 5, 6}
};
```

### Row-Major Storage

C stores multidimensional arrays in **row-major** order: all elements of row 0, then row 1, and so on. For `int a[R][C]`, element `a[i][j]` lives at offset:

```text
index = i * C + j
```

in a flat view of `R * C` contiguous `int`s.

```c
#include <stdio.h>

int main(void) {
    int a[2][3] = {
        {10, 20, 30},
        {40, 50, 60}
    };

    int *flat = &a[0][0];
    printf("a[1][2] via [i][j]  = %d\n", a[1][2]);      /* 60 */
    printf("a[1][2] via flat    = %d\n", flat[1 * 3 + 2]); /* 60 */

    printf("memory order: ");
    for (int k = 0; k < 6; k++) {
        printf("%d ", flat[k]);  /* 10 20 30 40 50 60 */
    }
    printf("\n");
    return 0;
}
```

### Passing 2D Arrays

The callee needs the column count (or full type) so index arithmetic works:

```c
#include <stdio.h>

#define COLS 3

void print_matrix(const int m[][COLS], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < COLS; j++) {
            printf("%4d", m[i][j]);
        }
        printf("\n");
    }
}

/* Flat form: treat as one vector with explicit rows/cols */
void print_flat(const int *m, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%4d", m[i * cols + j]);
        }
        printf("\n");
    }
}

int main(void) {
    int m[2][COLS] = {{1, 2, 3}, {4, 5, 6}};
    print_matrix(m, 2);
    print_flat(&m[0][0], 2, COLS);
    return 0;
}
```

## Worked Algorithms (Full Programs)

### 1. Reverse an Array In Place

```c
#include <stdio.h>

static void reverse(int *a, size_t n) {
    for (size_t i = 0; i < n / 2; i++) {
        int tmp = a[i];
        a[i] = a[n - 1 - i];
        a[n - 1 - i] = tmp;
    }
}

static void print_arr(const int *a, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%d%s", a[i], (i + 1 < n) ? " " : "\n");
    }
}

int main(void) {
    int a[] = {1, 2, 3, 4, 5};
    size_t n = sizeof a / sizeof a[0];

    printf("before: ");
    print_arr(a, n);
    reverse(a, n);
    printf("after:  ");
    print_arr(a, n);
    return 0;
}
```

### 2. Find Minimum and Maximum

```c
#include <stdio.h>
#include <stdbool.h>

/* Returns false if n == 0; otherwise writes *min_out / *max_out. */
static bool minmax(const int *a, size_t n, int *min_out, int *max_out) {
    if (a == NULL || min_out == NULL || max_out == NULL || n == 0) {
        return false;
    }
    int lo = a[0];
    int hi = a[0];
    for (size_t i = 1; i < n; i++) {
        if (a[i] < lo) lo = a[i];
        if (a[i] > hi) hi = a[i];
    }
    *min_out = lo;
    *max_out = hi;
    return true;
}

int main(void) {
    int a[] = {7, -2, 15, 0, 9, 15, -8};
    size_t n = sizeof a / sizeof a[0];
    int lo, hi;

    if (!minmax(a, n, &lo, &hi)) {
        fprintf(stderr, "empty array\n");
        return 1;
    }
    printf("min = %d, max = %d\n", lo, hi);
    return 0;
}
```

### 3. Frequency Count

Count how often each value appears in a small range (here: digits 0–9).

```c
#include <stdio.h>
#include <string.h>

enum { RANGE = 10 };

static void count_digits(const int *a, size_t n, int freq[RANGE]) {
    memset(freq, 0, RANGE * sizeof freq[0]);
    for (size_t i = 0; i < n; i++) {
        int v = a[i];
        if (v >= 0 && v < RANGE) {
            freq[v]++;
        }
    }
}

int main(void) {
    int data[] = {1, 3, 1, 7, 3, 3, 9, 0, 1};
    size_t n = sizeof data / sizeof data[0];
    int freq[RANGE];

    count_digits(data, n, freq);

    printf("value : count\n");
    for (int v = 0; v < RANGE; v++) {
        if (freq[v] > 0) {
            printf("  %d   : %d\n", v, freq[v]);
        }
    }
    return 0;
}
```

### 4. Small Matrix Multiply (2×3 · 3×2 → 2×2)

```c
#include <stdio.h>

enum { A_ROWS = 2, A_COLS = 3, B_COLS = 2 };

/*
 * C = A * B
 * A is (A_ROWS x A_COLS), B is (A_COLS x B_COLS), C is (A_ROWS x B_COLS)
 * Row-major: C[i][j] = sum_k A[i][k] * B[k][j]
 */
static void matmul(const int A[A_ROWS][A_COLS],
                   const int B[A_COLS][B_COLS],
                   int C[A_ROWS][B_COLS]) {
    for (int i = 0; i < A_ROWS; i++) {
        for (int j = 0; j < B_COLS; j++) {
            int sum = 0;
            for (int k = 0; k < A_COLS; k++) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] = sum;
        }
    }
}

static void print_2x2(const int M[A_ROWS][B_COLS]) {
    for (int i = 0; i < A_ROWS; i++) {
        for (int j = 0; j < B_COLS; j++) {
            printf("%4d", M[i][j]);
        }
        printf("\n");
    }
}

int main(void) {
    int A[A_ROWS][A_COLS] = {
        {1, 2, 3},
        {4, 5, 6}
    };
    int B[A_COLS][B_COLS] = {
        {7, 8},
        {9, 10},
        {11, 12}
    };
    int C[A_ROWS][B_COLS];

    matmul(A, B, C);
    printf("A * B =\n");
    print_2x2(C);
    /* Expected:
       58  64
       139 154
    */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra matmul.c -o matmul
./matmul
```

### 5. Histogram of Grades

Bucket scores into letter-grade ranges and print a text histogram.

```c
#include <stdio.h>
#include <string.h>

enum { N_BUCKETS = 5 };

/* 0: F <60, 1: D 60–69, 2: C 70–79, 3: B 80–89, 4: A 90–100 */
static int grade_bucket(int score) {
    if (score < 60) return 0;
    if (score < 70) return 1;
    if (score < 80) return 2;
    if (score < 90) return 3;
    return 4;
}

static void histogram(const int *scores, size_t n, int buckets[N_BUCKETS]) {
    memset(buckets, 0, N_BUCKETS * sizeof buckets[0]);
    for (size_t i = 0; i < n; i++) {
        int s = scores[i];
        if (s < 0 || s > 100) {
            continue;  /* skip invalid */
        }
        buckets[grade_bucket(s)]++;
    }
}

static void print_bar(const char *label, int count) {
    printf("%s (%2d): ", label, count);
    for (int i = 0; i < count; i++) {
        putchar('#');
    }
    putchar('\n');
}

int main(void) {
    int scores[] = {
        95, 82, 77, 61, 54, 88, 91, 73, 66, 100,
        59, 84, 70, 45, 92
    };
    size_t n = sizeof scores / sizeof scores[0];
    int buckets[N_BUCKETS];
    const char *labels[N_BUCKETS] = {"F", "D", "C", "B", "A"};

    histogram(scores, n, buckets);

    printf("Grade histogram (%zu scores)\n", n);
    for (int i = 0; i < N_BUCKETS; i++) {
        print_bar(labels[i], buckets[i]);
    }
    return 0;
}
```

### 6. Linear Search and Selection Sort (Together)

```c
#include <stdio.h>

static int linear_search(const int *a, size_t n, int target) {
    for (size_t i = 0; i < n; i++) {
        if (a[i] == target) {
            return (int)i;
        }
    }
    return -1;
}

static void selection_sort(int *a, size_t n) {
    for (size_t i = 0; i + 1 < n; i++) {
        size_t min_i = i;
        for (size_t j = i + 1; j < n; j++) {
            if (a[j] < a[min_i]) {
                min_i = j;
            }
        }
        if (min_i != i) {
            int t = a[i];
            a[i] = a[min_i];
            a[min_i] = t;
        }
    }
}

static void print_arr(const int *a, size_t n) {
    for (size_t i = 0; i < n; i++) {
        printf("%d%s", a[i], (i + 1 < n) ? " " : "\n");
    }
}

int main(void) {
    int a[] = {64, 25, 12, 22, 11};
    size_t n = sizeof a / sizeof a[0];

    printf("index of 22: %d\n", linear_search(a, n, 22));
    selection_sort(a, n);
    printf("sorted: ");
    print_arr(a, n);
    return 0;
}
```

## Common Bugs: Wrong vs Right

### Off-by-One in Loops

```c
#include <stdio.h>

int main(void) {
    int a[5] = {1, 2, 3, 4, 5};

    /* WRONG: i <= 5 reads a[5] — out of bounds */
    /* for (int i = 0; i <= 5; i++) printf("%d\n", a[i]); */

    /* RIGHT: i < n */
    for (int i = 0; i < 5; i++) {
        printf("%d\n", a[i]);
    }
    return 0;
}
```

### Forgetting That Arrays Decay

```c
#include <stdio.h>

/* WRONG: cannot recover length from decayed pointer */
static void bad_average(int arr[]) {
    size_t n = sizeof(arr) / sizeof(arr[0]);  /* pointer size! */
    int sum = 0;
    for (size_t i = 0; i < n; i++) {
        sum += arr[i];  /* may read garbage / crash */
    }
    printf("bad avg path used n=%zu\n", n);
    (void)sum;
}

/* RIGHT */
static double good_average(const int *arr, size_t n) {
    if (n == 0) {
        return 0.0;
    }
    long sum = 0;
    for (size_t i = 0; i < n; i++) {
        sum += arr[i];
    }
    return (double)sum / (double)n;
}

int main(void) {
    int a[] = {10, 20, 30, 40};
    size_t n = sizeof a / sizeof a[0];
    printf("avg = %.2f\n", good_average(a, n));
    bad_average(a);  /* educational only — do not copy this pattern */
    return 0;
}
```

### Using Uninitialized Local Arrays

```c
/* WRONG */
int buf[10];
printf("%d\n", buf[0]);  /* indeterminate value */

/* RIGHT */
int buf[10] = {0};
/* or fill before read */
```

### Copying with `=`

```c
int a[3] = {1, 2, 3};
int b[3];
/* b = a; */  /* ILLEGAL — arrays are not assignable */

/* RIGHT */
for (int i = 0; i < 3; i++) {
    b[i] = a[i];
}
/* or memcpy(b, a, sizeof a); with <string.h> */
```

### Returning a Pointer to a Local Array

```c
/* WRONG */
int *bad(void) {
    int local[4] = {1, 2, 3, 4};
    return local;  /* dangling — storage ends when function returns */
}

/* RIGHT: caller owns the buffer */
void good(int *out, size_t n) {
    for (size_t i = 0; i < n; i++) {
        out[i] = (int)(i + 1);
    }
}
```

## Practical Examples

### Temperature Analysis

```c
#include <stdio.h>

#define DAYS 7

int main(void) {
    float temperatures[DAYS] = {18.5f, 20.0f, 19.2f, 21.5f, 17.8f, 16.0f, 22.1f};

    float sum = 0.0f;
    float max = temperatures[0];
    float min = temperatures[0];

    for (int i = 0; i < DAYS; i++) {
        sum += temperatures[i];
        if (temperatures[i] > max) max = temperatures[i];
        if (temperatures[i] < min) min = temperatures[i];
    }

    printf("Average: %.2f\n", sum / DAYS);
    printf("Maximum: %.2f\n", max);
    printf("Minimum: %.2f\n", min);
    return 0;
}
```

### Student Scores (Parallel Arrays)

```c
#include <stdio.h>

#define STUDENTS 4

int main(void) {
    const char *names[STUDENTS] = {"Ada", "Linus", "Grace", "Ken"};
    float grades[STUDENTS] = {94.0f, 88.5f, 97.0f, 91.0f};

    int top = 0;
    float sum = 0.0f;
    for (int i = 0; i < STUDENTS; i++) {
        sum += grades[i];
        if (grades[i] > grades[top]) {
            top = i;
        }
    }

    printf("Top: %s (%.1f)\n", names[top], grades[top]);
    printf("Average: %.2f\n", sum / STUDENTS);
    return 0;
}
```

## Mini-Lab: Array Toolkit

Implement a single file `array_lab.c` that:

1. Reads up to 32 integers (first number is `n`, then `n` values), **or** uses a built-in sample if you prefer non-interactive code.
2. Prints the array.
3. Prints min, max, and sum.
4. Prints a frequency table for values in `0..9` (ignore others).
5. Reverses a copy of the array and prints it (leave the original intact).

Skeleton:

```c
#include <stdio.h>
#include <string.h>

enum { MAX_N = 32 };

static void print_arr(const int *a, int n) {
    for (int i = 0; i < n; i++) {
        printf("%d%s", a[i], (i + 1 < n) ? " " : "\n");
    }
}

/* TODO: minmax, sum, freq, reverse_into */

int main(void) {
    int sample[] = {1, 4, 1, 5, 9, 2, 6, 5};
    int n = (int)(sizeof sample / sizeof sample[0]);
    int copy[MAX_N];

    printf("data: ");
    print_arr(sample, n);

    /* Fill in the rest for the lab. */
    (void)copy;
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra array_lab.c -o array_lab
./array_lab
```

## Exercises

1. **Rotate left by `k`.** Given an array and `k`, rotate elements left by `k` positions in place (or via a temp buffer). Test with `k = 0`, `k = n`, and `k > n` (normalize with `k % n`).

2. **Second largest.** Return the second-largest distinct value, or document a clear error if it does not exist.

3. **Merge sorted arrays.** Given two sorted `int` arrays, produce a third sorted array of length `n + m`.

4. **Saddle point.** In a small matrix, find an element that is the minimum of its row and maximum of its column (if any).

5. **Sparse frequency.** Count frequencies without assuming values are in `0..9` — use a parallel “value / count” table or sort-then-scan.

6. **Bounds-safe wrapper.** Write `int at(const int *a, size_t n, size_t i, int *out)` that returns `0` on success and `-1` if `i >= n`, never reading out of range.

7. **Row and column sums.** For a fixed `R×C` matrix, print each row sum and each column sum.

8. **Mini-lab completion.** Finish `array_lab.c` from above and add selection sort on a copy.

## Summary

1. Arrays are contiguous same-type storage with zero-based indices.
2. C does not bounds-check — you own every index.
3. Arrays decay to pointers at function boundaries; **pass the length**.
4. Multidimensional arrays are row-major; `a[i][j]` sits at `i * cols + j` in flat form.
5. Classic operations — reverse, min/max, frequency, matrix multiply, histograms — are loops plus careful indexing.
6. Common bugs: off-by-one, `sizeof` on parameters, uninitialized data, illegal array assignment, dangling returns.

Solid array discipline is the base for strings, pointers, and almost every algorithm you will write in C.
