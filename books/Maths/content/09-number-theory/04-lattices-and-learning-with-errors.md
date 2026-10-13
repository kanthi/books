---
title: "Lattices and Learning With Errors: the Mathematics of ML-KEM"
author:
  - name: "K19G"
  - name: "grok-bot"
---

The previous chapter built public-key cryptography on two problems: factoring and discrete logarithms. Both fall to Shor's algorithm on a large quantum computer. The replacement standardised by NIST in 2024, **ML-KEM** (FIPS 203, formerly CRYSTALS-Kyber), rests on a different problem, **Learning With Errors (LWE)**. It is easy to state: solve a system of linear equations modulo $q$ in which every equation is off by a small random amount. Without the "off by a small amount", Gaussian elimination solves it in a fraction of a second. With it, the best known classical and quantum algorithms take time exponential in the dimension.

This chapter shows that gap with running code, builds Regev's original LWE encryption scheme for one bit, measures its **noise budget**, and then introduces the polynomial ring $\mathbb{Z}_q[x]/(x^n+1)$ that turns the toy into something with ML-KEM's shape. All listings are complete Python files using only the standard library. They were run with **Python 3.13.5**, and the outputs are pasted unedited. The parameters are toys. **Never** use these listings to protect anything.

## 1. Lattices in one paragraph

A **lattice** is the set of all integer combinations of $n$ linearly independent vectors $b_1,\dots,b_n\in\mathbb{R}^n$:

$$
\mathcal{L}(B)=\{\,Bz : z\in\mathbb{Z}^n\,\}.
$$

It is a grid, but usually a skewed one, and the same lattice has infinitely many bases. With a short, nearly orthogonal basis, finding the lattice point closest to a target is easy: round the coordinates (Babai). With a long, skewed basis of the same lattice, nobody knows how to do this efficiently in high dimension. That is the **Closest Vector Problem**. Its approximate versions (and the related Shortest Vector Problem) are the hard problems underneath everything below. Regev proved in 2005 that solving LWE on average is at least as hard as solving approximate worst-case lattice problems, using a quantum reduction. That theorem is the reason LWE is trusted.

## 2. The problem: linear algebra plus a little noise

Fix a prime modulus $q$, a dimension $n$, and a secret $s\in\mathbb{Z}_q^n$. An LWE sample is a pair

$$
(a,\; b=\langle a,s\rangle+e \bmod q),\qquad a\ \text{uniform in } \mathbb{Z}_q^n,\quad e\ \text{small}.
$$

Given many samples, written as $b = As + e$, find $s$. Drop $e$ and this is a linear system:

```python
# noiseless.py — without noise, "LWE" is just linear algebra mod q
import random
q, n = 97, 4
random.seed(1)
s = [random.randrange(q) for _ in range(n)]                     # the secret
A = [[random.randrange(q) for _ in range(n)] for _ in range(n)]
b = [sum(a * x for a, x in zip(row, s)) % q for row in A]       # b = A s  (no error)

def solve_mod(A, b, q):                                         # Gauss-Jordan over Z_q (q prime)
    M = [row[:] + [bi] for row, bi in zip(A, b)]
    for c in range(n):
        p = next(r for r in range(c, n) if M[r][c] % q)
        M[c], M[p] = M[p], M[c]
        inv = pow(M[c][c], -1, q)
        M[c] = [v * inv % q for v in M[c]]
        for r in range(n):
            if r != c and M[r][c]:
                f = M[r][c]; M[r] = [(v - f * w) % q for v, w in zip(M[r], M[c])]
    return [M[r][n] for r in range(n)]

print("secret   :", s)
print("recovered:", solve_mod(A, b, q))
e = [random.choice([-1, 0, 1]) for _ in range(n)]
b_noisy = [(bi + ei) % q for bi, ei in zip(b, e)]
print("with error e =", e, "-> 'recovered':", solve_mod(A, b_noisy, q))
```

```console
$ python3 noiseless.py
secret   : [17, 72, 8, 32]
recovered: [17, 72, 8, 32]
with error e = [0, 1, -1, 1] -> 'recovered': [78, 67, 58, 23]
```

Elimination recovers the secret exactly, and then a perturbation of $\pm1$ in three of the four equations produces garbage. The algorithm does not degrade gracefully. Each row operation multiplies the error by field elements as large as $q$, so after elimination the noise is spread uniformly over $\mathbb{Z}_q$. Geometrically, $b$ is a point *near* the lattice $\{Az \bmod q\}$ and recovering $s$ means finding the closest lattice point, which is CVP again.

## 3. Regev encryption of one bit

The public key is a batch of LWE samples $(A,b=As+e)$ with $A\in\mathbb{Z}_q^{m\times n}$. To encrypt a bit, add a random subset of the samples and hide the bit in the most significant position:

$$
u = r^{\mathsf T}A,\qquad v = r^{\mathsf T}b + \text{bit}\cdot\lfloor q/2\rfloor,\qquad r\in\{0,1\}^m.
$$

The secret-key holder computes

$$
v-\langle u,s\rangle = r^{\mathsf T}(As+e) - r^{\mathsf T}As + \text{bit}\cdot\lfloor q/2\rfloor = \text{bit}\cdot\lfloor q/2\rfloor + \underbrace{r^{\mathsf T}e}_{\text{small}}.
$$

The result is near $0$ for a 0 and near $q/2$ for a 1. Decrypt by asking which of the two it is closer to.

```python
# regev.py — encrypt one bit with Learning With Errors (Regev 2005), toy parameters
import random
random.seed(7)
n, m, q = 32, 64, 3329            # dimension, samples, modulus (q borrowed from ML-KEM)
def small(): return random.choice([-2, -1, 0, 1, 2])           # "small" error/secret

s = [small() for _ in range(n)]
A = [[random.randrange(q) for _ in range(n)] for _ in range(m)]
e = [small() for _ in range(m)]
b = [(sum(a * x for a, x in zip(A[i], s)) + e[i]) % q for i in range(m)]   # public key (A, b)

def encrypt(bit):
    r = [random.randint(0, 1) for _ in range(m)]                 # random subset of samples
    u = [sum(r[i] * A[i][j] for i in range(m)) % q for j in range(n)]
    v = (sum(r[i] * b[i] for i in range(m)) + bit * (q // 2)) % q
    return u, v

def decrypt(u, v):
    d = (v - sum(x * y for x, y in zip(u, s))) % q               # = bit*q/2 + sum(r_i e_i)
    centred = d - q if d > q // 2 else d
    return int(abs(centred) > q // 4), centred

for bit in (0, 1, 1, 0):
    u, v = encrypt(bit)
    out, noise = decrypt(u, v)
    print(f"bit={bit} decrypted={out} (v - <u,s> centred = {noise:+d}, threshold ±{q//4})")
```

```console
$ python3 regev.py
bit=0 decrypted=0 (v - <u,s> centred = +2, threshold ±832)
bit=1 decrypted=1 (v - <u,s> centred = -1661, threshold ±832)
bit=1 decrypted=1 (v - <u,s> centred = +1658, threshold ±832)
bit=0 decrypted=0 (v - <u,s> centred = +9, threshold ±832)
```

The values $+2$ and $+9$ are the accumulated noise $r^{\mathsf T}e$. The values $\pm1658$ are $\lfloor q/2\rfloor = 1664$ plus noise, seen from the "centred" representative in $(-q/2, q/2]$. The decision threshold is $q/4 = 832$, so this ciphertext has hundreds of units of headroom. Anyone without $s$ sees $(u,v)$, which under the LWE assumption is indistinguishable from uniform random.

## 4. The noise budget

Decryption is correct exactly when $|r^{\mathsf T}e| < q/4$. That is a statement about a *sum of random variables*, so we can predict when it fails. Take $e_i$ uniform on $\{-E,\dots,E\}$ (variance $E(E+1)/3$) and $r_i$ uniform on $\{0,1\}$. Then

$$
\operatorname{Var}(r^{\mathsf T}e)=\frac{m}{2}\cdot\frac{E(E+1)}{3},
$$

and by the central limit theorem $r^{\mathsf T}e$ is close to normal.

```python
# failure.py — the noise budget: grow the error and decryption starts to fail
import random
def trial(err, n=32, m=64, q=3329, runs=2000, seed=0):
    rnd = random.Random(seed)
    s = [rnd.randint(-2, 2) for _ in range(n)]
    A = [[rnd.randrange(q) for _ in range(n)] for _ in range(m)]
    e = [rnd.randint(-err, err) for _ in range(m)]
    b = [(sum(a*x for a, x in zip(A[i], s)) + e[i]) % q for i in range(m)]
    fails = 0
    for k in range(runs):
        bit = k & 1
        r = [rnd.randint(0, 1) for _ in range(m)]
        u = [sum(r[i]*A[i][j] for i in range(m)) % q for j in range(n)]
        v = (sum(r[i]*b[i] for i in range(m)) + bit*(q//2)) % q
        d = (v - sum(x*y for x, y in zip(u, s))) % q
        fails += (int(q//4 < d < 3*q//4) != bit)
    return fails / runs
for err in (2, 20, 40, 80, 160):
    print(f"|e_i| <= {err:3d}: decryption failure rate {trial(err):.4f}")
```

```console
$ python3 failure.py
|e_i| <=   2: decryption failure rate 0.0000
|e_i| <=  20: decryption failure rate 0.0000
|e_i| <=  40: decryption failure rate 0.0000
|e_i| <=  80: decryption failure rate 0.0000
|e_i| <= 160: decryption failure rate 0.1145
```

Check the last row against the formula. With $m=64$ and $E=160$ the standard deviation is $\sqrt{32\cdot160\cdot161/3}\approx 524$. The threshold $832$ is $1.59$ standard deviations, and $P(|Z|>1.59)\approx 0.112$ for a standard normal $Z$. The measured rate is $0.1145$.

This is the central tension in every LWE design. **More noise** makes the underlying lattice problem harder. **Less noise** keeps decryption correct. Real schemes choose $q$, $n$ and the error distribution so that the failure probability is cryptographically negligible. FIPS 203 reports roughly $2^{-139}$ to $2^{-174}$ for ML-KEM's three parameter sets, while the lattice problem stays out of reach of known attacks.

## 5. From vectors to polynomials: the ring $\mathbb{Z}_q[x]/(x^n+1)$

Plain LWE has big keys: the matrix $A$ has $mn$ entries. Structured variants replace the random matrix by multiplication in a polynomial ring

$$
R_q=\mathbb{Z}_q[x]/(x^n+1),\qquad n \text{ a power of two}.
$$

In $R_q$, $x^n=-1$, so multiplying by $x$ shifts the coefficients and *negates* whatever wraps around. Multiplication by a fixed polynomial is therefore a structured ("negacyclic") $n\times n$ matrix, described by only $n$ numbers:

```python
# negacyclic.py — the ring Z_q[x]/(x^n + 1) that ML-KEM works in: x^n wraps to -1
def mul(a, b, q):
    n = len(a); c = [0] * n
    for i in range(n):
        for j in range(n):
            k, sign = (i + j) % n, (-1 if i + j >= n else 1)
            c[k] = (c[k] + sign * a[i] * b[j]) % q
    return c
q = 3329
x = [0, 1, 0, 0]                       # the polynomial x, with n = 4
p = [1, 0, 0, 0]
for k in range(1, 9):
    p = mul(p, x, q)
    print(f"x^{k} =", [c if c <= q // 2 else c - q for c in p])
```

```console
$ python3 negacyclic.py
x^1 = [0, 1, 0, 0]
x^2 = [0, 0, 1, 0]
x^3 = [0, 0, 0, 1]
x^4 = [-1, 0, 0, 0]
x^5 = [0, -1, 0, 0]
x^6 = [0, 0, -1, 0]
x^7 = [0, 0, 0, -1]
x^8 = [1, 0, 0, 0]
```

The powers of $x$ have order $2n$: $x^4=-1$ and $x^8=1$. For $n=256$ and $q=3329$, the factor $q-1=3328=2^8\cdot 13$ contains a primitive $256$-th root of unity ($\zeta=17$) but no $512$-th root. So $x^{256}+1$ splits modulo $q$ into $128$ quadratic factors $x^2-\zeta^{2i+1}$, not into linear ones. ML-KEM multiplies ring elements with this "incomplete" number-theoretic transform, the modular analogue of the FFT. It costs $O(n\log n)$ operations instead of $O(n^2)$, plus a cheap product of degree-1 polynomials in each of the 128 slots. That arithmetic is the reason $q=3329$ was chosen.

**ML-KEM** works with *modules* over this ring: vectors of $k$ ring elements. Its secret is $\mathbf{s}\in R_q^k$ with small coefficients, its public key is $(\mathbf{A},\mathbf{t}=\mathbf{A}\mathbf{s}+\mathbf{e})$ with $\mathbf{A}\in R_q^{k\times k}$ expanded from a 32-byte seed, and encryption is the module version of Section 3. FIPS 203 fixes:

| Parameter set | $n$ | $q$ | $k$ | $\eta_1$ | $\eta_2$ | $(d_u, d_v)$ | NIST category |
|---|---|---|---|---|---|---|---|
| ML-KEM-512 | 256 | 3329 | 2 | 3 | 2 | (10, 4) | 1 |
| ML-KEM-768 | 256 | 3329 | 3 | 2 | 2 | (10, 4) | 3 |
| ML-KEM-1024 | 256 | 3329 | 4 | 2 | 2 | (11, 5) | 5 |

Here $\eta$ sets the width of the centred binomial error distribution, and $(d_u,d_v)$ are the numbers of bits kept when ciphertext coefficients are rounded. The rounding adds deterministic "noise" and shrinks ciphertexts, and the failure analysis must absorb it. The KEM itself wraps this public-key encryption in a Fujisaki–Okamoto transform to obtain security against chosen-ciphertext attacks. That transform is a protocol argument, not new mathematics, and is out of scope here.

## 6. What the hardness claim is, and is not

- LWE hardness is a **conjecture backed by a reduction**: average-case LWE is at least as hard as worst-case approximate lattice problems. No proof shows those lattice problems are hard, just as no proof shows factoring is hard.
- The best known attacks are lattice reduction (BKZ and its sieving subroutines). Their cost grows exponentially in the dimension, and parameter sets are chosen from concrete cost estimates for these algorithms.
- Ring and module structure is extra structure that an attacker might exploit. Decades of cryptanalysis have not found a general way to do so for these parameters, and that is a judgement call the community keeps re-examining. Public debates in 2026 about lattices versus hash-based signatures come down to how much margin that structure leaves. Each claim needs to be checked against the published analyses.

## Exercises

1. In `noiseless.py`, replace the error with $e$ such that $\sum |e_i| = 1$ (one equation off by one). How many of the recovered coordinates are still right? Explain using the row operations.
2. Derive the variance formula in Section 4 and use it to predict the smallest $E$ with a failure rate above $1\%$. Check with `failure.py`.
3. Modify `regev.py` to encrypt two bits per ciphertext by using the quarter points $0, q/4, q/2, 3q/4$. What does the noise budget become?
4. Show that multiplication by a fixed $a(x)\in R_q$ is the linear map with matrix $M_{ij}=\pm a_{(i-j) \bmod n}$, and determine the sign rule.
5. Check with `pow` that $17^{128}\equiv -1$ and $17^{256}\equiv 1 \pmod{3329}$. Explain why this means $17$ has order exactly $256$, and why no element can have order $512$.

## Sources

- NIST FIPS 203, *Module-Lattice-Based Key-Encapsulation Mechanism Standard* (August 2024): <https://csrc.nist.gov/pubs/fips/203/final>
- O. Regev, "On Lattices, Learning with Errors, Random Linear Codes, and Cryptography", *J. ACM* 56(6), 2009 (STOC 2005): <https://doi.org/10.1145/1568318.1568324>
- C. Peikert, "A Decade of Lattice Cryptography", *Foundations and Trends in TCS*, 2016: <https://eprint.iacr.org/2015/939>
- V. Lyubashevsky, C. Peikert, O. Regev, "On Ideal Lattices and Learning with Errors over Rings", EUROCRYPT 2010: <https://eprint.iacr.org/2012/230>
