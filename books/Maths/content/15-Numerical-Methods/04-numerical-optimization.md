# Numerical Optimization in Practice

This chapter bridges smooth optimization theory and finite-precision computation: step-size policies, Newton and quasi-Newton, constraints in practice, and diagnostics when training or fitting diverges.

## 1. Problem setup

Minimize smooth $f:\mathbb{R}^n\to\mathbb{R}$, optionally with constraints. Assume gradients (and sometimes Hessians) are available via AD or analytic forms.

**Local model:** near $x_k$,

$$
f(x_k+s)\approx f(x_k)+\nabla f(x_k)^\top s+\tfrac12 s^\top B_k s.
$$

First-order methods take $B_k\sim LI$; Newton takes $B_k=\nabla^2 f(x_k)$.

## 2. Gradient descent and step sizes

$$
x_{k+1}=x_k-\alpha_k\nabla f(x_k).
$$

**Fixed step:** for $L$-smooth convex $f$, $\alpha\in(0,2/L)$ ensures descent; $\alpha=1/L$ standard.

**Backtracking line search (Armijo):** try $\alpha,\rho\alpha,\rho^2\alpha,\ldots$ until

$$
f(x_k+\alpha d)\le f(x_k)+c\alpha\nabla f(x_k)^\top d
$$

with $d=-\nabla f$, $c\in(0,1)$, $\rho\in(0,1)$.

### Worked example 1

$f(x)=\frac12 x^\top Qx$ with known $L=\lambda_{\max}(Q)$: optimal fixed step related to $\kappa=\lambda_{\max}/\lambda_{\min}$.

### Worked example 2 — ML

Learning rate schedules (cosine, step decay) are practical step-size policies for nonconvex stochastic objectives.

## 3. Momentum and adaptive methods (numeric view)

Momentum / Nesterov accumulate velocity—helps ill-conditioned ravines. AdaGrad/Adam rescale coordinates by gradient history—help diagonal scaling mismatches.

**Numeric caution:** Adam’s $\varepsilon$ prevents divide-by-zero; mixed precision needs loss scaling; exploding gradients need clipping.

### Worked example 3

Feature scales $1$ vs $10^6$ without normalization: first-order methods crawl—conditioning of Hessian along axes differs wildly.

## 4. Newton and quasi-Newton

**Newton:**

$$
x_{k+1}=x_k-\nabla^2 f(x_k)^{-1}\nabla f(x_k).
$$

Quadratic convergence near nondegenerate local minima for smooth strongly convex $f$. Cost: Hessian form + linear solve.

**BFGS / L-BFGS:** build $B_k\approx\nabla^2 f$ from gradient pairs $(s_k,y_k)$ with secant equation $B_{k+1}s_k=y_k$. L-BFGS stores last $m$ pairs—workhorse for medium-scale deterministic problems.

### Worked example 4

Logistic regression with moderate $n,d$: L-BFGS often beats SGD wall-clock when full batch fits in memory.

### Worked example 5 — Hessian indefinite

In nonconvex regions, pure Newton may propose ascent directions. Modified Cholesky / trust-region Newton damp indefinite Hessians.

## 5. Trust regions vs line search

**Trust region:** choose $s$ minimizing model m subject to $\|s\|\le\Delta_k$. Expand/contract $\Delta_k$ based on ratio of actual to predicted reduction.

More robust when models are poor; common in nonlinear least squares (Levenberg–Marquardt is a related damping idea).

### Worked example 6 — Levenberg–Marquardt

Nonlinear least squares $f(\theta)=\frac12\|r(\theta)\|_2^2$: solve $(J^\top J+\mu I)\delta=-J^\top r$. $\mu$ interpolates gradient descent and Gauss–Newton.

## 6. Stochastic objectives

$f(w)=\mathbb{E}_\xi[f(w;\xi)]$ approximated by minibatches. Noise means:

- Do not expect monotone decrease  
- Use learning rate decay / averaging (Polyak–Ruppert)  
- Early stopping on validation  

### Worked example 7

Batch size vs noise: larger batches reduce gradient variance, change optimal LR and generalization dynamics.

## 7. Constraints in numerical practice

| Technique | Use when |
|-----------|----------|
| Projection | Simple sets (box, simplex, spectrahedron specials) |
| Barrier / IPM | Convex with inequality structure, moderate $n$ |
| Augmented Lagrangian | General equalities/inequalities |
| Penalty | Quick prototype; ill-conditioning as $\rho\uparrow$ |
| Riemannian | Manifolds (sphere, Stiefel, SPD) |

### Worked example 8

Probability simplex constraints on mixture weights: projected gradient or exponentiated gradient / multiplicative updates.

### Worked example 9 — SVM dual

Box constraints $0\le\alpha_i\le C$ + linear equality: SMO coordinate methods exploit structure.

## 8. Diagnostics and failure modes

Track:

- $f(x_k)$, $\|\nabla f(x_k)\|$, step $\|x_{k+1}-x_k\|$  
- Constraint violation  
- Gradient/parameter norms (detect explosion)  
- Condition estimates of Hessian or Gram mini-batches  

| Symptom | Likely cause |
|---------|--------------|
| $f\to\infty$ / NaN | LR too large, overflow, bad init |
| Oscillation | LR large, missing momentum tuning |
| Stagnation high loss | LR tiny, saddle, under-model |
| Train≪val | Overfit; need reg/early stop |
| Residual small, params huge | Ill-conditioning / need reg |

### Worked example 10

Logistic regression with separable data: $\|w\|\to\infty$ without regularization—numeric overflow in $\exp$. Add $\lambda\|w\|_2^2$.

## 9. Worked template: $\ell_2$-regularized logistic

$$
\min_w \sum_{i=1}^n \log\big(1+\exp(-y_i w^\top x_i)\big)+\frac{\lambda}{2}\|w\|_2^2.
$$

- Convex, smooth, strongly convex for $\lambda>0$  
- Gradient: $\sum_i \sigma(-y_i w^\top x_i)(-y_i x_i)+\lambda w$  
- Methods: L-BFGS, Newton-CG, or SGD for huge $n$  
- Monitor val log-loss and calibration  

### Worked example 11

Compare full-batch L-BFGS vs SGD on same objective: same $f$, different numeric paths and early-stopping behavior.

## 10. Automatic differentiation note

AD computes exact gradients of the implemented function (up to FP). Bugs in the **math of the implementation** (not AD) still yield “correct gradients of the wrong objective.” Check gradients with finite differences on small examples when debugging.

### Worked example 12

Softmax cross-entropy fused implementation avoids overflow via $\log\sum\exp$ trick—numeric method as modeling detail.

## 11. Pitfalls

1. One LR for unscaled features  
2. Newton without globalization far from optimum  
3. Interpreting SGD noise as bug  
4. Over-tight gradient tolerances beyond FP/κ limits  
5. Forgetting regularization on separable classification  
6. Trusting training loss alone under distribution shift  

## 12. Checkpoint

- Implement Armijo backtracking conceptually  
- Contrast GD, Newton, L-BFGS costs  
- Explain trust region ratio  
- Diagnose NaNs and exploding weights  
- Write a robust training loop checklist  

## Exercises

### Easy

1. For $f(x)=\frac12 L x^2$, what fixed steps $\alpha$ guarantee descent?
2. Write Armijo condition with symbols defined.
3. Why does Adam include $\varepsilon$?
4. Name one reason to prefer L-BFGS over SGD for small data.
5. What does gradient clipping change in the algorithm mathematically (approx)?

### Medium

6. Derive Newton step for $f(x)=\frac12 x^\top Qx-b^\top x$ with $Q\succ 0$—show one-step convergence from any start if exact arithmetic.
7. Explain why $J^\top J$ in Gauss–Newton is PSD.
8. Design stopping rules for noisy SGD (use val plateau, not only $\|\hat g\|$).
9. Projected GD onto $\|x\|_2\le 1$: write the projection formula.
10. Show that adding $\frac{\lambda}{2}\|w\|_2^2$ makes logistic objective strongly convex.

### Challenge

11. Pseudocode BFGS update; state curvature condition $s^\top y>0$ and damping if violated.
12. Trust-region subproblem: describe Cauchy point approximation.
13. Mixed-precision training: outline loss-scaling algorithm.
14. Compare barrier methods vs projected gradient for box constraints (pros/cons).
15. End-to-end: specify optimizer, line search/schedule, diagnostics, and success criteria for a sparse logistic problem with $n=10^7$, $d=10^5$.

## Summary

Numerical optimization combines models (linear/quadratic), step policies (line search/trust region), and solvers (first-order, Newton, quasi-Newton) under floating-point reality. Good practice is relentless diagnostics, scaling, regularization, and matching method to problem structure and noise.
