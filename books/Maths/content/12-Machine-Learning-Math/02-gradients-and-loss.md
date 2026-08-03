# Gradients, Loss Functions, and Backprop Sketch

Training is almost always: pick a **loss**, form **empirical risk**, descend on **gradients**. This chapter is the calculus you need to read training loops without treating them as magic.

## Diagram: risk minimization

```text
  data (x,y) ──► model f_w(x) ──► loss ℓ(y, ŷ)
                      ▲                │
                      │   ∇_w J        v
                      └──────── J(w) = avg ℓ + reg
```

## 1. Loss menu (intuition)

| Loss | Typical use | Notes |
|------|-------------|--------|
| Squared $(y-\hat y)^2$ | regression | sensitive to outliers |
| Absolute $|y-\hat y|$ | robust regression | less smooth at 0 |
| Logistic / log loss | binary classification | probabilistic |
| Cross-entropy | multi-class softmax | same family as logistic |
| Hinge | SVM-style | margin |

**Cross-entropy (multi-class):** if model outputs probabilities $p_k$ and true class is $c$,

$$
\ell=-\log p_c.
$$

## 2. Empirical risk and regularization

$$
J(w)=\frac{1}{n}\sum_{i=1}^n \ell(y_i,f_w(x_i))+\lambda\Omega(w).
$$

Common $\Omega$: $\|w\|_2^2$ (ridge), $\|w\|_1$ (sparsity).

## 3. Gradient descent

$$
w \leftarrow w-\eta\nabla J(w).
$$

```text
  J(w)
    \
     \      ● start
      \    /
       \  ●
        \/●  ──► near minimum
```

- $\eta$ too large: diverge / oscillate  
- $\eta$ too small: crawl  
- **SGD:** use mini-batch gradient (noisy but scalable)

## 4. Chain rule (backprop skeleton)

If $z=h(w)$, $\hat y=g(z)$, $\ell=\ell(y,\hat y)$:

$$
\frac{\partial\ell}{\partial w}=\frac{\partial\ell}{\partial\hat y}\cdot\frac{\partial\hat y}{\partial z}\cdot\frac{\partial z}{\partial w}.
$$

Neural nets stack many $g\circ h$; reverse-mode AD multiplies local Jacobians from the loss backward — **backpropagation**.

```text
  forward:   x → layer1 → layer2 → … → ŷ → ℓ
  backward:  ∂ℓ/∂ŷ ← … ← ∂ℓ/∂w   (reuse forward values)
```

## 5. Worked example — logistic regression

$f_w(x)=\sigma(w^\top x)$, $\sigma(t)=1/(1+e^{-t})$,  
$\ell=-(y\log\hat y+(1-y)\log(1-\hat y))$.

Gradient (average over data): proportional to $( \hat y-y)\,x$ — same structural form as least squares residual times features.

## 6. Convex vs non-convex (why it matters)

- **Convex** $J$: local min = global min (logistic, ridge least squares).
- **Deep nets:** non-convex; many saddles; SGD + overparametrization often still works — but theory is subtler.

## Exercises

1. Compute $f'(x)$ for $f(x)=\log(1+e^{x})$ (softplus).  
2. For $J(w)=\frac12(w-3)^2$, run 3 steps of GD from $w_0=0$ with $\eta=0.5$.  
3. Why is cross-entropy preferred over squared loss for classification probabilities?  
4. Explain one sentence: what does $\lambda$ do to the optimal $\|w\|$?  
5. **Sketch** backprop for $f(w)= (w^2+1)^3$: write $\partial f/\partial w$ two ways (expand vs chain).  
6. Mini-batch size tradeoff: noise vs compute parallelism — list two bullets.

## Checks

2. $w_1=0-0.5(0-3)=1.5$, $w_2=1.5-0.5(1.5-3)=2.25$, $w_3=2.25-0.5(2.25-3)=2.625$.  
3. Squared loss doesn’t match Bernoulli log-likelihood; can be poorly calibrated.  
4. Larger $\lambda$ shrinks weights.
