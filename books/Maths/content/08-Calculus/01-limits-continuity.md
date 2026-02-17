# Limits and Continuity

## 1. Intuition of Limits

A limit captures the behavior of a function near a point, not necessarily at the point.

`lim_{x->a} f(x)=L` means values of `f(x)` can be made arbitrarily close to `L` by taking `x` sufficiently close to `a`.

## 2. Formal Epsilon-Delta Definition

For every `epsilon > 0`, there exists `delta > 0` such that if `0 < |x-a| < delta`, then `|f(x)-L| < epsilon`.

This is the precise notion used in proofs.

## 3. One-Sided Limits

- Left limit: `x->a-`
- Right limit: `x->a+`

Two-sided limit exists iff both one-sided limits exist and are equal.

## 4. Continuity at a Point

Function `f` is continuous at `a` iff:
1. `f(a)` defined
2. `lim_{x->a} f(x)` exists
3. `lim_{x->a} f(x)=f(a)`

## 5. Types of Discontinuity

- Removable (hole)
- Jump
- Infinite (vertical asymptote)
- Oscillatory

## 6. Theorem (Algebra of Limits)

If `lim f = L` and `lim g = M`, then:
- `lim (f+g)=L+M`
- `lim (fg)=LM`
- `lim (f/g)=L/M` if `M!=0`

Proofs follow epsilon-delta bounds.

## 7. Worked Examples

1. `lim_{x->2} (x^2-4)/(x-2)=4`
2. Piecewise function matching for continuity at boundary
3. `lim_{x->0} sin(x)/x = 1` (fundamental limit)

## 8. CS Connections

- continuity assumptions in optimization and gradient methods
- numerical solvers depend on local behavior
- non-smooth objectives (ReLU, absolute value) require subgradient handling

## Exercises

1. Prove limit of a linear function using epsilon-delta.
2. Classify discontinuity type for three piecewise examples.
3. Construct function with removable discontinuity at `x=3`.
4. Explain why continuity matters in bisection root-finding.
