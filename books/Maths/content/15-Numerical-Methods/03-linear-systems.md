# Numerical Linear Systems

## 1. Problem

Solve `Ax=b`.

This appears in simulation, optimization, graphics, statistics, and ML.

## 2. Direct Methods

- Gaussian elimination
- LU decomposition (`PA=LU` with pivoting)
- Cholesky for symmetric positive definite matrices

### Theorem

If `A` is nonsingular, Gaussian elimination with partial pivoting computes a solution to a nearby problem (backward stable in practice).

## 3. Iterative Methods

- Jacobi
- Gauss-Seidel
- Conjugate Gradient (SPD matrices)

Iterative methods are preferred for large sparse systems.

## 4. Conditioning

`kappa(A)=||A||*||A^{-1}||`.

Large `kappa` means high sensitivity to perturbations.

### Example

Hilbert matrices are notoriously ill-conditioned.

## 5. Avoid Explicit Inverse

Never compute `x = A^{-1}b` in production code.
Use decomposition-based solve.

```python
x = np.linalg.solve(A, b)
```

## 6. Residual and Validation

Residual:
`r = b - Ax`.

Small residual does not always imply small forward error for ill-conditioned systems. Check both residual and conditioning.

## 7. Worked Sparse Example Strategy

For sparse SPD matrix from finite-difference PDE:
- use Conjugate Gradient,
- precondition if needed,
- monitor residual norm.

## Exercises

1. Compare solve via inverse vs solve routine for random matrices.
2. Compute condition numbers for Hilbert matrices of size 5, 8, 12.
3. Implement Jacobi and test convergence criteria.
4. Explain why pivoting is needed in elimination.
