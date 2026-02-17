# Convexity Foundations

## 1. Convex Sets

Set `C` is convex if for any `x,y in C` and `t in [0,1]`:

`tx + (1-t)y in C`.

## 2. Convex Functions

Function `f` convex on convex domain if:

`f(tx+(1-t)y) <= t f(x) + (1-t) f(y)`.

## 3. First-Order Characterization

Differentiable `f` is convex iff:

`f(y) >= f(x) + grad f(x)^T (y-x)` for all `x,y`.

## 4. Second-Order Characterization

Twice differentiable `f` is convex iff Hessian is positive semidefinite everywhere.

## 5. Theorem (Global Optimality)

For convex optimization, any local minimizer is global minimizer.

### Proof Sketch

Use convex inequality along segment between local minimizer and any point.

## 6. Strong Convexity

Adds quadratic lower curvature bound; gives uniqueness and faster convergence rates.

## 7. Worked Example

`f(x)=x^2` convex.
`f(x)=x^4` convex.
`f(x)=x^3` non-convex on R.

## Exercises

1. Prove convexity of norm function.
2. Determine convexity of logistic loss.
3. Show sum of convex functions is convex.
4. Give non-convex optimization example from deep learning.
