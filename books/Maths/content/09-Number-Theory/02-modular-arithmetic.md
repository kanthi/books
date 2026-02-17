# Modular Arithmetic and Congruences

## 1. Congruence Relation

`a ≡ b (mod m)` means `m | (a-b)`.

It partitions integers into residue classes.

Example for `mod 5`:
- Class 0: `..., -10, -5, 0, 5, 10, ...`
- Class 1: `..., -9, -4, 1, 6, 11, ...`

## 2. Arithmetic Laws

If `a ≡ b (mod m)` and `c ≡ d (mod m)`:
- `a+c ≡ b+d (mod m)`
- `a-c ≡ b-d (mod m)`
- `ac ≡ bd (mod m)`

Division needs caution: valid only if divisor has inverse modulo `m`.

## 3. Modular Inverse

`a^{-1} mod m` exists iff `gcd(a,m)=1`.

When inverse exists:
`a * a^{-1} ≡ 1 (mod m)`.

### Example

Inverse of `7 mod 26`.
Extended Euclid gives `15*7 - 4*26 = 1`, so inverse is `15`.

## 4. Fast Exponentiation

Need to compute `a^e mod m` efficiently.

Binary method complexity: `O(log e)` multiplications.

```python
def mod_pow(a, e, m):
    a %= m
    ans = 1
    while e > 0:
        if e & 1:
            ans = (ans * a) % m
        a = (a * a) % m
        e >>= 1
    return ans
```

## 5. Fermat and Euler Theorems

### Fermat's Little Theorem

If `p` is prime and `p !| a`, then:

`a^(p-1) ≡ 1 (mod p)`.

Corollary:
`a^(p-2) ≡ a^{-1} (mod p)`.

### Euler's Theorem

If `gcd(a,n)=1`, then:

`a^{phi(n)} ≡ 1 (mod n)`.

## 6. Chinese Remainder Theorem (CRT)

### Theorem

If moduli `m1,...,mk` are pairwise coprime, then system
`x ≡ ai (mod mi)` has unique solution modulo `M = product(mi)`.

### Worked Example

Solve:
- `x ≡ 2 (mod 3)`
- `x ≡ 3 (mod 5)`
- `x ≡ 2 (mod 7)`

Unique solution: `x ≡ 23 (mod 105)`.

## 7. Application Patterns in CS

- Ring arithmetic for rolling hash
- Circular buffers (`index mod capacity`)
- Time wheels/schedulers
- Finite field foundations in crypto and coding

## Exercises

1. Compute `3^123 mod 17`.
2. Find inverse of `19 mod 41`.
3. Solve with CRT:
   `x ≡ 1 (mod 4), x ≡ 2 (mod 9), x ≡ 5 (mod 7)`.
4. Prove: if `a ≡ b (mod m)` then `a^k ≡ b^k (mod m)` for `k>=1`.
5. Show a counterexample where modular division fails.

## Summary

Modular arithmetic lets you perform large integer computation safely and quickly. Together with Euclid and CRT, it forms a core algorithmic toolkit.
