# Asymptotic Analysis and Big O Notation

Asymptotic analysis provides a mathematical framework for describing the growth rate of functions, particularly the time and space complexity of algorithms. It allows us to compare algorithms and predict their performance on large inputs.

## Big O Notation

### Definition

For functions f(n) and g(n), we say **f(n) = O(g(n))** if there exist positive constants c and n₀ such that:

**f(n) ≤ c · g(n)** for all n ≥ n₀

This means f(n) grows no faster than g(n) asymptotically.

```python
import numpy as np
import matplotlib.pyplot as plt

def plot_big_o_examples():
    """Visualize different growth rates"""
    n = np.linspace(1, 100, 1000)

    functions = {
        'O(1)': np.ones_like(n),
        'O(log n)': np.log2(n),
        'O(n)': n,
        'O(n log n)': n * np.log2(n),
        'O(n²)': n**2,
        'O(n³)': n**3,
        'O(2ⁿ)': 2**np.minimum(n/10, 20)  # Scaled to fit plot
    }

    plt.figure(figsize=(12, 8))

    for name, values in functions.items():
        plt.plot(n, values, label=name, linewidth=2)

    plt.xlabel('Input Size (n)')
    plt.ylabel('Operations')
    plt.title('Common Time Complexity Growth Rates')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.xlim(1, 100)
    plt.ylim(1, 1000)
    plt.yscale('log')
    plt.show()

plot_big_o_examples()
```

### Common Complexity Classes

```python
def analyze_complexity_examples():
    """Analyze time complexity of common algorithms"""

    examples = [
        ("Array access", "O(1)", "arr[i]"),
        ("Linear search", "O(n)", "for i in range(n): if arr[i] == target"),
        ("Binary search", "O(log n)", "Divide search space in half each step"),
        ("Merge sort", "O(n log n)", "Divide and conquer sorting"),
        ("Bubble sort", "O(n²)", "Nested loops comparing adjacent elements"),
        ("Matrix multiplication", "O(n³)", "Three nested loops"),
        ("Traveling salesman (brute force)", "O(n!)", "Try all permutations"),
        ("Subset sum (brute force)", "O(2ⁿ)", "Try all possible subsets")
    ]

    print("Common Algorithm Complexities:")
    print("-" * 60)
    for name, complexity, description in examples:
        print(f"{name:25} {complexity:10} {description}")

analyze_complexity_examples()
```

## Other Asymptotic Notations

### Big Omega (Ω) - Lower Bound

**f(n) = Ω(g(n))** means f(n) grows at least as fast as g(n).

### Big Theta (Θ) - Tight Bound

**f(n) = Θ(g(n))** means f(n) grows exactly as fast as g(n).
This is equivalent to f(n) = O(g(n)) AND f(n) = Ω(g(n)).

```python
def demonstrate_asymptotic_bounds():
    """Demonstrate different asymptotic bounds"""

    def f1(n):
        return 3*n**2 + 2*n + 1

    def f2(n):
        return n**2

    def f3(n):
        return n

    n_values = np.array([10, 100, 1000, 10000])

    print("Asymptotic Bounds Example:")
    print("f(n) = 3n² + 2n + 1")
    print("-" * 40)
    print(f"{'n':>6} {'f(n)':>10} {'n²':>10} {'n':>10}")
    print("-" * 40)

    for n in n_values:
        print(f"{n:>6} {f1(n):>10.0f} {f2(n):>10.0f} {f3(n):>10.0f}")

    print("\nObservations:")
    print("- f(n) = O(n²) because f(n) ≤ 4n² for large n")
    print("- f(n) = Ω(n²) because f(n) ≥ 3n² for large n")
    print("- f(n) = Θ(n²) because it's both O(n²) and Ω(n²)")

demonstrate_asymptotic_bounds()
```

## Analyzing Algorithm Complexity

### Example 1: Linear Search

```python
def linear_search_analysis():
    """Analyze linear search complexity"""

    def linear_search(arr, target):
        """Linear search with operation counting"""
        operations = 0
        for i in range(len(arr)):
            operations += 1  # Comparison operation
            if arr[i] == target:
                return i, operations
        return -1, operations

    # Test with different array sizes
    sizes = [10, 100, 1000, 10000]
    results = []

    for size in sizes:
        arr = list(range(size))

        # Best case: target at beginning
        _, best_ops = linear_search(arr, 0)

        # Worst case: target not found
        _, worst_ops = linear_search(arr, -1)

        # Average case: target in middle
        _, avg_ops = linear_search(arr, size // 2)

        results.append((size, best_ops, avg_ops, worst_ops))

    print("Linear Search Complexity Analysis:")
    print("-" * 50)
    print(f"{'Size':>6} {'Best':>8} {'Average':>8} {'Worst':>8}")
    print("-" * 50)

    for size, best, avg, worst in results:
        print(f"{size:>6} {best:>8} {avg:>8} {worst:>8}")

    print("\nComplexity:")
    print("Best case: O(1) - target at first position")
    print("Average case: O(n) - target in middle")
    print("Worst case: O(n) - target not found")

linear_search_analysis()
```

### Example 2: Nested Loops

```python
def nested_loops_analysis():
    """Analyze algorithms with nested loops"""

    def count_operations(n, algorithm):
        """Count operations for different nested loop patterns"""
        if algorithm == "double_loop":
            # for i in range(n):
            #     for j in range(n):
            #         operation()
            return n * n

        elif algorithm == "triangular":
            # for i in range(n):
            #     for j in range(i):
            #         operation()
            return n * (n - 1) // 2

        elif algorithm == "triple_loop":
            # for i in range(n):
            #     for j in range(n):
            #         for k in range(n):
            #             operation()
            return n * n * n

    sizes = [10, 20, 50, 100]
    algorithms = [
        ("Double loop", "double_loop", "O(n²)"),
        ("Triangular", "triangular", "O(n²)"),
        ("Triple loop", "triple_loop", "O(n³)")
    ]

    print("Nested Loop Complexity Analysis:")
    print("-" * 60)

    for name, algo, complexity in algorithms:
        print(f"\n{name} - {complexity}:")
        print(f"{'n':>6} {'Operations':>12} {'Ratio':>8}")
        print("-" * 30)

        prev_ops = None
        for n in sizes:
            ops = count_operations(n, algo)
            ratio = ops / prev_ops if prev_ops else 1
            print(f"{n:>6} {ops:>12} {ratio:>8.1f}")
            prev_ops = ops

nested_loops_analysis()
```

## Recurrence Relations

### Master Theorem

For recurrences of the form: **T(n) = aT(n/b) + f(n)**

```python
def master_theorem_examples():
    """Examples of Master Theorem applications"""

    examples = [
        {
            'name': 'Binary Search',
            'recurrence': 'T(n) = T(n/2) + O(1)',
            'a': 1, 'b': 2, 'f': 'O(1)',
            'result': 'O(log n)'
        },
        {
            'name': 'Merge Sort',
            'recurrence': 'T(n) = 2T(n/2) + O(n)',
            'a': 2, 'b': 2, 'f': 'O(n)',
            'result': 'O(n log n)'
        },
        {
            'name': 'Karatsuba Multiplication',
            'recurrence': 'T(n) = 3T(n/2) + O(n)',
            'a': 3, 'b': 2, 'f': 'O(n)',
            'result': 'O(n^log₂3) ≈ O(n^1.585)'
        },
        {
            'name': 'Matrix Multiplication (naive)',
            'recurrence': 'T(n) = 8T(n/2) + O(n²)',
            'a': 8, 'b': 2, 'f': 'O(n²)',
            'result': 'O(n³)'
        }
    ]

    print("Master Theorem Applications:")
    print("=" * 60)

    for ex in examples:
        print(f"\n{ex['name']}:")
        print(f"Recurrence: {ex['recurrence']}")
        print(f"a = {ex['a']}, b = {ex['b']}, f(n) = {ex['f']}")
        print(f"Solution: {ex['result']}")

master_theorem_examples()
```

### Solving Recurrences by Substitution

```python
def solve_recurrence_substitution():
    """Demonstrate solving recurrences by substitution method"""

    def fibonacci_recurrence(n, memo={}):
        """Fibonacci with memoization to show exponential vs polynomial"""
        if n in memo:
            return memo[n], 1  # 1 operation (lookup)

        if n <= 1:
            return n, 1

        fib_n_1, ops1 = fibonacci_recurrence(n-1, memo)
        fib_n_2, ops2 = fibonacci_recurrence(n-2, memo)

        result = fib_n_1 + fib_n_2
        total_ops = ops1 + ops2 + 1  # +1 for addition

        memo[n] = result
        return result, total_ops

    def fibonacci_naive(n):
        """Naive Fibonacci to show exponential complexity"""
        if n <= 1:
            return n, 1

        fib_n_1, ops1 = fibonacci_naive(n-1)
        fib_n_2, ops2 = fibonacci_naive(n-2)

        return fib_n_1 + fib_n_2, ops1 + ops2 + 1

    print("Fibonacci Complexity Comparison:")
    print("-" * 50)
    print(f"{'n':>3} {'Naive Ops':>12} {'Memo Ops':>10} {'Ratio':>8}")
    print("-" * 50)

    for n in range(5, 26, 5):
        _, naive_ops = fibonacci_naive(n)
        _, memo_ops = fibonacci_recurrence(n, {})
        ratio = naive_ops / memo_ops

        print(f"{n:>3} {naive_ops:>12} {memo_ops:>10} {ratio:>8.1f}")

    print("\nComplexity Analysis:")
    print("Naive: T(n) = T(n-1) + T(n-2) + O(1) → O(φⁿ) where φ ≈ 1.618")
    print("Memoized: T(n) = O(1) for each subproblem → O(n)")

solve_recurrence_substitution()
```

## Space Complexity Analysis

### Memory Usage Patterns

```python
def space_complexity_examples():
    """Analyze space complexity of different algorithms"""

    def recursive_factorial_space(n, depth=0):
        """Factorial with space tracking"""
        if n <= 1:
            return 1, depth + 1  # Base case uses 1 stack frame

        result, max_depth = recursive_factorial_space(n-1, depth + 1)
        return n * result, max_depth

    def iterative_factorial_space(n):
        """Iterative factorial - constant space"""
        result = 1
        for i in range(1, n + 1):
            result *= i
        return result, 1  # Constant space

    def merge_sort_space(arr):
        """Merge sort space analysis"""
        if len(arr) <= 1:
            return arr, len(arr)

        mid = len(arr) // 2
        left, left_space = merge_sort_space(arr[:mid])
        right, right_space = merge_sort_space(arr[mid:])

        # Merge step requires O(n) additional space
        merged = []
        i = j = 0
        while i < len(left) and j < len(right):
            if left[i] <= right[j]:
                merged.append(left[i])
                i += 1
            else:
                merged.append(right[j])
                j += 1

        merged.extend(left[i:])
        merged.extend(right[j:])

        # Space complexity: max of recursive calls + current level
        total_space = max(left_space, right_space) + len(arr)
        return merged, total_space

    print("Space Complexity Analysis:")
    print("=" * 50)

    # Test factorial space complexity
    print("\nFactorial Space Complexity:")
    print(f"{'n':>3} {'Recursive':>12} {'Iterative':>12}")
    print("-" * 30)

    for n in [5, 10, 15, 20]:
        _, rec_space = recursive_factorial_space(n)
        _, iter_space = iterative_factorial_space(n)
        print(f"{n:>3} {rec_space:>12} {iter_space:>12}")

    # Test merge sort space complexity
    print("\nMerge Sort Space Complexity:")
    print(f"{'Array Size':>12} {'Space Used':>12}")
    print("-" * 25)

    for size in [8, 16, 32, 64]:
        arr = list(range(size))
        _, space_used = merge_sort_space(arr)
        print(f"{size:>12} {space_used:>12}")

space_complexity_examples()
```

## Amortized Analysis

### Dynamic Array (Vector) Analysis

```python
class DynamicArray:
    """Dynamic array with amortized analysis"""

    def __init__(self):
        self.capacity = 1
        self.size = 0
        self.data = [None] * self.capacity
        self.total_operations = 0
        self.resize_operations = 0

    def append(self, value):
        """Append with doubling strategy"""
        if self.size == self.capacity:
            self._resize()

        self.data[self.size] = value
        self.size += 1
        self.total_operations += 1

    def _resize(self):
        """Double the capacity"""
        old_capacity = self.capacity
        self.capacity *= 2
        new_data = [None] * self.capacity

        # Copy all elements (this is the expensive operation)
        for i in range(self.size):
            new_data[i] = self.data[i]
            self.total_operations += 1

        self.data = new_data
        self.resize_operations += old_capacity
        print(f"Resized from {old_capacity} to {self.capacity}")

def analyze_dynamic_array():
    """Analyze amortized cost of dynamic array operations"""

    arr = DynamicArray()
    n_operations = 32

    print("Dynamic Array Amortized Analysis:")
    print("-" * 40)
    print(f"{'Operation':>10} {'Total Ops':>12} {'Amortized':>12}")
    print("-" * 40)

    for i in range(1, n_operations + 1):
        arr.append(i)

        if i in [1, 2, 4, 8, 16, 32] or i % 8 == 0:
            amortized_cost = arr.total_operations / i
            print(f"{i:>10} {arr.total_operations:>12} {amortized_cost:>12.2f}")

    print(f"\nTotal operations: {arr.total_operations}")
    print(f"Resize operations: {arr.resize_operations}")
    print(f"Regular operations: {arr.total_operations - arr.resize_operations}")
    print(f"Amortized cost per append: {arr.total_operations / n_operations:.2f}")
    print("Theoretical amortized cost: O(1)")

analyze_dynamic_array()
```

## Practical Algorithm Analysis

### Sorting Algorithm Comparison

```python
import time
import random

def empirical_complexity_analysis():
    """Empirical analysis of sorting algorithms"""

    def bubble_sort(arr):
        """O(n²) sorting algorithm"""
        n = len(arr)
        operations = 0
        for i in range(n):
            for j in range(0, n - i - 1):
                operations += 1
                if arr[j] > arr[j + 1]:
                    arr[j], arr[j + 1] = arr[j + 1], arr[j]
        return operations

    def merge_sort(arr):
        """O(n log n) sorting algorithm"""
        operations = [0]  # Use list to allow modification in nested function

        def merge_sort_helper(arr):
            if len(arr) <= 1:
                return arr

            mid = len(arr) // 2
            left = merge_sort_helper(arr[:mid])
            right = merge_sort_helper(arr[mid:])

            return merge(left, right, operations)

        def merge(left, right, ops):
            result = []
            i = j = 0

            while i < len(left) and j < len(right):
                ops[0] += 1
                if left[i] <= right[j]:
                    result.append(left[i])
                    i += 1
                else:
                    result.append(right[j])
                    j += 1

            result.extend(left[i:])
            result.extend(right[j:])
            return result

        merge_sort_helper(arr)
        return operations[0]

    # Test different input sizes
    sizes = [100, 200, 400, 800]

    print("Empirical Complexity Analysis:")
    print("=" * 60)
    print(f"{'Size':>6} {'Bubble Sort':>12} {'Merge Sort':>12} {'Ratio':>8}")
    print("-" * 60)

    for size in sizes:
        # Generate random array
        arr1 = [random.randint(1, 1000) for _ in range(size)]
        arr2 = arr1.copy()

        # Measure operations
        bubble_ops = bubble_sort(arr1)
        merge_ops = merge_sort(arr2)

        ratio = bubble_ops / merge_ops if merge_ops > 0 else 0

        print(f"{size:>6} {bubble_ops:>12} {merge_ops:>12} {ratio:>8.1f}")

    print("\nTheoretical Complexity:")
    print("Bubble Sort: O(n²)")
    print("Merge Sort: O(n log n)")
    print("Expected ratio growth: O(n / log n)")

empirical_complexity_analysis()
```

### Cache Performance Analysis

```python
def cache_complexity_analysis():
    """Analyze cache-friendly vs cache-unfriendly algorithms"""

    def matrix_multiply_ijk(A, B):
        """Standard matrix multiplication (cache-unfriendly for large matrices)"""
        n = len(A)
        C = [[0] * n for _ in range(n)]
        cache_misses = 0

        for i in range(n):
            for j in range(n):
                for k in range(n):
                    C[i][j] += A[i][k] * B[k][j]
                    # Simulate cache miss for B[k][j] access pattern
                    if k % 4 == 0:  # Simplified cache model
                        cache_misses += 1

        return C, cache_misses

    def matrix_multiply_ikj(A, B):
        """Cache-friendly matrix multiplication"""
        n = len(A)
        C = [[0] * n for _ in range(n)]
        cache_misses = 0

        for i in range(n):
            for k in range(n):
                for j in range(n):
                    C[i][j] += A[i][k] * B[k][j]
                    # Better cache locality for C[i][j] access pattern
                    if j % 8 == 0:  # Fewer cache misses
                        cache_misses += 1

        return C, cache_misses

    print("Cache Performance Analysis:")
    print("-" * 50)
    print(f"{'Size':>6} {'IJK Misses':>12} {'IKJ Misses':>12} {'Ratio':>8}")
    print("-" * 50)

    for size in [8, 16, 32]:
        # Create test matrices
        A = [[random.randint(1, 10) for _ in range(size)] for _ in range(size)]
        B = [[random.randint(1, 10) for _ in range(size)] for _ in range(size)]

        _, ijk_misses = matrix_multiply_ijk(A, B)
        _, ikj_misses = matrix_multiply_ikj(A, B)

        ratio = ijk_misses / ikj_misses if ikj_misses > 0 else 0

        print(f"{size:>6} {ijk_misses:>12} {ikj_misses:>12} {ratio:>8.1f}")

    print("\nCache Locality Impact:")
    print("- IJK order: Poor cache locality for matrix B")
    print("- IKJ order: Better cache locality for matrix C")
    print("- Real performance difference can be 2-10x")

cache_complexity_analysis()
```

## Summary

Asymptotic analysis provides essential tools for:

1. **Algorithm Comparison**: Compare algorithms independent of hardware
2. **Scalability Prediction**: Understand how algorithms behave on large inputs
3. **Resource Planning**: Estimate computational requirements
4. **Algorithm Design**: Guide design decisions for efficiency
5. **Problem Classification**: Identify inherently difficult problems

Key takeaways:
- **Big O** describes upper bounds (worst-case behavior)
- **Big Ω** describes lower bounds (best-case behavior)
- **Big Θ** describes tight bounds (exact growth rate)
- **Amortized analysis** considers average cost over sequences of operations
- **Space-time tradeoffs** often exist between memory and computation
- **Cache effects** can significantly impact real-world performance

Understanding these concepts enables you to write more efficient code and make informed decisions about algorithm selection and system design.
## Recurrence Tree Intuition

For recurrences like `T(n)=2T(n/2)+n`, a recurrence tree helps visualize per-level work.

```text
flow:
  A -> C
  B -> D
  B -> E
  C -> F
  C -> G
```

Each level contributes about `n` total work; there are `log n` levels, giving `Theta(n log n)`.

## Proof Checklist for Asymptotic Claims

1. State constants `c, n0` explicitly.
2. Show inequality holds for all `n >= n0`.
3. Separate upper and lower bounds when proving `Theta`.
4. Avoid empirical-only argument as proof.
