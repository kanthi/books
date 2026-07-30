# Floating-Point Arithmetic, Error, and Stability

Floating-point is the lingua franca of scientific computing and ML. Understanding IEEE-754, rounding models, cancellation, and the distinction between **conditioning** and **stability** prevents an entire class of silent failures.

## 1. IEEE-754 style machine numbers

A binary floating-point number has the form

$$
x = (-1)^s \cdot (1.m)_2 \cdot 2^{e},
$$

with finite mantissa bits and exponent range (subnormals and specials: $\pm 0,\pm\infty,\mathrm{NaN}$).

**Double precision (binary64):** 1 sign + 11 exponent + 52 explicit mantissa bits $\Rightarrow$ about 16 decimal digits, machine epsilon $\varepsilon_{\mathrm{mach}}\approx 2^{-52}\approx 2.22\times 10^{-16}$.

**Single (binary32):** $\varepsilon_{\mathrm{mach}}\approx 1.19\times 10^{-7}$.

### Worked example 1

$0.1$ is not exactly representable in binary FP. Summing $0.1$ ten times may not equal $1.0$ exactly. Compare with integers or decimals only when you understand representation.

### Worked example 2 — spacing

Between powers of two, floats are equally spaced in ulps. Near $2^{53}$, double integers are not all representable—loops with large integer-valued doubles skip values.

## 2. Rounding model

Let $\mathrm{fl}(x)$ be the floating representation of real $x$ (within range). Standard model for elementary ops:

$$
\mathrm{fl}(x \oplus y) = (x \oplus y)(1+\delta),\qquad |\delta|\le u,
$$

where $u$ is unit roundoff ($\approx \tfrac12\varepsilon_{\mathrm{mach}}$ depending on rounding mode; analysis often uses $u=\varepsilon_{\mathrm{mach}}$ order-of-magnitude).

Operations $\oplus\in\{+,-,\times,/\}$. This model enables backward error analysis.

## 3. Error types

| Error | Definition |
|-------|------------|
| Absolute | $|\hat{x}-x|$ |
| Relative | $|\hat{x}-x|/|x|$ |
| Forward | error in the computed output |
| Backward | smallest perturbation of inputs making $\hat{x}$ exact for the perturbed problem |

**Backward stable algorithm:** computed solution is exact for a nearby problem (perturbation $O(u)$ relative, problem-dependent).

### Worked example 3

LU with partial pivoting is typically backward stable for solving $Ax=b$: $\hat{x}$ solves $(A+\Delta A)\hat{x}=b$ with $\|\Delta A\|$ small relative to $\|A\|$ (with caveats).

## 4. Catastrophic cancellation

Subtracting nearly equal quantities cancels leading significand bits; relative error explodes even if each operand is accurate.

### Worked example 4 — classic unstable formula

$f(x)=\sqrt{x+1}-\sqrt{x}$ for large $x$. Direct evaluation loses digits. Rationalize:

$$
f(x)=\frac{1}{\sqrt{x+1}+\sqrt{x}}.
$$

### Worked example 5 — variance

One-pass $\sum x_i^2 - n\bar{x}^2$ can cancel. Use Welford’s method or two-pass with compensated arithmetic.

### Worked example 6 — `log1p` / `expm1`

$\log(1+x)$ for small $x$: use specialized functions. Direct formula suffers cancellation in $1+x$.

## 5. Conditioning of problems

For $f:\mathbb{R}\to\mathbb{R}$ differentiable, relative condition number approximately

$$
\kappa_f(x)\approx \left|\frac{x f'(x)}{f(x)}\right|.
$$

Large $\kappa$ means **inherent** sensitivity.

### Worked example 7

$f(x)=\sqrt{x}$ near $0^+$: absolute condition moderate in some senses; $f(x)=1/(x-a)$ near pole: extremely ill-conditioned.

### Worked example 8 — linear systems

$\kappa(A)=\|A\|\|A^{-1}\|$. Relative input error may amplify by $\sim\kappa(A)$ in the solution.

## 6. Stability of algorithms

A stable algorithm does not introduce much more error than conditioning forces. Unstable algorithms can destroy even well-conditioned problems.

### Worked example 9 — solving triangular systems

Forward/back substitution is backward stable. Explicit inverse formation is not recommended.

### Worked example 10 — Horner vs naive polynomial

Horner’s rule evaluates polynomials with better stability structure than expanded power sums in many cases.

## 7. Accumulation and summation

Summing $n$ numbers: naive left-to-right can have error $O(nu\sum |x_i|)$. Pairwise or Kahan compensated summation reduces effective constant.

### Worked example 11

Summing many tiny values into a large accumulator: large number “swallows” small addends (absorption). Sort or use higher precision accumulators.

## 8. Exceptions and special values

- Overflow $\to\pm\infty$  
- Underflow $\to 0$ or subnormal  
- $0/0$, $\infty-\infty$ $\to$ NaN  
- Comparisons with NaN are always false (including `!=` subtleties in languages)

ML training: watch mixed precision overflow; loss scaling exists for this reason.

## 9. Practical guidelines

1. Prefer mathematically equivalent stable rearrangements  
2. Scale/normalize data and matrices  
3. Use fused multiply-add (FMA) when available for $ax+b$ patterns  
4. Avoid explicit inverses; use solvers  
5. Monitor residuals **and** condition estimates  
6. Don’t use FP for currency / exact discrete counts  

### Worked example 12

Python sketch:

```python
import math
x = 1e16
naive = math.sqrt(x + 1) - math.sqrt(x)
stable = 1.0 / (math.sqrt(x + 1) + math.sqrt(x))
# naive often 0.0; stable ~ 5e-9
```

## 10. Pitfalls

1. Assuming associativity: $(a+b)+c$ vs $a+(b+c)$  
2. Using tiny finite-difference $h<\sqrt{\varepsilon}$ blindly  
3. Interpreting all digits of a printout as correct  
4. Ignoring that $\kappa$ depends on norm choice (order of magnitude still matters)  
5. “More iterations” of an unstable recurrence making error worse  

## 11. Checkpoint

- Describe binary64 layout and $\varepsilon_{\mathrm{mach}}$  
- Write the standard rounding model  
- Detect cancellation and rewrite one formula  
- Define conditioning vs stability  
- Explain backward error for $Ax=b$  

## Exercises

### Easy

1. Show in code or by reasoning that `(1e16 + 1) - 1e16` can be $0$ in double.
2. Estimate relative spacing between doubles near $1.0$.
3. Define ulp.
4. Why is $x^2-y^2$ often better as $(x-y)(x+y)$ for cancellation when $x\approx y$? (Also discuss when not.)
5. Give an example of absorption in summation.

### Medium

6. Derive a stable formula for $\frac{1-\cos x}{x^2}$ near $0$ (use trig identities).
7. Compute approximate $\kappa$ for $f(x)=e^x$ (relative).
8. Explain why Gaussian elimination without pivoting can be unstable (growth factor).
9. Compare absolute vs relative error for approximating $\pi$ by $3.14$.
10. Finite difference $f'(x)\approx (f(x+h)-f(x))/h$: balance truncation $O(h)$ vs roundoff $O(u|f|/h)$; optimal $h$ scale.

### Challenge

11. Read Wilkinson’s polynomial root sensitivity story; summarize conditioning of roots vs coefficient perturbation.
12. Prove error bound sketch for naive sum of $n$ positives under the standard model.
13. Implement Kahan summation pseudocode; explain the compensation term.
14. Mixed precision: when does fp16 matmul + fp32 accumulate help throughput without destroying accuracy?
15. For $Ax=b$, relate forward error bound to $\kappa(A)$ and backward error (standard inequality).

## Summary

Floating-point arithmetic is accurate **relative to a rounding unit**, not exact. Cancellation, absorption, and ill-conditioning create large forward errors; stable algorithms and careful algebra keep results honest. Mastering these ideas is prerequisite to trusting any numerical solver or ML kernel.
