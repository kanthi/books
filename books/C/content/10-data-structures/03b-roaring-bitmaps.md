---
title: "Roaring Bitmaps from Scratch: Array, Bitmap and Run Containers"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Roaring Bitmaps from Scratch: Array, Bitmap and Run Containers

After this page you will understand how a Roaring bitmap is laid out, you will have built a small two-level version in C that switches a container from array to bitmap on its own, and you will be able to work out when an array, bitmap or run container is the smallest choice.

## Why Compressed Bitmaps?

Bitmaps are fundamental data structures in database engines, search engines, and data analytics systems. In an inverted index, a bitmap can represent the set of document IDs containing a specific search term. In analytical engines, bitmaps speed up filters, set operations (intersection, union, difference) and counting.

A plain uncompressed bitmap maps each integer identifier directly to a bit position in an array of words. For a 32-bit unsigned integer space ($0$ to $2^{32}-1$), a traditional dense bitmap requires exactly $2^{32} \text{ bits} = 512 \text{ MiB}$ of contiguous memory. While this provides $O(1)$ set membership checks and fast bitwise CPU vectorization, it introduces massive memory overhead when representing sparse datasets. For instance, storing just 1,000 sparse 32-bit integers in a plain bitmap still consumes 512 MiB, whereas a simple array of 32-bit integers (`uint32_t`) takes only 4,000 bytes.

Conversely, sorted arrays of 32-bit integers are memory-efficient for sparse data (consuming 4 bytes per entry), but performing set membership or intersections requires binary search or multi-way merge operations, scaling with $O(\log N)$ or $O(N)$ time complexity instead of fast word-aligned bitwise arithmetic.

To solve this dilemma, compressed bitmap formats balance memory efficiency with high-performance operations. Early compressed bitmap designs such as WAH (Word-Aligned Hybrid) and EWAH (Enhanced Word-Aligned Hybrid) rely on Run-Length Encoding (RLE). While RLE compresses long sequences of identical bits effectively, it limits random access speed because indexing into an arbitrary position requires decoding previous compressed runs sequentially.

Roaring bitmaps, introduced by Chambi, Lemire, Kaser and Godin (2016) and described in more detail by Lemire et al. (2018), take a different approach. They split the 32-bit space into two levels and pick a container format for each chunk to suit how dense it is. Lucene, Druid, ClickHouse and Pilosa use them, and CRoaring is the reference C library.

## The Two-Level Layout

Roaring splits every 32-bit integer $x$ into two 16-bit components:

1. **High 16 bits (`x >> 16`)**: Serves as a chunk key (ranging from $0$ to $65535$).
2. **Low 16 bits (`x & 0xFFFF`)**: Stored inside a container corresponding to that chunk key.

Because the upper 16 bits partition the value space into $2^{16} = 65,536$ logical chunks, each individual container never holds more than $65,536$ distinct 16-bit integers ($0$ to $65,535$).

Empty chunks take no memory. The top level is a sorted array of the keys that are in use, each paired with its container.

| Layer | Component | Range / Description | Memory Footprint |
| :--- | :--- | :--- | :--- |
| **Top Level** | Key Array / Directory | Sorted list of active high-16-bit chunk keys | Dynamic ($2 \text{ bytes per key} + \text{pointer}$) |
| **Container Level** | Low-16 Storage | Holds low-16-bit values for a specific chunk key | Up to $8 \text{ KiB}$ payload per chunk |

So memory is only spent on parts of the 32-bit range that actually hold values.

## Containers and the 4096 Rule

Inside each chunk, Roaring selects one of three primary container types depending on the density and pattern of the low-16-bit values:

1. **Array Container**: Stores the low 16 bits of each value as a sorted array of `uint16_t`. It is used when the container holds at most 4,096 values.
2. **Bitmap Container**: Stores presence or absence of values using a fixed $2^{16}\text{-bit}$ array ($65,536 \text{ bits} = 8,192 \text{ bytes} = 8 \text{ KiB}$), represented as 1,024 64-bit words (`uint64_t`). It is used when a container holds more than 4,096 values.
3. **Run Container**: Stores continuous sequences (runs) of consecutive values as pairs of 16-bit integers: `(start_value, run_length)`. Each run takes $2 + 2 = 4 \text{ bytes}$, plus 2 bytes for the run count. (The format stores length minus one, so a full chunk is the single run `(0, 65535)`.)

### The Break-Even Calculation

The boundary between array containers and bitmap containers is strictly derived from memory efficiency:

- Each value in an **Array Container** consumes 2 bytes ($16 \text{ bits}$).
- A **Bitmap Container** occupies a fixed payload of $8,192 \text{ bytes}$ ($65,536 \text{ bits}$), regardless of how many values are present.

Setting the memory consumption of both structures equal determines the threshold:

$$\text{Cardinality} \times 2 \text{ bytes} = 8,192 \text{ bytes}$$

$$\text{Cardinality} = \frac{8,192}{2} = 4,096$$

When a container holds fewer than 4,096 values, an array container consumes less memory than an 8 KiB bitmap container (e.g., 1,000 values consume $2,000 \text{ bytes}$). At 4,096 values, an array container consumes exactly $4,096 \times 2 = 8,192 \text{ bytes}$, matching the fixed bitmap size. When cardinality exceeds 4,096, an array container would consume more than 8,192 bytes (e.g., 5,000 values would consume $10,000 \text{ bytes}$), making the bitmap container strictly more compact.


### Run Container Trade-off

Run containers are for consecutive values. Take the 10,000 integers $100,000$ to $109,999$. They all have key 1, and their low parts are 34,464 to 44,463. As an array that would be 20,000 bytes, more than the 4,096-value limit allows, so they go in an 8,192-byte bitmap. As one run, `(34464, 9999)`, they take $2 \text{ bytes (count)} + 4 \text{ bytes (run)} = 6 \text{ bytes}$.

## Implementation Walk-through

The program below has array and bitmap containers. It turns an array container into a bitmap when the array is full at 4,096 values, finds containers by binary search on the keys, and reports what each container would cost as a run container. It does **not** store run containers or implement set operations; those are exercises at the end.

<!-- file: roaring.c -->
```c
/* A minimal Roaring-style bitmap: 32-bit values split into a 16-bit key
 * (high bits, selects a container) and a 16-bit low part stored in either
 * an array container (sorted uint16_t, up to 4096 values) or a bitmap
 * container (65536 bits = 8 KiB). Run containers are measured, not stored. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_MAX 4096

typedef struct {
    uint16_t key;
    int is_bitmap;
    uint32_t card;      /* number of values in the container */
    uint16_t *array;    /* used when !is_bitmap, capacity ARRAY_MAX */
    uint64_t *bits;     /* used when is_bitmap, 1024 words */
} container;

typedef struct {
    container *c;
    size_t n, cap;
} roaring;

static container *find_or_add(roaring *r, uint16_t key) {
    size_t lo = 0, hi = r->n;
    while (lo < hi) { /* binary search on keys */
        size_t mid = (lo + hi) / 2;
        if (r->c[mid].key < key) lo = mid + 1; else hi = mid;
    }
    if (lo < r->n && r->c[lo].key == key)
        return &r->c[lo];
    if (r->n == r->cap) {
        r->cap = r->cap ? r->cap * 2 : 4;
        r->c = realloc(r->c, r->cap * sizeof *r->c);
        if (!r->c) { perror("realloc"); exit(1); }
    }
    memmove(&r->c[lo + 1], &r->c[lo], (r->n - lo) * sizeof *r->c);
    r->n++;
    container *c = &r->c[lo];
    memset(c, 0, sizeof *c);
    c->key = key;
    c->array = malloc(ARRAY_MAX * sizeof *c->array);
    if (!c->array) { perror("malloc"); exit(1); }
    return c;
}

static void to_bitmap(container *c) {
    c->bits = calloc(1024, sizeof *c->bits);
    if (!c->bits) { perror("calloc"); exit(1); }
    for (uint32_t i = 0; i < c->card; i++)
        c->bits[c->array[i] >> 6] |= UINT64_C(1) << (c->array[i] & 63);
    free(c->array);
    c->array = NULL;
    c->is_bitmap = 1;
}

static void roaring_add(roaring *r, uint32_t x) {
    container *c = find_or_add(r, (uint16_t)(x >> 16));
    uint16_t low = (uint16_t)x;
    if (c->is_bitmap) {
        uint64_t m = UINT64_C(1) << (low & 63);
        if (!(c->bits[low >> 6] & m)) { c->bits[low >> 6] |= m; c->card++; }
        return;
    }
    uint32_t lo = 0, hi = c->card; /* binary search in the sorted array */
    while (lo < hi) {
        uint32_t mid = (lo + hi) / 2;
        if (c->array[mid] < low) lo = mid + 1; else hi = mid;
    }
    if (lo < c->card && c->array[lo] == low)
        return;
    if (c->card == ARRAY_MAX) { /* array full: switch representation */
        to_bitmap(c);
        roaring_add(r, x);
        return;
    }
    memmove(&c->array[lo + 1], &c->array[lo], (c->card - lo) * sizeof *c->array);
    c->array[lo] = low;
    c->card++;
}

static int roaring_contains(const roaring *r, uint32_t x) {
    uint16_t key = (uint16_t)(x >> 16), low = (uint16_t)x;
    for (size_t i = 0; i < r->n; i++) {
        const container *c = &r->c[i];
        if (c->key != key) continue;
        if (c->is_bitmap) return (c->bits[low >> 6] >> (low & 63)) & 1;
        for (uint32_t j = 0; j < c->card; j++) if (c->array[j] == low) return 1;
        return 0;
    }
    return 0;
}

static int test_low(const container *c, uint32_t v) {
    if (c->is_bitmap) return (c->bits[v >> 6] >> (v & 63)) & 1;
    for (uint32_t j = 0; j < c->card; j++) if (c->array[j] == v) return 1;
    return 0;
}

/* Count runs of consecutive values: a run container needs 4 bytes per run. */
static uint32_t count_runs(const container *c) {
    uint32_t runs = 0;
    int prev = 0;
    for (uint32_t v = 0; v < 65536; v++) {
        int cur = test_low(c, v);
        if (cur && !prev) runs++;
        prev = cur;
    }
    return runs;
}

static void report(const char *name, const roaring *r) {
    uint64_t total = 0, bytes = 0, best = 0;
    for (size_t i = 0; i < r->n; i++) {
        const container *c = &r->c[i];
        uint32_t runs = count_runs(c);
        uint64_t arr = 2ull * c->card, bm = 8192, run = 2 + 4ull * runs;
        uint64_t now = c->is_bitmap ? bm : arr;
        uint64_t min = arr < bm ? arr : bm;
        if (run < min) min = run;
        total += c->card; bytes += now; best += min;
    }
    printf("%-14s values=%-8llu containers=%-3zu bytes=%-8llu with-runs=%-8llu plain-u32=%llu\n",
           name, (unsigned long long)total, r->n, (unsigned long long)bytes,
           (unsigned long long)best, (unsigned long long)total * 4);
    for (size_t i = 0; i < r->n && i < 3; i++)
        printf("    key=%-5u %-6s card=%u\n", r->c[i].key,
               r->c[i].is_bitmap ? "bitmap" : "array", r->c[i].card);
}

static void roaring_free(roaring *r) {
    for (size_t i = 0; i < r->n; i++) { free(r->c[i].array); free(r->c[i].bits); }
    free(r->c);
}

int main(void) {
    roaring sparse = {0}, dense = {0}, ranges = {0};
    srand(42);
    for (int i = 0; i < 1000; i++) roaring_add(&sparse, (uint32_t)rand() * 7u);
    for (uint32_t i = 0; i < 200000; i++) if (rand() % 2) roaring_add(&dense, i);
    for (uint32_t i = 1000000; i < 1300000; i++) roaring_add(&ranges, i);

    report("sparse", &sparse);
    report("dense-random", &dense);
    report("one-range", &ranges);

    printf("contains(1000123)=%d contains(999999)=%d\n",
           roaring_contains(&ranges, 1000123), roaring_contains(&ranges, 999999));
    roaring_free(&sparse); roaring_free(&dense); roaring_free(&ranges);
    return 0;
}
```

### Function Breakdowns

- `find_or_add`: Performs a binary search over the array of container keys (`r->c[mid].key`). If the high 16 bits match an existing key, it returns that container. If missing, it uses `memmove` to make room and inserts a new container in key order. To keep the code short, every new array container is allocated at full capacity, `ARRAY_MAX` values (8 KiB), up front. A real library grows arrays as needed.
- `to_bitmap`: Upgrades an array container to a bitmap container. It allocates $1,024$ 64-bit words ($8,192 \text{ bytes}$) zero-initialized via `calloc`, iterates over the existing sorted `array` entries, sets bit `(val & 63)` in word `(val >> 6)`, frees the array buffer, and sets `is_bitmap = 1`.
- `roaring_add`: Extracts high (`x >> 16`) and low (`x & 0xFFFF`) parts. If the container is already a bitmap, it sets the corresponding bit. If it is an array container, it uses binary search to find the insertion index for `low`. If the value exists, it returns early; if the array contains `ARRAY_MAX` elements, it calls `to_bitmap(c)` and then `roaring_add` again, which now takes the bitmap path.
- `roaring_contains`: kept deliberately simple, it scans the keys and the array linearly. Exercise 3 asks you to make it binary-search both.
- `count_runs`: Scans low-16 bit values from 0 to 65535 to count transitions from 0 to 1 (`cur && !prev`), calculating how many run segments `(start, length)` would be needed to store the container's contents.
- `report`: for each set, prints the total payload in its current containers (`bytes`), the payload if every container used its cheapest format, run containers included (`with-runs`), and a plain `uint32_t` array (`plain-u32`, 4 bytes per value). The counts are payload only: no key array, no container structs, no allocator overhead, and not the full-size array allocations mentioned above.

Compile it. With gcc 14.2 this gives no warnings, and an `-fsanitize=address,undefined` build prints the same output with no reports:

```bash
gcc -std=c17 -Wall -Wextra -O2 -o roaring roaring.c
```

Run it:

```bash
./roaring
```

```text
sparse         values=1000     containers=995 bytes=2000     with-runs=2000     plain-u32=4000
    key=30    array  card=1
    key=91    array  card=1
    key=109   array  card=1
dense-random   values=99704    containers=4   bytes=28006    with-runs=27970    plain-u32=398816
    key=0     bitmap card=32552
    key=1     bitmap card=32790
    key=2     bitmap card=32647
one-range      values=300000   containers=5   bytes=40960    with-runs=30       plain-u32=1200000
    key=15    bitmap card=48576
    key=16    bitmap card=65536
    key=17    bitmap card=65536
contains(1000123)=1 contains(999999)=0
```

## Reading the Results

Each set prints a summary line and its first three containers.

1. **Sparse Dataset (`sparse`)**:
   - Holds 1,000 random values spread across the full 32-bit range.
   - The values are scattered over the whole range, so almost every value gets its own container: 995 containers for 1,000 values.
   - Each is an array container with one value, 2 bytes of payload, so the payload total is 2,000 bytes against 4,000 for a plain `uint32_t` array.
   - *That comparison flatters Roaring.* The payload count leaves out the 995 key entries and container structs, which are far bigger than 2 bytes each (and this toy allocates 8 KiB per array on top). For data this sparse, per-container overhead dominates, and a plain sorted array is the smaller format.

2. **Dense Random Dataset (`dense-random`)**:
   - Holds 99,704 values, about half of `0` to `199,999`, chosen at random.
   - Keys 0, 1 and 2 cover full 65,536-value chunks with about 32,600 values each, far above 4,096, so they are bitmaps at 8,192 bytes each.
   - Key 3 only covers 196,608 to 199,999 and holds about 1,700 values, so it stays an array (about 3,400 bytes). That gives 28,006 bytes in total.
   - A plain array would need 398,816 bytes. Random data has few long runs, so run containers barely help here (27,970).

3. **Sequential Range Dataset (`one-range`)**:
   - Stores 300,000 consecutive integers spanning `1,000,000` to `1,299,999`.
   - The range touches keys 15 to 19: five containers, each with far more than 4,096 values, so five bitmaps, 40,960 bytes.
   - Within each container the values are one unbroken run (a full chunk is `(0, 65535)`; the two ends are partial runs), so as run containers they would need $2 + 4 = 6$ bytes each, 30 bytes in all.
   - The last line checks membership: 1,000,123 is in the range and 999,999 is not.

## What Real Roaring Adds

CRoaring and the other production libraries add a lot on top of this.

### Run Optimization Pass

Adding values one at a time doesn't turn containers into run containers. In CRoaring you ask for it explicitly (some operations, such as adding a whole range, can produce run containers directly):

```c
roaring_bitmap_run_optimize(bitmap);
```

It checks each array and bitmap container and converts it to a run container where that is smaller.

### Specialized Container-Pair Operations

When executing set intersections (`AND`), unions (`OR`), differences (`ANDNOT`), or symmetric differences (`XOR`), CRoaring dispatches optimized operation algorithms based on the type pair of the two target containers:

- **Array vs Array**: a merge of two sorted arrays, switching to galloping search when one array is much smaller than the other. CRoaring also has SIMD versions on CPUs that support them.
- **Bitmap vs Bitmap**: works 64 bits at a time (or wider with SIMD) and counts the result with popcount instructions, so the new cardinality comes almost for free.
- **Array vs Bitmap**: Iterates through the array elements, checking bit positions in the bitmap container directly.

### Serialization Specification

Roaring has a shared serialization format, `RoaringFormatSpec`. A serialized bitmap starts with a cookie that also says whether there are run containers. Next comes each container's key and cardinality, then (in some cases) offsets, then the container data. Everything is little-endian, so the C, Java, Go and other implementations can read each other's output.

### 64-bit Variants

For 64-bit values you need another level over the high bits. CRoaring's C++ `Roaring64Map` maps the high 32 bits to an ordinary 32-bit Roaring bitmap, and its C `roaring64` API uses an adaptive radix tree instead.

### Production Usage with CRoaring

For real use, take CRoaring (dual Apache-2.0 / MIT licence). It ships a single-file amalgamation, `roaring.c` plus `roaring.h`, that you can drop into a project.

::: {.callout-note}
**Not run here.** CRoaring is not installed on the test machine. The snippet follows the API in CRoaring's README.
:::

```c
#include <stdio.h>
#include "roaring.h" /* compile together with the amalgamated roaring.c */

int main(void) {
    /* Create a new bitmap */
    roaring_bitmap_t *r = roaring_bitmap_create();

    /* Add values */
    roaring_bitmap_add(r, 100);
    roaring_bitmap_add_range_closed(r, 100000, 200000);

    /* Optimize container representations */
    roaring_bitmap_run_optimize(r);

    /* Membership check & cardinality */
    if (roaring_bitmap_contains(r, 100050)) {
        printf("Cardinality: %llu\n", 
               (unsigned long long)roaring_bitmap_get_cardinality(r));
    }

    /* Cleanup */
    roaring_bitmap_free(r);
    return 0;
}
```

## Common Mistakes

### 1. Assuming Bitmaps Are Always Smaller Than Arrays

A bitmap container is 8,192 bytes however few bits are set. Placing 10 scattered elements in a bitmap container consumes 8,192 bytes, whereas an array container consumes 20 bytes. Switching to bitmap containers before reaching the 4,096 break-even threshold increases memory usage.

### 2. Ignoring Per-Container Overhead on Sparse Data

Summing payload sizes, as `report` does, understates the cost of sparse data. Each container also needs a key entry, its own struct (`key`, `card`, pointers) and allocator overhead. With one value per container, as in the `sparse` set, that overhead is many times the 2-byte payload.

### 3. Inserting Unsorted Data into Array Containers

Array containers must stay sorted: binary search and merge-based set operations depend on it. Appending a value at the end instead of inserting it in place breaks lookups and lets duplicates in. The same goes for the key array.

### 4. Integer Overflow during High/Low Bit Splitting

When extracting 16-bit keys and low values from a 32-bit integer, bit shifts and type casting must be handled carefully:

```c
uint16_t high = (uint16_t)(x >> 16);
uint16_t low  = (uint16_t)(x & 0xFFFF);
```

Do the split on an unsigned 32-bit type. Right-shifting a negative `int` gives an implementation-defined result. Storing the low part in something wider than 16 bits without masking makes `low >> 6` index past the 1,024-word bitmap.

## Exercises

1. **Implement run containers**: add a third container kind holding an array of `struct { uint16_t start; uint16_t length; }`, and a `run_optimize` pass that converts each container to whichever of the three formats is smallest. Check your sizes against the `with-runs` column.
2. **Implement Container Set Intersection (`AND`)**: Write a function `roaring_and(const roaring *r1, const roaring *r2)` that creates a new Roaring bitmap containing only elements present in both inputs. Implement array-array merging and bitmap-bitmap bitwise AND logic.
3. **Faster lookups**: make `roaring_contains` binary-search the keys and the array instead of scanning them.
4. **Right-size arrays**: allocate array containers small and grow them by doubling, then measure the real heap use of the `sparse` set (for example with `mallinfo2`) and compare it with the payload figure.

## Summary

A Roaring bitmap splits each 32-bit value into a 16-bit key, which picks a container, and a 16-bit low part, which is stored in it. Arrays win up to 4,096 values (2 bytes each against a fixed 8,192-byte bitmap), bitmaps win above that, and run containers win for consecutive values. Every container stays small and fast to search, but for very sparse data the per-container overhead can cost more than a plain array.

- **Array Containers** store up to 4,096 sorted `uint16_t` values ($2 \text{ bytes}$ per entry).
- **Bitmap Containers** store dense allocations across $2^{16}$ bits using 1,024 64-bit words ($8,192 \text{ bytes}$).
- **Run Containers** compress consecutive sequence ranges using `(start, length)` pairs ($4 \text{ bytes}$ per run).

## Sources

- [Roaring Bitmap Official Site](https://roaringbitmap.org/)
- [Roaring Bitmaps: Implementation of an Optimized Software Library (Lemire et al., 2018)](https://arxiv.org/abs/1709.07821)
- [Better bitmap performance with Roaring bitmaps (Chambi et al., 2016)](https://arxiv.org/abs/1402.6407)
- [CRoaring GitHub Repository](https://github.com/RoaringBitmap/CRoaring)
- [Roaring Format Specification](https://github.com/RoaringBitmap/RoaringFormatSpec)
