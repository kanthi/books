---
title: "Interval Arithmetic and Certified Computation"
author:
  - name: "K19G"
  - name: "grok-bot"
---

Every earlier chapter in this part *estimated* error: a truncation term $C h^q$, a residual, a condition number times machine epsilon. Estimates are usually right and occasionally badly wrong, and nothing in the printed number tells you which case you are in. **Interval arithmetic** changes the question. Instead of computing one floating-point number near the answer, it computes an interval $[\underline{x}, \overline{x}]$ that is **guaranteed to contain** the exact real result. Every rounding error, every inexact input, every operation is accounted for. When the interval is narrow, you have a *certified* answer. When it is wide, the computation is telling you that it does not know.

This chapter builds a small interval type on IEEE doubles. It then shows the two effects that make intervals hard to use well (**dependency** and **wrapping**), the standard cure (subdivision and rewriting), the **interval Newton** method that *proves* a root exists and is unique, and Rump's classic expression where float and multi-precision arithmetic agree on a wrong answer, but an interval does not.

All listings are complete Python files. They were run on Debian 13 with **Python 3.13.5** (standard library only) and **mpmath 1.3.0** for the last section. Outputs are pasted unedited.

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install mpmath
```

## 1. The containment principle

For an operation $\circ \in \{+,-,\times,\div\}$ and intervals $X, Y$ define

$$
X \circ Y \;=\; \{\, x \circ y : x \in X,\ y \in Y \,\}.
$$

For the four basic operations this set is again an interval, and its endpoints come from the endpoints of $X$ and $Y$:

$$
\begin{aligned}
[a,b] + [c,d] &= [a+c,\; b+d], \qquad [a,b] - [c,d] = [a-d,\; b-c],\\
[a,b] \times [c,d] &= [\min S,\; \max S], \quad S = \{ac, ad, bc, bd\},\\
[a,b] \div [c,d] &= [a,b] \times [1/d,\; 1/c] \quad (0 \notin [c,d]).
\end{aligned}
$$

The **fundamental theorem of interval arithmetic** (Moore) follows by induction over the expression: if $f$ is built from these operations and $x \in X$, then $f(x) \in F(X)$, where $F$ is the same expression evaluated with intervals. The containment is guaranteed, and nothing guarantees that it is tight.

On a computer the endpoints are themselves rounded. To keep containment, the lower endpoint must be rounded **down** and the upper endpoint **up**: *outward rounding*. Hardware supports this through rounding modes, which the IEEE 1788-2015 interval standard builds on. Python cannot switch rounding modes, so the type below takes a cruder, still rigorous route. It computes each endpoint with round-to-nearest and then moves it one ulp outward with `math.nextafter`. Round-to-nearest is off by at most half an ulp, so one ulp outward always covers the true value. The price is intervals that are a little wider than necessary.

```python
# interval.py - a minimal outward-rounded interval type on IEEE doubles
import math
from fractions import Fraction
from dataclasses import dataclass

down = lambda x: math.nextafter(x, -math.inf)   # one ulp toward -inf
up = lambda x: math.nextafter(x, math.inf)      # one ulp toward +inf


@dataclass(frozen=True)
class I:
    lo: float
    hi: float

    def __post_init__(self):
        if not self.lo <= self.hi:
            raise ValueError(f"empty interval [{self.lo}, {self.hi}]")

    @staticmethod
    def of(x) -> "I":
        """Enclose a number given as int or decimal string ("0.1") rigorously."""
        f = float(x)
        exact = Fraction(f) == Fraction(str(x))     # is the double *equal* to the real?
        return I(f, f) if exact else I(down(f), up(f))

    def __add__(s, o): o = _i(o); return I(down(s.lo + o.lo), up(s.hi + o.hi))
    __radd__ = __add__
    def __sub__(s, o): o = _i(o); return I(down(s.lo - o.hi), up(s.hi - o.lo))
    def __rsub__(s, o): return _i(o) - s
    def __neg__(s): return I(-s.hi, -s.lo)

    def __mul__(s, o):
        o = _i(o)
        p = [s.lo * o.lo, s.lo * o.hi, s.hi * o.lo, s.hi * o.hi]
        return I(down(min(p)), up(max(p)))
    __rmul__ = __mul__

    def __truediv__(s, o):
        o = _i(o)
        if o.lo <= 0 <= o.hi:
            raise ZeroDivisionError(f"divisor {o} contains 0")
        q = [s.lo / o.lo, s.lo / o.hi, s.hi / o.lo, s.hi / o.hi]
        return I(down(min(q)), up(max(q)))

    def sq(s) -> "I":
        """x**2 as one operation: never negative, unlike x*x on [-1, 2]."""
        a, b = abs(s.lo), abs(s.hi)
        lo = 0.0 if s.lo <= 0 <= s.hi else min(a, b) ** 2
        return I(down(lo) if lo else 0.0, up(max(a, b) ** 2))

    @property
    def mid(s): return s.lo + (s.hi - s.lo) / 2
    @property
    def width(s): return s.hi - s.lo
    def __contains__(s, x):                       # x may be a Fraction: an exact real
        return Fraction(s.lo) <= Fraction(x) <= Fraction(s.hi)
    def __repr__(s): return f"[{s.lo:.17g}, {s.hi:.17g}]"


def _i(x) -> I:
    return x if isinstance(x, I) else I.of(x)
```

Two details matter. `I.of("0.1")` takes the **decimal string**: the double nearest to $0.1$ is not $0.1$, so the type widens it to the two neighbouring doubles. An integer like `I.of(3)` is exact and stays a point. Membership (`in`) compares with `Fraction`, so you can ask whether an *exact* real number such as $3/10$ is enclosed, not only a double near it.

## 2. Enclosures you can trust, and the dependency problem

```python
# demo_basic.py - enclosures you can trust, and the dependency problem
from fractions import Fraction
from interval import I

tenth = I.of("0.1")
print("0.1 * 3 in doubles:", 0.1 * 3)
print("enclosure of 0.1  :", tenth)
print("3 * [0.1]         :", 3 * tenth)
print("contains 3/10?    :", Fraction(3, 10) in 3 * tenth)

x = I(0.0, 1.0)
print("\nx = [0, 1]")
print("x - x             :", x - x, "   (true range: [0, 0])")
print("x * (1 - x)       :", x * (1 - x), "   (true range: [0, 0.25])")
print("0.25 - (x-0.5)^2  :", 0.25 - (x - 0.5).sq(), "  (same function, rewritten)")
```

```text
0.1 * 3 in doubles: 0.30000000000000004
enclosure of 0.1  : [0.099999999999999992, 0.10000000000000002]
3 * [0.1]         : [0.29999999999999993, 0.3000000000000001]
contains 3/10?    : True

x = [0, 1]
x - x             : [-1.0000000000000002, 1.0000000000000002]    (true range: [0, 0])
x * (1 - x)       : [-9.8813129168249309e-324, 1.0000000000000004]    (true range: [0, 0.25])
0.25 - (x-0.5)^2  : [-1.6653345369377351e-16, 0.25000000000000006]   (same function, rewritten)
```

The first block is the good news. The double `0.30000000000000004` is simply wrong in its last digit, and nothing flags it. The interval contains the exact $3/10$, and its width ($1.7 \times 10^{-16}$) is an honest error bar.

The second block is the bad news. `x - x` should be $0$, but interval arithmetic treats the two occurrences of `x` as **independent** values anywhere in $[0,1]$. So it returns $[-1, 1]$. This is the **dependency problem**: every repeated variable can inflate the result. $x(1-x)$ is enclosed by $[0, 1]$, four times wider than its true range $[0, 0.25]$. Rewriting the same function so that $x$ appears **once**, as $0.25 - (x - 0.5)^2$, and using a dedicated square (which knows $x^2 \ge 0$) gives the true range up to rounding.

> **Rule.** The width of an interval result depends on *how the expression is written*, not only on the function. Expressions in which each variable occurs once give exact ranges in exact arithmetic (a theorem of Moore). Rewrite towards that form when you can.

## 3. Subdivision: buying tightness with work

When rewriting is not possible, split the domain, enclose each piece, and take the hull. The overestimate of a *natural* interval extension shrinks linearly with the piece width $h$. The method is first-order:

```python
# demo_subdivide.py - tighten a range enclosure by splitting the domain
from interval import I

def f(x: I) -> I:          # f(x) = x(1-x), written the "bad" way on purpose
    return x * (1 - x)

def enclose(lo: float, hi: float, pieces: int) -> I:
    h = (hi - lo) / pieces
    parts = [f(I(lo + k * h, lo + (k + 1) * h if k < pieces - 1 else hi)) for k in range(pieces)]
    return I(min(p.lo for p in parts), max(p.hi for p in parts))

for n in (1, 2, 4, 16, 256, 4096):
    r = enclose(0.0, 1.0, n)
    print(f"{n:5d} pieces: {r}   overestimate of max = {r.hi - 0.25:.2e}")
```

```text
    1 pieces: [-9.8813129168249309e-324, 1.0000000000000004]   overestimate of max = 7.50e-01
    2 pieces: [-9.8813129168249309e-324, 0.50000000000000022]   overestimate of max = 2.50e-01
    4 pieces: [-9.8813129168249309e-324, 0.37500000000000017]   overestimate of max = 1.25e-01
   16 pieces: [-9.8813129168249309e-324, 0.28125000000000011]   overestimate of max = 3.13e-02
  256 pieces: [-9.8813129168249309e-324, 0.25195312500000011]   overestimate of max = 1.95e-03
 4096 pieces: [-9.8813129168249309e-324, 0.25012207031250011]   overestimate of max = 1.22e-04
```

Doubling the pieces halves the overestimate: $O(h)$. In one dimension that is affordable. In $d$ dimensions the number of boxes grows like $h^{-d}$, which is why serious interval codes use better extensions. The **mean-value form** $F(X) = f(m) + F'(X)(X - m)$ has an overestimate of order $O(h^2)$. Taylor models go further. Global optimisation codes use branch-and-bound to split only the boxes that might hold the optimum.

## 4. Interval Newton: proving that a root exists

Floating-point Newton finds *a number* where $f$ looks small. Interval Newton proves a statement. Let $m$ be the midpoint of $X$ and define

$$
N(X) \;=\; m - \frac{f(m)}{F'(X)}.
$$

Two facts follow from the mean value theorem:

- every root of $f$ in $X$ also lies in $N(X)$, so $X \leftarrow X \cap N(X)$ never loses a root, and an empty intersection **proves** that there is no root in $X$;
- if $N(X)$ lies **strictly inside** $X$, then $f$ has **exactly one** root in $X$.

```python
# demo_newton.py - prove that x^2 = 2 has exactly one root in [1, 2], and pin it down
from interval import I

def f(x: I) -> I:  return x.sq() - 2
def df(x: I) -> I: return 2 * x

X = I(1.0, 2.0)
for step in range(1, 7):
    m = I(X.mid, X.mid)                     # a point, but evaluated with intervals
    N = m - f(m) / df(X)                    # interval Newton operator
    if N.hi < X.lo or N.lo > X.hi:
        print("no root in", X); break
    proved = X.lo < N.lo and N.hi < X.hi    # N(X) strictly inside X  =>  unique root
    X = I(max(X.lo, N.lo), min(X.hi, N.hi))
    print(f"step {step}: {X}  width={X.width:.1e}  unique-root proof: {proved}")

from fractions import Fraction as Q
print("lo^2 < 2 < hi^2 exactly?", Q(X.lo) ** 2 < 2 < Q(X.hi) ** 2)
```

```text
step 1: [1.3749999999999996, 1.4375000000000004]  width=6.3e-02  unique-root proof: True
step 2: [1.4140624999999998, 1.414417613636364]  width=3.6e-04  unique-root proof: True
step 3: [1.414213559294524, 1.4142135659471793]  width=6.7e-09  unique-root proof: True
step 4: [1.4142135623730947, 1.4142135623730956]  width=8.9e-16  unique-root proof: True
step 5: [1.4142135623730947, 1.4142135623730954]  width=6.7e-16  unique-root proof: False
step 6: [1.4142135623730947, 1.4142135623730954]  width=6.7e-16  unique-root proof: False
lo^2 < 2 < hi^2 exactly? True
```

Step 1 already proves that $[1, 2]$ holds exactly one root of $x^2 - 2$. The widths after that go $6\times10^{-2} \to 4\times10^{-4} \to 7\times10^{-9} \to 9\times10^{-16}$: the number of correct digits doubles each step, the familiar quadratic convergence of Newton's method, now with a certificate attached. At step 5 the interval is a few ulps wide, and outward rounding cannot shrink it further. "Proof: False" there only means that $N(X)$ is no longer *strictly* inside the stalled interval. The uniqueness proof from step 1 still holds. The last line checks the final enclosure with exact rational arithmetic.

## 5. Rump's example: two confident wrong answers

S. M. Rump (1988) built an expression that defeats ordinary floating point at almost any precision. With $a = 77617$, $b = 33096$:

$$
f(a,b) = 333.75\, b^6 + a^2\left(11a^2b^2 - b^6 - 121 b^4 - 2\right) + 5.5\, b^8 + \frac{a}{2b}.
$$

The large terms cancel to exactly $-2$, leaving $f = -2 + a/(2b)$. The intermediate terms are about $10^{36}$, so they must be carried to well over 30 significant digits before the cancellation leaves anything correct. The run below shows that 30 digits are not enough and 37 are.

```python
# demo_rump.py - Rump's example: confident wrong answers, and an interval that refuses to lie
from fractions import Fraction
from mpmath import iv, mp, mpf

a, b = 77617, 33096

def rump(a, b, half, c1, c2):
    return c1 * b**6 + a**2 * (11 * a**2 * b**2 - b**6 - 121 * b**4 - 2) + c2 * b**8 + a / (half * b)

exact = rump(Fraction(a), Fraction(b), 2, Fraction(1335, 4), Fraction(11, 2))
print("exact (Fraction)  :", float(exact))
print("float64           :", rump(float(a), float(b), 2.0, 333.75, 5.5))

for dps in (15, 30, 37, 40):
    mp.dps = dps
    print(f"mpmath  {dps:2d} digits :", mp.nstr(rump(mpf(a), mpf(b), 2, mpf("333.75"), mpf("5.5")), 12))

for dps in (15, 30, 37, 40):
    iv.dps = dps
    r = rump(iv.mpf(a), iv.mpf(b), 2, iv.mpf("333.75"), iv.mpf("5.5"))
    print(f"iv      {dps:2d} digits : width {float(r.delta.b):9.2e}  ->", iv.nstr(r, 10))
```

```text
exact (Fraction)  : -0.8273960599468214
float64           : -1.1805916207174113e+21
mpmath  15 digits : -1.18059162072e+21
mpmath  30 digits : 1.17260394005
mpmath  37 digits : -0.827396059947
mpmath  40 digits : -0.827396059947
iv      15 digits : width  1.06e+22  -> [-5.902958104e+21, 4.722366483e+21]
iv      30 digits : width  2.10e+06  -> [-1048574.827, 1048577.173]
iv      37 digits : width  2.35e-38  -> [-0.8273960599, -0.8273960599]
iv      40 digits : width  2.30e-41  -> [-0.8273960599, -0.8273960599]
```

Read the middle lines. At 30 digits, plain multi-precision arithmetic returns `1.17260394005`: wrong sign, wrong magnitude, and twelve plausible-looking digits. "Recompute at higher precision and see if the answer changes" would have caught it here, but only because we happened to try 37 next. The interval at 30 digits spans two million units around zero, which says plainly that the digits are meaningless. At 37 digits it collapses to a width of $2 \times 10^{-38}$ around $-0.8273960599$, and that answer is now certified.

`mpmath.iv` is a ready-made, arbitrary-precision interval context. It rounds outward properly at every operation and has interval versions of the elementary functions (`iv.exp`, `iv.sin`, …). For production work in compiled languages, see the libraries listed under Sources.

## 6. Where certified computation is used

- **Computer-assisted proofs.** W. Tucker's 2002 proof that the Lorenz attractor exists combined normal-form theory with rigorous interval ODE integration. Hales' proof of the Kepler conjecture checked thousands of nonlinear inequalities with interval arithmetic.
- **Global optimisation and constraint solving.** Interval branch-and-bound returns an enclosure of the *global* minimum, and boxes proven to contain no minimiser are discarded.
- **Robust geometry.** Exact-predicate libraries filter with intervals first and fall back to exact arithmetic only when the interval straddles zero.
- **Sanity checking.** Running a numerical kernel once in interval mode tells you how many of its output digits survive rounding, which is cheaper than an error analysis by hand.

## 7. Pitfalls

1. **Treating a wide interval as a bug.** Width is information: the computation, *as written*, cannot be more precise. Rewrite, subdivide, or raise the precision. Do not trim the interval.
2. **Unrigorous inputs.** `I(0.1, 0.1)` encloses the double `0.1`, not the real number one tenth. Enclose literals from their exact decimal or rational value (`I.of("0.1")`, `iv.mpf("0.1")`).
3. **Forgetting dependency.** `x*x` on $[-1, 2]$ gives $[-2, 4]$. A real square gives $[0, 4]$. Use dedicated power functions, and write each variable once where possible.
4. **Division by an interval containing zero.** The result is unbounded or a union of two pieces. Basic interval types raise an error, and *extended* interval arithmetic (IEEE 1788) returns the pieces.
5. **Mixing in plain floats mid-expression.** One `math.sin(x.mid)` silently drops rigour for everything downstream. Every operation on the path must be an interval operation.
6. **Expecting speed.** Each multiply is four multiplies plus min/max plus outward rounding, and libraries that switch rounding modes stall the pipeline. Use intervals to *certify*, not as the default arithmetic.

## 8. Checkpoint

1. Why is $[a,b] - [c,d] = [a - d,\; b - c]$ and not $[a - c,\; b - d]$?
2. Give an expression for $x^2 - 2x$ on $[0, 2]$ whose natural interval extension is exact.
3. In §4, why is an *empty* intersection $X \cap N(X)$ a proof and not merely a failure?
4. Why did the 30-digit interval in §5 come out roughly symmetric around zero?

## Exercises

1. **Mean-value form.** Add `mean_value(f, df, X)` that computes $f(m) + F'(X)(X - m)$ and repeat §3 for $f(x) = x(1-x)$. Confirm that halving the piece width now divides the overestimate by about four.
2. **Root isolation.** Apply interval Newton with bisection to $f(x) = \sin x - x/3$ on $[-4, 4]$ with `mpmath.iv`. Bisect any box that is neither proven root-free nor proven to hold a unique root. How many roots are certified, and how many boxes did you need?
3. **Find the precision cliff.** In §5, find the smallest `iv.dps` for which the interval excludes zero. Compare it with the number of digits in $b^8$.
4. **Kahan versus intervals.** Sum `[I.of("0.1")] * 10**6` with the interval type. Compare the width of the result with the error of naive and Kahan float summation of the same series.

## Summary

Interval arithmetic computes sets that are guaranteed to contain the exact result, so a narrow interval is a certificate and a wide one is an honest refusal. Containment is easy. Tightness is the craft: write each variable once, subdivide, use centred or mean-value forms, and raise the precision when cancellation needs it. Interval Newton turns root-finding into proof: it shows existence and uniqueness and converges quadratically. Rump's example shows why this matters. Floating point at 16 and 30 digits gives two different, equally confident wrong answers, while the interval says exactly how little it knows.

## Sources (for further reading)

- R. E. Moore, R. B. Kearfott, M. J. Cloud, *Introduction to Interval Analysis*, SIAM, 2009: containment theorem, single-use expressions, interval Newton.
- IEEE Std 1788-2015, *Standard for Interval Arithmetic* (and the simplified IEEE 1788.1-2017).
- S. M. Rump, "Algorithms for verified inclusions: theory and practice", in *Reliability in Computing*, Academic Press, 1988. The example in §5 is the commonly used corrected form (Loh & Walster, 2002).
- W. Tucker, "A rigorous ODE solver and Smale's 14th problem", *Foundations of Computational Mathematics* 2 (2002).
- mpmath documentation, "Arbitrary-precision interval arithmetic (iv)": <https://mpmath.org/doc/current/contexts.html>.
- Python documentation, `math.nextafter` (3.9+) and `fractions.Fraction`: <https://docs.python.org/3/library/math.html#math.nextafter>.
- Libraries for compiled languages: Arb/FLINT (ball arithmetic), MPFI, Boost.Interval, and the C++ `libieeep1788` reference implementation.
