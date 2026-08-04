# Matrix Calculus for ML (Practical Identities)

You rarely expand every partial $\partial J/\partial W_{ij}$ by hand. A few **layout-consistent identities** cover least squares, logistic regression, and dense layers. This chapter uses **numerator layout** habits common in ML notes: gradients of a scalar match the shape of the parameter.

## Diagram: shapes

```text
  X ∈ R^{n×d}     data (rows = examples)
  w ∈ R^d         weights
  Xw ∈ R^n        predictions (linear)
  ∇_w J ∈ R^d     same shape as w
```

## 1. Layout discipline

- $J$ scalar ⇒ $\nabla_w J$ same shape as $w$  
- Always check dimensions: every term in an identity must match  
- For matrices, $\frac{\partial J}{\partial W}$ has the same shape as $W$  
- When reading papers, confirm layout (numerator vs denominator) — identities can transpose  

**Rule of thumb:** if shapes do not multiply cleanly, the formula is wrong or the layout differs.

## 2. Differentials (often easier than coordinates)

If $J$ is scalar and $u$ is a vector expression,

$$
dJ = \langle \nabla_u J,\, du\rangle.
$$

Push $d$ through linear maps, then read off the gradient.

### Worked example 1

$J=\frac12\|w\|_2^2$: $dJ=w^\top dw$ ⇒ $\nabla_w J=w$ (or $2w$ without $\frac12$).

## 3. Core identities (column vectors)

Let $a,b$ be vectors and $A$ a matrix of compatible size; $w$ the variable.

| Expression | Gradient w.r.t. marked variable |
|------------|----------------------------------|
| $w^\top a$ (const $a$) | $\nabla_w = a$ |
| $\|w\|_2^2$ | $\nabla_w = 2w$ |
| $\|Xw-y\|_2^2$ | $\nabla_w = 2X^\top(Xw-y)$ |
| $\frac12\|Xw-y\|_2^2$ | $\nabla_w = X^\top(Xw-y)$ |
| $a^\top W b$ | $\partial/\partial W = ab^\top$ |
| $\|W\|_F^2$ | $\partial/\partial W = 2W$ |
| $\mathrm{tr}(W^\top A)$ | $\partial/\partial W = A$ |

### Worked example 2 — ridge

$$
J(w)=\frac12\|Xw-y\|_2^2+\frac\lambda2\|w\|_2^2
\quad\Rightarrow\quad
\nabla J=X^\top(Xw-y)+\lambda w.
$$

Set to zero: $(X^\top X+\lambda I)w=X^\top y$.

### Worked example 3 — shapes

$X\in\mathbb{R}^{100\times 5}$, $w\in\mathbb{R}^5$, $y\in\mathbb{R}^{100}$:  
$Xw-y\in\mathbb{R}^{100}$, $X^\top(Xw-y)\in\mathbb{R}^5$. ✓

## 4. Least squares and normal equations

$J(w)=\|Xw-y\|_2^2$, $\nabla J=0$:

$$
X^\top X w=X^\top y.
$$

If $X^\top X$ ill-conditioned, ridge: $(X^\top X+\lambda I)w=X^\top y$. Prefer QR/SVD numerically when $\lambda=0$ and $\kappa$ large.

## 5. Linear layer + scalar loss

Single example, vector output $\hat y=Wx$ (absorb bias via augmented $x$ if needed), loss $\ell(\hat y)$:

$$
\frac{\partial\ell}{\partial W}
=\frac{\partial\ell}{\partial\hat y}\, x^\top
=\delta x^\top
\quad\text{(outer product)}.
$$

```text
  error signal δ = ∂ℓ/∂ŷ   (column, same dim as ŷ)
  input x                  (column)
  ∂ℓ/∂W = δ x^T            (matrix, same shape as W)
```

Mini-batch: sum/mean outer products over examples (or one matrix multiply).

### Worked example 4 — bias

$\hat y=Wx+b$, $\delta=\partial\ell/\partial\hat y$:  
$\partial\ell/\partial b=\delta$, $\partial\ell/\partial W=\delta x^\top$.

## 6. Softmax + cross-entropy (fact)

For one-hot $y$ and softmax probabilities $p$ from logits $z$:

$$
\frac{\partial\ell}{\partial z}=p-y.
$$

Why popular: the Jacobian of softmax and the CE gradient cancel into a simple residual. Implement as fused `cross_entropy_with_logits` for stability.

### Worked example 5

$p=(0.2,0.5,0.3)$, $y=(0,1,0)$: $\partial\ell/\partial z=(0.2,-0.5,0.3)$.

## 7. Logistic regression (vector form)

$\hat y=\sigma(Xw)$ elementwise, binary CE averaged:

$$
\nabla_w J = \frac1n X^\top(\hat y-y)
$$

(with $y,\hat y\in\mathbb{R}^n$). Same residual-times-design-matrix pattern.

## 8. Chain rule for products and Frobenius

Inner product on matrices: $\langle A,B\rangle_F=\mathrm{tr}(A^\top B)$.

If $Z=WX$, then for scalar $J(Z)$,

$$
\frac{\partial J}{\partial W}=\frac{\partial J}{\partial Z} X^\top,\qquad
\frac{\partial J}{\partial X}=W^\top\frac{\partial J}{\partial Z}.
$$

These two lines power dense backprop.

## 9. Elementwise nonlinearities

$H=\sigma(Z)$ elementwise, $\delta_H=\partial J/\partial H$:

$$
\frac{\partial J}{\partial Z}=\delta_H\odot\sigma'(Z)
$$

(Hadamard product). Then backprop into $W,x$ as linear layer with that $\delta_Z$.

## 10. Finite-difference checks

$$
\frac{\partial J}{\partial w_i}
\approx\frac{J(w+\varepsilon e_i)-J(w-\varepsilon e_i)}{2\varepsilon}.
$$

For matrices, perturb single entries. Relative error should be tiny for smooth $J$ in double precision. Mismatch ⇒ bug in analytic backprop, not “deep learning mystery.”

### Worked example 6 — protocol

1. Fix small random $W$  
2. Compute analytic $\partial J/\partial W$  
3. Check 5–10 random coordinates by finite differences  
4. Use $\varepsilon\sim 10^{-5}$–$10^{-6}$ as a starting point  

## 11. Hessian-vector products (awareness)

Second derivatives: $Hv=\nabla(\langle\nabla J,v\rangle)$ can be obtained by differentiating the gradient JVPs — used in second-order optimization and some training analyses without forming full $H$.

### Worked example 7

For $J=\frac12(a^\top w)^2$, $\nabla J=(a^\top w)a$, Hessian $H=aa^\top$. Rank-one curvature in direction $a$.

## 12. Common ML gradients cheat-sheet

| Model piece | Gradient |
|-------------|----------|
| Linear reg. | $X^\top(Xw-y)$ |
| Ridge | $+ \lambda w$ |
| Logistic | $X^\top(\sigma(Xw)-y)/n$ |
| Dense layer | $\delta x^\top$ |
| Softmax+CE | $p-y$ on logits |
| L2 weight decay | add $\lambda W$ to $\partial J/\partial W$ |

## 13. Pitfalls

1. Shape errors from mixing row/column conventions  
2. Forgetting the $1/n$ mean vs sum  
3. `log(softmax)` overflow instead of `log_softmax`  
4. Double-counting $\frac12$ factors in squared norms  
5. Broadcasting bugs in batched outer products  

## 14. Checkpoint

- State $\nabla_w\frac12\|Xw-y\|^2$  
- Write outer-product rule for $W$  
- Softmax+CE logit gradient  
- Chain through elementwise $\sigma$  
- Finite-difference check a gradient  

## Exercises

### Easy

1. Derive $\nabla_w \|w-w_0\|_2^2$.  
2. For $J(w)=\frac12\|Xw-y\|_2^2+\frac\lambda2\|w\|_2^2$, write $\nabla J$.  
3. Shapes: $X\in\mathbb{R}^{100\times 5}$, $w\in\mathbb{R}^5$ — shape of $X^\top(Xw-y)$?  
4. Explain in words why outer product $\delta x^\top$ updates $W$.  
5. Gradient of $\frac\lambda2\|W\|_F^2$ w.r.t. $W$.  

### Medium

6. Derive $\nabla_w$ of logistic NLL in matrix form.  
7. Show $d(\|Xw-y\|_2^2)=2(Xw-y)^\top X\,dw$.  
8. For $Z=WA$, prove $\partial J/\partial W=(\partial J/\partial Z)A^\top$.  
9. Batch of $n$ examples stored as rows of $X$: write $\partial J/\partial W$ using matrix multiplies only.  
10. Softmax Jacobian: show diagonal $p_i(1-p_i)$ and off-diagonal $-p_i p_j$, then recover $p-y$ for CE.  

### Challenge

11. Show for scalar $a^\top w$, Hessian of $\frac12(a^\top w)^2$ is $aa^\top$.  
12. Derive gradient of multi-class CE through a linear layer $z=Wx$ (batch form).  
13. Frobenius inner product: prove $\langle UV,W\rangle_F=\langle V,U^\top W\rangle_F$.  
14. Implement (pseudocode) a finite-difference gradient check for a 2-layer MLP.  
15. Explain why reverse-mode AD costs $O(1)$ forward-equivalents for scalar $J$ regardless of parameter count (high-level argument).  

## Checks

2. $X^\top(Xw-y)+\lambda w$.  
3. $\mathbb{R}^5$.  

## Summary

Matrix calculus for ML is shape-disciplined chain rules: linear maps push gradients through multiplies and transposes; nonlinearities contribute Hadamard factors; softmax+CE collapses to $p-y$. Learn a short identity table, verify with finite differences, and never invent a formula that fails a dimension check.
