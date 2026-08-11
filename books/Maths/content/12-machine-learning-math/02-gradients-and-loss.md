# Gradients, Loss Functions, and Backprop Sketch

Training is almost always: pick a **loss**, form **empirical risk**, descend on **gradients**. This chapter is the calculus you need to read training loops without treating them as magic.

## Diagram: risk minimization

```text
  data (x,y) ──► model f_w(x) ──► loss ℓ(y, ŷ)
                      ▲                │
                      │   ∇_w J        v
                      └──────── J(w) = avg ℓ + reg
```

## 1. Loss menu

| Loss | Formula (scalar) | Typical use | Notes |
|------|------------------|-------------|--------|
| Squared | $(y-\hat y)^2$ | regression | outlier-sensitive |
| Absolute | $|y-\hat y|$ | robust regression | subgradient at $0$ |
| Huber | piecewise quad/lin | robust + smooth | threshold $\delta$ |
| Logistic / log | $-y\log\hat y-(1-y)\log(1-\hat y)$ | binary clf | $\hat y\in(0,1)$ |
| Cross-entropy | $-\log p_c$ | multi-class | with softmax $p$ |
| Hinge | $\max(0,1-y\hat y)$ | SVM-style | margin; $y\in\{\pm1\}$ |
| Cosine | $1-\cos(y,\hat y)$ | embeddings | direction focus |

**Multi-class CE:** model outputs probabilities $p_k$, true class $c$:

$$
\ell=-\log p_c.
$$

### Worked example 1 — CE numerical

$p=(0.1,0.7,0.2)$, true class $c=2$ (0-index class 1): $\ell=-\log 0.7\approx 0.357$ nats if $\ln$.

## 2. Empirical risk and regularization

Given data $(x_i,y_i)_{i=1}^n$:

$$
J(w)=\frac{1}{n}\sum_{i=1}^n \ell\bigl(y_i,f_w(x_i)\bigr)+\lambda\Omega(w).
$$

| $\Omega(w)$ | Effect |
|-------------|--------|
| $\|w\|_2^2$ | ridge / weight decay |
| $\|w\|_1$ | sparsity |
| elastic net | mix |

$\lambda$ trades fit vs complexity; choose on validation data.

### Population vs empirical

True risk $R(w)=\mathbb{E}[\ell(y,f_w(x))]$. ERM minimizes $J$ without the expectation. Generalization: $R(\hat w)$ vs $J$ without $\Omega$.

## 3. Gradients and directional derivatives

If $J$ is differentiable,

$$
\nabla J(w)\in\mathbb{R}^d,\qquad
\lim_{t\to 0}\frac{J(w+tv)-J(w)}{t}=\langle\nabla J(w),v\rangle.
$$

Steepest ascent direction is $\nabla J$; **descent** uses $-\nabla J$.

### Gradient descent

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
- **SGD / mini-batch:** replace $\nabla J$ by average over a batch — noisy but scalable  

### Worked example 2 — pure GD arithmetic

$J(w)=\frac12(w-3)^2$, $w_0=0$, $\eta=0.5$.  
$\nabla J=w-3$.  

$w_1=0-0.5(0-3)=1.5$,  
$w_2=1.5-0.5(1.5-3)=2.25$,  
$w_3=2.25-0.5(2.25-3)=2.625$ → approaches $3$.

## 4. Chain rule and backpropagation

If $z=h(w)$, $\hat y=g(z)$, $\ell=\ell(y,\hat y)$:

$$
\frac{\partial\ell}{\partial w}
=\frac{\partial\ell}{\partial\hat y}\cdot\frac{\partial\hat y}{\partial z}\cdot\frac{\partial z}{\partial w}.
$$

Neural nets stack many maps; **reverse-mode automatic differentiation** multiplies local Jacobians from the scalar loss backward while reusing forward activations — **backpropagation**.

```text
  forward:   x → layer1 → layer2 → … → ŷ → ℓ
  backward:  ∂ℓ/∂ŷ ← … ← ∂ℓ/∂w   (reuse forward values)
```

Complexity: for scalar loss, reverse mode costs a small constant factor over one forward pass — not “one forward per parameter.”

### Worked example 3 — scalar chain

$f(w)=(w^2+1)^3$.  

Expand: messy. Chain: $u=w^2+1$, $f=u^3$, $f'=3u^2\cdot 2w=6w(w^2+1)^2$.

## 5. Worked example — logistic regression end-to-end

Model: $f_w(x)=\sigma(w^\top x)$, $\sigma(t)=\frac{1}{1+e^{-t}}$, label $y\in\{0,1\}$.

$$
\ell=-(y\log\hat y+(1-y)\log(1-\hat y)).
$$

Using $\sigma'= \sigma(1-\sigma)$ and algebra:

$$
\nabla_w \ell = (\hat y-y)\,x.
$$

Average over a batch: same residual-times-features structure as least squares, with residual $\hat y-y$.

**Regularized:** $\nabla J = \frac1n\sum_i(\hat y_i-y_i)x_i + 2\lambda w$ (for $\Omega=\|w\|_2^2$ with conventional factor — match your code’s $\lambda$ scaling).

## 6. Softmax + cross-entropy

Logits $z\in\mathbb{R}^K$, $p=\mathrm{softmax}(z)$, one-hot $y$:

$$
\ell=-\sum_k y_k\log p_k=-\log p_{c}.
$$

$$
\frac{\partial\ell}{\partial z}=p-y.
$$

Stable implementation: `log_softmax` in the log domain, never `log(softmax(z))` with naive overflow.

## 7. Convex vs non-convex landscapes

| Setting | Landscape | Implication |
|---------|-----------|-------------|
| Ridge least squares | strongly convex quadratic | unique global min |
| Logistic + L2 | convex | local = global |
| Deep nets | non-convex | saddles, many minima; SGD often still works |
| ReLU nets | piecewise linear regions | gradients sparse |

Convexity guarantees are about $J(w)$ as a function of parameters — not about whether the data model is “correct.”

## 8. Subgradients (nonsmooth losses)

For $J(w)=|w|$, $\partial J(0)=[-1,1]$. **Subgradient descent** picks any $g\in\partial J(w)$. Hinge and ReLU need this language at kinks; in practice autodiff returns one element of the subdifferential (e.g. $0$ at ReLU kink).

## 9. Second-order glance

Hessian $H=\nabla^2 J$. Newton: $w\leftarrow w-H^{-1}\nabla J$. Expensive in high $d$; explains curvature: large eigenvalues ⇒ need smaller $\eta$ along those axes. Momentum / Adam partially compensate without forming $H$.

## 10. Numerical gradient checks

Central difference:

$$
\frac{\partial J}{\partial w_i}
\approx\frac{J(w+\varepsilon e_i)-J(w-\varepsilon e_i)}{2\varepsilon}.
$$

Relative error $\ll 10^{-5}$ (double, smooth $J$) builds trust in backprop. Failures are bugs, not mysticism.

## 11. Mini-batch tradeoffs

| Larger batch | Smaller batch |
|--------------|---------------|
| stabler gradient | more noise (sometimes useful) |
| better matrix hardware use | more updates per epoch |
| may need larger $\eta$ | generalization folklore varies |

## 12. Pitfalls

1. Squared loss on classification probabilities (wrong likelihood, poor calibration)  
2. Softmax without log-sum-exp stability  
3. Averaging loss wrong (sum vs mean) while reusing an $\eta$ tuned for the other  
4. Forgetting regularization term in the gradient  
5. Leaking test data into early stopping  

## 13. Checkpoint

- Pick a loss for regression vs classification  
- Write ERM + regularizer  
- Run a few GD steps by hand on a 1D quadratic  
- State the logistic gradient $(\hat y-y)x$  
- Explain backprop as reverse-mode AD on a scalar loss  
- Gradient-check a suspicious implementation  

## Exercises

### Easy

1. Compute $f'(x)$ for $f(x)=\log(1+e^{x})$ (softplus).  
2. For $J(w)=\frac12(w-3)^2$, run 3 steps of GD from $w_0=0$ with $\eta=0.5$.  
3. Why is cross-entropy preferred over squared loss for classification probabilities?  
4. One sentence: what does larger $\lambda$ do to optimal $\|w\|$?  
5. Mini-batch size: list two bullets on noise vs parallelism.  

### Medium

6. Sketch backprop for $f(w)=(w^2+1)^3$: expand vs chain.  
7. Derive $\nabla_w \frac12\|Xw-y\|_2^2=X^\top(Xw-y)$.  
8. Binary CE: show $\partial\ell/\partial\hat y = (\hat y-y)/(\hat y(1-\hat y))$ then chain through sigmoid.  
9. Hinge loss: write a subgradient w.r.t. $w$ for linear scores.  
10. Show that adding $\lambda\|w\|_2^2$ adds $2\lambda w$ to the gradient.  

### Challenge

11. Softmax+CE: prove $\partial\ell/\partial z=p-y$.  
12. Compare full-batch GD and SGD on a finite-sum quadratic (bias/variance of updates).  
13. Explain vanishing gradients for a product of many Jacobians with spectral norms $<1$.  
14. Design a finite-difference check protocol for a 2-layer MLP Jacobian.  
15. Map MAP inference with Gaussian prior to L2-regularized ERM.  

## Checks

2. $w_1=1.5$, $w_2=2.25$, $w_3=2.625$.  
3. Squared loss does not match Bernoulli log-likelihood; can be poorly calibrated.  
4. Larger $\lambda$ shrinks weights.  

## Summary

Losses encode task goals; gradients point downhill on empirical risk; backprop implements the chain rule efficiently for deep compositions. Logistic and softmax+CE give clean gradients that match classification likelihoods. Master the scalar chain rule, the residual-times-features pattern, and gradient checks — then optimizers and architectures become readable rather than magical.
