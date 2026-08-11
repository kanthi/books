# Orthogonality and Projections

Orthogonality is the geometry of right angles in inner product spaces. It yields stable bases (QR), optimal approximation (orthogonal projections), and the Pythagorean decompositions behind least squares.

## 1. Inner products and norms

On $\mathbb{R}^n$, standard inner product $\langle u,v\rangle=u^\top v$, norm $\|v\|_2=\sqrt{\langle v,v\rangle}$.

**Cauchy–Schwarz:** $|\langle u,v\rangle|\le\|u\|\|v\|$, equality iff linearly dependent.

**Angle:** $\cos\theta=\langle u,v\rangle/(\|u\|\|v\|)$ for nonzero vectors.

### Worked example 1

$u=(1,0)$, $v=(1,1)$: $\cos\theta=1/\sqrt{2}$, $\theta=\pi/4$.

## 2. Orthogonal sets and bases

Set $\{u_i\}$ **orthogonal** if $i\neq j\Rightarrow\langle u_i,u_j\rangle=0$; **orthonormal** if also $\|u_i\|=1$.

**Theorem.** Orthogonal nonzero vectors are linearly independent.

**Parseval / Pythagoras:** if $\{q_i\}$ orthonormal basis,

$$
\|x\|^2=\sum_i |\langle x,q_i\rangle|^2,\qquad x=\sum_i\langle x,q_i\rangle q_i.
$$

### Worked example 2

Fourier-like expansions in finite dimensions: coefficients are inner products.

## 3. Orthogonal projection onto a line

Projection of $x$ onto $\mathrm{span}\{u\}$ ($u\neq 0$):

$$
\mathrm{proj}_u x=\frac{\langle x,u\rangle}{\langle u,u\rangle}u.
$$

Error $x-\mathrm{proj}_u x\perp u$.

### Worked example 3

Project $(2,2)$ onto $\mathrm{span}\{(1,0)\}$: get $(2,0)$; residual $(0,2)$.

## 4. Projection onto a subspace

Let $U=\mathrm{range}(A)$ with $A\in\mathbb{R}^{n\times k}$ full column rank. Orthogonal projection:

$$
P=A(A^\top A)^{-1}A^\top,\qquad Px=\arg\min_{y\in U}\|x-y\|_2.
$$

Properties: $P^2=P=P^\top$; eigenvalues $0$ or $1$.

If columns of $Q$ orthonormal basis of $U$, then $P=QQ^\top$—numerically better.

### Worked example 4

Least squares $\min_b\|Ab-y\|$ is projection of $y$ onto $\mathrm{col}(A)$; normal equations $A^\top A\hat b=A^\top y$.

### Worked example 5 — residual orthogonality

$A^\top(y-A\hat b)=0$: residual $\perp$ column space—normal equations geometry.

## 5. Gram–Schmidt and QR

**Classical Gram–Schmidt** orthogonalizes columns of $A$ to produce $A=QR$ with $Q$ orthonormal columns, $R$ upper triangular.

**Modified Gram–Schmidt** and **Householder QR** are more stable in FP arithmetic.

### Worked example 6

QR solve for least squares: $A=QR\Rightarrow R\hat b=Q^\top y$ (thin QR)—avoids squaring $\kappa$ via $A^\top A$.

### Worked example 7 — Householder idea

Reflectors $I-2vv^\top/\|v\|^2$ zero out entries below pivots—stable orthogonal transforms.

## 6. Orthogonal matrices

$Q$ square with $Q^\top Q=I$ (so $Q^{-1}=Q^\top$). Preserves norms and angles: $\|Qx\|=\|x\|$.

Products of reflections/rotations. Condition number $\kappa_2(Q)=1$—perfectly conditioned linear maps.

### Worked example 8

Rotations in graphics: orthogonal (or unitary) transforms avoid distorting lengths.

## 7. Orthogonal complements

$U^\perp=\{v:\langle v,u\rangle=0\ \forall u\in U\}$. $\mathbb{R}^n=U\oplus U^\perp$ for subspaces.  
$(U^\perp)^\perp=U$. For $A$, $\ker(A)=(\mathrm{row}(A))^\perp$, $\ker(A^\top)=(\mathrm{col}(A))^\perp$.

### Worked example 9 — fundamental theorem of linear algebra

Four fundamental subspaces linked by orthogonality—Strang’s diagram.

## 8. Projections in ML/CS

| Use | Geometry |
|-----|----------|
| PCA reconstruction | project onto top principal subspace |
| Residual connections (loose analogy) | skip paths vs learned maps |
| OLS / GLM linear predictors | column space projection |
| Nearest subspace classifiers | distance to class subspaces |
| Kalman updates | sequential orthogonalization ideas |

### Worked example 10 — centering

Subtracting the mean is projection orthogonal to the all-ones vector in sample space—prep for covariance.

### Worked example 11 — dual view

Ridge can be seen as shrinking coordinates in singular vector basis—orthogonal decomposition of feature space.

## 9. Non-orthogonal projections (warning)

Oblique projections ($P^2=P$ but $P\neq P^\top$) appear in some domain decompositions; they do **not** solve unconstrained least squares. Stick to orthogonal projections for $\|{\cdot}\|_2$ optimality.

## 10. Pitfalls

1. Classical GS loss of orthogonality in FP for nearly dependent columns  
2. Using $A(A^\top A)^{-1}A^\top$ when $A$ ill-conditioned—prefer QR/SVD  
3. Forgetting to orthonormalize before $P=QQ^\top$  
4. Confusing algebraic projection matrices with statistical “projection pursuit”  
5. Applying Euclidean orthogonality after arbitrary feature scaling without care  

## 11. Checkpoint

- Project onto lines and subspaces  
- State $P=QQ^\top$ for orthonormal bases  
- Connect least squares to residual orthogonality  
- Explain QR advantage over normal equations  
- Use orthogonal complements for kernels/row spaces  

## Exercises

### Easy

1. Prove Cauchy–Schwarz from $\|\ u-tv\|^2\ge 0$ optimized in $t$.
2. Project $(1,2,3)$ onto span of $(1,1,1)/$normalized.
3. Show $P=qq^\top$ for unit $q$ is a projection.
4. Verify $Q$ rotation by $90^\circ$ is orthogonal.
5. Why is $\kappa_2(Q)=1$?

### Medium

6. Derive normal equations from residual $\perp\mathrm{col}(A)$.
7. Prove orthogonal nonzero vectors are independent.
8. Gram–Schmidt two columns by hand.
9. Show $I-P$ projects onto $U^\perp$ when $P$ orthoproj onto $U$.
10. Prove $\|Px\|\le\|x\|$ for orthogonal projections.

### Challenge

11. Modified vs classical GS: explain reorthogonalization need.
12. Householder QR: write algorithm to zero a column below diagonal.
13. Prove four fundamental subspaces orthogonality relations.
14. Conditioning: compare $\kappa(A^\top A)$ vs $\kappa(A)$ for thin $A$.
15. Implement (pseudocode) least squares via thin QR; count FLOPs vs normal eq.

## Summary

Orthogonality gives independent directions, optimal subspace approximations, and norm-preserving transforms. Projections and QR are the computational geometry of least squares and of every method that says “best approximation in a subspace.”
