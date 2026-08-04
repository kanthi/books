# Spectral Thinking: Eigenvalues in Practice

Eigenpairs $(Av=\lambda v)$ are not only homework: they govern **stability**, **oscillation**, **PCA**, **PageRank-like** updates, Markov mixing, graph cuts, and conditioning of linear solves.

## Diagram: eigen action

```text
       v
       │
   A   │  if Av = λv
       v
      λv   (same direction, scaled by λ)
```

## 1. Core facts

Let $A\in\mathbb{R}^{n\times n}$ (or complex).

- $\lambda$ eigenvalue, $v\neq 0$ eigenvector: $Av=\lambda v$ iff $\det(A-\lambda I)=0$  
- Distinct eigenvalues ⇒ linearly independent eigenvectors  
- **Real symmetric** $A$: all $\lambda$ real; orthonormal basis of eigenvectors; $A=Q\Lambda Q^\top$  
- Spectral radius $\rho(A)=\max_i|\lambda_i|$ controls growth of $A^k$  
- $\mathrm{tr}(A)=\sum\lambda_i$, $\det(A)=\prod\lambda_i$ (over $\mathbb{C}$, with multiplicity)

### Worked example 1

$A=\begin{bmatrix}0&1\\1&0\end{bmatrix}$: $\lambda=\pm 1$, vectors $(1,1)$ and $(1,-1)$.

### Worked example 2 — diagonal action

$A=\begin{bmatrix}2&0\\0&0.5\end{bmatrix}$: $\lambda=2,0.5$ with axis eigenvectors.  
$A^{10}$ stretches $e_1$ by $2^{10}$, shrinks $e_2$ by $0.5^{10}$.

## 2. Powers, iterations, and stability

If $A$ is diagonalizable, $A=V\Lambda V^{-1}$, then

$$
A^k = V\Lambda^k V^{-1}.
$$

Along eigenvector $v_i$, components multiply by $\lambda_i^k$.

```text
  |λ|<1  →  component dies
  |λ|>1  →  explodes
  |λ|=1  →  persists / oscillates (sign or complex angle)
```

Linear iteration $x\leftarrow Ax$ (from a generic start) converges to $0$ if $\rho(A)<1$ (defective cases need Jordan-block care: polynomial factors $k^{m}\lambda^k$).

### Worked example 3 — discrete dynamics

$x_{t+1}=Ax_t$. Stability of the origin requires $\rho(A)<1$. In control and signal processing, place eigenvalues of closed-loop maps carefully.

### Worked example 4 — Markov / PageRank flavor

Column-stochastic matrices have $\lambda=1$ with stationary distribution eigenvector. Power iteration $x\leftarrow Ax/\|Ax\|$ (or normalized differently) finds dominant eigenpairs — PageRank is a damped variant guaranteeing uniqueness and convergence.

## 3. Symmetric matrices and Rayleigh quotients

For $A=A^\top$,

$$
R(x)=\frac{x^\top A x}{x^\top x},\qquad
\lambda_{\min}=\min_{\|x\|=1}x^\top Ax,\quad
\lambda_{\max}=\max_{\|x\|=1}x^\top Ax.
$$

Variational characterization drives PCA, spectral clustering objectives, and many optimization bounds.

## 4. PCA link

Covariance $C=\frac1n X_c^\top X_c$ (centered data) is symmetric PSD. Top eigenvectors = principal directions of variance; eigenvalues = variances along those axes. Full development in the SVD/PCA chapter — spectral thinking says: **variance ↔ spectrum of $C$**.

## 5. Graph Laplacian

For undirected graph with adjacency $A$ and degree matrix $D$:

$$
L=D-A.
$$

Properties:

- $L$ symmetric PSD: $x^\top Lx=\sum_{(i,j)\in E}(x_i-x_j)^2$  
- $L\mathbf{1}=0$ always ⇒ $\lambda=0$ with constant eigenvector  
- Multiplicity of $\lambda=0$ = number of connected components  
- **Spectral clustering:** use smallest nontrivial eigenvectors as embeddings, then k-means  
- Fiedler value $\lambda_2$: algebraic connectivity — small ⇒ easy cut  

### Worked example 5 — path of 3 nodes

Degrees $(1,2,1)$; $L$ has rows summing to $0$ ⇒ $0$ is eigenvalue with $(1,1,1)$.

## 6. Conditioning

For symmetric invertible $A$, in the $2$-norm:

$$
\kappa_2(A)=\frac{|\lambda_{\max}|}{|\lambda_{\min}|}.
$$

Large $\kappa$ ⇒ sensitive linear solves and inverted maps. For general $A$, $\kappa_2(A)=\sigma_{\max}/\sigma_{\min}$ (singular values) — eigenvalues alone can mislead for non-normal matrices.

### Worked example 6 — non-normal caution

Some matrices have all $|\lambda|$ moderate yet $\|A^k\|$ transiently huge (non-normality). Spectrum is necessary but not always sufficient for transient behavior.

## 7. Power method and cousins

**Power method:** iterate $x\leftarrow Ax/\|Ax\|$. Converges to dominant eigenvector if $|\lambda_1|>|\lambda_2|$ strictly and start has a component along $v_1$.

**Inverse iteration / Rayleigh quotient iteration:** find interior eigenvalues.  
**QR algorithm / modern eigensolvers:** library defaults for dense problems.  
**Lanczos / Arnoldi:** large sparse partial spectra.

### Worked example 7

Dominant eigenpair of a link matrix ≈ “importance” ranking direction when the model is linear and well-connected.

## 8. Differential equations (glimpse)

$\dot x=Ax$: solutions involve $e^{At}$. Modes $e^{\lambda t}v$. Stability needs $\mathrm{Re}(\lambda)<0$ for all eigenvalues. Spectral thinking unifies discrete $A^k$ and continuous $e^{At}$.

## 9. Positive matrices (Perron–Frobenius flavor)

For positive (or irreducible nonnegative) matrices, the spectral radius is a simple positive eigenvalue with positive eigenvector — foundation for ranking, population models, and some Markov arguments.

## 10. CS applications map

| Area | Spectral object |
|------|-----------------|
| PCA / whitening | eigendecomposition of covariance |
| Graph ML | Laplacian eigenvectors |
| Stability of linear systems | $\rho(A)$, $\mathrm{Re}\lambda$ |
| Google-style ranking | dominant eigenvector of modified transition matrix |
| Vibration / circuits | modal analysis |
| Quantum / signal | Hermitian spectra |
| Optimization | Hessian eigenvalues (curvature, condition) |

## 11. Pitfalls

1. Assuming real eigenvectors for real nonsymmetric $A$ (rotations)  
2. Using eigenvalue ratios as $\kappa$ for highly non-normal $A$  
3. Power method without a spectral gap — slow/no convergence  
4. Confusing algebraic vs geometric multiplicity (defective matrices)  
5. Interpreting every eigenvector of a data matrix as a “concept” without validation  

### Worked example 8 — rotation

$90^\circ$ rotation $R=\begin{bmatrix}0&-1\\1&0\end{bmatrix}$ has no **real** eigenvectors (eigenvalues $\pm i$). Over $\mathbb{C}$, spectral picture exists; over $\mathbb{R}$, think invariant planes.

## 12. Checkpoint

- Define eigenpairs and spectral radius  
- Explain $A^k$ via diagonalization  
- Connect PCA to covariance eigenvectors  
- State Laplacian kernel and connectivity fact  
- Condition number for SPD matrices  
- Power method’s target  

## Exercises

### Easy

1. Find eigenpairs of $\begin{bmatrix}0&1\\1&0\end{bmatrix}$.  
2. Why can’t a real $2\times 2$ rotation by $90^\circ$ have real eigenvectors?  
3. If all $|\lambda|<1$ for diagonalizable $A$, show $A^k\to 0$.  
4. Relate trace to sum of eigenvalues.  
5. Power method idea — iterate $x\leftarrow Ax/\|Ax\|$; what does it find?  

### Medium

6. For Laplacian of a path of 3 nodes, argue $0$ is an eigenvalue.  
7. Prove $x^\top Lx=\sum_{(i,j)\in E}(x_i-x_j)^2$ for undirected graphs.  
8. Rayleigh: show $\lambda_{\max}=\max_{\|x\|=1}x^\top Ax$ for symmetric $A$ (using spectral theorem).  
9. If $A$ symmetric with eigenvalues in $[m,M]$, bound $\|Ax\|$ for $\|x\|=1$.  
10. PageRank damping: why does adding teleportation help uniqueness/convergence?  

### Challenge

11. Jordan block $J=\begin{bmatrix}\lambda&1\\0&\lambda\end{bmatrix}$: compute $J^k$ and discuss $|\lambda|<1$ vs $\|J^k\|$.  
12. Show multiplicity of $\lambda=0$ of $L$ equals number of connected components.  
13. Non-normal transient growth: construct a $2\times 2$ example with $\rho(A)<1$ but $\|A^k\|>1$ for some $k$.  
14. Connect Hessian condition number at a minimum to GD step-size limits.  
15. Spectral clustering: write the RatioCut / Laplacian relaxation idea at high level.  

## Checks

1. $\lambda=\pm 1$ with vectors $(1,1)$, $(1,-1)$.  
4. $\mathrm{tr}(A)=\sum\lambda_i$.  
5. Dominant eigenvector (largest $|\lambda|$).  

## Summary

Spectral thinking asks: **what does this matrix stretch, shrink, or rotate?** Eigenvalues control long-term iteration, continuous dynamics, variance directions, graph cuts, and conditioning. Symmetric problems give clean orthogonal diagonalizations; nonsymmetric and non-normal cases need extra care. From PCA to PageRank to Laplacians, reading the spectrum is a practical superpower for scientific computing and ML systems.
