# Least Squares and Conditioning

## 1. Least Squares Problem

Given overdetermined system `Ax ≈ b`, solve:

`min_x ||Ax-b||_2^2`.

## 2. Normal Equations

Optimality condition:

`A^T A x = A^T b`.

Geometrically: residual is orthogonal to column space of `A`.

## 3. Theorem

If columns of `A` are independent, least-squares solution is unique.

### Proof Sketch

`A^T A` is positive definite under full column rank, so linear system has unique solution.

## 4. Numerical Caution

Normal equations square condition number; can degrade accuracy.
Prefer QR or SVD methods in practice.

## 5. Conditioning and Sensitivity

High `kappa(A)` implies small data perturbations can cause large parameter changes.

Regularization (ridge) improves conditioning:
`(A^T A + lambda I)x = A^T b`.

## 6. Worked Example

Linear regression with correlated features:
- unregularized coefficients unstable
- ridge stabilizes estimates and prediction behavior

## 7. Practical Checklist

- check singular values / condition number
- inspect residual norm and validation error
- use robust solvers (`lstsq`, QR, SVD)
- regularize if ill-conditioned

## Exercises

1. Solve least squares via normal equations and QR; compare numeric error.
2. Construct near-collinear design matrix and observe instability.
3. Show ridge reduces condition number numerically.
4. Prove orthogonality of residual to column space at optimum.
