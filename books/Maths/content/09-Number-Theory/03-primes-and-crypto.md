# Prime Numbers and Cryptography Basics

## 1. Prime Fundamentals

Prime number: integer `p > 1` with no divisors except `1` and `p`.

Composite numbers factor into primes uniquely.

### Theorem (Fundamental Theorem of Arithmetic)

Every integer `n > 1` can be expressed as a product of primes, uniquely up to ordering.

### Proof Idea

- Existence by induction.
- Uniqueness via Euclid's lemma: if prime `p` divides `ab`, then `p|a` or `p|b`.

## 2. Prime Generation

### Sieve of Eratosthenes

Compute all primes `<= n` in `O(n log log n)`.

```python
def sieve(n):
    is_prime = [True] * (n + 1)
    is_prime[0] = is_prime[1] = False
    p = 2
    while p * p <= n:
        if is_prime[p]:
            for x in range(p*p, n+1, p):
                is_prime[x] = False
        p += 1
    return [i for i, v in enumerate(is_prime) if v]
```

## 3. Primality Testing

- Trial division: simple, slow for large `n`
- Probabilistic tests (Miller-Rabin): practical and fast
- Deterministic variants for bounded ranges

## 4. Euler Totient Function

`phi(n)` = count of integers in `[1..n]` coprime to `n`.

Useful formulas:
- If `p` prime: `phi(p)=p-1`
- If `p,q` distinct primes: `phi(pq)=(p-1)(q-1)`

## 5. RSA Cryptosystem (Sketch)

### Key Generation

1. Pick large primes `p, q`
2. Compute `n = pq`
3. Compute `phi(n) = (p-1)(q-1)`
4. Choose `e` with `gcd(e,phi(n))=1`
5. Compute `d ≡ e^{-1} (mod phi(n))`

Public key: `(n,e)`
Private key: `(n,d)`

### Encryption/Decryption

- Encrypt: `c = m^e mod n`
- Decrypt: `m = c^d mod n`

### Why It Works

From Euler/Fermat structure of modular exponentiation under coprimality assumptions.

## 6. Security Intuition

RSA security relies on hardness of factoring large semiprimes (`n = pq`).
Given only `n`, deriving `phi(n)` (and thus `d`) is hard in classical computation.

## 7. Tiny RSA Example (Pedagogical)

Choose `p=11, q=17`.
- `n=187`
- `phi(n)=160`
- choose `e=7` (`gcd(7,160)=1`)
- inverse `d=23` since `7*23=161 ≡ 1 (mod 160)`

Message `m=88`:
- Encrypt: `c = 88^7 mod 187 = 11`
- Decrypt: `11^23 mod 187 = 88`

## Exercises

1. Use sieve to list primes up to 200.
2. Factor `13860` into primes.
3. Compute `phi(84)`.
4. Build toy RSA using `p=13, q=19`, choose valid `e`, compute `d`.
5. Explain why tiny RSA is insecure even if mathematically correct.

## Summary

Primes, totients, modular inverses, and fast exponentiation combine into real cryptographic systems. This chapter links pure number theory to practical security engineering.
