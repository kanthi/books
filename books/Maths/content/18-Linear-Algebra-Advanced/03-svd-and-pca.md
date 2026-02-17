# Singular Value Decomposition and PCA

## 1. SVD Statement

Any matrix `A` in `R^{m x n}` can be written:

`A = U Sigma V^T`,

where `U` and `V` are orthonormal and `Sigma` has nonnegative singular values.

## 2. Geometric Meaning

Linear map decomposes into:
1. rotation/reflection (`V^T`)
2. axis scaling (`Sigma`)
3. rotation/reflection (`U`)

## 3. Eckart-Young Theorem

Best rank-`k` approximation in Frobenius norm is:

`A_k = U_k Sigma_k V_k^T`.

### Proof Idea

Energy captured by top singular values; truncation minimizes residual norm.

## 4. PCA Connection

PCA directions are eigenvectors of covariance matrix or right singular vectors of centered data matrix.

Explained variance ratio comes from singular values.

## 5. Worked Example (Conceptual)

High-dimensional text embeddings compressed to 2D using top components for visualization.

## 6. Applications

- denoising
- compression
- latent semantic indexing
- recommendation systems
- model acceleration via low-rank structure

## Exercises

1. Compute SVD of a simple 2x2 matrix manually.
2. Prove that singular values are square roots of eigenvalues of `A^T A`.
3. Implement PCA and report explained variance.
4. Compare reconstruction error for rank-1, rank-2 approximations.
