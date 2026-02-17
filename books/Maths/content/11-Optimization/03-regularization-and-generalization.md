# Regularization and Generalization

## 1. Generalization Problem

Model should perform well on unseen data, not only training set.

## 2. Regularized Objectives

- Ridge: `Loss + lambda ||w||_2^2`
- Lasso: `Loss + lambda ||w||_1`
- Elastic net: combination

## 3. Optimization and Geometry

L2 shrinks smoothly.
L1 encourages sparsity due to corner geometry of L1 ball.

## 4. Bias-Variance Tradeoff

Increasing regularization:
- reduces variance
- increases bias

Need tuning via validation/cross-validation.

## 5. Early Stopping as Implicit Regularization

Iterative optimization halted before overfitting can regularize model.

## 6. Worked Example

Compare linear regression with and without ridge on collinear features; regularized model stabilizes coefficients.

## 7. Practical Workflow

1. Split train/validation/test
2. Tune `lambda`
3. Monitor train-vs-validation gap
4. Report uncertainty and calibration

## Exercises

1. Derive closed form of ridge solution.
2. Explain why lasso can perform feature selection.
3. Plot validation error vs lambda and select optimum.
4. Compare early stopping vs explicit L2 on same dataset.
