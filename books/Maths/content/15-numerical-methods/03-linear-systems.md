# Numerical Linear Systems

Solving $Ax=b$ is the kernel of simulation, least squares, Gaussian processes, spline fitting, interior-point methods, and Newton steps for nonlinear systems. This chapter covers direct factorizations, iterative methods, conditioning, and validation—without forming $A^{-1}$.

## 1. The problem

Given $A\in\mathbb{R}^{n\times n}$ nonsingular and $b\in\mathbb{R}^n$, find $x$ with $Ax=b$.

**Variants:** rectangular least squares $A\in\mathbb{R}^{m\times n}$, singular/ill-posed systems (regularize), multiple right-hand sides, matrix equations.

### Worked example 1

2D: $A=\begin{bmatrix}2&1\\1&2\end{bmatrix}$, $b=\begin{bmatrix}3\\3\end{bmatrix}$ $\Rightarrow x=\begin{bmatrix}1\\1\end{bmatrix}$.

## 2. Direct methods: Gaussian elimination and LU

**LU factorization:** $A=LU$ (or $PA=LU$ with permutation $P$ from pivoting), $L$ unit lower triangular, $U$ upper triangular.

**Solve:** $Ly=Pb$ then $Ux=y$ by substitution—$O(n^2)$ after $O(n^3)$ factorization.

**Partial pivoting:** swap rows to maximize pivot magnitude—controls element growth, improves stability.

### Worked example 2 — why pivot

$A=\begin{bmatrix}\varepsilon&1\\1&1\end{bmatrix}$ with tiny $\varepsilon$: without pivoting, elimination is unstable in FP; with pivoting, swap rows first.

### Cholesky

If $A$ SPD ($A=A^\top\succ 0$), $A=LL^\top$ (or $R^\top R$) with half the work and better stability constants. **Always prefer Cholesky when SPD is known.**

### Worked example 3

Gram matrices $X^\top X+\lambda I$ for $\lambda>0$ are SPD—use Cholesky for ridge solves.

## 3. Complexity and structure

| Method | Leading cost | Notes |
|--------|--------------|-------|
| Dense LU/Cholesky | $\frac13 n^3$ / $\frac16 n^3$ | BLAS3 heavy |
| Banded | depends on bandwidth | ODE/PDE discretizations |
| Sparse direct | fill-in dependent | Ordering (AMD, nested dissection) critical |
| Iterative | per-iter matvec | Need preconditioners |

### Worked example 4

Tridiagonal systems: Thomas algorithm $O(n)$—never use dense LU.

## 4. Residual, forward error, condition number

Residual $r=b-A\hat{x}$.

**Rule of thumb:** $\frac{\|\hat{x}-x\|}{\|x\|}\lesssim \kappa(A)\frac{\|r\|}{\|A\|\|x\|}$ (norm-dependent constants).

$$
\kappa(A)=\|A\|\|A^{-1}\|.
$$

For 2-norm, $\kappa_2(A)=\sigma_{\max}(A)/\sigma_{\min}(A)$.

### Worked example 5 — Hilbert

Hilbert matrix $H_{ij}=1/(i+j-1)$ has $\kappa$ growing exponentially with $n$. Even tiny residual can coexist with large forward error.

### Worked example 6 — scaling

Row/column equilibration can change practical accuracy; ill-scaling is a common modeling bug.

## 5. Never form the inverse

Computing $A^{-1}$ then $x=A^{-1}b$:

- More FLOPs and memory  
- Typically worse accuracy  
- Destroys sparsity  

Use `solve`, factorizations, or iterative methods.

### Worked example 7

```text
# good
x = Solve(A, b)           # LU/Cholesky inside
# bad
x = Inverse(A) * b
```

## 6. Iterative methods overview

Generate $x^{(k)}\to x$ using matvecs $v\mapsto Av$.

### Jacobi

$x_i^{(k+1)}=\frac{1}{a_{ii}}\big(b_i-\sum_{j\neq i}a_{ij}x_j^{(k)}\big)$. Needs nonzero diagonals; converges if diagonally dominant (sufficient conditions).

### Gauss–Seidel

Use newest values within the sweep—often faster than Jacobi.

### Conjugate gradient (CG)

For SPD $A$: optimal Krylov method minimizing $A$-norm error over Krylov subspace. Memory: few vectors. Convergence depends on eigenvalue distribution / $\kappa$.

**Preconditioning:** solve $M^{-1}Ax=M^{-1}b$ with $M\approx A$ SPD easier to invert (incomplete Cholesky, multigrid, …).

### Worked example 8

Poisson equation finite differences: classic CG + multigrid showcase—sparse huge $n$.

### Worked example 9 — GMRES

For nonsymmetric $A$, GMRES/MINRES/BiCGSTAB families. Restarted GMRES trades optimality for memory.

## 7. Stopping criteria for iterative solvers

Common: $\|r^{(k)}\|/\|b\|<\tau$. Also monitor stagnation, max iters, and (when possible) cheap error estimates. Too tight $\tau$ wastes time beyond FP meaningful digits given $\kappa$.

### Worked example 10

If $\kappa\sim 10^{10}$ and $u\sim 10^{-16}$, expecting 14 correct digits is fantasy—stop earlier.

## 8. Least squares connection

Overdetermined $Ax\approx b$: solve normal equations $A^\top A \hat{x}=A^\top b$ **or better** use QR / SVD for stability.

$\kappa(A^\top A)=\kappa(A)^2$—normal equations square the condition number. Prefer QR for moderately ill-conditioned least squares.

### Worked example 11

Polynomial fitting high degree: Vandermonde ill-conditioned; use orthogonal polynomials or regularization.

## 9. CS/ML applications

- Newton steps: $H\Delta w=-\nabla J$  
- Gaussian process / kernel methods: $(K+\sigma^2 I)v=y$  
- Graph Laplacians: semi-supervised learning, embeddings  
- Bundle adjustment / SLAM: sparse Schur complements  
- Recommendation / ALS: alternating least squares solves  

## 10. Pitfalls

1. Explicit inverses  
2. Using CG on nonsymmetric or indefinite $A$ without variants  
3. Ignoring fill-in ordering in sparse direct  
4. Trusting residual alone  
5. Integer overflow in index arrays for huge sparse graphs  
6. Mixed precision without iterative refinement when needed  

## 11. Checkpoint

- Factor $PA=LU$ and solve by substitution  
- Prefer Cholesky for SPD  
- Define $\kappa$ and interpret Hilbert pathology  
- Choose iterative vs direct at a high level  
- Prefer QR over naive normal equations for least squares  

## Exercises

### Easy

1. Solve a $2\times 2$ system by hand with GE and with Cramer; compare effort.
2. Why is pivoting unnecessary for many SPD Cholesky cases?
3. Compute $\kappa_2$ of $\mathrm{diag}(1,10^{-8})$.
4. Cost of solving 100 RHS after one LU vs 100 independent GEs.
5. Write Jacobi update for a 3×3 diagonally dominant example.

### Medium

6. Show that if $A$ is strictly diagonally dominant, Jacobi converges (sketch/reference theorem).
7. Prove $\kappa_2(A)=\sigma_{\max}/\sigma_{\min}$.
8. Explain iterative refinement: solve, compute residual in higher precision, correct.
9. Compare flop counts: form $A^{-1}$ vs LU solve for one $b$.
10. For ridge $X^\top X+\lambda I$, argue SPD and recommend a solver.

### Challenge

11. Sparse Cholesky fill-in: give a matrix ordering bad vs good (path graph vs nested dissection intuition).
12. Derive CG at high level from Krylov optimality (A-norm).
13. SVD solution of least squares and relation to pseudoinverse.
14. Conditioning of Vandermonde systems—why orthogonal bases help.
15. Design a preconditioner intuition for a graph Laplacian (degree diagonal / incomplete factorization).

## Summary

Linear solves are factorization plus substitution or Krylov iteration—not inversion. Stability, conditioning, and structure (SPD, sparse, banded) dictate the method. Validate with residuals **and** condition awareness, especially in ML and simulation pipelines.
