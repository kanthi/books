# Divisibility, GCD, and the Euclidean Algorithm

## 1. Division Algorithm

For integers `a` and positive integer `b`, there exist unique integers `q, r` such that:

`a = bq + r`, with `0 <= r < b`.

This is the foundation of modular arithmetic and Euclid's algorithm.

### Worked Example

For `a = 252, b = 17`:

`252 = 17*14 + 14`.

So quotient `q=14`, remainder `r=14`.

## 2. Divisibility and Basic Laws

`d | n` means `n = dk` for some integer `k`.

Useful rules:
- If `d|a` and `d|b`, then `d|(a+b)` and `d|(a-b)`.
- If `d|a`, then `d|ax` for any integer `x`.
- If `d|a` and `a|b`, then `d|b`.

## 3. Greatest Common Divisor

`gcd(a,b)` is the greatest positive integer dividing both.

### Theorem (Euclidean Step)

`gcd(a,b) = gcd(b, a mod b)`.

### Proof Sketch

Let `a = bq + r`.
A number `d` divides both `a` and `b` iff it divides `r = a - bq`.
So common divisors of `(a,b)` and `(b,r)` are identical. Hence gcd is identical.

## 4. Euclidean Algorithm

Algorithm:
1. Replace `(a,b)` with `(b, a mod b)` repeatedly.
2. Stop when second value is zero.
3. First value is gcd.

### Example

`gcd(252,105)`:
- `252 = 2*105 + 42`
- `105 = 2*42 + 21`
- `42 = 2*21 + 0`
Answer: `21`.

### Complexity

Euclid runs in `O(log min(a,b))` arithmetic steps.

## 5. Bézout Identity and Extended Euclid

### Theorem (Bézout)

There exist integers `x,y` such that:

`ax + by = gcd(a,b)`.

### Why It Matters

- Modular inverse computation
- Solving linear Diophantine equations
- RSA key generation step

### Extended Euclid Example

Find inverse of `17 mod 43`.

Compute:
- `43 = 2*17 + 9`
- `17 = 1*9 + 8`
- `9 = 1*8 + 1`
- `8 = 8*1 + 0`

Back-substitute:
- `1 = 9 - 1*8`
- `8 = 17 - 1*9`
- `1 = 2*9 - 17`
- `9 = 43 - 2*17`
- `1 = 2*43 - 5*17`

So `-5*17 ≡ 1 (mod 43)`, inverse is `38`.

## 6. Linear Diophantine Equation

Equation: `ax + by = c`.

### Theorem

A solution exists iff `gcd(a,b) | c`.

### Example

Solve `14x + 21y = 35`.
`gcd(14,21)=7`, and `7|35`, so solutions exist.
One solution from simplification: `2x + 3y = 5` gives `x=1, y=1`.
General solution obtained by parameterization.

## 7. Python Reference Implementations

```python
def gcd(a, b):
    while b:
        a, b = b, a % b
    return abs(a)

def egcd(a, b):
    if b == 0:
        return a, 1, 0
    g, x1, y1 = egcd(b, a % b)
    return g, y1, x1 - (a // b) * y1
```

## Exercises

1. Compute `gcd(987654, 123456)` via Euclid.
2. Find integers `x,y` such that `391x + 299y = gcd(391,299)`.
3. Solve `35x + 50y = 10`.
4. Prove that consecutive Fibonacci numbers are coprime.
5. Show that if `gcd(a,b)=1`, then `gcd(a, b+ka)=1`.

## Summary

Euclid's algorithm plus Bézout identity gives a complete computational engine for gcd, inverses, and integer equations.
