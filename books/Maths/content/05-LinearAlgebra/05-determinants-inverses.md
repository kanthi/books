# Determinants, Inverses, and Volume

The **determinant** $\det A$ is a scalar measuring oriented volume scaling under the linear map $A$. It decides invertibility and appears in change-of-variables formulas, multivariate Gaussians, and geometric algorithms.

## Diagram: area scaling

```text
  unit square              after A (2D)

  ┌───┐                    ╱╲
  │   │   ──A──►          ╱  ╲
  └───┘                  ╱____╲
  area 1                 area |det A|
```

## 1. Invertibility criteria

For square $A\in\mathbb{R}^{n\times n}$, the following are equivalent (**TFAE**):

1. $A$ is invertible (exists $B$ with $AB=BA=I$)  
2. $\det A\neq 0$  
3. Columns form a basis of $\mathbb{R}^n$ (linearly independent)  
4. Rows form a basis of $\mathbb{R}^n$  
5. $\mathrm{rank}(A)=n$  
6. $\ker(A)=\{0\}$  
7. $0$ is not an eigenvalue of $A$  
8. $Ax=b$ has a unique solution for every $b$  

**Inverse:** $A^{-1}A=I=AA^{-1}$ when invertible.

### Worked example 1 — $2\times 2$ inverse

$A=\begin{bmatrix}2&1\\0&3\end{bmatrix}$, $\det A=6\neq 0$.

$$
A^{-1}=\frac{1}{6}\begin{bmatrix}3&-1\\0&2\end{bmatrix}
=\begin{bmatrix}1/2&-1/6\\0&1/3\end{bmatrix}.
$$

Verify $AA^{-1}=I$.

### Worked example 2 — singular

$A=\begin{bmatrix}1&2\\2&4\end{bmatrix}$, $\det=0$, columns collinear, $\ker$ spanned by $(2,-1)$, not invertible.

## 2. Computing determinants

### $2\times 2$

$$
\det\begin{bmatrix}a&b\\c&d\end{bmatrix}=ad-bc.
$$

### $3\times 3$ (cofactor expansion along row 1)

$$
\det\begin{bmatrix}a&b&c\\d&e&f\\g&h&i\end{bmatrix}
=a(ei-fh)-b(di-fg)+c(dh-eg).
$$

### Via row reduction

Row-reduce $A$ to upper triangular $U$ with pivots $u_{11},\ldots,u_{nn}$:

$$
\det A = (-1)^s \Bigl(\prod_i u_{ii}\Bigr) \Big/ \text{(scale factors)},
$$

more carefully tracking:

| Row operation | Effect on det |
|---------------|----------------|
| Swap two rows | multiply by $-1$ |
| Scale a row by $k$ | multiply by $k$ |
| Add multiple of one row to another | **unchanged** |

Product of pivots (with sign from swaps) gives $\det$ if you only used swaps and shears (no row scaling), or adjust for scalings.

### Multiplicativity and friends

$$
\det(AB)=\det(A)\det(B),\qquad
\det(A^\top)=\det(A),\qquad
\det(A^{-1})=\frac{1}{\det A}\ (A\text{ invertible}),
$$

$$
\det(cA)=c^n\det A,\qquad
\det(A^{-1}BA)=\det B
$$

(similarity preserves det — eigenvalues product invariant).

### Worked example 3 — triangular

$$
\det\begin{bmatrix}1&2&0\\0&3&4\\0&0&5\end{bmatrix}=1\cdot 3\cdot 5=15.
$$

### Worked example 4 — product

If $\det A=2$, $\det B=-3$, then

$$
\det(A^2 B^{-1})=\det(A)^2\det(B)^{-1}=4\cdot\Bigl(-\frac13\Bigr)=-\frac43.
$$

## 3. Geometric meaning

- $|\det A|=$ volume of the parallelepiped spanned by the columns of $A$  
- $\det A>0$: orientation-preserving; $\det A<0$: orientation-reversing (includes a reflection component)  
- $\det A=0$: columns collapse volume to a lower-dimensional flat  
- Orthogonal matrices: $Q^\top Q=I$ ⇒ $\det Q=\pm 1$ (rotations vs improper rotations)  

### Worked example 5 — shear preserves area

$S=\begin{bmatrix}1&k\\0&1\end{bmatrix}$, $\det S=1$. Shears preserve area; shape changes.

### Worked example 6 — scaling

$D=\mathrm{diag}(\lambda_1,\ldots,\lambda_n)$, $\det D=\prod\lambda_i$ — product of axis scale factors.

## 4. Determinant and eigenvalues

Characteristic polynomial $p_A(\lambda)=\det(A-\lambda I)$ (sign convention variants exist).  

$$
\det A = \prod_{i=1}^n \lambda_i
$$

(over $\mathbb{C}$, counting algebraic multiplicity). Trace $\mathrm{tr}(A)=\sum\lambda_i$.

So $\det A\neq 0$ iff no zero eigenvalue — matches invertibility.

## 5. Cramer’s rule (theory / tiny $n$)

For invertible $Ax=b$,

$$
x_i=\frac{\det(A_i)}{\det A},
$$

where $A_i$ is $A$ with column $i$ replaced by $b$.

**Practice:** use elimination / library solvers for $n\gtrsim 3$. Cramer is exponential cost if determinants are expanded naively and numerically unstable if implemented poorly.

## 6. Explicit inverse formulas

### $2\times 2$

$$
\begin{bmatrix}a&b\\c&d\end{bmatrix}^{-1}
=\frac{1}{ad-bc}\begin{bmatrix}d&-b\\-c&a\end{bmatrix}.
$$

### Adjugate (general $n$)

$A^{-1}=\frac{1}{\det A}\mathrm{adj}(A)$ where $\mathrm{adj}$ is the cofactor matrix transpose. Useful in proofs; rarely the right computational tool.

## 7. Jacobians and change of variables

If $T:\mathbb{R}^n\to\mathbb{R}^n$ is differentiable and $y=T(x)$, volumes transform by $|\det DT(x)|$:

$$
\int_{T(U)} f(y)\,dy = \int_U f(T(x))\,|\det DT(x)|\,dx.
$$

In probability: if $Y=g(X)$ invertible, densities pick up $|\det Dg^{-1}|$.

### Worked example 7 — polar (idea)

$x=r\cos\theta$, $y=r\sin\theta$, Jacobian determinant magnitude is $r$ — area element $r\,dr\,d\theta$.

## 8. Multivariate Gaussians

For $X\sim\mathcal{N}(\mu,\Sigma)$ with $\Sigma\succ 0$,

$$
p(x)=(2\pi)^{-n/2}(\det\Sigma)^{-1/2}
\exp\Bigl(-\tfrac12(x-\mu)^\top\Sigma^{-1}(x-\mu)\Bigr).
$$

$\det\Sigma$ scales the normalizing constant; ill-conditioned $\Sigma$ (tiny eigenvalues) makes density peaks sharp and numerics fragile.

## 9. Numerical wisdom

1. **Do not** compute $x=A^{-1}b$ by forming $A^{-1}$ explicitly when you only need $x$ — solve $Ax=b$  
2. Determinants of large matrices can overflow/underflow; work in log-domain ($\sum\log|\mathrm{pivots}|$)  
3. Near-singular matrices: $\det\approx 0$ is a symptom; prefer condition number $\kappa(A)$ and residual checks  
4. Integer matrices can have huge dets (Hadamard bound); exact arithmetic may need big integers  

## 10. CS / graphics / systems connections

| Domain | Role of det / inverse |
|--------|------------------------|
| Computer graphics | orientation tests, back-face, volume of tetrahedra |
| Robotics / vision | homogeneous transforms; watch $\det$ of rotation blocks $=1$ |
| Optimization | Newton steps solve linear systems, not inverses as matrices |
| Random matrices | volume of zonotopes; covariance geometry |
| Finite elements | Jacobian of reference maps |

## 11. Pitfalls

1. $\det(A+B)\neq\det A+\det B$  
2. $\det(cA)=c^n\det A$, not $c\det A$  
3. Using Cramer for large systems  
4. Interpreting $\det\approx 0$ without scaling context (scale rows by $10^{10}$ inflates det)  
5. Forming inverses “because the formula has $A^{-1}$”  

## 12. Checkpoint

- Compute $2\times 2$ and triangular determinants  
- Use row-operation rules  
- Apply $\det(AB)=\det A\det B$  
- Interpret $|\det|$ as volume scaling  
- Explain why solvers beat explicit inverses  

## Exercises

### Easy

1. Compute $\det\begin{bmatrix}1&2&0\\0&3&4\\0&0&5\end{bmatrix}$.  
2. Show that if two columns are equal, $\det=0$.  
3. If $\det A=2$ and $\det B=-3$, find $\det(A^2 B^{-1})$ ($B$ invertible).  
4. For shear $\begin{bmatrix}1&k\\0&1\end{bmatrix}$, compute det and interpret area.  
5. Invert $\begin{bmatrix}1&2\\3&4\end{bmatrix}$ if possible.  

### Medium

6. Explain why solving $Ax=b$ via $x=A^{-1}b$ is usually a bad numerical plan.  
7. Prove $\det(A^\top)=\det A$ for $2\times 2$ by expansion.  
8. Using only row ops, compute $\det\begin{bmatrix}0&1&2\\3&4&5\\6&7&8\end{bmatrix}$.  
9. If $Q$ orthogonal, show $|\det Q|=1$.  
10. Relate $\det A$ to the product of eigenvalues for a diagonalizable $A$.  

### Challenge

11. Prove $\det(AB)=\det A\det B$ for $2\times 2$ by direct expansion.  
12. Show $\det(e^B)=e^{\mathrm{tr}(B)}$ for square $B$ (use eigenvalues or series intuition).  
13. Hadamard inequality: $|\det A|\le\prod_j \|a_j\|_2$ for columns $a_j$ — interpret geometrically.  
14. Cramer’s rule derivation from $A\,\mathrm{adj}(A)=(\det A)I$.  
15. Floating point: construct a matrix with huge condition number but moderate entries; compare $\det$ vs reliable rank-revealing QR.  

## Checks

1. $15$.  
3. $4\cdot(-1/3)=-4/3$.  
4. det $=1$, area preserved.  
5. $\det=-2$, inverse $-\frac12\begin{bmatrix}4&-2\\-3&1\end{bmatrix}$.  

## Summary

Determinants package volume, orientation, and invertibility into one scalar. Compute them via small expansions, pivots, or library routines; reason with multiplicativity and eigenvalue products. Inverses exist exactly when $\det\neq 0$, but the mature computational habit is: **solve systems, factor matrices, monitor conditioning** — not chase giant explicit inverses. Geometry (shears, orthogonal maps) and applications (Jacobians, Gaussians) keep the scalar meaningful beyond algebra drills.
