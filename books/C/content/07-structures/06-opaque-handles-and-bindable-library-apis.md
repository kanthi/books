---
title: "Opaque Handles and Library APIs Other Languages Can Bind"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Opaque Handles and Library APIs Other Languages Can Bind

After reading this chapter, you will be able to design, compile, and distribute C shared libraries that expose a clean, stable Application Binary Interface (ABI) easily consumed by any language with a Foreign Function Interface (FFI). You will know how to hide internal struct layouts behind opaque handles, return structured error codes instead of relying on global state, support caller-allocated memory through two-pass size queries, evolve configuration structs across releases without breaking binary compatibility, enforce strict symbol visibility at the dynamic linker level, and bind the resulting shared object from high-level runtimes using standard tools like Python's `ctypes`.

## The ABI Contract: Why Naive C APIs Break Other Languages

C is the universal lingua franca of systems programming. Runtimes as varied as Python, Rust, Go, Zig, Java, and C# can invoke C functions directly through their respective FFI layers. However, an API that feels convenient when written for another C translation unit in the same repository often becomes an unmaintainable hazard across an ABI boundary.

When a header exposes concrete struct definitions, callers compile hard-coded byte offsets and struct sizes into their binaries. If a library author adds a diagnostic counter or reorders members in a minor patch, every external caller that allocated the struct on the stack or accessed a field will read corrupted memory or smash the stack. Similarly, returning raw pointers to library-allocated memory forces callers to guess which deallocator to call—a recipe for heap corruption when the host runtime and the C library link against different allocators or different versions of the C runtime library.

A production-grade C library API must follow strict constraints:

1. **Information hiding**: Data structures are declared as incomplete types in public headers and defined only inside private translation units.
2. **Explicit lifecycle**: Every resource allocated by the library must have a corresponding release function provided by the same library.
3. **Structured return values**: Functions communicate failure via predictable status integer enums and return output data through caller-provided pointer arguments.
4. **Caller-allocated memory**: Functions producing variable-length data allow the caller to query the required buffer size first, keeping memory ownership entirely in the caller's hands.
5. **No thread-local or process-wide side effects**: Configuration and state belong to explicit context handles, and callbacks accept `void *user` state pointers to prevent reliance on global variables.
6. **Controlled symbol export**: Internal helpers and private functions must never leak into the dynamic symbol table (`.dynsym`).

## Anti-Patterns and Reliable Solutions

The following table contrasts common internal C idioms against their ABI-safe counterparts.

| Fragile Idiom / Anti-Pattern | Operational Risk Across FFI | Robust Design Solution |
|---|---|---|
| Exposing concrete `struct` layout in the public header | Altering or adding fields changes struct size and member offsets, silently corrupting external callers. | Declare an opaque handle (`typedef struct tally tally;`) in the header; define the struct solely in the `.c` file. |
| Returning pointers to internal library buffers | Callers can mutate internal state or read stale data after subsequent calls; ownership of freeing memory is ambiguous. | Caller-owned buffers: caller supplies the buffer and capacity. Support a two-pass size query with a `NULL` buffer. |
| Relying on `errno` or static error strings | Not thread-safe without runtime thread-local storage support; high-level language FFI bridges often struggle to reliably capture global variables. | Every function returns an explicit integer status code (`TALLY_OK`, `TALLY_EINVAL`, etc.); outputs are returned through pointer parameters. |
| Aborting (`assert()`, `exit()`) on invalid arguments | A single bad pointer kills the host runtime (e.g., terminating an entire Python or Java process server). | Defensive argument validation: check all pointers and ranges, returning `TALLY_EINVAL` on error without crashing. |
| Functions taking naked callback function pointers | Callers cannot pass instance state or closures without resorting to global variables, breaking reentrancy and concurrency. | Accompany every callback function pointer with a `void *user` context pointer passed back on every invocation. |
| Exporting all functions by default | Leaks implementation details, increases dynamic symbol table bloat, slows load times, and invites naming collisions. | Build with `-fvisibility=hidden` and tag only public entry points with `__attribute__((visibility("default")))`. |
| Unversioned configuration structs | Adding fields to configuration structs breaks ABI compatibility with binaries compiled against earlier headers. | Place a `size_t size` member at the start of options structs so the library can inspect how much the caller knows. |

## Designing the Tally Library

To demonstrate these principles in practice, we will build a small, robust tally library named `libtally`. The library counts distinct words, supports case-sensitive and case-insensitive matching, provides a two-pass query for the most frequent word, and allows full iteration across collected counts via a closure-style callback.

### Opaque Handles and Lifecycle Management

The public header exposes the handle as an incomplete type:

```c
typedef struct tally tally;
```

Because the compiler does not know `sizeof(struct tally)` when compiling client code, clients cannot allocate `tally` on the stack (`tally t;` fails to compile) or directly access its fields (`t->count` fails to compile). The library controls allocation through `tally_new` and destruction through `tally_free`.

Following standard POSIX and ISO C conventions, `tally_free` safely treats a `NULL` pointer as a no-op, mirroring the behavior of `free(NULL)`:

```c
void tally_free(tally *t)
{
    if (t == NULL)
        return;
    /* Clean up resources */
}
```

### Return Codes and Out-Parameters

Functions return an integer status enum indicating success or a specific failure mode:

```c
enum {
    TALLY_OK     =  0,
    TALLY_EINVAL = -1,
    TALLY_ENOMEM = -2,
    TALLY_ERANGE = -3
};
```

Actual computation results are delivered via pointer out-parameters. For example, retrieving a count takes the handle, the search key, and an out-parameter for the count:

```c
int tally_get(const tally *t, const char *word, size_t *out_count);
```

If the caller passes `NULL` for `out_count`, the function immediately yields `TALLY_EINVAL` rather than attempting a memory dereference.

### Caller-Owned Buffers and Two-Pass Size Queries

When an API returns a string or variable-length byte array, who allocates the buffer? If the library allocates the string with `malloc`, the caller must know which deallocator to invoke. In Python or Go, passing that pointer directly into standard language constructs can cause memory leaks or undefined behavior if the host runtime frees it using an incompatible allocator.

The standard solution is the two-pass buffer query, the same idea behind C's `snprintf` (called with a null buffer, it returns the length it would need) and many Windows APIs:

1. **Pass 1 (Query)**: The caller invokes the function with a `NULL` buffer pointer and a buffer length of zero. The function calculates the necessary capacity (including the null terminator), writes the size into an out-parameter `needed_len`, and returns `TALLY_OK`.
2. **Pass 2 (Fill)**: The caller allocates the requested number of bytes using its own preferred memory management mechanism and calls the function again, passing the pointer and the allocated capacity. If the caller provides insufficient capacity, the function returns `TALLY_ERANGE`.

```c
int tally_top_word(const tally *t, char *buf, size_t buf_len, size_t *needed_len, size_t *out_count);
```

### Versioned Options Structs

When a library introduces new configuration toggles across minor versions, naive struct signatures force an ABI break. By placing `size_t size` as the very first member of the options struct, the library can safely determine which version of the struct the caller was compiled against:

```c
typedef struct tally_options {
    size_t size;        /* Must be sizeof(tally_options) */
    int case_sensitive;
} tally_options;
```

The caller initializes the struct with its current compile-time size:

```c
tally_options opts = {
    .size = sizeof(opts),
    .case_sensitive = 1
};
```

The library validates `opts->size`. If the caller passes a size smaller than the base requirements, the library returns `TALLY_EINVAL`. If a future version adds new fields, older binaries passing a smaller `size` will cause the new library to apply sensible default values for the missing fields, preserving forward and backward compatibility.

### Symbol Visibility and Dynamic Linker Sonames

By default, GCC exports every non-static function into the shared library's dynamic symbol table (`.dynsym`). In a shared library, this exposes private helper routines, pollutes the public namespace and costs performance. An exported function can be interposed by another library at load time, so calls to it go through the PLT and are harder for the compiler to inline.

To lock down exports, we compile with `-fvisibility=hidden` and annotate public APIs with a visibility macro:

```c
#if defined(__GNUC__) && __GNUC__ >= 4
  #define TALLY_API __attribute__((visibility("default")))
#else
  #define TALLY_API
#endif
```

During linkage, setting `-Wl,-soname,libtally.so.1` embeds the library's logical ABI version directly into the ELF header (`DT_SONAME`). When an executable links against `libtally.so`, the dynamic linker (`ld.so`) records a dependency on `libtally.so.1` rather than the unversioned development symlink.

## Library Implementation

Below are the complete source files for `libtally`. The implementation is written in ISO C17 and stays under 200 lines while remaining strictly defensive against malformed input.

<!-- file: tally.h -->
```c
#ifndef TALLY_H
#define TALLY_H

#include <stddef.h>

#if defined(_WIN32) || defined(__CYGWIN__)
  #ifdef TALLY_BUILDING_DLL
    #define TALLY_API __declspec(dllexport)
  #else
    #define TALLY_API __declspec(dllimport)
  #endif
#elif defined(__GNUC__) && __GNUC__ >= 4
  #define TALLY_API __attribute__((visibility("default")))
#else
  #define TALLY_API
#endif

enum {
    TALLY_OK     =  0,
    TALLY_EINVAL = -1,
    TALLY_ENOMEM = -2,
    TALLY_ERANGE = -3
};

typedef struct tally tally;

typedef struct tally_options {
    size_t size;
    int case_sensitive;
} tally_options;

typedef int (*tally_iter_fn)(const char *word, size_t count, void *user);

TALLY_API int tally_new(const tally_options *opts, tally **out);
TALLY_API void tally_free(tally *t);
TALLY_API int tally_add(tally *t, const char *word);
TALLY_API int tally_get(const tally *t, const char *word, size_t *out_count);
TALLY_API int tally_top_word(const tally *t, char *buf, size_t buf_len, size_t *needed_len, size_t *out_count);
TALLY_API int tally_iterate(const tally *t, tally_iter_fn callback, void *user);

#endif /* TALLY_H */
```

<!-- file: tally.c -->
```c
#include "tally.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

struct tally_entry {
    char *word;
    size_t count;
};

struct tally {
    struct tally_entry *entries;
    size_t count;
    size_t capacity;
    int case_sensitive;
};

static int words_equal(const char *a, const char *b, int case_sensitive)
{
    if (case_sensitive)
        return strcmp(a, b) == 0;
    while (*a && *b) {
        if (tolower((unsigned char)*a) != tolower((unsigned char)*b))
            return 0;
        a++;
        b++;
    }
    return *a == *b;
}

int tally_new(const tally_options *opts, tally **out)
{
    if (out == NULL)
        return TALLY_EINVAL;
    *out = NULL;

    int case_sensitive = 0;
    if (opts != NULL) {
        if (opts->size < sizeof(size_t))
            return TALLY_EINVAL;
        if (opts->size >= sizeof(tally_options))
            case_sensitive = opts->case_sensitive;
    }

    tally *t = calloc(1, sizeof(*t));
    if (t == NULL)
        return TALLY_ENOMEM;

    t->case_sensitive = case_sensitive;
    *out = t;
    return TALLY_OK;
}

void tally_free(tally *t)
{
    if (t == NULL)
        return;
    for (size_t i = 0; i < t->count; i++)
        free(t->entries[i].word);
    free(t->entries);
    free(t);
}

int tally_add(tally *t, const char *word)
{
    if (t == NULL || word == NULL)
        return TALLY_EINVAL;

    for (size_t i = 0; i < t->count; i++) {
        if (words_equal(t->entries[i].word, word, t->case_sensitive)) {
            t->entries[i].count++;
            return TALLY_OK;
        }
    }

    if (t->count == t->capacity) {
        size_t new_cap = (t->capacity == 0) ? 8 : t->capacity * 2;
        struct tally_entry *new_entries = realloc(t->entries, new_cap * sizeof(*new_entries));
        if (new_entries == NULL)
            return TALLY_ENOMEM;
        t->entries = new_entries;
        t->capacity = new_cap;
    }

    size_t len = strlen(word);
    char *copy = malloc(len + 1);
    if (copy == NULL)
        return TALLY_ENOMEM;
    memcpy(copy, word, len + 1);

    t->entries[t->count].word = copy;
    t->entries[t->count].count = 1;
    t->count++;
    return TALLY_OK;
}

int tally_get(const tally *t, const char *word, size_t *out_count)
{
    if (t == NULL || word == NULL || out_count == NULL)
        return TALLY_EINVAL;

    for (size_t i = 0; i < t->count; i++) {
        if (words_equal(t->entries[i].word, word, t->case_sensitive)) {
            *out_count = t->entries[i].count;
            return TALLY_OK;
        }
    }

    *out_count = 0;
    return TALLY_OK;
}

int tally_top_word(const tally *t, char *buf, size_t buf_len, size_t *needed_len, size_t *out_count)
{
    if (t == NULL || needed_len == NULL)
        return TALLY_EINVAL;

    if (t->count == 0) {
        *needed_len = 1;
        if (out_count != NULL)
            *out_count = 0;
        if (buf != NULL && buf_len > 0)
            buf[0] = '\0';
        return TALLY_OK;
    }

    size_t best_idx = 0;
    for (size_t i = 1; i < t->count; i++) {
        if (t->entries[i].count > t->entries[best_idx].count)
            best_idx = i;
    }

    const char *best_word = t->entries[best_idx].word;
    size_t req = strlen(best_word) + 1;
    *needed_len = req;
    if (out_count != NULL)
        *out_count = t->entries[best_idx].count;

    if (buf == NULL)
        return TALLY_OK;

    if (buf_len < req)
        return TALLY_ERANGE;

    memcpy(buf, best_word, req);
    return TALLY_OK;
}

int tally_iterate(const tally *t, tally_iter_fn callback, void *user)
{
    if (t == NULL || callback == NULL)
        return TALLY_EINVAL;

    for (size_t i = 0; i < t->count; i++) {
        int rc = callback(t->entries[i].word, t->entries[i].count, user);
        if (rc != 0)
            break;
    }
    return TALLY_OK;
}
```

## Consuming the Library in C

The following demonstration client exercises the entire public API: initializing options, handling bad parameters defensively, querying counts, performing two-pass buffer size queries, and iterating with closures.

<!-- file: demo.c -->
```c
#include "tally.h"
#include <stdio.h>
#include <stdlib.h>

static int print_entry(const char *word, size_t count, void *user)
{
    size_t *total_words = (size_t *)user;
    *total_words += count;
    printf("  %s: %zu\n", word, count);
    return 0;
}

int main(void)
{
    tally_options opts = {
        .size = sizeof(opts),
        .case_sensitive = 0
    };

    tally *t = NULL;
    int rc = tally_new(&opts, &t);
    if (rc != TALLY_OK) {
        fprintf(stderr, "Failed to initialize tally: error %d\n", rc);
        return 1;
    }

    /* Verify defensive handling of NULL input */
    int null_check_1 = tally_add(NULL, "orphan");
    int null_check_2 = tally_add(t, NULL);
    printf("NULL check return values: %d, %d\n", null_check_1, null_check_2);

    /* Populate words (case-insensitive test) */
    tally_add(t, "pipeline");
    tally_add(t, "Pipeline");
    tally_add(t, "socket");
    tally_add(t, "socket");
    tally_add(t, "socket");
    tally_add(t, "buffer");

    /* Direct lookups */
    size_t count = 0;
    tally_get(t, "pipeline", &count);
    printf("Count for 'pipeline': %zu\n", count);
    tally_get(t, "socket", &count);
    printf("Count for 'socket': %zu\n", count);

    /* Two-pass buffer query for the most frequent word */
    size_t needed = 0;
    size_t top_count = 0;
    rc = tally_top_word(t, NULL, 0, &needed, &top_count);
    printf("Pass 1 (size query): rc=%d, needed_bytes=%zu\n", rc, needed);

    /* Verify bounds protection */
    char tiny_buf[2];
    rc = tally_top_word(t, tiny_buf, sizeof(tiny_buf), &needed, &top_count);
    printf("Small buffer check: rc=%d (expected ERANGE=%d)\n", rc, TALLY_ERANGE);

    /* Pass 2: Allocate caller-owned buffer and retrieve */
    char *word_buf = malloc(needed);
    if (word_buf != NULL) {
        rc = tally_top_word(t, word_buf, needed, &needed, &top_count);
        printf("Pass 2 (retrieval): '%s' with count %zu (rc=%d)\n", word_buf, top_count, rc);
        free(word_buf);
    }

    /* Iteration with accumulator passed via void *user */
    size_t aggregate = 0;
    puts("Tallied entries:");
    tally_iterate(t, print_entry, &aggregate);
    printf("Total tokens processed: %zu\n", aggregate);

    /* Cleanup */
    tally_free(t);
    tally_free(NULL); /* Safe no-op */

    return 0;
}
```

To build the shared object, set up the soname symlink, and compile the client executable against the library:

```bash
gcc -std=c17 -Wall -Wextra -O2 -fPIC -fvisibility=hidden -shared -Wl,-soname,libtally.so.1 -o libtally.so.1 tally.c && ln -sf libtally.so.1 libtally.so && gcc -std=c17 -Wall -Wextra -O2 demo.c -L. -ltally -Wl,-rpath,'$ORIGIN' -o demo && ./demo
```

The following command executed the compilation pipeline and ran the demo binary:
```text
NULL check return values: -1, -1
Count for 'pipeline': 2
Count for 'socket': 3
Pass 1 (size query): rc=0, needed_bytes=7
Small buffer check: rc=-3 (expected ERANGE=-3)
Pass 2 (retrieval): 'socket' with count 3 (rc=0)
Tallied entries:
  pipeline: 2
  socket: 3
  buffer: 1
Total tokens processed: 6
```

Notice that both `NULL` invocations return `-1` (`TALLY_EINVAL`) without triggering a segmentation fault. The small buffer check returns `-3` (`TALLY_ERANGE`), protecting the caller against memory corruption. When supplied with the queried buffer size, the library copies the string into memory allocated and managed strictly by the caller.

Next, verify that `-fvisibility=hidden` successfully suppressed internal functions from the exported dynamic symbol table:

```bash
nm -D --defined-only libtally.so.1
```

The following command inspected the exported symbols of the compiled shared library:
```text
00000000000012e0 T tally_add
0000000000001280 T tally_free
0000000000001450 T tally_get
0000000000001630 T tally_iterate
0000000000001210 T tally_new
0000000000001520 T tally_top_word
```

The output shows only the six functions marked `TALLY_API`. The helper `words_equal` is missing for a simpler reason: it is `static`, and static functions never reach the dynamic symbol table. `-fvisibility=hidden` matters for the next helper you write. That's a non-`static` function in one `.c` file that another `.c` file of the library calls. Without the flag, it would be exported and someone would eventually bind to it.

The soname shows up on the consumer's side too. Running `readelf -d demo | grep NEEDED` on the client built above prints:

```text
 0x0000000000000001 (NEEDED)             Shared library: [libtally.so.1]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
```

The client recorded `libtally.so.1`, not the `libtally.so` development symlink it was linked through.

## Binding from Python via ctypes

Because the API relies entirely on primitive scalar types, opaque pointers, explicit memory lengths, and standard calling conventions, binding `libtally` from Python requires no third-party generators or native C extensions. Standard library `ctypes` handles the interface directly.

<!-- file: bind.py -->
```python
import ctypes
import os
import sys

# Locate and load the shared library
so_path = os.path.abspath("libtally.so.1")
try:
    lib = ctypes.CDLL(so_path)
except OSError as err:
    print(f"Failed to load shared library: {err}", file=sys.stderr)
    sys.exit(1)

# Status constants
TALLY_OK = 0
TALLY_EINVAL = -1
TALLY_ENOMEM = -2
TALLY_ERANGE = -3

# Options struct matching tally_options layout
class TallyOptions(ctypes.Structure):
    _fields_ = [
        ("size", ctypes.c_size_t),
        ("case_sensitive", ctypes.c_int),
    ]

# Callback prototype: int (*)(const char *word, size_t count, void *user)
ITER_CALLBACK = ctypes.CFUNCTYPE(
    ctypes.c_int,
    ctypes.c_char_p,
    ctypes.c_size_t,
    ctypes.c_void_p
)

# Function prototype signatures
lib.tally_new.argtypes = [ctypes.POINTER(TallyOptions), ctypes.POINTER(ctypes.c_void_p)]
lib.tally_new.restype = ctypes.c_int

lib.tally_free.argtypes = [ctypes.c_void_p]
lib.tally_free.restype = None

lib.tally_add.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
lib.tally_add.restype = ctypes.c_int

lib.tally_get.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.POINTER(ctypes.c_size_t)]
lib.tally_get.restype = ctypes.c_int

lib.tally_top_word.argtypes = [
    ctypes.c_void_p,
    ctypes.c_char_p,
    ctypes.c_size_t,
    ctypes.POINTER(ctypes.c_size_t),
    ctypes.POINTER(ctypes.c_size_t)
]
lib.tally_top_word.restype = ctypes.c_int

lib.tally_iterate.argtypes = [ctypes.c_void_p, ITER_CALLBACK, ctypes.c_void_p]
lib.tally_iterate.restype = ctypes.c_int

def main():
    # Initialize versioned options struct
    opts = TallyOptions(size=ctypes.sizeof(TallyOptions), case_sensitive=0)
    handle = ctypes.c_void_p()

    rc = lib.tally_new(ctypes.byref(opts), ctypes.byref(handle))
    if rc != TALLY_OK:
        raise RuntimeError(f"tally_new failed with code {rc}")

    # Add sample data
    tokens = [b"stream", b"Stream", b"STREAM", b"buffer", b"kernel", b"kernel"]
    for token in tokens:
        rc = lib.tally_add(handle, token)
        if rc != TALLY_OK:
            raise RuntimeError(f"tally_add failed with code {rc}")

    # Single item lookup
    count_val = ctypes.c_size_t()
    lib.tally_get(handle, b"stream", ctypes.byref(count_val))
    print(f"Lookup 'stream': {count_val.value}")

    # Two-pass size query for top item
    needed = ctypes.c_size_t()
    top_count = ctypes.c_size_t()
    rc = lib.tally_top_word(handle, None, 0, ctypes.byref(needed), ctypes.byref(top_count))
    if rc != TALLY_OK:
        raise RuntimeError(f"Size query failed with code {rc}")

    # Allocate caller buffer in Python ctypes memory
    buf = ctypes.create_string_buffer(needed.value)
    rc = lib.tally_top_word(handle, buf, needed.value, ctypes.byref(needed), ctypes.byref(top_count))
    if rc != TALLY_OK:
        raise RuntimeError(f"Buffer retrieval failed with code {rc}")

    print(f"Top word: {buf.value.decode('utf-8')} (occurrences: {top_count.value})")

    # Callback iteration collected into Python list
    results = []
    def python_collector(word_ptr, count, user_ptr):
        results.append((word_ptr.decode("utf-8"), count))
        return 0

    c_callback = ITER_CALLBACK(python_collector)
    rc = lib.tally_iterate(handle, c_callback, None)
    if rc != TALLY_OK:
        raise RuntimeError(f"Iteration failed with code {rc}")

    print("Iterated items:", results)

    # Release handle
    lib.tally_free(handle)

if __name__ == "__main__":
    main()
```

Run the binding script:

```bash
python3 bind.py
```

The following command executed the Python ctypes verification script:
```text
Lookup 'stream': 3
Top word: stream (occurrences: 3)
Iterated items: [('stream', 3), ('buffer', 1), ('kernel', 2)]
```

Because `opts.case_sensitive` was set to `0`, all casing variations of `stream` collapse into a single bucket, making it the most frequent word. The Python script never interacted with internal C pointers or guessed struct offsets.

## Pitfalls

### 1. Ownership of Returned Strings Across Language runtimes

Never return a heap-allocated `char *` from a C library that expects the caller to free it using standard `free()`. On platforms like Windows, a shared library may link against a different C Runtime (CRT) dynamic link library (DLL) than the host executable or runtime. Calling `free()` in one CRT on a pointer allocated by another results in immediate heap corruption. In garbage-collected environments like Python, Java, or Go, managing native heap lifecycles outside of the language runtime creates leaks. 

Always prefer caller-allocated buffers with two-pass size queries. If the library must allocate memory on behalf of the caller, export an explicit deallocator (such as `tally_string_free(char *str)`) that calls `free()` inside the same DSO.

### 2. Callbacks Reentering the Library

When an API executes a user-provided callback during traversal (`tally_iterate`), the caller's code runs synchronously on the same thread. If the callback attempts to mutate the instance by calling `tally_add` or destroys the instance with `tally_free`, the loop inside the library can read reallocated or freed arrays, which is a use-after-free. If a later version adds a lock, it can deadlock.

Document reentrancy invariants clearly: mark traversal functions as non-reentrant or enforce internal state guards (such as an iteration counter) that return an error if a reentrant mutation is attempted during an active callback.

### 3. Struct Size Versioning Rules

The versioned options pattern (`size_t size` as the first field) requires strict adherence to two rules:

1. **Strict member ordering**: New members must only ever be appended to the end of the struct. Never insert a field between existing fields or reorder fields, as this changes field offsets and corrupts reads by binaries compiled against older headers.
2. **Padding and alignment awareness**: Compilers pad struct members to match architecture alignment requirements. Always check that the provided `opts->size` reaches at least `offsetof(tally_options, field) + sizeof(field)` before reading that field from the caller.

## Key Takeaways

- **Opaque handles eliminate ABI coupling**: Defining structs exclusively inside the C implementation hides memory layouts and allows internal data structures to change without breaking external callers.
- **Explicit lifecycles guarantee memory safety**: Pair every constructor (`tally_new`) with a destructor (`tally_free`) that tolerates `NULL` pointers.
- **Status return codes provide unambiguous control flow**: Return error enums from functions and pass outputs through pointers to ensure compatibility with foreign language error handling.
- **Two-pass size queries respect caller ownership**: Allowing callers to query buffer sizes with `NULL` pointers keeps heap allocation decisions firmly within the calling language.
- **Versioned structs support backward compatibility**: Placing a `size_t size` header on configuration structs allows APIs to grow without breaking existing compiled binaries.
- **Stateless callbacks enable clean foreign closures**: Accompanying callback function pointers with `void *user` parameters allows foreign runtimes to associate state without relying on global variables.
- **Hidden symbol visibility produces tidy DSOs**: Compiling with `-fvisibility=hidden` and annotating public interfaces with `__attribute__((visibility("default")))` restricts dynamic exports exclusively to intentional entry points.

## Sources

- [GCC Wiki: Visibility](https://gcc.gnu.org/wiki/Visibility)
- [How To Write Shared Libraries (Ulrich Drepper)](https://www.akkadia.org/drepper/dsohowto.pdf)
- [Python ctypes Documentation](https://docs.python.org/3/library/ctypes.html)
- [GCC manual: Code Gen Options (`-fvisibility`)](https://gcc.gnu.org/onlinedocs/gcc/Code-Gen-Options.html)
