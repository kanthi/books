# SVD and PCA

The singular value decomposition (SVD) is the Swiss army knife of applied linear algebra: it diagonalizes any matrix via two orthogonal bases, yields optimal low-rank approximations, and powers PCA, pseudoinverses, and many recommender and NLP factorizations.

## 1. SVD statement

**Theorem.** Any $A\in\mathbb{R}^{m\times n}$ admits

$$
A=U\Sigma V^\top
$$

where $U\in\mathbb{R}^{m\times m}$ and $V\in\mathbb{R}^{n\times n}$ are orthogonal, and $\Sigma\in\mathbb{R}^{m\times n}$ is rectangular diagonal with nonnegative **singular values**

$$
\sigma_1\ge\sigma_2\ge\cdots\ge\sigma_{r}>0=\cdots,\qquad r=\mathrm{rank}(A).
$$

**Thin/economy SVD:** keep first $r$ (or $k$) columns of $U,V$ and $k\times k$ $\Sigma_k$.

### Geometric reading

$V$ orthonormal input directions; $\Sigma$ axis-aligned stretches; $U$ orthonormal output directions. $A$ maps $v_i\mapsto\sigma_i u_i$.

### Worked example 1

Rank-1: $A=uv^\top$ (up to scale) has one positive singular value $\|u\|\|v\|$ in simple cases—outer products are the atoms of SVD expansions $A=\sum_i\sigma_i u_i v_i^\top$.

## 2. Links to eigenvalues

$A^\top A=V\Sigma^\top\Sigma V^\top$: eigenvalues of $A^\top A$ are $\sigma_i^2$.  
$AA^\top=U\Sigma\Sigma^\top U^\top$: same nonzero spectrum.  

Singular vectors are eigenvectors of these Gram matrices—but computing SVD via forming $A^\top A$ can be less stable than dedicated SVD algorithms.

### Worked example 2

If $A$ is symmetric PSD, SVD coincides with eigen-decomposition ($U=V$).

## 3. Eckart–Young–Mirsky theorem

**Theorem.** Among rank-at-most-$k$ matrices, the truncated SVD

$$
A_k=\sum_{i=1}^k \sigma_i u_i v_i^\top
$$

minimizes both $\|A-B\|_2$ and $\|A-B\|_F$. Error $\|A-A_k\|_F^2=\sum_{i>k}\sigma_i^2$, $\|A-A_k\|_2=\sigma_{k+1}$.

### Worked example 3 — compression

Store $U_k,\Sigma_k,V_k$ instead of dense $A$ when $\sigma_i$ decay rapidly—image compression and latent factor models.

### Worked example 4 — denoising

If noise inflates small singular values, truncating acts as a spectral filter.

## 4. Moore–Penrose pseudoinverse

$$
A^+=V\Sigma^+ U^\top,\qquad \Sigma^+\text{ reciprocates nonzero }\sigma_i.
$$

Solves min-norm least squares: $\hat x=A^+ b$ minimizes $\|x\|$ among minimizers of $\|Ax-b\|$ (when consistent, min-norm solution of $Ax=b$).

### Worked example 5

Underdetermined full-row-rank $A$: $A^+=A^\top(AA^\top)^{-1}$.  
Overdetermined full-column-rank: $A^+=(A^\top A)^{-1}A^\top$.

## 5. PCA via SVD

**Data.** Centered matrix $X\in\mathbb{R}^{n\times d}$ (rows observations). Sample covariance $\propto X^\top X$.

**PCA:** principal directions = top eigenvectors of covariance = right singular vectors of $X$.  
Scores = $XV_k=U_k\Sigma_k$.

**Objective:** maximize variance of projected data, or equivalently minimize reconstruction error $\|X-X_k\|_F$—Eckart–Young.

### Worked example 6

2D correlated Gaussian cloud: first PC along major axis; second orthogonal minor axis.

### Worked example 7 — explained variance

Fraction $\sigma_j^2/\sum_i\sigma_i^2$ (for centered $X$) measures variance along PC $j$.

### Worked example 8 — whitening

Transform $X V\Sigma^{-1}$ (careful with tiny $\sigma$) yields approximately identity covariance—preprocessing for some models.

## 6. Recommendations and factor models

Approximate ratings matrix $R\approx WH$ or via SVD of filled/centered $R$. Truncation = latent factors.

### Worked example 9

Latent dimension $k$: users and items embed into $\mathbb{R}^k$; predictions inner products—classic collaborative filtering.

## 7. Conditioning and numerical rank

$\kappa_2(A)=\sigma_1/\sigma_{\min}$ for square invertible $A$.  
Numerical rank: count $\sigma_i$ above a threshold relative to $\sigma_1$ and machine precision.

### Worked example 10

Nearly rank-deficient design matrices: tiny $\sigma_{\min}$ $\Rightarrow$ huge coefficient sensitivity in OLS—regularize (ridge shrinks small directions).

## 8. Randomized SVD (awareness)

Sketch $A$ with random projections; compute thin SVD of sketch—near-optimal low-rank approx for huge matrices (Halko–Martinsson–Tropp).

### Worked example 11

Billion-scale PCA: randomized algorithms + streaming variants.

## 9. Pitfalls

1. Forgetting to **center** before PCA  
2. Interpreting PCs as causal factors  
3. Scaling features inconsistently (PCA is not scale-invariant)  
4. Using too large $k$ (fitting noise)  
5. Forming $X^\top X$ explicitly for wide data when $XX^\top$ is smaller (dual PCA)  
6. Confusing $U$ and $V$ roles (samples vs features)  

### Worked example 12 — scale

Feature in meters vs millimeters dominates PCs if unstandardized—standardize when variables incomparable.

## 10. Checkpoint

- State full and truncated SVD  
- Apply Eckart–Young error formulas  
- Build pseudoinverse from SVD  
- Derive PCA from SVD of centered $X$  
- Read explained variance from singular values  

## Exercises

### Easy

1. SVD of a diagonal rectangular matrix?
2. Show $\|A\|_2=\sigma_1$ and $\|A\|_F^2=\sum\sigma_i^2$.
3. Rank-$(1)$ approx of $A$ from top singular triple.
4. Why center for PCA?
5. $\kappa_2$ from singular values for invertible square $A$.

### Medium

6. Prove $A^\top A$ eigenvectors relate to $V$ (compute).
7. Show $A_k$ has rank $\le k$ and write residual Frobenius error.
8. Dual PCA: when $n\ll d$, eigen of $XX^\top$ vs $X^\top X$.
9. Ridge: show solution filters singular components by $\sigma/(\sigma^2+\lambda)$.
10. Pseudoinverse: verify $AA^+A=A$ for thin full-rank cases.

### Challenge

11. Prove Eckart–Young for Frobenius norm using orthogonal invariance of $\|\cdot\|_F$.
12. Randomized range finder algorithm sketch + why oversampling helps.
13. PCA as maximum variance: Lagrange multiplier derivation for first PC.
14. Robust PCA awareness: sparse + low-rank decomposition goal.
15. Systems: compress a $1000\times 800$ image matrix by keeping 5% energy; estimate storage.

## Summary

SVD factors every matrix into orthogonal geometry plus nonnegative scales. Truncation is optimal low-rank approximation; PCA is SVD on centered data; pseudoinverses and ridge filters live naturally in the singular basis. For data and scientific computing, SVD is often the first decomposition to reach for.
