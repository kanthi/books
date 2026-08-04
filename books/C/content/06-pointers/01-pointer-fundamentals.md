# Pointer Fundamentals

## Introduction

A pointer is a variable that stores the **address** of another object, not the object’s value itself. Pointers unlock efficient parameter passing, dynamic data structures, and low-level system programming. This chapter builds intuition with step-by-step memory pictures, complete programs, `const` combinations, `void *`, array/pointer relationships, and out-parameters.

Compile with:

```bash
gcc -std=c17 -Wall -Wextra program.c -o program
```

## What Is a Pointer?

Every object in your program lives at a memory address. The address-of operator `&` yields that address; the dereference operator `*` follows a pointer to the object.

```c
#include <stdio.h>

int main(void) {
    int x = 42;
    printf("Value of x:   %d\n", x);
    printf("Address of x: %p\n", (void *)&x);
    return 0;
}
```

Always cast to `void *` when printing with `%p`.

## Visual Step-by-Step: `&` and `*`

Think of memory as numbered boxes. Variable names label boxes; pointers hold box numbers.

### Step 1 — Create an `int`

```c
int x = 42;
```

```text
  name: x
  ┌────────┐
  │   42   │   address e.g. 0x1000
  └────────┘
```

### Step 2 — Point at it

```c
int *p = &x;   /* p holds the address of x */
```

```text
  name: p                      name: x
  ┌──────────┐                 ┌────────┐
  │  0x1000  │ ──────────────► │   42   │  0x1000
  └──────────┘                 └────────┘
```

### Step 3 — Read through the pointer

```c
int y = *p;    /* y becomes 42 */
```

`*p` means “the `int` sitting at the address stored in `p`.”

### Step 4 — Write through the pointer

```c
*p = 99;       /* x is now 99 */
```

```text
  p ──► x: 99
```

### Full Demo Program

```c
#include <stdio.h>

int main(void) {
    int x = 42;
    int *p = &x;

    printf("1) x=%d  &x=%p  p=%p  *p=%d\n",
           x, (void *)&x, (void *)p, *p);

    *p = 99;
    printf("2) after *p=99: x=%d  *p=%d\n", x, *p);

    x = 7;
    printf("3) after x=7:   x=%d  *p=%d\n", x, *p);

    int z = 100;
    p = &z;
    printf("4) p now points at z: *p=%d  x still %d\n", *p, x);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra ptr_steps.c -o ptr_steps
./ptr_steps
```

## Declaration and Initialization

```c
int *ptr;           /* pointer to int (uninitialized — dangerous) */
char *cptr;
float *fptr;

int x = 42;
int *p1 = &x;       /* initialized */
int *p2 = NULL;     /* safe empty pointer */
int *p3 = 0;        /* also null */
```

### Null Pointers

```c
#include <stdio.h>

int main(void) {
    int *p = NULL;

    if (p != NULL) {
        printf("%d\n", *p);
    } else {
        printf("Pointer is null — do not dereference\n");
    }
    return 0;
}
```

Never dereference `NULL`. On most systems that crashes; the language only says the behavior is undefined.

## Swap via Pointers (Full Program)

Pass-by-value cannot swap the caller’s variables. Pass pointers (addresses) so the function can write back.

### Why Values Alone Fail

```c
#include <stdio.h>

/* This does NOT swap the caller's x and y */
static void swap_by_value(int a, int b) {
    int t = a;
    a = b;
    b = t;
}

int main(void) {
    int x = 10, y = 20;
    swap_by_value(x, y);
    printf("still x=%d y=%d\n", x, y);  /* 10 20 */
    return 0;
}
```

### Correct Swap with Pointers

```c
#include <stdio.h>

static void swap(int *a, int *b) {
    if (a == NULL || b == NULL) {
        return;
    }
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main(void) {
    int x = 10, y = 20;
    printf("before: x=%d y=%d\n", x, y);

    swap(&x, &y);

    printf("after:  x=%d y=%d\n", x, y);  /* 20 10 */
    return 0;
}
```

Picture of the call:

```text
main:  x=10   y=20
         ▲      ▲
         │      │
swap:    a      b     (a and b hold addresses)
         *a ↔ *b      (values exchanged)
```

```bash
gcc -std=c17 -Wall -Wextra swap.c -o swap
./swap
```

## `const` and Pointers: Three Combinations

`const` can protect the **data**, the **pointer**, or **both**.

| Declaration | Can change `*p`? | Can reassign `p`? |
|-------------|------------------|-------------------|
| `const int *p` | no | yes |
| `int *const p` | yes | no |
| `const int *const p` | no | no |
| `int *p` | yes | yes |

### Full Program

```c
#include <stdio.h>

int main(void) {
    int x = 10;
    int y = 20;

    /* 1) Pointer to const int — data is read-only through p */
    const int *p1 = &x;
    printf("p1 -> %d\n", *p1);
    /* *p1 = 99; */          /* ERROR: discards const */
    p1 = &y;                 /* OK: pointer may move */
    printf("p1 now -> %d\n", *p1);

    /* 2) Const pointer to int — pointer frozen, data mutable */
    int *const p2 = &x;
    *p2 = 11;                /* OK */
    /* p2 = &y; */           /* ERROR: p2 is const */
    printf("x is now %d\n", x);

    /* 3) Const pointer to const int — both frozen */
    const int *const p3 = &y;
    printf("p3 -> %d\n", *p3);
    /* *p3 = 0; */           /* ERROR */
    /* p3 = &x; */           /* ERROR */

    /* Reading is always fine for all three */
    printf("read-only views: %d %d %d\n", *p1, *p2, *p3);
    return 0;
}
```

### Why `const int *` Appears in APIs

```c
/* Caller knows print_ints will not modify the buffer */
void print_ints(const int *a, size_t n);
```

That is a promise to the reader and a constraint the compiler helps enforce (unless you cast const away — don’t).

### Note on `const int *` vs `int const *`

These are the **same**: pointer to const int. Read declarations right-to-left: `const int *p` → “`p` is a pointer to const int.”

## `void *` with Careful Casting

`void *` is a generic object pointer. You can convert to and from other object pointer types, but you **must not** dereference a `void *` without casting to a concrete type first.

### Full Program: Generic Swap of Bytes

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Swap n bytes between the objects pointed to by a and b. */
static int memswap(void *a, void *b, size_t n) {
    if (a == NULL || b == NULL) {
        return -1;
    }
    if (n == 0) {
        return 0;
    }
    unsigned char *p = a;   /* implicit void* → unsigned char* */
    unsigned char *q = b;
    for (size_t i = 0; i < n; i++) {
        unsigned char t = p[i];
        p[i] = q[i];
        q[i] = t;
    }
    return 0;
}

static void print_ints(const char *label, const int *a, size_t n) {
    printf("%s:", label);
    for (size_t i = 0; i < n; i++) {
        printf(" %d", a[i]);
    }
    printf("\n");
}

int main(void) {
    int u = 5, v = 9;
    memswap(&u, &v, sizeof u);
    printf("u=%d v=%d\n", u, v);

    int a[] = {1, 2, 3};
    int b[] = {7, 8, 9};
    memswap(a, b, sizeof a);
    print_ints("a", a, 3);
    print_ints("b", b, 3);

    /* Careful cast example: recover a typed pointer from void* */
    void *raw = a;
    int *typed = (int *)raw;   /* explicit cast for clarity */
    printf("typed[0]=%d\n", typed[0]);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra void_swap.c -o void_swap
./void_swap
```

### Rules of Thumb for `void *`

1. Use for generic buffers, allocators (`malloc` returns `void *`), and callbacks.
2. Cast to the **actual** type before arithmetic or dereference.
3. Keep size information alongside the pointer when the type is erased.
4. Do not cast `void *` to function pointers (different category in C).

## Pointer Arithmetic (Brief)

Arithmetic scales by the size of the pointed-to type:

```c
#include <stdio.h>

int main(void) {
    int arr[5] = {10, 20, 30, 40, 50};
    int *p = arr;  /* same as &arr[0] */

    printf("*p       = %d\n", *p);       /* 10 */
    printf("*(p+1)   = %d\n", *(p + 1)); /* 20 */
    printf("p[2]     = %d\n", p[2]);     /* 30 — syntactic sugar */

    p++;
    printf("after p++: %d\n", *p);       /* 20 */
    return 0;
}
```

`p[i]` is defined as `*(p + i)`.

## Pointers vs Arrays: Equivalence and Differences

### Where They Look the Same

In most expression contexts, an array name **decays** to a pointer to its first element:

```c
int a[4] = {1, 2, 3, 4};
int *p = a;       /* decay */
int *q = &a[0];   /* same address */

/* These all refer to the third element (value 3) */
a[2];
*(a + 2);
p[2];
*(p + 2);
```

### Where They Differ

| | Array `int a[4]` | Pointer `int *p` |
|--|------------------|------------------|
| Storage | Holds 4 ints | Holds one address |
| `sizeof` | `4 * sizeof(int)` | `sizeof(int *)` |
| Assignability | `a = …` illegal | `p = …` OK |
| Address | `&a` is `int (*)[4]` | `&p` is `int **` |
| Lifetime | As declared (e.g. auto) | Points wherever you set |

### Full Comparison Program

```c
#include <stdio.h>

static void show_param(int arr[]) {
    /* arr is really int * here */
    printf("  sizeof(param) = %zu (pointer, not array)\n", sizeof arr);
}

int main(void) {
    int a[4] = {1, 2, 3, 4};
    int *p = a;

    printf("sizeof(a) = %zu\n", sizeof a);   /* e.g. 16 */
    printf("sizeof(p) = %zu\n", sizeof p);   /* e.g. 8 */

    printf("a[2]=%d p[2]=%d\n", a[2], p[2]);

    p = &a[1];   /* OK */
    /* a = p; */ /* ERROR: array is not assignable */

    show_param(a);

    /* &a vs &a[0] */
    printf("&a    = %p (pointer to whole array)\n", (void *)&a);
    printf("&a[0] = %p (pointer to first int)\n", (void *)&a[0]);
    printf("same address, different types/sizeof arithmetic\n");
    return 0;
}
```

## Out-Parameters: Return Status Separately from Data

A common C pattern: return an `int` status (`0` success, non-zero error) and write results through pointer out-parameters.

### Full Program

```c
#include <stdio.h>
#include <stdbool.h>

enum {
    OK = 0,
    ERR_NULL = -1,
    ERR_RANGE = -2,
    ERR_EMPTY = -3
};

/* Divide n / d into *quot_out. */
static int safe_div(int n, int d, int *quot_out) {
    if (quot_out == NULL) {
        return ERR_NULL;
    }
    if (d == 0) {
        return ERR_RANGE;
    }
    *quot_out = n / d;
    return OK;
}

/* Find max of a[0..n). */
static int array_max(const int *a, size_t n, int *max_out) {
    if (a == NULL || max_out == NULL) {
        return ERR_NULL;
    }
    if (n == 0) {
        return ERR_EMPTY;
    }
    int m = a[0];
    for (size_t i = 1; i < n; i++) {
        if (a[i] > m) {
            m = a[i];
        }
    }
    *max_out = m;
    return OK;
}

/* Parse a simple non-negative integer from a C string. */
static int parse_u32(const char *s, unsigned *out) {
    if (s == NULL || out == NULL) {
        return ERR_NULL;
    }
    if (*s == '\0') {
        return ERR_EMPTY;
    }
    unsigned value = 0;
    for (const char *p = s; *p != '\0'; p++) {
        if (*p < '0' || *p > '9') {
            return ERR_RANGE;
        }
        value = value * 10u + (unsigned)(*p - '0');
    }
    *out = value;
    return OK;
}

int main(void) {
    int q;
    if (safe_div(42, 5, &q) == OK) {
        printf("42/5 = %d\n", q);
    }
    if (safe_div(42, 0, &q) != OK) {
        printf("division by zero handled\n");
    }

    int data[] = {3, 9, 2, 9, 5};
    int mx;
    if (array_max(data, 5, &mx) == OK) {
        printf("max = %d\n", mx);
    }

    unsigned u;
    if (parse_u32("12345", &u) == OK) {
        printf("parsed %u\n", u);
    }
    if (parse_u32("12x", &u) != OK) {
        printf("reject bad digits\n");
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra outparams.c -o outparams
./outparams
```

### Design Tips

1. Document who allocates and who frees any pointer you return.
2. Prefer `const T *` for inputs you only read.
3. Check for `NULL` out-parameters when the API is public.
4. Do not leave `*out` half-written on failure unless you document it; either write only on success or define failure values.

## Pointers and Functions (More)

### Returning a Pointer into a Caller-Owned Array

```c
#include <stdio.h>

/* Returns pointer to first element equal to target, or NULL. */
static int *find_int(int *a, size_t n, int target) {
    for (size_t i = 0; i < n; i++) {
        if (a[i] == target) {
            return &a[i];
        }
    }
    return NULL;
}

int main(void) {
    int nums[] = {10, 50, 30, 40, 20};
    int *hit = find_int(nums, 5, 40);
    if (hit != NULL) {
        printf("found %d at offset %td\n", *hit, hit - nums);
        *hit = 41;  /* modify through returned pointer */
    }
    printf("nums[3]=%d\n", nums[3]);
    return 0;
}
```

Safe because the array lives in `main` longer than the pointer is used.

### Unsafe: Returning Address of Local

```c
/* NEVER do this */
static int *bad(void) {
    int local = 42;
    return &local;  /* dangling */
}
```

## Pointer Comparison and Size

```c
#include <stdio.h>

int main(void) {
    int arr[5] = {10, 20, 30, 40, 50};
    int *p1 = &arr[1];
    int *p2 = &arr[4];

    if (p1 < p2) {
        printf("p1 before p2 in the same array\n");
    }
    printf("element distance: %td\n", p2 - p1);  /* 3 */

    printf("sizeof(int*)  = %zu\n", sizeof(int *));
    printf("sizeof(char*) = %zu\n", sizeof(char *));
    /* Same size on typical platforms; type still matters for arithmetic */
    return 0;
}
```

Relational comparisons are only defined for pointers into the same array object (or one past the end).

## Best Practices

1. **Initialize** every pointer (`NULL` or a valid address).
2. **Check** for `NULL` before dereference when the value might be empty.
3. Prefer **`const`** on pointer parameters that only read data.
4. Do not return addresses of **automatic** locals.
5. Keep **size** next to raw buffers and `void *`.
6. Use **out-parameters + status** instead of overloading return values for both data and errors when both matter.
7. Compile with **`-Wall -Wextra`**; treat warnings as bugs.

## Practical Examples

### Pointer-Based String Reverse

```c
#include <stdio.h>
#include <string.h>

static void reverse_string(char *str) {
    if (str == NULL || *str == '\0') {
        return;
    }
    char *start = str;
    char *end = str + strlen(str) - 1;
    while (start < end) {
        char temp = *start;
        *start = *end;
        *end = temp;
        start++;
        end--;
    }
}

int main(void) {
    char str[] = "Hello, World!";  /* must be mutable array */
    printf("Original: %s\n", str);
    reverse_string(str);
    printf("Reversed: %s\n", str);
    return 0;
}
```

### Sum with Pointer Walking

```c
#include <stdio.h>

static int sum_array(const int *arr, size_t n) {
    int sum = 0;
    const int *end = arr + n;
    for (const int *p = arr; p < end; p++) {
        sum += *p;
    }
    return sum;
}

int main(void) {
    int numbers[] = {1, 2, 3, 4, 5};
    size_t n = sizeof numbers / sizeof numbers[0];
    printf("Sum: %d\n", sum_array(numbers, n));
    return 0;
}
```

## Exercises

1. **Trace on paper.** For `int x=3; int *p=&x; *p=5; int y=*p;`, draw boxes after each statement.

2. **Swap three ways.** Implement swap of two `int`s with pointers; of two `double`s; and a generic `memswap` with `void *` and `sizeof`.

3. **`const` experiments.** Write four small snippets that should fail to compile for illegal uses of `const int *`, `int *const`, and `const int *const`. Confirm with `gcc -std=c17 -Wall -Wextra`.

4. **Out-parameter min/max.** `int minmax(const int *a, size_t n, int *min_out, int *max_out)` returning status codes; write a driver that tests empty and null cases.

5. **Find and replace.** Return a pointer to the first space in a mutable string; replace that space with `'_'` through the pointer.

6. **Array vs pointer quiz.** Print `sizeof` for an array and for a pointer parameter that “receives” it. Explain the numbers in a comment.

7. **`void *` printer.** Write `void print_bytes(const void *p, size_t n)` that prints `n` bytes in hex by casting to `const unsigned char *`.

8. **Pointer distance.** Given two pointers into the same array, print how many elements lie between them. What happens if they are not from the same array? (Do not rely on that case.)

## Summary

1. Pointers store **addresses**; `*` accesses the object; `&` produces an address.
2. **Swap and out-parameters** are the classic reasons to pass pointers to functions.
3. **`const`** can lock data, the pointer variable, or both — use it in APIs.
4. **`void *`** erases type; cast carefully and track sizes.
5. Arrays **decay** to pointers but are not the same as pointers (`sizeof`, assignment).
6. Always initialize, avoid dangling pointers, and return status separately when needed.

Mastering these fundamentals makes every later C topic — arrays, strings, dynamic memory, data structures — much easier to reason about.
