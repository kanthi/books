# Matrix Calculus for ML (Practical Identities)

You rarely expand every partial $\partial J/\partial W_{ij}$ by hand. A few **layout-consistent identities** cover least squares, logistic regression, and dense layers.

## Diagram: shapes

```text
  X ∈ R^{n×d}     data (rows = examples)
  w ∈ R^d         weights
  Xw ∈ R^n        predictions (linear)
  ∇_w J ∈ R^d     same shape as w
```

## 1. Scalar, vector, matrix gradients

- $J$ scalar ⇒ $\nabla_w J$ same shape as $w$
- Always check dimensions: every term in an identity must match

## 2. Core identities (column vectors)

Let $a,b$ vectors, $A$ matrix of compatible size.

| Expression | Gradient / differential |
|------------|-------------------------|
| $w^\top a$ | $\nabla_w = a$ |
| $\|w\|_2^2$ | $\nabla_w = 2w$ |
| $\|Xw-y\|_2^2$ | $\nabla_w = 2X^\top(Xw-y)$ |
| $a^\top W b$ | $\partial/\partial W = ab^\top$ (outer product) |

## 3. Least squares normal equations

$J(w)=\|Xw-y\|_2^2$  
set $\nabla J=0$: $X^\top X w=X^\top y$.  
If $X^\top X$ ill-conditioned, use ridge: $(X^\top X+\lambda I)w=X^\top y$.

## 4. Linear layer + scalar loss

$\hat y=Wx$ (single example, vector out), then $\ell(\hat y)$.  
$\frac{\partial\ell}{\partial W}=\frac{\partial\ell}{\partial\hat y}\,x^\top$ (outer product).

```text
  error signal δ = ∂ℓ/∂ŷ   (column)
  input x                  (column)
  ∂ℓ/∂W = δ x^T            (matrix)
```

## 5. Softmax + cross-entropy (fact)

For one-hot $y$ and softmax probabilities $p$,

$$
\frac{\partial\ell}{\partial z}=p-y
$$

(logits $z$). This simplification is why the combo is popular.

## 6. Finite-difference check

Numerically verify analytic gradients:

$$
\frac{\partial J}{\partial w_i}\approx\frac{J(w+\varepsilon e_i)-J(w-\varepsilon e_i)}{2\varepsilon}.
$$

If mismatch, your backprop has a bug — not “deep learning mystery.”

## Exercises

1. Derive $\nabla_w \|w-w_0\|_2^2$.  
2. For $J(w)=\frac12\|Xw-y\|_2^2+\frac\lambda2\|w\|_2^2$, write $\nabla J$.  
3. Shapes: $X\in\mathbb{R}^{100\times 5}$, $w\in\mathbb{R}^5$ — shape of $X^\top(Xw-y)$?  
4. Explain in words why outer product $\delta x^\top$ updates $W$.  
5. **Challenge:** Show for scalar $a^\top w$, Hessian of $\frac12(a^\top w)^2$ is $aa^\top$.

## Checks

2. $X^\top(Xw-y)+\lambda w$.  
3. $\mathbb{R}^5$.
