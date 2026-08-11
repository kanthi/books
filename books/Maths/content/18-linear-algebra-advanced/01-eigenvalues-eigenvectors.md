# Eigenvalues and Eigenvectors

Eigenvectors are directions a linear map merely stretches; eigenvalues are the stretch factors. Spectral theory unlocks matrix powers, differential systems, PCA special cases, Markov stationarity, and stability of discrete dynamics.

## 1. Definition

Let $A\in\mathbb{C}^{n\times n}$ (or $\mathbb{R}^{n\times n}$). A nonzero vector $v$ is an **eigenvector** with **eigenvalue** $\lambda$ if

$$
Av=\lambda v \iff (A-\lambda I)v=0.
$$

So $\lambda$ is eigenvalue iff $A-\lambda I$ is singular iff $\det(A-\lambda I)=0$.

### Worked example 1

$A=\begin{bmatrix}2&1\\1&2\end{bmatrix}$. Characteristic polynomial $(2-\lambda)^2-1=(\lambda-3)(\lambda-1)$.  
$\lambda=3$ with $v\propto(1,1)$; $\lambda=1$ with $v\propto(1,-1)$.

### Worked example 2

Diagonal $D=\mathrm{diag}(\lambda_i)$: standard basis vectors are eigenvectors.

## 2. Characteristic polynomial

$p_A(\lambda)=\det(A-\lambda I)$ is degree $n$. Fundamental theorem of algebra: $n$ roots in $\mathbb{C}$ counting multiplicity (**algebraic multiplicity**).

**Geometric multiplicity:** $\dim\ker(A-\lambda I)\ge 1$ for each eigenvalue. Always $\le$ algebraic multiplicity.

### Worked example 3 — defective matrix

$J=\begin{bmatrix}\lambda&1\\0&\lambda\end{bmatrix}$ has one eigenvector direction (up to scale); not diagonalizable.

## 3. Diagonalization

**Theorem.** $A$ is diagonalizable iff there is a basis of eigenvectors iff $A=PDP^{-1}$ with $D$ diagonal.

Then $A^k=PD^kP^{-1}$ and (when defined) $f(A)=Pf(D)P^{-1}$ for analytic $f$.

### Worked example 4 — dynamics

$x_{t+1}=Ax_t\Rightarrow x_t=A^t x_0$. In eigenbasis, each mode multiplies by $\lambda_i^t$. Stable discrete LTI if all $|\lambda_i|<1$.

### Worked example 5 — continuous

$\dot x=Ax\Rightarrow x(t)=e^{tA}x_0$; modes $e^{\lambda_i t}$.

## 4. Spectral theorem (real symmetric)

**Theorem.** If $A=A^\top\in\mathbb{R}^{n\times n}$, then:

1. All eigenvalues real  
2. Eigenvectors for distinct eigenvalues are orthogonal  
3. $A=Q\Lambda Q^\top$ with $Q$ orthogonal ($Q^\top Q=I$), $\Lambda$ diagonal  

**Proof sketch.** Existence of at least one real eigenpair (real char poly degree odd? actually use complex eigenpair and show imaginary part vanishes via $v^*Av$ real); induct by restricting to orthogonal complement; orthogonality from $(\lambda-\mu)u^\top v=u^\top Av-v^\top Au=0$. $\blacksquare$

### Worked example 6

Covariance matrices and graph Laplacians are real symmetric (PSD actually for Laplacians/cov)—spectral theorem applies fully.

### Hermitian extension

$A=A^*$ over $\mathbb{C}$: unitary diagonalization with real eigenvalues.

## 5. Invariant subspaces and Schur form (awareness)

Every square matrix is unitarily similar to upper triangular (Schur). Eigenvalues appear on the diagonal—even when not diagonalizable.

## 6. Rayleigh quotient

For symmetric $A$,

$$
R(v)=\frac{v^\top A v}{v^\top v},\qquad \lambda_{\min}\le R(v)\le\lambda_{\max}.
$$

Maximizing $R$ recovers the top eigenpair—basis of power methods and PCA variance interpretation.

### Worked example 7

Power iteration: $v\leftarrow Av/\|Av\|$ converges to dominant eigenvector if $|\lambda_1|>|\lambda_2|$ gap.

## 7. Graph spectra (CS)

- Adjacency $A$: $\lambda_{\max}$ related to max degree; regularity  
- Laplacian $L=D-A$: $L\succeq 0$, $0$ eigenvalue with multiplicity = # components; Fiedler value $\lambda_2$ measures connectivity  

### Worked example 8

Connected graph $\Leftrightarrow$ $\ker L$ is constants only ($\lambda_2>0$).

### Worked example 9 — spectral clustering

Embed nodes via small Laplacian eigenvectors; cluster in that space.

## 8. Markov chains link

Stationary $\pi$ satisfies $P^\top\pi=\pi$—eigenvalue $1$ of $P^\top$. Spectral gap controls mixing.

### Worked example 10

PageRank: dominant eigenpair of Google matrix.

## 9. Non-symmetric caveats

- Complex conjugate eigenvalues  
- Defective matrices / Jordan blocks: polynomial factors $t^k\lambda^t$ in powers  
- Left eigenvectors $w^\top A=\lambda w^\top$ matter for biorthogonal expansions  

### Worked example 11

Rotation by $\theta\neq 0,\pi$ in 2D: eigenvalues $e^{\pm i\theta}$, no real eigenbasis.

## 10. Trace and determinant

$\mathrm{tr}(A)=\sum\lambda_i$, $\det(A)=\prod\lambda_i$ (over $\mathbb{C}$ with multiplicity). Useful checksums.

### Worked example 12

$\det(A)\neq 0\Leftrightarrow 0$ not eigenvalue $\Leftrightarrow$ invertible.

## 11. Pitfalls

1. Assuming all matrices diagonalizable  
2. Normalizing differently and thinking eigenvectors unique  
3. Sorting eigenvalues inconsistently (algebraic vs by magnitude)  
4. Using Euclidean orthogonality for non-symmetric eigenbases  
5. Floating-point: naive charpoly is unstable—use library eigensolvers  

## 12. Checkpoint

- Solve $2\times 2$ eigenproblems by hand  
- State diagonalization criterion  
- Apply spectral theorem for symmetric $A$  
- Use $A^k=PD^kP^{-1}$  
- Connect Laplacian $\lambda_2$ to connectivity  

## Exercises

### Easy

1. Eigenvalues of $\begin{bmatrix}0&1\\0&0\end{bmatrix}$; diagonalizable?
2. Show eigenvectors of distinct eigenvalues of symmetric $A$ are orthogonal.
3. Compute $\mathrm{tr},\det$ from eigenvalues of Example 1.
4. If $Av=\lambda v$, what is $A^{-1}v$ when $A$ invertible?
5. Rayleigh for $A=I$: what values?

### Medium

6. Diagonalize Example 1; compute $A^5$ via $PD^5P^{-1}$.
7. Prove $\ker L$ dimension equals components for graph Laplacian.
8. Show $|\lambda|\le \|A\|$ for any operator norm (spectral radius bounds).
9. Power method: why gap $|\lambda_1/\lambda_2|$ controls rate.
10. For projection matrix $P^2=P=P^\top$, show eigenvalues in $\{0,1\}$.

### Challenge

11. Prove spectral theorem for real symmetric $2\times 2$ fully elementary.
12. Jordan form existence statement; give dynamics when Jordan block size $>1$.
13. Courant–Fischer min-max theorem statement for $\lambda_k$.
14. Google matrix: prove eigenvalue 1 exists for row-stochastic matrices.
15. Sensitivity: Bauer–Fike sketch—eigenvalue perturbation vs non-normality.

## Summary

Eigenpairs reduce linear maps to scalings on special lines. Symmetric matrices are orthogonally diagonalizable—the cleanest spectral world—while defective and non-normal matrices warn that not every $A$ behaves like a stretch on an orthonormal frame. CS applications from PageRank to spectral clustering rest on these facts.
