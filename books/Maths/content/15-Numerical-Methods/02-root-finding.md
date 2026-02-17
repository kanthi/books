# Root Finding: Bisection, Newton, and Secant

## 1. Problem Statement

Find `x*` such that `f(x*)=0`.

## 2. Bisection Method

Assume continuous `f` on `[a,b]` and `f(a)f(b)<0`.
Repeatedly halve interval preserving sign-change bracket.

### Theorem (Convergence)

After `k` steps, interval width is `(b-a)/2^k`, so method converges linearly.

### Proof

Each iteration halves interval length by construction.
By Intermediate Value Theorem, root remains inside bracket.

## 3. Newton's Method

Iteration:
`x_{k+1}=x_k - f(x_k)/f'(x_k)`.

### Local Convergence Theorem

If `f` is smooth and `f'(x*) != 0`, with initial guess close enough, convergence is quadratic.

Proof idea: Taylor expansion around root.

## 4. Secant Method

Derivative-free variant:

`x_{k+1}=x_k - f(x_k)(x_k-x_{k-1})/(f(x_k)-f(x_{k-1}))`.

Superlinear convergence in typical smooth cases.

## 5. Choosing Method in Practice

- Need guaranteed bracketed convergence -> bisection
- Need speed with derivatives -> Newton
- Derivative unavailable -> secant
- Hybrid strategy: bisection globally, Newton locally

## 6. Worked Example

Solve `f(x)=x^3-x-2=0`.

- Bisection bracket `[1,2]` since signs differ
- Newton start `x0=1.5`

Newton iterations converge rapidly near root `~1.521...`.

## 7. Stopping Criteria

Use combination:
- `|f(x_k)| < tol_f`
- `|x_{k+1}-x_k| < tol_x`
- max iterations

## Exercises

1. Prove bisection error bound after `k` iterations.
2. Implement Newton with safe derivative-zero check.
3. Give function where Newton diverges from poor initial point.
4. Compare iteration counts for bisection/newton/secant on same function.
