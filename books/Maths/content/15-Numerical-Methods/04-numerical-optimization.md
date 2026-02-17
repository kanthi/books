# Numerical Optimization in Practice

## 1. Problem Setup

Minimize objective `f(x)` possibly with constraints.

## 2. First-Order Methods

Gradient descent update:
`x_{k+1}=x_k - alpha_k grad f(x_k)`.

Convergence depends on step-size strategy and smoothness assumptions.

## 3. Second-Order Methods

Newton update:
`x_{k+1}=x_k - H^{-1}(x_k) grad f(x_k)`.

Very fast locally but expensive and sensitive to Hessian properties.

## 4. Line Search and Trust Regions

- Line search picks acceptable step along direction.
- Trust region restricts step to model-valid neighborhood.

## 5. Constrained Optimization

Common numerical techniques:
- projected gradient,
- penalty methods,
- barrier methods,
- augmented Lagrangian.

## 6. Diagnostics and Failure Modes

Track:
- objective value,
- gradient norm,
- step norm,
- constraint violation.

Failure patterns:
- divergence (step too large),
- stagnation (ill-conditioning),
- oscillation (poor scaling),
- infeasible drift (constraint handling issue).

## 7. Worked Example Outline

L2-regularized logistic regression:
`min_w sum log(1+exp(-y_i w^T x_i)) + lambda ||w||^2`.

Use mini-batch gradient with decaying learning rate and monitor validation loss.

## Exercises

1. Implement gradient descent with backtracking line search.
2. Compare convergence of GD vs Newton on quadratic objective.
3. Add L2 regularization and inspect conditioning effect.
4. Define robust stopping rules for noisy stochastic objective.

## Summary

Numerical optimization is the bridge between mathematical objective definitions and trainable systems.
