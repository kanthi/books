---
title: "Random Rotations, Johnson–Lindenstrauss, and Hadamard Transforms"
author:
  - name: "K19G"
  - name: "grok-bot"
---

High-dimensional space has two properties that look like bugs and turn out to be tools. Random directions are almost always nearly perpendicular. And a random linear map to far fewer dimensions barely changes any distance in a finite point set. The **Johnson–Lindenstrauss (JL) lemma** makes the second property exact: $n$ points need only $O(\varepsilon^{-2}\log n)$ dimensions to keep every pairwise distance within a factor $1 \pm \varepsilon$, whatever the original dimension was.

The same facts explain a technique behind current low-bit quantization of neural networks and vector databases: **rotate before you quantize**. A random orthogonal rotation spreads a vector's energy evenly over its coordinates, so a coarse quantizer with one scale per vector stops wasting its levels on a few huge entries. Dense random rotations are expensive. The **randomized Hadamard transform** gets the same effect in $O(d\log d)$ time with $\pm 1$ arithmetic.

This chapter proves the pieces, measures them, and points out where the guarantees end. Every listing is a complete script. They were run with Python 3.13.5, NumPy 2.5.3 and SciPy 1.18.1 on Debian 13.7, and the outputs are pasted unedited. Timings depend on the machine; everything else is seeded and reproducible.

**Prerequisites:** orthogonal matrices and norms, expectation and variance, a tail bound such as Chernoff or Hoeffding.

---

## 1. Concentration: random directions are nearly orthogonal

Let $u, v$ be independent uniform unit vectors in $\mathbb R^d$. A convenient way to sample one is $g/\lVert g\rVert$ with $g \sim \mathcal N(0, I_d)$. By symmetry $\mathbb E\langle u, v\rangle = 0$. Fix $v$ by rotation invariance; then $\langle u, v\rangle$ is one coordinate of $u$, and since the $d$ squared coordinates of $u$ sum to 1,

$$
\mathbb E\,\langle u, v\rangle^2 = \frac1d, \qquad \text{so} \qquad \langle u, v\rangle \approx \mathcal N\!\left(0, \tfrac1d\right) \text{ for large } d.
$$

The angle $\theta = \arccos\langle u,v\rangle$ therefore sits at $90^\circ$ with spread about $(180/\pi)/\sqrt d$ degrees. The coordinate density is exactly $\propto (1-t^2)^{(d-3)/2}$ on $[-1,1]$, and its tails are sub-Gaussian: $\Pr(|\langle u,v\rangle| > \varepsilon) \le 2e^{-d\varepsilon^2/2}$. A union bound then shows you can pick about $e^{d\varepsilon^2/4}$ unit vectors whose pairwise $|\cos|$ are all below $\varepsilon$, which is exponentially many "almost orthogonal" directions in only $d$ dimensions.

### Worked example 1 — angles between 1000 random vectors

```python
# file: angles.py
# Angles between independent random directions concentrate at 90 degrees as d grows.
import numpy as np

rng = np.random.default_rng(0)
n = 1000                                   # 1000 vectors -> 499,500 distinct pairs
print(f"{'d':>6} {'mean angle':>10} {'std':>7} {'min':>7} {'max':>7} {'1/sqrt(d) in deg':>17}")
for d in (3, 30, 300, 3000, 12288):
    X = rng.standard_normal((n, d))
    X /= np.linalg.norm(X, axis=1, keepdims=True)
    cos = (X @ X.T)[np.triu_indices(n, k=1)]
    ang = np.degrees(np.arccos(np.clip(cos, -1, 1)))
    print(f"{d:6d} {ang.mean():10.2f} {ang.std():7.2f} {ang.min():7.2f} {ang.max():7.2f} "
          f"{np.degrees(1 / np.sqrt(d)):17.2f}")
```

```bash
python angles.py
```

Output:

```text
     d mean angle     std     min     max  1/sqrt(d) in deg
     3      89.86   39.15    0.02  179.95             33.08
    30      90.01   10.64   40.68  134.97             10.46
   300      90.01    3.31   73.61  105.26              3.31
  3000      90.00    1.05   85.28   94.77              1.05
 12288      90.00    0.52   87.72   92.41              0.52
```

The standard deviation tracks $1/\sqrt d$ (in degrees) almost exactly from $d=30$ up. At $d = 12{,}288$ (the hidden width of a GPT-3-sized model), half a million pairs all fall between $87.7^\circ$ and $92.4^\circ$. In $d=3$ the same experiment covers the whole range from $0^\circ$ to $180^\circ$. Low-dimensional intuition is the wrong guide here.

---

## 2. The Johnson–Lindenstrauss lemma

**Lemma (JL; constants of Dasgupta–Gupta).** Let $0<\varepsilon<1$ and

$$
k \;\ge\; \frac{4\ln n}{\varepsilon^2/2-\varepsilon^3/3}.
$$

For every set of $n$ points in $\mathbb R^D$ there is a linear map $f:\mathbb R^D\to\mathbb R^k$ with

$$
(1-\varepsilon)\lVert u-v\rVert^2 \;\le\; \lVert f(u)-f(v)\rVert^2 \;\le\; (1+\varepsilon)\lVert u-v\rVert^2 \quad\text{for all pairs } u,v.
$$

Two things stand out. $k$ does **not** depend on $D$. And the map can be random and oblivious to the data.

**Proof sketch.** Take $f(x) = Rx$ with $R \in \mathbb R^{k\times D}$ having i.i.d. $\mathcal N(0, 1/k)$ entries. For a fixed vector $x$, each coordinate of $Rx$ is $\mathcal N(0, \lVert x\rVert^2/k)$, independently, so

$$
\frac{k\,\lVert Rx\rVert^2}{\lVert x\rVert^2} \sim \chi^2_k, \qquad \mathbb E\lVert Rx\rVert^2 = \lVert x\rVert^2, \qquad \operatorname{sd}\!\left(\frac{\lVert Rx\rVert^2}{\lVert x\rVert^2}\right) = \sqrt{2/k}.
$$

A Chernoff bound on the $\chi^2$ moment generating function gives

$$
\Pr\!\left(\left|\frac{\lVert Rx\rVert^2}{\lVert x\rVert^2}-1\right| > \varepsilon\right) \le 2\exp\!\left(-\frac k2\left(\frac{\varepsilon^2}2-\frac{\varepsilon^3}3\right)\right).
$$

Apply this to the $\binom n2$ difference vectors $x = u - v$. With $k$ as in the lemma, each pair fails with probability at most $2/n^2$. By the union bound all pairs succeed with probability at least $1/n > 0$, so a good map exists. Replacing $4\ln n$ by $6\ln n$ pushes the success probability of a *single* random draw to at least $1 - 1/n$.

**Optimality.** Larsen and Nelson (2017) proved that $k = \Omega(\varepsilon^{-2}\log n)$ is necessary for some point sets, even for nonlinear maps. The lemma cannot be improved beyond constants.

**The rule of thumb to remember:** a Gaussian projection to $k$ dimensions distorts each squared distance by a relative error with standard deviation $\sqrt{2/k}$. The worst of $N$ pairs is a few standard deviations out, roughly $\sqrt{2\ln N}$ of them.

### Worked example 2 — what k does a real point set need?

```python
# file: jl_distortion.py
# Project n points from D=10,000 dimensions down to k with a Gaussian matrix and
# measure the worst distortion of squared pairwise distances, next to the k that the
# Johnson-Lindenstrauss bound (Dasgupta-Gupta constants) asks for.
import numpy as np

rng = np.random.default_rng(1)
n, D = 300, 10_000
# Data with structure: a 20-dim signal subspace plus small isotropic noise.
X = rng.standard_normal((n, 20)) @ rng.standard_normal((20, D)) + 0.5 * rng.standard_normal((n, D))
iu = np.triu_indices(n, k=1)


def sq_dists(Y):
    g = np.sum(Y * Y, 1)
    return (g[:, None] + g[None, :] - 2 * Y @ Y.T)[iu]


def jl_k(n, eps):
    return int(np.ceil(4 * np.log(n) / (eps**2 / 2 - eps**3 / 3)))


d0 = sq_dists(X)
print(f"n={n} points, D={D}, {len(d0):,} pairs")
print(f"{'k':>5} {'max |ratio-1|':>13} {'99.9th pct':>10} {'eps where JL k = this k':>23}")
for k in (25, 50, 100, 200, 400, 800, 1600):
    R = rng.standard_normal((D, k)) / np.sqrt(k)
    ratio = sq_dists(X @ R) / d0
    dev = np.abs(ratio - 1)
    eps = next((f"{e:.3f}" for e in np.arange(0.01, 1, 0.001) if jl_k(n, e) <= k), "none (eps<1)")
    print(f"{k:5d} {dev.max():13.3f} {np.quantile(dev, 0.999):10.3f} {eps:>23}")
print(f"JL k for eps=0.1: {jl_k(n, 0.1):,}   eps=0.2: {jl_k(n, 0.2):,}   eps=0.5: {jl_k(n, 0.5):,}")
```

```bash
python jl_distortion.py
```

Output:

```text
n=300 points, D=10000, 44,850 pairs
    k max |ratio-1| 99.9th pct eps where JL k = this k
   25         1.581      1.169            none (eps<1)
   50         0.997      0.734            none (eps<1)
  100         0.590      0.423            none (eps<1)
  200         0.428      0.340                   0.626
  400         0.357      0.245                   0.394
  800         0.206      0.163                   0.263
 1600         0.132      0.110                   0.181
JL k for eps=0.1: 4,889   eps=0.2: 1,317   eps=0.5: 274
```

Reading the table:

- The worst-case distortion falls like $1/\sqrt k$: from 0.59 at $k=100$ to 0.13 at $k=1600$, a factor of 4.5 for a 16-fold increase in $k$.
- The rule of thumb is accurate. At $k=400$, $\sqrt{2/k} = 0.071$ and $\sqrt{2\ln 44850} \approx 4.6$, predicting a worst case near 0.33. The measured worst case is 0.357.
- The lemma's guarantee is not wildly pessimistic. At $k = 400$ it guarantees $\varepsilon = 0.394$; one draw achieved 0.357. Below $k = 24\ln n \approx 137$ the bound promises nothing at all, because $\varepsilon^2/2-\varepsilon^3/3 \le 1/6$ on $(0,1)$.
- Tight guarantees are expensive. $\varepsilon = 0.1$ for 300 points needs $k = 4889$, about half of $D$. JL pays off when $D$ is huge or when you only need $\varepsilon$ around 0.2 to 0.5.

---

## 3. Hadamard matrices and the fast transform

A **Hadamard matrix** of order $n$ has entries $\pm1$ and satisfies $HH^\top = nI$, so its rows are mutually orthogonal. Sylvester's construction doubles the order:

$$
H_1 = [1], \qquad H_{2n} = \begin{bmatrix} H_n & H_n \\ H_n & -H_n\end{bmatrix}.
$$

Properties of the Sylvester family, for $n = 2^m$:

- $\tfrac1{\sqrt n}H$ is orthogonal **and** symmetric, so it is its own inverse.
- Row $i$ is a Walsh function: entry $(i,j)$ is $(-1)^{\langle i, j\rangle}$, where $\langle i,j\rangle$ counts the 1 bits shared by the binary expansions of $i$ and $j$.
- The recursion gives a butterfly algorithm, the **fast Walsh–Hadamard transform (FWHT)**: $\log_2 n$ passes of $n/2$ add/subtract pairs, $n\log_2 n$ additions and no multiplications until the final $1/\sqrt n$ scale. For $n = 4096$ that is 49,152 additions, against 16.8 million multiply-adds for a dense $n\times n$ product.

Hadamard matrices exist only for $n = 1, 2$ and multiples of 4. That every multiple of 4 works is the open Hadamard conjecture; the smallest unresolved order is 668. Sylvester's construction gives only powers of two. Other sizes use Paley constructions or Kronecker products such as $H_{12}\otimes H_{2^m}$, or **block-diagonal** Hadamards on power-of-two blocks, or zero-padding.

### Worked example 3 — build it, check it, transform fast

```python
# file: hadamard.py
# Sylvester Hadamard matrices and the fast Walsh-Hadamard transform (FWHT).
import numpy as np


def sylvester(m):
    """H_{2^m} with entries +-1, built by H_{2n} = [[H, H], [H, -H]]."""
    H = np.array([[1.0]])
    for _ in range(m):
        H = np.block([[H, H], [H, -H]])
    return H


def fwht(x):
    """Orthonormal transform (H / sqrt(n)) x along the last axis in O(n log n)."""
    x = np.array(x, dtype=np.float64, copy=True)
    shape, n = x.shape, x.shape[-1]
    assert n & (n - 1) == 0, "length must be a power of two"
    x = x.reshape(-1, n)
    h = 1
    while h < n:
        x = x.reshape(-1, n // (2 * h), 2, h)
        a = x[:, :, 0, :].copy()
        b = x[:, :, 1, :]
        x[:, :, 0, :] = a + b
        x[:, :, 1, :] = a - b
        x = x.reshape(-1, n)
        h *= 2
    return x.reshape(shape) / np.sqrt(n)


if __name__ == "__main__":
    H4 = sylvester(2)
    print(H4.astype(int))
    H = sylvester(10) / np.sqrt(1024)
    x = np.random.default_rng(0).standard_normal((5, 1024))
    print("orthogonal:      ", np.allclose(H @ H.T, np.eye(1024)))
    print("symmetric:       ", np.allclose(H, H.T))
    print("fwht == H @ x:   ", np.allclose(fwht(x), x @ H.T))
    print("fwht(fwht(x))==x:", np.allclose(fwht(fwht(x)), x))
```

```bash
python hadamard.py
```

Output:

```text
[[ 1  1  1  1]
 [ 1 -1  1 -1]
 [ 1  1 -1 -1]
 [ 1 -1 -1  1]]
orthogonal:       True
symmetric:        True
fwht == H @ x:    True
fwht(fwht(x))==x: True
```

---

## 4. Cheaper JL maps: sparse signs and the subsampled randomized Hadamard transform

A dense Gaussian $R$ costs $kD$ random numbers and $O(kD)$ time per vector. Two lines of work cut that down.

- **Achlioptas (2003):** entries $\sqrt{3/k}\cdot\{+1, 0, -1\}$ with probabilities $\{1/6, 2/3, 1/6\}$ satisfy the same bound. Two thirds of the matrix is zero, and the arithmetic is additions only.
- **Ailon–Chazelle (2006), the fast JL transform:** first apply $HD$, where $D$ is a random $\pm1$ diagonal and $H$ the normalized Hadamard matrix, and then a sparse or sampling projection. The popular **SRHT** variant keeps $k$ random coordinates of $HDx$ and rescales by $\sqrt{D/k}$ (in the scale factor $D$ is the ambient dimension, not the sign matrix). It costs $O(D\log D)$ per vector and stores only $D$ signs plus $k$ indices.

Why not just sample $k$ coordinates of $x$? Because sampling estimates $\lVert x\rVert^2$ well only when the energy is spread out. A vector with all of its energy in a few coordinates is either missed or overcounted by a factor of $D/k$. The $HD$ step exists to spread the energy first (Section 5).

### Worked example 4 — four projections to k = 512

```python
# file: jl_variants.py
# Three ways to project 300 points from D=8192 to k=512: dense Gaussian, sparse signs
# (Achlioptas), and the subsampled randomized Hadamard transform (SRHT).
import time

import numpy as np

from hadamard import fwht

rng = np.random.default_rng(2)
n, D, k = 300, 8192, 512
X = rng.standard_normal((n, 16)) @ rng.standard_normal((16, D))
X[:, :8] *= 40.0                                     # a few heavy coordinates
iu = np.triu_indices(n, k=1)


def sq_dists(Y):
    g = np.sum(Y * Y, 1)
    return (g[:, None] + g[None, :] - 2 * Y @ Y.T)[iu]


G = rng.standard_normal((D, k)) / np.sqrt(k)
S = rng.choice([-1.0, 0.0, 1.0], size=(D, k), p=[1 / 6, 2 / 3, 1 / 6]) * np.sqrt(3 / k)
signs = rng.choice([-1.0, 1.0], size=D)
rows = rng.choice(D, size=k, replace=False)
projections = {
    "Gaussian": lambda Z: Z @ G,
    "sparse signs": lambda Z: Z @ S,
    "SRHT": lambda Z: fwht(Z * signs)[:, rows] * np.sqrt(D / k),
    "subsample, no HD": lambda Z: Z[:, rows] * np.sqrt(D / k),
}
d0 = sq_dists(X)
print(f"{'projection':17} {'max |ratio-1|':>13} {'mean |ratio-1|':>14} {'storage':>16} {'ms':>6}")
for name, f in projections.items():
    t = time.perf_counter()
    Y = f(X)
    ms = 1e3 * (time.perf_counter() - t)
    dev = np.abs(sq_dists(Y) / d0 - 1)
    store = {"Gaussian": f"{D * k:,} floats", "sparse signs": f"{np.count_nonzero(S):,} nz",
             "SRHT": f"{D + k:,} ints", "subsample, no HD": f"{k:,} ints"}[name]
    print(f"{name:17} {dev.max():13.3f} {dev.mean():14.3f} {store:>16} {ms:6.1f}")
```

```bash
python jl_variants.py
```

Output:

```text
projection        max |ratio-1| mean |ratio-1|          storage     ms
Gaussian                  0.238          0.050 4,194,304 floats   25.3
sparse signs              0.314          0.045     1,397,248 nz   15.0
SRHT                      0.185          0.045       8,704 ints  176.1
subsample, no HD          9.656          1.805         512 ints    2.1
```

- All three JL constructions give mean distortion about 0.045 to 0.05, which matches $\sqrt{2/512}\cdot\sqrt{2/\pi} \approx 0.050$. The worst cases differ by draw and are all in the 0.2 to 0.3 range.
- Plain coordinate sampling fails badly: worst ratio off by 9.7x, because the eight heavy coordinates are sampled or missed at random.
- The timing column is a warning about asymptotics. On this machine the dense Gaussian product (BLAS, multithreaded) beats the NumPy-level FWHT, whose butterfly passes allocate temporaries. The $O(D\log D)$ advantage appears with a compiled or GPU FWHT, or when $k$ is close to $D$ so that a dense map would be $D \times D$. The storage column holds regardless: 8,704 small integers against 4.2 million floats.

---

## 5. Why random signs: the spreading lemma

Let $x$ be a fixed unit vector and $y = \tfrac1{\sqrt d}HDx$ with i.i.d. random signs $D_{jj}$. Each coordinate

$$
y_i = \frac1{\sqrt d}\sum_j H_{ij}D_{jj}\,x_j
$$

is a sum of independent, bounded, mean-zero terms with $\sum_j (H_{ij}x_j/\sqrt d)^2 = 1/d$. Hoeffding's inequality gives $\Pr(|y_i| > t) \le 2e^{-t^2d/2}$, and a union bound over the $d$ coordinates gives

$$
\max_i |y_i| \;\le\; \sqrt{\frac{2\ln(2d/\delta)}{d}} \quad\text{with probability at least } 1-\delta.
$$

A perfectly flat unit vector has every entry equal to $1/\sqrt d$, so the randomized Hadamard transform leaves every vector within a $\sqrt{2\ln(2d/\delta)}$ factor of flat, simultaneously and with high probability. That is what makes the SRHT work, and it is what Section 6 uses.

The signs are essential. Without them $Hx$ is deterministic, so some inputs map to spikes. The rows of $H$ are such inputs: $H$ maps a Walsh function to a one-hot vector, the worst possible output.

### Worked example 5 — peaks before and after

```python
# file: spread.py
# How evenly does y = (1/sqrt(d)) H D x spread a vector's energy? Compare the largest
# coordinate with the Hoeffding bound sqrt(2 ln(2d/delta) / d) for a unit vector x.
import numpy as np
from scipy.linalg import hadamard

from hadamard import fwht

rng = np.random.default_rng(3)
d, delta, trials = 1024, 0.01, 2000
bound = np.sqrt(2 * np.log(2 * d / delta) / d)
H = hadamard(d).astype(float)

inputs = {
    "one-hot e_0": np.eye(d)[0],
    "4 equal spikes": np.r_[np.full(4, 0.5), np.zeros(d - 4)],
    "Gaussian": rng.standard_normal(d),
    "Walsh row 37": H[37] / np.sqrt(d),
}
print(f"d={d}: perfectly flat = {1 / np.sqrt(d):.4f}, Hoeffding bound (delta={delta}) = {bound:.4f}")
print(f"{'input (unit norm)':18} {'max|x|':>7} {'max|Hx|':>8} {'max|HDx| median':>15} "
      f"{'worst of 2000':>13} {'P(> bound)':>10}")
for name, x in inputs.items():
    x = x / np.linalg.norm(x)
    D = rng.choice([-1.0, 1.0], size=(trials, d))
    peaks = np.abs(fwht(D * x)).max(axis=1)
    print(f"{name:18} {np.abs(x).max():7.4f} {np.abs(fwht(x)).max():8.4f} {np.median(peaks):15.4f} "
          f"{peaks.max():13.4f} {np.mean(peaks > bound):10.4f}")
```

```bash
python spread.py
```

Output:

```text
d=1024: perfectly flat = 0.0312, Hoeffding bound (delta=0.01) = 0.1546
input (unit norm)   max|x|  max|Hx| max|HDx| median worst of 2000 P(> bound)
one-hot e_0         1.0000   0.0312          0.0312        0.0312     0.0000
4 equal spikes      0.5000   0.0625          0.0625        0.0625     0.0000
Gaussian            0.1036   0.1011          0.1063        0.1545     0.0000
Walsh row 37        0.0312   1.0000          0.1055        0.1504     0.0000
```

- A one-hot or few-spike input becomes **exactly** flat (or nearly so) under $H$ alone, and under $HD$ too. Hadamard rows have entries of constant magnitude.
- A Walsh row is the adversarial case: $Hx$ has a peak of 1.0, the whole vector in one coordinate. With random signs the median peak is 0.106, in line with a random input.
- The Hoeffding bound (0.155) was never exceeded in 2000 sign draws for any input. The worst draws came within 3% of it, so the bound is not slack.

---

## 6. Rotate, then quantize

A **uniform quantizer** with $b$ bits and one scale per vector maps each entry to the nearest multiple of $s = \max_i|x_i| / q_{\max}$, with $q_{\max} = 2^{b-1}-1$. When most entries span several steps, the rounding error behaves like uniform noise of variance $s^2/12$, so

$$
\frac{\lVert x - \hat x\rVert}{\lVert x\rVert} \;\approx\; \frac{\kappa(x)}{q_{\max}\sqrt{12}}, \qquad \kappa(x) = \frac{\max_i |x_i|}{\operatorname{rms}(x)} \quad\text{(crest factor)}.
$$

The error is driven entirely by the crest factor, and an orthogonal rotation changes the crest factor without changing the vector's length or its inner products. If $Q$ is orthogonal, then $\langle Qx, Qw\rangle = \langle x, w\rangle$. A layer computing $Wx$ can therefore store $\operatorname{quant}(Qx)$ and use the weights $WQ^\top$, folded in offline. Nothing needs to be un-rotated at run time. This **computational invariance** is how QuaRot, QuIP# and SpinQuant quantize LLM weights and activations to 4 bits. Rotation-based vector quantizers for embeddings and attention caches (DRIVE, EDEN, RaBitQ, HIGGS, TurboQuant) build on the same idea, and their codebooks rely on Section 1: after a random rotation, every coordinate of a unit vector is approximately $\mathcal N(0, 1/d)$.

### Worked example 6 — 4-bit quantization with outliers

```python
# file: rotate_quantize.py
# Uniform 4-bit quantization with one scale per vector, before and after a shared
# randomized Hadamard rotation. Inner products survive if both sides use the same rotation.
import numpy as np

from hadamard import fwht

rng = np.random.default_rng(4)
n, d, bits = 2000, 256, 4
X = rng.standard_normal((n, d))
X[:, [5, 77, 200]] *= 30.0                            # outlier coordinates, as in real activations
W = rng.standard_normal((64, d)) / np.sqrt(d)         # 64 fixed "weight" rows
signs = rng.choice([-1.0, 1.0], size=d)
rot = lambda Z: fwht(Z * signs)                       # Q z with Q = (1/sqrt d) H D, orthogonal
unrot = lambda Z: fwht(Z) * signs                     # Q^T z


def quantize(Z, bits):
    qmax = 2 ** (bits - 1) - 1
    s = np.abs(Z).max(axis=1, keepdims=True) / qmax
    return np.clip(np.round(Z / s), -qmax - 1, qmax) * s


crest = lambda Z: np.mean(np.abs(Z).max(1) / np.sqrt(np.mean(Z**2, 1)))
rel = lambda A, B: np.linalg.norm(A - B) / np.linalg.norm(B)
Y = X @ W.T                                           # exact products
print(f"crest factor max|x|/rms(x): original {crest(X):.1f}, rotated {crest(rot(X)):.1f}, "
      f"i.i.d. Gaussian {crest(rng.standard_normal((n, d))):.1f}")
print(f"{'scheme':40} {'rel. error in x':>15} {'rel. error in Wx':>16}")
Xq = quantize(X, bits)
print(f"{'quantize x directly':40} {rel(Xq, X):15.4f} {rel(Xq @ W.T, Y):16.4f}")
Xr_q = quantize(rot(X), bits)                         # store this
print(f"{'rotate, quantize, unrotate':40} {rel(unrot(Xr_q), X):15.4f} {rel(unrot(Xr_q) @ W.T, Y):16.4f}")
Wr = rot(W)                                           # fold Q into the weights once: W Q^T
print(f"{'rotated x against rotated W (no unrotate)':40} {'':>15} {rel(Xr_q @ Wr.T, Y):16.4f}")
print(f"{'BUG: rotated x against original W':40} {'':>15} {rel(Xr_q @ W.T, Y):16.4f}")
```

```bash
python rotate_quantize.py
```

Output:

```text
crest factor max|x|/rms(x): original 12.1, rotated 2.3, i.i.d. Gaussian 3.0
scheme                                   rel. error in x rel. error in Wx
quantize x directly                               0.2745           0.2605
rotate, quantize, unrotate                        0.0867           0.0824
rotated x against rotated W (no unrotate)                           0.0824
BUG: rotated x against original W                                  1.4390
```

- Three coordinates at 30 times the scale give a crest factor of 12.1. With a 4-bit absmax quantizer the step is so large that every ordinary coordinate rounds to zero, and the error (27%) is simply the energy those coordinates carried.
- After the rotation the crest factor is 2.3, and the error drops to 8.7%. The formula predicts $2.3/(7\sqrt{12}) = 0.095$. The rotated vectors are even flatter than i.i.d. Gaussian ones (crest 3.0): a few large spikes rotate into $\pm a \pm b \pm c$ patterns of nearly constant magnitude.
- Rotating the weights instead of un-rotating the activations gives the same $Wx$ error (0.0824), confirming $\langle Qx, Qw\rangle = \langle x, w\rangle$.
- Forgetting to rotate the other side produces garbage (144% error). The mistake is silent: shapes match and nothing crashes.

---

## 7. The trap and the boring rule

**The trap:** treating a rotation as a free accuracy gain without checking its two side conditions.

1. **Consistency.** Every operand that meets the rotated vector in an inner product must see the same $Q$: same signs, same Hadamard ordering, same block size. A mismatched seed or a different FWHT ordering (natural versus sequency) is the last line of the table above.
2. **Randomness.** A deterministic Hadamard has adversarial inputs (Walsh-like vectors). Real data rarely looks like that, but "rarely" is an empirical claim about your data, not a theorem. The random sign vector costs $d$ bits and turns it into a theorem.

**The boring rule:** rotate with $\tfrac1{\sqrt d}HD$ from a recorded seed, fold the rotation into whatever sits on the other side of the inner product, and measure the quantity you care about (inner products, distances, model loss), not just the quantization MSE.

---

## 8. Pitfalls

| Pitfall | Symptom | Fix |
|---|---|---|
| Expecting JL to help at small $D$ | $k$ from the bound exceeds $D$ | JL pays off for $D \gg \varepsilon^{-2}\log n$ |
| Using the existence bound as a per-draw guarantee | Occasional bad projection | Use $6\ln n$ in place of $4\ln n$, or check distortion and redraw |
| Sampling coordinates without mixing first | Huge errors on spiky vectors | Apply $HD$ (or a Gaussian map) before sampling |
| Plain $H$ without random signs | Rare inputs map to spikes | Use $HD$ with a stored seed |
| $d$ not a power of two | Sylvester $H$ undefined | Pad, block-diagonal Hadamard, or a Kronecker product with a known $H_{12}$, $H_{20}$, ... |
| Rotating only one operand | Silent garbage in $Wx$ | Fold $Q$ into the other side: $WQ^\top$ |
| Forgetting $1/\sqrt d$ | Norms scale by $\sqrt d$ | Use the orthonormal transform; check $\lVert Qx\rVert = \lVert x\rVert$ |
| Trusting big-O for speed | FWHT slower than BLAS in NumPy | Benchmark the actual implementation |

---

## 9. Checkpoint

- Show $\mathbb E\langle u,v\rangle^2 = 1/d$ for independent random unit vectors.
- State the JL lemma, including what $k$ does and does not depend on.
- Explain where the union bound enters the proof and why it gives $\log n$.
- Give the cost of the FWHT and why $\tfrac1{\sqrt n}H$ is its own inverse.
- Derive $\max_i|y_i| \lesssim \sqrt{2\ln(2d/\delta)/d}$ for $y = \tfrac1{\sqrt d}HDx$.
- Explain why a rotation lowers uniform-quantization error and why it does not change $Wx$ when folded into $W$.

---

## Exercises

### Easy

1. For $d = 768$, what is the standard deviation of the angle between two random directions, in degrees?
2. Compute the lemma's $k$ for $n = 10^6$ points and $\varepsilon = 0.2$. Does it depend on whether the points live in $\mathbb R^{1000}$ or $\mathbb R^{10^9}$?
3. Write $H_8$ by Sylvester's construction and check that rows 3 and 5 are orthogonal.

### Medium

4. Show that $\mathbb E\lVert Rx\rVert^2 = \lVert x\rVert^2$ and $\operatorname{Var}(\lVert Rx\rVert^2) = 2\lVert x\rVert^4/k$ for $R$ with i.i.d. $\mathcal N(0,1/k)$ entries.
5. Count the additions in an FWHT of length $2^m$, and compare with a dense matrix-vector product at $m = 12$.
6. Modify `spread.py` to use a random permutation matrix $P$ in place of $D$. Does $HPx$ still flatten Walsh rows? Explain.
7. In `rotate_quantize.py`, sweep `bits` over 2 to 8 and plot both errors. At what bit-width does rotation stop mattering, and why?

### Challenge

8. Prove the "exponentially many nearly orthogonal vectors" claim: using $\Pr(|\langle u,v\rangle| > \varepsilon) \le 2e^{-d\varepsilon^2/2}$, show that $m = \lfloor e^{d\varepsilon^2/4}/2 \rfloor$ random unit vectors are pairwise $\varepsilon$-orthogonal with positive probability.
9. Implement a block-diagonal randomized Hadamard for $d = 96$ (three blocks of 32). How does its worst-case peak compare with a full $128$-point transform on the zero-padded vector?
10. Replace the uniform quantizer in `rotate_quantize.py` with a Lloyd–Max quantizer designed for $\mathcal N(0, 1/d)$ coordinates, applied to $Qx/\lVert x\rVert$ with $\lVert x\rVert$ stored separately. Compare the error at 2, 3 and 4 bits.

---

## Summary

Independent random directions in $\mathbb R^d$ have inner products of size $1/\sqrt d$, so high-dimensional space is full of nearly orthogonal directions. The Johnson–Lindenstrauss lemma turns this into an algorithm: a random linear map to $k = O(\varepsilon^{-2}\log n)$ dimensions preserves all pairwise distances of $n$ points within $1\pm\varepsilon$, independent of the original dimension, and this is optimal. The per-pair relative error has standard deviation $\sqrt{2/k}$, which predicts measured worst cases well. Hadamard matrices give orthogonal transforms computable in $n\log n$ additions. With random signs in front, the randomized Hadamard transform spreads every vector's energy to within $\sqrt{2\ln(2d/\delta)}$ of flat, which makes coordinate sampling (SRHT) and coarse scalar quantization work. Rotation preserves inner products, so it can be folded into the other operand for free. It is only safe when both sides use the same rotation and the rotation includes the random signs.

---

## Sources (for further reading)

- W. B. Johnson, J. Lindenstrauss, "Extensions of Lipschitz mappings into a Hilbert space", *Contemporary Mathematics* 26 (1984).
- S. Dasgupta, A. Gupta, "An elementary proof of a theorem of Johnson and Lindenstrauss", *Random Structures & Algorithms* 22(1) (2003). Constants used in Section 2.
- D. Achlioptas, "Database-friendly random projections: Johnson–Lindenstrauss with binary coins", *JCSS* 66(4) (2003).
- N. Ailon, B. Chazelle, "Approximate nearest neighbors and the fast Johnson–Lindenstrauss transform", STOC 2006; *SIAM J. Computing* 39(1) (2009).
- J. A. Tropp, "Improved analysis of the subsampled randomized Hadamard transform", *Advances in Adaptive Data Analysis* 3 (2011).
- K. G. Larsen, J. Nelson, "Optimality of the Johnson–Lindenstrauss lemma", FOCS 2017.
- R. Vershynin, *High-Dimensional Probability* (Cambridge, 2018), chapters 2–3 (Hoeffding, concentration on the sphere).
- A. Baggag, Y. Saad, "The Numerical Linear Algebra of Large Language Models" (arXiv:2610.04631, 2026), §3.14 (near-orthogonality in 12,288 dimensions) and §4.4 (randomized methods, Linformer).
- S. Ashkboos et al., "QuaRot: Outlier-Free 4-Bit Inference in Rotated LLMs" (NeurIPS 2024). A. Tseng et al., "QuIP#" (ICML 2024). Z. Liu et al., "SpinQuant" (ICLR 2025).
- S. Vargaftik et al., DRIVE (NeurIPS 2021) and EDEN (ICML 2022). J. Gao, C. Long, "RaBitQ" (SIGMOD 2024). A. Zandieh et al., "TurboQuant" (arXiv:2504.19874, ICLR 2026).

**Inspiration (not a source):** a post on X by Omri Weinstein on the Hadamard transform behind low-bit quantization, https://x.com/WeinsteinOmri/status/2070482412908277797. The mathematics above follows the papers and texts listed.
