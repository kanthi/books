# Spectral Thinking: Eigenvalues in Practice

Eigenpairs $(Av=\lambda v)$ are not only homework: they govern **stability**, **oscillation**, **PCA**, **PageRank-like** updates, and conditioning.

## Diagram: eigen action

```text
       v
       │
   A   │  if Av = λv
       v
      λv   (same direction, scaled by λ)
```

## 1. Core facts

- Eigenvalues roots of $\det(A-\lambda I)=0$.  
- Distinct eigenvalues ⇒ independent eigenvectors.  
- Symmetric real $A$: real $\lambda$, orthogonal diagonalization $A=Q\Lambda Q^T$.  
- Spectral radius $\rho(A)=\max|\lambda_i|$ controls $A^k$ growth.

## 2. Powers and stability

$A^k v$ along eigenvector multiplies by $\lambda^k$.

```text
  |λ|<1  →  component dies
  |λ|>1  →  explodes
  |λ|=1  →  persists / oscillates
```

Linear iterations $x\leftarrow Ax$ converge (from generic start) only if $\rho(A)<1$ (with care for defective cases).

## 3. PCA link

Covariance $C$ symmetric PSD; top eigenvectors = principal directions of variance (see SVD/PCA chapter).

## 4. Graph Laplacian (preview)

$L=D-A$ (degree minus adjacency) has $\lambda\ge 0$, $0$ with multiplicity $=$ # connected components (undirected). Spectral clustering uses small eigenvectors.

## 5. Conditioning

For symmetric $A$, $\kappa_2(A)=|\lambda_{\max}|/|\lambda_{\min}|$ (if invertible). Large $\kappa$ ⇒ sensitive linear solves.

## 6. Worked mini

$A=\begin{bmatrix}2&0\\0&0.5\end{bmatrix}$: $\lambda=2,0.5$, axes eigenvectors.  
$A^{10}$ stretches $e_1$ by $2^{10}$, shrinks $e_2$ by $0.5^{10}$.

## Exercises

1. Find eigenpairs of $\begin{bmatrix}0&1\\1&0\end{bmatrix}$.  
2. Why can’t a real $2\times 2$ rotation by $90^\circ$ have real eigenvectors?  
3. If all $|\lambda|<1$ for diagonalizable $A$, show $A^k\to 0$.  
4. Relate trace to sum of eigenvalues.  
5. **Numerical:** power method idea — iterate $x\leftarrow Ax/\|Ax\|$; what does it find?  
6. For Laplacian of a path of 3 nodes, argue $0$ is an eigenvalue.

## Checks

1. $\lambda=\pm 1$ with vectors $(1,1)$, $(1,-1)$.  
4. $\mathrm{tr}(A)=\sum\lambda_i$.  
5. Dominant eigenvector (largest $|\lambda|$).
