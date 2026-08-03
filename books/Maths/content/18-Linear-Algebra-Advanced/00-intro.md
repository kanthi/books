# Advanced Linear Algebra for CS/ML

Advanced linear algebra studies structure beyond “multiply matrices”: spectral decompositions, orthogonality, low-rank approximation, and the numerical meaning of conditioning. These tools run PCA, PageRank-like iterations, least squares solvers, quantum-inspired algorithms, and the theory of gradient descent on quadratics.

## Why go beyond basic LA

| Capability | Payoff |
|------------|--------|
| Eigen / spectral | Dynamics $A^k$, stability, graph spectra |
| Orthogonality | Stable bases, QR, projections |
| SVD | PCA, compression, pseudoinverse, recommendations |
| Conditioning | Predict numerical accuracy of solves |

## Learning path

```text
flow:
  B -> C
  C -> D
  A -> C
```

## Matrix as linear map

$A\in\mathbb{R}^{m\times n}$ represents $x\mapsto Ax$. Change of basis $A=PBP^{-1}$ (square case) reveals simpler action: diagonal, Jordan, or orthogonal spectral form.

### Worked example 1

On an eigenbasis, $A$ scales axes independently—powers and exponentials $e^{tA}$ become easy.

### Worked example 2 — graphs

Adjacency and Laplacian matrices encode graphs; their eigenvalues constrain cuts, connectivity, and random walk mixing.

## Roadmap

1. Eigenvalues and eigenvectors  
2. Orthogonality and projections  
3. SVD and PCA  
4. Least squares and conditioning  

Prerequisites: matrix multiply, invertibility, rank, basic Gaussian elimination. Inner products strongly recommended.

## CS/ML touchpoints preview

- PCA via top singular vectors  
- Ridge regression spectral filtering  
- Attention and Gram matrices (pairwise similarities)  
- Kalman / Gaussian covariances SPD structure  
- Word embeddings and matrix factorization  

## Four identities worth memorizing

1. **Eigen:** $Av=\lambda v$ $\Rightarrow$ $A^k v=\lambda^k v$ (when defined)  
2. **Symmetric spectral:** $A=A^\top\Rightarrow A=Q\Lambda Q^\top$ with $Q^\top Q=I$  
3. **SVD:** $A=U\Sigma V^\top$, $A_k=\sum_{i\le k}\sigma_i u_i v_i^\top$ optimal rank-$k$  
4. **Normal equations:** $A^\top A\hat x=A^\top b$ for least squares (prefer QR/SVD numerically)

### Worked example 3 — PCA in one line

Center $X$, compute thin SVD $X=U\Sigma V^\top$; top columns of $V$ are principal axes; scores $XV_k$.

### Worked example 4 — ridge filter

In the right singular basis, ridge multiplies component $i$ by $\sigma_i/(\sigma_i^2+\lambda)$—shrinks noisy small-$\sigma$ directions.

### Worked example 5 — graph Laplacian

$L=D-A\succeq 0$; multiplicity of eigenvalue $0$ equals the number of connected components; Fiedler vector (for $\lambda_2$) seeds spectral partitioning.

## Orthogonality as numerical gold

Orthogonal/unitary transforms preserve $\|\cdot\|_2$ and have $\kappa_2=1$. Householder QR and SVD are built from them—why library solvers beat naive elimination on tough problems.

## Pitfalls

1. Non-diagonalizable matrices (defective) break naive $A=PDP^{-1}$  
2. Complex eigenvalues of real nonsymmetric $A$  
3. Confusing left/right singular vectors  
4. Interpreting every basis as orthogonal  
5. Ignoring $\kappa(A)$ when solving $Ax=b$  
6. PCA without centering or without scaling incomparable features  

## Checkpoint

- State eigen-equation $Av=\lambda v$  
- Know spectral theorem for real symmetric matrices  
- Name SVD factors $U\Sigma V^\top$  
- Connect PCA to covariance eigenvectors  
- Define condition number  

## Exercises

1. Compute eigenvalues of a $2\times 2$ diagonal matrix; of a rotation by $90^\circ$.
2. Why do real symmetric matrices have real eigenvalues? (one reason)
3. Give a defective $2\times 2$ Jordan block example.
4. What does $\sigma_{\min}(A)=0$ mean for least squares?
5. PageRank as eigenproblem: what eigenvalue is targeted?
6. Checkpoint reading: map one ML method you know to an eigen/SVD step.

## Summary

This part upgrades linear algebra from row reduction to spectral geometry and stable computation—the language of modern data and scientific computing.
