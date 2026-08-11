# Least Squares and Conditioning

Least squares is the default linear fitting tool; conditioning explains when solutions are trustworthy in finite precision. Together they connect geometry (projections), algebra (normal equations / QR / SVD), and numerics (error amplification).

## 1. Linear least squares problem

Given $A\in\mathbb{R}^{m\times n}$, $b\in\mathbb{R}^m$, $m\ge n$ typically:

$$
\min_{x\in\mathbb{R}^n} \|Ax-b\|_2.
$$

If $A$ full column rank, unique solution

$$
\hat x=(A^\top A)^{-1}A^\top b.
$$

Geometry: $A\hat x=P_{\mathrm{col}(A)}b$.

### Worked example 1 — line fit

$A$ columns $[1,x_i]$, $b=y_i$: slope/intercept regression.

### Worked example 2 — overdetermined system

No exact solution if $b\notin\mathrm{col}(A)$; LS finds best compromise in $\ell_2$.

## 2. Normal equations

$A^\top A\hat x=A^\top b$. Derive by setting $\nabla_x\frac12\|Ax-b\|^2=A^\top(Ax-b)=0$.

**Pros:** simple, $n\times n$ system.  
**Cons:** $\kappa(A^\top A)=\kappa(A)^2$—squares condition number; forms Gram matrix with possible cancellation.

### Worked example 3

If $\kappa(A)=10^8$, $\kappa(A^\top A)=10^{16}$—double precision collapses. Prefer QR/SVD.

## 3. QR method

Thin QR $A=QR$ ($Q\in\mathbb{R}^{m\times n}$ orthonormal columns, $R$ upper triangular invertible if full rank):

$$
R\hat x=Q^\top b.
$$

Backward stable in practice with Householder QR.

### Worked example 4

Same solution as normal equations in exact arithmetic; better residual/forward accuracy in FP when $A$ moderately ill-conditioned.

## 4. SVD method

$A=U\Sigma V^\top$, $\hat x=V\Sigma^+ U^\top b$ (pseudoinverse). Handles rank deficiency via truncated or regularized inverses of $\sigma_i$.

### Worked example 5 — rank-deficient

If $\sigma_n=0$, infinite solutions to min $\|Ax-b\|$; min-norm via $\Sigma^+$.

## 5. Weighted and generalized LS

$\min\|W^{1/2}(Ax-b)\|$ for heteroscedastic noise. Generalized SVD / whitening when noise covariance known.

### Worked example 6

GLS: if $\mathrm{Cov}(\varepsilon)=\Sigma$, transform by $\Sigma^{-1/2}$ then OLS—BLUE under Gauss–Markov extensions.

## 6. Ridge regression as conditioning fix

$$
\min_x \|Ax-b\|_2^2+\lambda\|x\|_2^2,\quad\lambda>0.
$$

Solution $(A^\top A+\lambda I)^{-1}A^\top b$. In SVD basis, component along $v_i$ multiplied by $\sigma_i/(\sigma_i^2+\lambda)$.

### Worked example 7

Small $\sigma_i$ directions damped—stabilizes inversion and reduces variance.

### Worked example 8 — leverage

Hat matrix $H=A(A^\top A)^{-1}A^\top$; diagonal $H_{ii}$ leverage of point $i$. High leverage points dominate fit—check influence.

## 7. Condition number and error bounds

For square invertible systems, $\kappa(A)=\|A\|\|A^{-1}\|$. Relative residual and relative forward error linked by $\kappa$.

For LS, effective sensitivity involves $\kappa(A)$ and how close $b$ is to $\mathrm{col}(A)$ (angle subtleties).

### Worked example 9 — Hilbert design

Polynomial regression with monomial basis: Vandermonde/Hilbert-like severe ill-conditioning—use orthogonal polynomials.

### Worked example 10 — collinearity

Nearly dependent columns: $\sigma_{\min}$ tiny; coefficients large and unstable. VIF diagnostics in statistics.

## 8. Iterative methods for large LS

- LSQR / LSMR on $Ax\approx b$  
- Normal eq CG on $A^\top A$ (careful conditioning)  
- Stochastic / sketching for enormous $m$  

### Worked example 11

$m=10^7$, $n=10^3$ sparse: iterative Krylov + good preconditioner beats dense QR.

## 9. Gauss–Markov theorem (stat view)

If $y=Ax+\varepsilon$, $\mathbb{E}\varepsilon=0$, $\mathrm{Cov}(\varepsilon)=\sigma^2 I$, $A$ full rank, then OLS is BLUE (best linear unbiased estimator). Heteroscedasticity/correlation $\Rightarrow$ GLS.

### Worked example 12 — misspecification

Nonlinear truth or omitted variables: LS still projects, but coefficients may not estimate “causal” parameters.

## 10. Pitfalls

1. Normal equations by default for ill-conditioned $A$  
2. Interpreting huge coefficients without checking $\kappa$  
3. Ignoring intercept / centering inconsistency  
4. Multiple collinear features + no regularization  
5. Extrapolation far from row space of training $A$  
6. Using $R^2$ alone without residual diagnostics  

## 11. Checkpoint

- State LS geometry and normal equations  
- Solve via QR and SVD conceptually  
- Explain why ridge stabilizes  
- Define $\kappa$ and risk of collinearity  
- Choose direct vs iterative at scale  

## Exercises

### Easy

1. Derive $\nabla\|Ax-b\|^2=0\Rightarrow$ normal equations.
2. For orthogonal columns of $A$, simplify $\hat x$.
3. Compute LS fit of points $(0,0),(1,1),(2,1)$ by a line through origin $y=\beta x$.
4. Why is $A^\top A$ SPD when $A$ full column rank?
5. Write ridge closed form.

### Medium

6. Prove residual $b-A\hat x\perp\mathrm{col}(A)$.
7. Show economy QR LS formula.
8. Express ridge solution in SVD basis (filter factors).
9. Relate leverage $H_{ii}$ to sensitivity of $\hat y_i$.
10. Compare FLOPs: form normal eq + Cholesky vs Householder QR for $m\gg n$.

### Challenge

11. Prove Gauss–Markov for simple case $n=1$.
12. Conditioning of Vandermonde: explain growth with degree.
13. Total least squares vs OLS when $A$ is noisy (idea).
14. Weighted LS as standard LS on transformed data.
15. Design numerical experiment: collinear features, compare OLS vs ridge coefficient variance.

## Summary

Least squares is orthogonal projection onto a model subspace; algorithms (normal eq, QR, SVD) differ in stability. Conditioning and collinearity decide whether coefficients mean anything in floating point. Regularization and better bases turn fragile fits into reliable estimators—core craft for data science and scientific computing.
