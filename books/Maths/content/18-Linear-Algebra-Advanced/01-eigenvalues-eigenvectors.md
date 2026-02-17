# Eigenvalues and Eigenvectors

## 1. Definition

For square matrix `A`, nonzero vector `v` is eigenvector if:

`Av = lambda v`.

`lambda` is eigenvalue.

## 2. Characteristic Polynomial

`det(A - lambda I)=0` gives eigenvalues.

For each eigenvalue, eigenspace is null space of `(A-lambda I)`.

## 3. Theorem (Diagonalization Criterion)

`A` is diagonalizable iff it has a basis of eigenvectors.
Equivalent to geometric multiplicities summing to dimension.

## 4. Symmetric Matrix Spectral Theorem

If `A` is real symmetric:
- all eigenvalues are real
- eigenvectors for distinct eigenvalues are orthogonal
- `A = Q Lambda Q^T` with orthonormal `Q`

### Proof Sketch

Use self-adjoint properties and orthogonality of eigenspaces.

## 5. Powers and Dynamics

If diagonalizable, `A^k = P D^k P^{-1}`.
This simplifies repeated-update systems and Markov-like analysis.

## 6. Worked Example

`A = [[2,1],[1,2]]`.
Eigenvalues: 3 and 1.
Eigenvectors: `[1,1]^T` and `[1,-1]^T`.
Interpretation: transformation scales principal directions differently.

## 7. CS Applications

- PageRank and spectral ranking
- graph partitioning via Laplacian eigenvectors
- PCA foundations
- stability of iterative maps

## Exercises

1. Compute eigenvalues/eigenvectors of `[[4,0],[0,7]]`.
2. Determine whether a given 3x3 matrix is diagonalizable.
3. Prove orthogonality of eigenvectors for symmetric matrix.
4. Use eigen-decomposition to compute `A^10` for diagonalizable `A`.
