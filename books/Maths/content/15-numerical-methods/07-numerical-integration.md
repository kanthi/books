---
title: "Numerical Integration (Quadrature)"
author:
  - name: "K19G"
  - name: "grok-bot"
---

Most integrals that matter in computing have no closed form: the normalising constant of a posterior, the expected loss under a data distribution, the energy in a signal, the light arriving at a pixel. A **quadrature rule** replaces $\int_a^b f(x)\,dx$ by a weighted sum of function values,

$$
\int_a^b f(x)\,dx \;\approx\; \sum_{i=1}^{n} w_i\, f(x_i),
$$

and the whole craft is choosing the **nodes** $x_i$ and **weights** $w_i$ so the error is small for the functions you actually have, with as few evaluations of $f$ as possible. Evaluations are the cost unit: $f$ may be a simulation, a neural network, or a database query.

This chapter builds the working toolkit: composite Newton–Cotes rules and how to *measure* their order, the surprising accuracy of the trapezoid rule on periodic functions, Richardson extrapolation (Romberg), Gaussian quadrature, adaptive subdivision, singularities and infinite ranges, production use of `scipy.integrate.quad` (and where it silently fails), and what changes in many dimensions.

All listings are complete Python files. They were run on Debian 13 with **Python 3.13.5, NumPy 2.5.3, SciPy 1.18.1**; outputs are pasted unedited.

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install numpy scipy
```

## 1. Rules, exactness, and order

Two numbers describe a rule:

- **Degree of exactness** $p$: the rule integrates every polynomial of degree $\le p$ exactly. Trapezoid has $p=1$, Simpson $p=3$ (one better than you would expect from quadratics, by symmetry), $n$-point Gauss–Legendre $p=2n-1$.  
- **Order of convergence** of the *composite* rule: split $[a,b]$ into $N$ panels of width $h=(b-a)/N$, apply the basic rule on each, and the error behaves like $C\,h^{q}$ for smooth $f$. Trapezoid $q=2$, Simpson $q=4$.

| Rule | Basic form on $[x_0,x_0+h]$ (or $[x_0, x_0+2h]$ for Simpson) | Error term (smooth $f$) |
|------|-------------|------------|
| Midpoint | $h\,f(x_0+h/2)$ | $+\frac{h^3}{24}f''(\xi)$ per panel |
| Trapezoid | $\frac{h}{2}\,[f(x_0)+f(x_0+h)]$ | $-\frac{h^3}{12}f''(\xi)$ per panel |
| Simpson | $\frac{h}{3}\,[f(x_0)+4f(x_0+h)+f(x_0+2h)]$ | $-\frac{h^5}{90}f^{(4)}(\xi)$ per pair |
| Composite trapezoid | | $-\frac{(b-a)h^2}{12}f''(\xi)$ |
| Composite Simpson | | $-\frac{(b-a)h^4}{180}f^{(4)}(\xi)$ |

Summing $N\propto 1/h$ panel errors of size $h^3$ gives the global $h^2$; that bookkeeping is where the "one order lost" comes from.

### Worked example 1 — measure the order

Halve $h$; for an order-$q$ method the error should drop by $2^q$. Never trust a label you have not measured.

```python
# file: composite_order.py
# Observed order of composite trapezoid and Simpson on I = ∫_0^1 e^x dx = e - 1.
import math

def trapezoid(f, a, b, n):
    h = (b - a) / n
    s = 0.5 * (f(a) + f(b)) + sum(f(a + i * h) for i in range(1, n))
    return h * s

def simpson(f, a, b, n):            # n must be even
    h = (b - a) / n
    s = f(a) + f(b)
    s += 4 * sum(f(a + i * h) for i in range(1, n, 2))
    s += 2 * sum(f(a + i * h) for i in range(2, n, 2))
    return h * s / 3

exact = math.e - 1
print(f"{'n':>5} {'trap error':>12} {'ratio':>6} {'simp error':>12} {'ratio':>6}")
prev_t = prev_s = None
for n in [2, 4, 8, 16, 32, 64, 128]:
    et = abs(trapezoid(math.exp, 0, 1, n) - exact)
    es = abs(simpson(math.exp, 0, 1, n) - exact)
    rt = f"{prev_t / et:6.2f}" if prev_t else "     -"
    rs = f"{prev_s / es:6.2f}" if prev_s else "     -"
    print(f"{n:5d} {et:12.3e} {rt} {es:12.3e} {rs}")
    prev_t, prev_s = et, es
```

```bash
python3 composite_order.py
```

```text
    n   trap error  ratio   simp error  ratio
    2    3.565e-02      -    5.793e-04      -
    4    8.940e-03   3.99    3.701e-05  15.65
    8    2.237e-03   4.00    2.326e-06  15.91
   16    5.593e-04   4.00    1.456e-07  15.98
   32    1.398e-04   4.00    9.103e-09  15.99
   64    3.496e-05   4.00    5.690e-10  16.00
  128    8.740e-06   4.00    3.556e-11  16.00
```

Ratios settle at $4=2^2$ and $16=2^4$. If your own implementation shows a ratio of 2 where you expected 4, you have a bug (often a misplaced endpoint weight), or $f$ is not as smooth as you think (§6).

## 2. The trapezoid rule on periodic functions

The **Euler–Maclaurin formula** explains the trapezoid error exactly:

$$
T_h - \int_a^b f = \frac{h^2}{12}\big[f'(b)-f'(a)\big] - \frac{h^4}{720}\big[f'''(b)-f'''(a)\big] + \cdots
$$

Every term is a difference of odd derivatives at the **endpoints**. If $f$ is smooth and periodic with period $b-a$, all of them vanish, and the error decays faster than any power of $h$ — typically geometrically.

### Worked example 2 — the same rule, two integrands

```python
# file: periodic_trap.py
# Trapezoid on a smooth PERIODIC integrand over a full period:
#   I = ∫_0^{2π} e^{cos x} dx = 2π I_0(1)   (I_0 = modified Bessel function)
# Compare with the same rule on a non-periodic integrand of similar smoothness.
import math
from scipy.special import i0

def trapezoid(f, a, b, n):
    h = (b - a) / n
    return h * (0.5 * (f(a) + f(b)) + sum(f(a + i * h) for i in range(1, n)))

exact_p = 2 * math.pi * i0(1.0)
exact_np = math.e - 1                       # ∫_0^1 e^x dx, not periodic on [0,1]
print(f"{'n':>4} {'periodic err':>14} {'non-periodic err':>17}")
for n in [2, 4, 8, 16, 32]:
    ep = abs(trapezoid(lambda x: math.exp(math.cos(x)), 0, 2 * math.pi, n) - exact_p)
    en = abs(trapezoid(math.exp, 0, 1, n) - exact_np)
    print(f"{n:4d} {ep:14.3e} {en:17.3e}")
```

```bash
python3 periodic_trap.py
```

```text
   n   periodic err  non-periodic err
   2      1.741e+00         3.565e-02
   4      3.440e-02         8.940e-03
   8      1.252e-06         2.237e-03
  16      0.000e+00         5.593e-04
  32      1.776e-15         1.398e-04
```

Sixteen points reach machine precision on the periodic integrand; the non-periodic one is still at $5\times 10^{-4}$. This is why the trapezoid rule, not Simpson, is the right default for integrals over a full period (Fourier coefficients, contour integrals, averages over an angle), and why the DFT is a trapezoid rule in disguise.

## 3. Richardson extrapolation and Romberg integration

If $T(h) = I + c_1 h^2 + c_2 h^4 + \cdots$, then $\frac{4T(h/2)-T(h)}{3}$ cancels the $h^2$ term. (That combination is exactly composite Simpson.) Repeating the trick column by column gives the **Romberg table**:

$$
R_{k,j} = R_{k,j-1} + \frac{R_{k,j-1}-R_{k-1,j-1}}{4^{j}-1}.
$$

### Worked example 3 — Romberg for $\pi$

```python
# file: romberg.py
# Richardson extrapolation on trapezoid values = Romberg integration.
# I = ∫_0^1 4/(1+x^2) dx = π.
import math

def trapezoid(f, a, b, n):
    h = (b - a) / n
    return h * (0.5 * (f(a) + f(b)) + sum(f(a + i * h) for i in range(1, n)))

f = lambda x: 4 / (1 + x * x)
levels = 6
R = [[0.0] * levels for _ in range(levels)]
for k in range(levels):
    R[k][0] = trapezoid(f, 0, 1, 2 ** k)          # n = 1, 2, 4, ... panels
    for j in range(1, k + 1):                     # cancel h^2, h^4, h^6, ... terms
        R[k][j] = R[k][j - 1] + (R[k][j - 1] - R[k - 1][j - 1]) / (4 ** j - 1)

for k in range(levels):
    print(f"n={2**k:3d} " + " ".join(f"{R[k][j]:.12f}" for j in range(k + 1)))
print("errors in the last row:", " ".join(f"{abs(R[5][j] - math.pi):.1e}" for j in range(levels)))
print(f"function evaluations used: {2**(levels-1) + 1}")
```

```bash
python3 romberg.py
```

```text
n=  1 3.000000000000
n=  2 3.100000000000 3.133333333333
n=  4 3.131176470588 3.141568627451 3.142117647059
n=  8 3.138988494491 3.141592502459 3.141594094126 3.141585783762
n= 16 3.140941612041 3.141592651225 3.141592661143 3.141592638397 3.141592665278
n= 32 3.141429893175 3.141592653553 3.141592653708 3.141592653590 3.141592653650 3.141592653638
errors in the last row: 1.6e-04 3.7e-11 1.2e-10 2.4e-13 6.0e-11 4.8e-11
function evaluations used: 33
```

From the same 33 evaluations, the plain trapezoid value is good to $10^{-4}$ and the extrapolated values to $10^{-11}$–$10^{-13}$. But the errors along the last row are **not monotone**, and that is the lesson. For $f=4/(1+x^2)$ the coefficient $c_2$ is zero, because $f'''(1)-f'''(0)=0$ (check: $f'(1)-f'(0)=-2$, $f'''(1)-f'''(0)=0$, $f^{(5)}(1)-f^{(5)}(0)=60$). So column 1 is already sixth order, and column 2, built to cancel an $h^4$ term that does not exist, removes nothing useful and adds noise. Extrapolation assumes an error expansion. When the assumption is wrong, or $f$ is not smooth, extra columns can make things worse. Watch the differences between neighbouring entries, not just the corner.

## 4. Gaussian quadrature

Newton–Cotes rules fix the nodes (equally spaced) and choose weights. **Gauss** chooses both: with $n$ free nodes and $n$ free weights you can match $2n$ moments, so $n$-point Gauss–Legendre is exact for polynomials of degree $2n-1$. The nodes are the roots of the Legendre polynomial $P_n$. The **Golub–Welsch** algorithm gets them, stably, as eigenvalues of a small symmetric tridiagonal matrix built from the three-term recurrence; the weights come from the first components of the eigenvectors.

### Worked example 4 — build the rule, check exactness, race Simpson

```python
# file: gauss_legendre.py
# Gauss–Legendre nodes/weights from the Golub–Welsch eigenvalue method,
# checked against numpy, then used on I = ∫_{-1}^{1} e^x dx = e - 1/e.
import math
import numpy as np

def golub_welsch(n):
    k = np.arange(1, n)
    beta = k / np.sqrt(4 * k * k - 1)          # Legendre recurrence coefficients
    J = np.diag(beta, 1) + np.diag(beta, -1)   # symmetric tridiagonal Jacobi matrix
    x, V = np.linalg.eigh(J)
    w = 2 * V[0, :] ** 2                       # weight = 2 * (first eigenvector component)^2
    return x, w

x, w = golub_welsch(3)
print("n=3 nodes  ", np.round(x, 12))
print("n=3 weights", np.round(w, 12))
xr, wr = np.polynomial.legendre.leggauss(3)
print("max |diff| vs numpy leggauss:", max(np.max(abs(x - xr)), np.max(abs(w - wr))))

# Degree of exactness: n points integrate polynomials up to degree 2n-1 exactly.
for deg in [4, 5, 6]:
    approx = np.sum(w * x ** deg)
    exact = 0.0 if deg % 2 else 2 / (deg + 1)
    print(f"n=3, ∫x^{deg}: rule {approx:.15f}  exact {exact:.15f}")

exact = math.e - 1 / math.e
print(f"{'evals':>5} {'Gauss error':>12} {'Simpson error':>14}")
for n in [3, 5, 7, 9, 11]:                     # odd n: Simpson with n-1 panels uses n points too
    xg, wg = golub_welsch(n)
    eg = abs(np.sum(wg * np.exp(xg)) - exact)
    m = n - 1
    h = 2 / m
    xs = -1 + h * np.arange(m + 1)
    cs = np.ones(m + 1); cs[1:-1:2] = 4; cs[2:-1:2] = 2
    es = abs(h / 3 * np.sum(cs * np.exp(xs)) - exact)
    print(f"{n:5d} {eg:12.3e} {es:14.3e}")
```

```bash
python3 gauss_legendre.py
```

```text
n=3 nodes   [-0.77459667  0.          0.77459667]
n=3 weights [0.55555556 0.88888889 0.55555556]
max |diff| vs numpy leggauss: 3.3306690738754696e-16
n=3, ∫x^4: rule 0.400000000000000  exact 0.400000000000000
n=3, ∫x^5: rule -0.000000000000000  exact 0.000000000000000
n=3, ∫x^6: rule 0.240000000000000  exact 0.285714285714286
evals  Gauss error  Simpson error
    3    6.546e-05      1.165e-02
    5    8.248e-10      7.924e-04
    7    2.665e-15      1.591e-04
    9    4.441e-16      5.063e-05
   11    0.000e+00      2.079e-05
```

Three points integrate $x^4$ and $x^5$ exactly and fail at $x^6$: degree of exactness $5=2\cdot3-1$, as promised. On the smooth integrand $e^x$, seven Gauss points reach $3\times10^{-15}$, while Simpson with the same seven evaluations is at $1.6\times10^{-4}$. For smooth $f$, Gauss error decays geometrically in $n$; Newton–Cotes decays algebraically.

Variants worth knowing: **Gauss–Kronrod** (a $2n+1$-point rule that reuses the $n$ Gauss nodes, so the difference gives a free error estimate; QUADPACK is built on 7–15 and 10–21 pairs), **Gauss–Hermite** for $\int e^{-x^2}f$, **Gauss–Laguerre** for $\int_0^\infty e^{-x}f$, and **Clenshaw–Curtis** (Chebyshev nodes, nested, nearly as accurate as Gauss in practice).

## 5. Adaptive quadrature

Uniform panels waste evaluations where $f$ is boring and starve the places where it changes fast. **Adaptive** rules estimate the error on each panel by comparing a coarse and a fine answer, and split only where the estimate exceeds the local tolerance.

### Worked example 5 — one sharp peak

$f(x) = 1/((x-0.3)^2+10^{-6})$ has a spike of width $\sim10^{-3}$ at $x=0.3$.

```python
# file: adaptive_simpson.py
# Adaptive Simpson vs uniform Simpson on a function with one sharp feature:
#   f(x) = 1 / ((x - 0.3)^2 + 1e-6) on [0, 1].  Exact via arctan.
import math

calls = 0
def f(x):
    global calls
    calls += 1
    return 1.0 / ((x - 0.3) ** 2 + 1e-6)

eps = 1e-3
exact = (math.atan(0.7 / eps) + math.atan(0.3 / eps)) / eps

def simpson_panel(a, fa, m, fm, b, fb):
    return (b - a) / 6 * (fa + 4 * fm + fb)

def adapt(a, fa, m, fm, b, fb, whole, tol, depth):
    lm, rm = (a + m) / 2, (m + b) / 2
    flm, frm = f(lm), f(rm)
    left = simpson_panel(a, fa, lm, flm, m, fm)
    right = simpson_panel(m, fm, rm, frm, b, fb)
    delta = left + right - whole
    if depth == 0 or abs(delta) <= 15 * tol:          # 15 = 2^4 - 1 (Simpson is O(h^4))
        return left + right + delta / 15              # Richardson-corrected
    return (adapt(a, fa, lm, flm, m, fm, left, tol / 2, depth - 1) +
            adapt(m, fm, rm, frm, b, fb, right, tol / 2, depth - 1))

def adaptive_simpson(a, b, tol, depth=50):
    fa, fb, m = f(a), f(b), (a + b) / 2
    fm = f(m)
    return adapt(a, fa, m, fm, b, fb, simpson_panel(a, fa, m, fm, b, fb), tol, depth)

def uniform_simpson(a, b, n):
    h = (b - a) / n
    s = f(a) + f(b) + 4 * sum(f(a + i * h) for i in range(1, n, 2)) \
        + 2 * sum(f(a + i * h) for i in range(2, n, 2))
    return h * s / 3

for tol in [1e-4, 1e-8]:
    calls = 0
    v = adaptive_simpson(0, 1, tol)
    print(f"adaptive tol={tol:.0e}: error {abs(v - exact):.2e} with {calls} evaluations")
for n in [512, 8192, 65536]:
    calls = 0
    v = uniform_simpson(0, 1, n)
    print(f"uniform  n={n:5d}:   error {abs(v - exact):.2e} with {calls} evaluations")
```

```bash
python3 adaptive_simpson.py
```

```text
adaptive tol=1e-04: error 7.89e-07 with 1645 evaluations
adaptive tol=1e-08: error 4.55e-13 with 16249 evaluations
uniform  n=  512:   error 3.17e+02 with 513 evaluations
uniform  n= 8192:   error 4.31e-09 with 8193 evaluations
uniform  n=65536:   error 4.55e-13 with 65537 evaluations
```

At $4.6\times10^{-13}$, adaptive Simpson needs 16,249 evaluations where uniform Simpson needs 65,537. With 513 uniform points the spike is under-sampled and the answer is off by 317 (the integral is about 3,140). The factor 15 is $2^4-1$: comparing Simpson on a panel and on its two halves gives the error estimate *and* a Richardson correction for free. The tolerance is halved on each split so the panel errors add up to at most the global tolerance.

## 6. Singularities and infinite ranges

Every error formula above assumed bounded high derivatives. An endpoint like $\sqrt{x}$ at $0$ (continuous, but $f'$ unbounded) silently lowers the order.

### Worked example 6 — order collapse and the cure

```python
# file: singular_endpoint.py
# ∫_0^1 sqrt(x) dx = 2/3.  sqrt is continuous but not differentiable at 0:
# Simpson's h^4 rate collapses.  Substituting x = t^2 gives ∫_0^1 2 t^2 dt — a polynomial.
import math

def simpson(f, a, b, n):
    h = (b - a) / n
    s = f(a) + f(b) + 4 * sum(f(a + i * h) for i in range(1, n, 2)) \
        + 2 * sum(f(a + i * h) for i in range(2, n, 2))
    return h * s / 3

exact = 2 / 3
print(f"{'n':>5} {'Simpson on sqrt(x)':>19} {'ratio':>6} {'after x=t^2':>12}")
prev = ratio = None
for n in [4, 8, 16, 32, 64, 128]:
    e = abs(simpson(math.sqrt, 0, 1, n) - exact)
    e2 = abs(simpson(lambda t: 2 * t * t, 0, 1, n) - exact)
    ratio = prev / e if prev else None
    r = f"{ratio:6.2f}" if ratio else "     -"
    print(f"{n:5d} {e:19.3e} {r} {e2:12.1e}")
    prev = e
print(f"observed order = log2(last ratio) = {math.log2(ratio):.2f}   (theory: 1.5)")
```

```bash
python3 singular_endpoint.py
```

```text
    n  Simpson on sqrt(x)  ratio  after x=t^2
    4           1.014e-02      -      0.0e+00
    8           3.587e-03   2.83      0.0e+00
   16           1.268e-03   2.83      0.0e+00
   32           4.485e-04   2.83      0.0e+00
   64           1.586e-04   2.83      0.0e+00
  128           5.606e-05   2.83      0.0e+00
observed order = log2(last ratio) = 1.50   (theory: 1.5)
```

The measured ratio $2.83=2^{1.5}$ says Simpson has become an $O(h^{1.5})$ method. The substitution $x=t^2$, $dx = 2t\,dt$ turns the integrand into $2t^2$, a quadratic that Simpson integrates exactly. Change variables to move singular behaviour out of the integrand before you integrate. For $\int_0^\infty$, map to a finite interval ($x=t/(1-t)$) or use a rule with the right weight (Gauss–Laguerre). The **tanh-sinh** (double-exponential) substitution handles endpoint singularities of unknown type remarkably well and is the default in arbitrary-precision libraries.

## 7. Production quadrature: `scipy.integrate.quad`

`quad` wraps QUADPACK (globally adaptive Gauss–Kronrod with extrapolation for singularities, plus transformations for infinite ranges). Use it, but read everything it returns.

### Worked example 7 — four calls, one trap

```python
# file: scipy_quad.py
# Production quadrature: scipy.integrate.quad (QUADPACK) — read its error estimate and evaluation count.
import math
from scipy import integrate

f = lambda x: 1.0 / ((x - 0.3) ** 2 + 1e-4)
exact = (math.atan(70) + math.atan(30)) / 1e-2
val, err, info = integrate.quad(f, 0, 1, full_output=True)
print(f"peak:      value {val:.12f} est.err {err:.1e} true err {abs(val-exact):.1e} neval {info['neval']}")

# Integrable endpoint singularity: ∫_0^1 x^(-1/2) dx = 2
val, err, info = integrate.quad(lambda x: x ** -0.5, 0, 1, full_output=True)
print(f"1/sqrt(x): value {val:.12f} est.err {err:.1e} neval {info['neval']}")

# Infinite interval: ∫_0^∞ e^(-x^2) dx = sqrt(pi)/2
val, err = integrate.quad(lambda x: math.exp(-x * x), 0, math.inf)
print(f"gaussian:  value {val:.15f} true err {abs(val - math.sqrt(math.pi)/2):.1e}")

# A trap: a narrow feature far from where quad looks. Exact ≈ 1 (bump area), on [0, 1000].
bump = lambda x: math.exp(-((x - 700.0) / 0.1) ** 2) / (0.1 * math.sqrt(math.pi))
val, err, info = integrate.quad(bump, 0, 1000, full_output=True)
print(f"bump, no hint:        value {val:.6e} est.err {err:.1e} neval {info['neval']}")
val, err = integrate.quad(bump, 0, 1000, points=[699.5, 700.5])
print(f"bump, points=[699.5,700.5]: value {val:.12f} est.err {err:.1e}")
```

```bash
python3 scipy_quad.py
```

```text
peak:      value 309.398691512415 est.err 2.4e-08 true err 1.7e-13 neval 315
1/sqrt(x): value 2.000000000000 est.err 3.8e-15 neval 231
gaussian:  value 0.886226925452758 true err 0.0e+00
bump, no hint:        value 0.000000e+00 est.err 0.0e+00 neval 21
bump, points=[699.5,700.5]: value 0.999999999999 est.err 2.6e-14
```

- The peak (width $10^{-2}$ here) is handled in 315 evaluations, and the **reported** error ($2.4\times10^{-8}$) is a pessimistic bound on the **true** one ($1.7\times10^{-13}$). That is the right direction to be wrong.
- The $x^{-1/2}$ singularity at $0$ is detected and extrapolated away. QUADPACK never evaluates the endpoint.
- The infinite range is mapped internally.
- **The trap:** a narrow bump at $x=700$ in $[0,1000]$. The first 21-point Kronrod rule never lands near it, sees a function that is zero everywhere it looked, and reports **value 0 with error estimate 0 after 21 evaluations — and no warning**. An adaptive method can only refine what it has seen. If you know where features are, say so (`points=`, or split the range yourself). If you do not, sample $f$ on a grid first.

Related tools: `scipy.integrate.quad_vec` (vector-valued $f$), `fixed_quad` (plain $n$-point Gauss), `simpson`/`trapezoid` for **tabulated data** you cannot re-sample, and `nquad`/`tplquad` for low-dimensional nested integrals.

## 8. Many dimensions: tensor grids, Monte Carlo, quasi-Monte Carlo

A tensor-product rule with $n$ points per axis costs $n^d$ evaluations: fine for $d\le 3$, painful by $d=6$, hopeless at $d=20$ ($2^{20}\approx10^6$ points for the crudest rule). **Monte Carlo** averages $f$ at $N$ random points. Its error is $\sigma/\sqrt{N}$ whatever the dimension, but $\sqrt{N}$ is slow. **Quasi-Monte Carlo** uses low-discrepancy points (Sobol', Halton) and, for reasonably smooth $f$, gets close to $1/N$. Scrambling makes it randomised, so repetitions give an error estimate.

### Worked example 8 — $d=6$

```python
# file: high_dim.py
# d = 6:  I = ∫_[0,1]^6  Π_i (π/2) sin(π x_i) dx = 1.
# Tensor-product Gauss–Legendre vs Monte Carlo vs scrambled Sobol' (quasi-Monte Carlo).
import numpy as np
from scipy.stats import qmc

d = 6
f = lambda X: np.prod(0.5 * np.pi * np.sin(np.pi * X), axis=1)

print("tensor Gauss–Legendre (n points per axis → n^d evaluations)")
for n in [2, 3, 4, 6]:
    x, w = np.polynomial.legendre.leggauss(n)
    x, w = (x + 1) / 2, w / 2                      # map [-1,1] → [0,1]
    grids = np.meshgrid(*([x] * d), indexing="ij")
    X = np.stack([g.ravel() for g in grids], axis=1)
    W = np.prod(np.stack(np.meshgrid(*([w] * d), indexing="ij")).reshape(d, -1), axis=0)
    print(f"  n={n}: evals {n**d:6d}  error {abs(W @ f(X) - 1):.2e}")

rng = np.random.default_rng(20261008)
print("Monte Carlo vs scrambled Sobol' (mean |error| over 20 repetitions)")
for m in [10, 12, 14, 16]:
    N = 2 ** m
    mc = [abs(f(rng.random((N, d))).mean() - 1) for _ in range(20)]
    qm = [abs(f(qmc.Sobol(d, scramble=True, seed=rng).random_base2(m)).mean() - 1) for _ in range(20)]
    print(f"  N=2^{m} = {N:6d}:  MC {np.mean(mc):.2e}   Sobol {np.mean(qm):.2e}")
```

```bash
python3 high_dim.py
```

```text
tensor Gauss–Legendre (n points per axis → n^d evaluations)
  n=2: evals     64  error 1.78e-01
  n=3: evals    729  error 4.17e-03
  n=4: evals   4096  error 4.73e-05
  n=6: evals  46656  error 1.57e-09
Monte Carlo vs scrambled Sobol' (mean |error| over 20 repetitions)
  N=2^10 =   1024:  MC 2.87e-02   Sobol 4.45e-03
  N=2^12 =   4096:  MC 1.52e-02   Sobol 2.30e-03
  N=2^14 =  16384:  MC 1.25e-02   Sobol 7.38e-04
  N=2^16 =  65536:  MC 4.26e-03   Sobol 6.87e-05
```

Read it honestly. For this **smooth, separable** integrand in six dimensions, tensor Gauss still wins ($46{,}656$ points give $10^{-9}$). Monte Carlo improves by about $2\times$ per $4\times$ more points ($N^{-1/2}$), and scrambled Sobol' is $6$–$60\times$ better than Monte Carlo at the same $N$ and improves faster. The crossover to (Q)MC comes with higher $d$, less smoothness, or integrands you can only sample (expectations under a simulator). Sparse grids (Smolyak) sit in between.

## 9. Choosing a method

| Situation | First choice | Why |
|-----------|-------------|-----|
| Smooth $f$ on $[a,b]$, cheap to call | `scipy.integrate.quad` | Adaptive Gauss–Kronrod with error estimate |
| Smooth periodic $f$ over a full period | Composite trapezoid | Geometric convergence (§2) |
| Fixed budget, smooth $f$, no adaptivity | $n$-point Gauss–Legendre | Degree $2n-1$, geometric convergence |
| Tabulated samples only | `simpson` / `trapezoid` on the data | Cannot choose nodes |
| Known endpoint singularity | Substitution, then any rule; or `quad` | Restores smoothness (§6) |
| Narrow features at known locations | `quad(..., points=[...])` or split ranges | Adaptive rules cannot find what they never sample (§7) |
| $d \lesssim 4$, smooth | Nested `quad` / tensor Gauss | Accurate, deterministic |
| $d \gtrsim 6$ or rough $f$ | Scrambled Sobol' QMC, else MC | Dimension-robust; repeat for error bars |

## 10. Pitfalls

1. **Trusting a label instead of a measurement.** Halve $h$ (or double $n$) and look at the ratio (§1).  
2. **Assuming smoothness.** Kinks, $\sqrt{\cdot}$, $|x|$, and discontinuities drop the order. Split at the kink or substitute (§6).  
3. **Believing "error estimate 0".** It means "no evidence of error where I looked" (§7).  
4. **Extrapolating past what the error expansion supports.** Romberg columns are not guaranteed to improve (§3).  
5. **Equally spaced high-order Newton–Cotes.** Beyond Simpson/Boole, weights turn negative and rounding amplifies. Go composite or Gauss.  
6. **Tolerance below conditioning.** Integrals of large cancelling values ($\int$ of an oscillating function with a small net area) cannot be computed to a relative accuracy better than (cancellation × $u$). Ask for an absolute tolerance.  
7. **Grids in high dimension.** $n^d$ grows faster than your patience.  

## 11. Checkpoint

- State the degree of exactness of trapezoid, Simpson, and $n$-point Gauss–Legendre  
- Measure the order of a composite rule from an error table  
- Explain, from Euler–Maclaurin, why trapezoid excels on periodic integrands  
- Build one Romberg column and say when extra columns stop helping  
- Describe how adaptive Simpson estimates its own error (the factor 15)  
- Remove an endpoint singularity by substitution  
- Read `quad`'s value, error estimate, and `neval`, and name a case where all three mislead  
- Pick between tensor Gauss, MC, and QMC for a given $d$ and smoothness  

## Exercises

### Easy

1. Apply the composite trapezoid rule with $N=4$ to $\int_0^1 x^3\,dx$ by hand and compare with the error formula.  
2. Show that Simpson's rule integrates $x^3$ exactly on $[-1,1]$ even though it is built from quadratics.  
3. Verify the 3-point Gauss–Legendre nodes $0,\pm\sqrt{3/5}$ and weights $8/9, 5/9$ by integrating $1, x^2, x^4$.  

### Medium

4. Modify `composite_order.py` to integrate $|x-1/3|$ on $[0,1]$. What orders do you observe, and why does splitting at $1/3$ restore them?  
5. Use `periodic_trap.py` to integrate $1/(2+\cos x)$ over $[0,2\pi]$ (exact: $2\pi/\sqrt3$). How many points reach $10^{-14}$?  
6. Replace Simpson inside `adaptive_simpson.py` with 3-point Gauss on each panel (compare one panel against its two halves). How many evaluations does it need for `tol=1e-8`?  
7. In `high_dim.py`, set $d=12$ and keep $n=2$ for tensor Gauss. Compare the cost and error with Sobol' at $N=2^{12}$.  

### Challenge

8. Implement Gauss–Kronrod 7–15 (look up the 15 nodes and weights in the QUADPACK documentation) and use $|G_7-K_{15}|$ as an error estimate in a globally adaptive integrator with a priority queue of panels.  
9. Implement the tanh-sinh rule $x=\tanh(\tfrac{\pi}{2}\sinh t)$ with trapezoid in $t$ and test it on $\int_0^1 \ln x\,dx$ and $\int_0^1 x^{-1/2}\,dx$.  
10. Prove the Euler–Maclaurin $h^2$ term for the composite trapezoid rule using the Peano kernel or Taylor expansion on one panel.  

## Summary

Quadrature is the art of choosing nodes and weights. Composite trapezoid and Simpson are $O(h^2)$ and $O(h^4)$ for smooth integrands, and you should verify that by measurement. Trapezoid is spectrally accurate on periodic integrands. Richardson/Romberg turns a cheap rule into a high-order one when the error expansion holds. Gauss–Legendre is exact to degree $2n-1$ and converges geometrically for smooth $f$. Adaptive methods put evaluations where $f$ is hard, and they cannot find what they never sample. Singularities lower the order unless you transform them away. In many dimensions, grids give way to Monte Carlo and quasi-Monte Carlo.

## Sources (for further reading)

- P. J. Davis and P. Rabinowitz, *Methods of Numerical Integration*, 2nd ed., Academic Press, 1984.  
- L. N. Trefethen and J. A. C. Weideman, "The Exponentially Convergent Trapezoidal Rule", *SIAM Review* 56(3), 2014: <https://doi.org/10.1137/130932132>  
- G. H. Golub and J. H. Welsch, "Calculation of Gauss Quadrature Rules", *Mathematics of Computation* 23, 1969: <https://doi.org/10.1090/S0025-5718-69-99647-1>  
- R. Piessens, E. de Doncker-Kapenga, C. Überhuber, D. Kahaner, *QUADPACK: A Subroutine Package for Automatic Integration*, Springer, 1983 (the library behind `scipy.integrate.quad`).  
- SciPy documentation — `scipy.integrate.quad`: <https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.quad.html>; `scipy.stats.qmc.Sobol`: <https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.qmc.Sobol.html>  
- NumPy documentation — `numpy.polynomial.legendre.leggauss`: <https://numpy.org/doc/stable/reference/generated/numpy.polynomial.legendre.leggauss.html>  
- NIST Digital Library of Mathematical Functions, §3.5 Quadrature: <https://dlmf.nist.gov/3.5>  
- A. B. Owen, *Practical Quasi-Monte Carlo Integration* (draft book): <https://artowen.su.domains/mc/practicalqmc.pdf>  
