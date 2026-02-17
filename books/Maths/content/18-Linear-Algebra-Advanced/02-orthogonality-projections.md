# Orthogonality and Projections

## 1. Inner Product Geometry

Orthogonality: `u·v=0`.
Norm: `||v|| = sqrt(v·v)`.

Cauchy-Schwarz:
`|u·v| <= ||u|| ||v||`.

## 2. Orthogonal Projection onto a Vector

Projection of `x` onto nonzero `u`:

`proj_u(x) = (x·u)/(u·u) * u`.

Residual `r = x - proj_u(x)` is orthogonal to `u`.

## 3. Projection onto Subspace

For full-column-rank matrix `A`, projection onto `Col(A)`:

`P = A(A^T A)^{-1}A^T`, `xhat = Px`.

### Theorem

`xhat` is unique minimizer of `||x-y||` over all `y in Col(A)`.

### Proof Sketch

Use orthogonality condition: residual orthogonal to subspace basis.

## 4. Gram-Schmidt and QR

Gram-Schmidt orthonormalizes basis vectors.
QR decomposition `A=QR` gives orthonormal columns and upper triangular `R`.

## 5. Numerical Perspective

Classical Gram-Schmidt can be unstable; modified Gram-Schmidt or Householder QR preferred in practice.

## 6. Worked Example

Fit line through points by projecting target onto column space of design matrix.
This leads directly to least squares.

## Exercises

1. Compute projection of `(3,1)` onto vector `(1,2)`.
2. Verify `P^2=P` and `P^T=P` for projection matrix.
3. Run Gram-Schmidt on three 3D vectors.
4. Explain why orthonormal bases improve numerical behavior.
