# Determinants, Inverses, and Volume

The **determinant** $\det A$ is a scalar measuring oriented volume scaling under the linear map $A$. It decides invertibility and appears in change-of-variables and geometry.

## Diagram: area scaling

```text
  unit square              after A (2D)

  ┌───┐                    ╱╲
  │   │   ──A──►          ╱  ╲
  └───┘                  ╱____╲
  area 1                 area |det A|
```

## 1. Invertibility

For square $A\in\mathbb{R}^{n\times n}$, TFAE:

- $A$ invertible
- $\det A\neq 0$
- columns (rows) form a basis of $\mathbb{R}^n$
- $0$ not an eigenvalue
- full rank $n$

Inverse formula (when invertible): $A^{-1}A=I=AA^{-1}$.

## 2. Computing small determinants

$2\times 2$:

$$
\det\begin{bmatrix}a&b\\c&d\end{bmatrix}=ad-bc.
$$

$3\times 3$: cofactor expansion (or row-reduction product of pivots with sign).

**Row operations and det:**

| Operation | Effect on det |
|-----------|----------------|
| Swap rows | multiply by $-1$ |
| Scale row by $k$ | multiply by $k$ |
| Add multiple of one row to another | unchanged |

Product: $\det(AB)=\det(A)\det(B)$.  
$\det(A^T)=\det(A)$, $\det(A^{-1})=1/\det(A)$.

## 3. Geometric meaning

- $|\det A|=$ volume of parallelepiped spanned by columns
- $\det A<0$: orientation reversing (reflection component)
- Orthogonal matrices: $\det=\pm 1$

## 4. Cramer’s rule (small systems)

For $Ax=b$ invertible, $x_i=\det(A_i)/\det(A)$ where $A_i$ replaces column $i$ by $b$.  
Good for theory/tiny $n$; use elimination for real systems.

## 5. Worked examples

**Ex 1.** $A=\begin{bmatrix}2&1\\0&3\end{bmatrix}$, $\det=6\neq 0$, inverse $\frac{1}{6}\begin{bmatrix}3&-1\\0&2\end{bmatrix}$.

**Ex 2.** Singular: $\begin{bmatrix}1&2\\2&4\end{bmatrix}$, det $0$, columns collinear.

## 6. CS connections

| Use | Role of det / inverse |
|-----|------------------------|
| Change of variables | Jacobian determinant |
| Covariance | $|\Sigma|$ in multivariate Gaussians |
| Graphics | orientation, volume, backface |
| Numerical | never form $A^{-1}$ explicitly if solving $Ax=b$ — use solvers |

## Exercises

1. Compute $\det\begin{bmatrix}1&2&0\\0&3&4\\0&0&5\end{bmatrix}$.
2. Show that if two columns are equal, $\det=0$.
3. If $\det A=2$ and $\det B=-3$, find $\det(A^2 B^{-1})$ (assume $B$ invertible).
4. Explain why solving $Ax=b$ via $x=A^{-1}b$ is usually a bad numerical plan.
5. For a shear matrix $\begin{bmatrix}1&k\\0&1\end{bmatrix}$, compute det and interpret area.
6. **Challenge:** Prove $\det(AB)=\det A\det B$ for $2\times 2$ by direct expansion.

## Checks

1. $15$.  
3. $2^2 / (-3) wait: \det(A^2 B^{-1})=4\cdot(-1/3)=-4/3$.  
5. det $=1$, area preserved.
