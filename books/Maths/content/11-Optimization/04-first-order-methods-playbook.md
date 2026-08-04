# First-Order Methods Playbook

Between the pure math of convexity and production training loops: a **playbook** of first-order algorithms, step sizes, projections, and diagnostics. Complements gradient-methods material with recipes you can apply to convex problems and deep learning alike.

## Diagram: algorithm family

```text
  gradient available?
       │
      yes
       │
       v
  full-batch GD ──► SGD / mini-batch ──► momentum / Adam
       │                  │
       └── projection / proximal for constraints & L1
```

## 1. Problem template

Minimize $f:\mathbb{R}^d\to\mathbb{R}$ (possibly $f=\hat R_n$ empirical risk). **First-order** methods use $\nabla f$ (or unbiased stochastic estimates), not Hessians.

Assumptions you will see in rates:

- **$L$-smooth:** $\|\nabla f(x)-\nabla f(y)\|\le L\|x-y\|$  
- **$\mu$-strongly convex:** $f(y)\ge f(x)+\langle\nabla f(x),y-x\rangle+\frac{\mu}{2}\|y-x\|^2$  
- **Convex** but not strongly: rates slow from linear to sublinear  

## 2. Gradient descent (GD)

$$
x_{k+1}=x_k-\eta\nabla f(x_k).
$$

### Step size rules

| Rule | When |
|------|------|
| Constant $\eta\in(0,2/L)$ | $L$-smooth; $\eta=1/L$ classic |
| Exact / backtracking line search | unknown $L$; Armijo condition |
| Diminishing $\eta_k$ | stochastic or non-smooth setups |
| Learning-rate schedules | ML: cosine, step decay, warmup |

### Worked example 1 — 1D quadratic

$f(x)=\frac12 L x^2$, $\nabla f=Lx$.  
$x_{k+1}=(1-\eta L)x_k$.  

- $0<\eta<2/L$: contracts to $0$  
- $\eta=1/L$: one step to optimum from any start  
- $\eta>2/L$: diverges / oscillates with growing amplitude  

### Complexity intuition (smooth convex)

To reach $f(x_k)-f^\star\le\varepsilon$, GD needs $\mathcal{O}(L\|x_0-x^\star\|^2/\varepsilon)$ iterations (order of magnitude). **Strongly convex + smooth:** linear rate $\mathcal{O}\bigl((1-\mu/L)^k\bigr)$ — condition number $\kappa=L/\mu$ controls speed.

## 3. Stochastic gradient descent (SGD)

$$
x_{k+1}=x_k-\eta_k g_k,\qquad \mathbb{E}[g_k\mid x_k]=\nabla f(x_k)
$$

(unbiased noisy gradient). Mini-batch: average $g$ over $B$ samples — variance scales $\sim 1/B$.

| Batch size | Pros | Cons |
|------------|------|------|
| $B=1$ | cheap updates, noise exploration | high variance, hardware underuse |
| Medium $B$ | parallelism, stable | tune $\eta$ with $B$ |
| Full batch | true gradient | costly; can stick in sharp regions |

### Worked example 2 — empirical risk

$f(w)=\frac1n\sum_i \ell_i(w)$, $g_k=\nabla\ell_{i_k}(w_k)$ for random $i_k$. Unbiased if uniform $i_k$.

### Schedules

- Constant $\eta$ small: approaches a noise ball  
- $\eta_k\sim 1/\sqrt{k}$ or $1/k$: classic convergent schedules  
- **Warmup then decay:** stabilizes early deep-net training  

## 4. Momentum and acceleration

### Heavy ball / classical momentum

$$
v_{k+1}=\beta v_k+\nabla f(x_k),\qquad x_{k+1}=x_k-\eta v_{k+1}
$$

(with $\beta\in[0,1)$, e.g. $0.9$). Velocity accumulates consistent gradient directions and damps zigzagging in narrow valleys.

```text
  zigzag GD:    /\/\/\/
  momentum:     ─────→  smoother
```

### Nesterov acceleration (convex smooth)

Evaluates gradient at a look-ahead point; achieves optimal $\mathcal{O}(1/k^2)$ rate among first-order methods for smooth convex problems (in the standard oracle model).

### Worked example 3 — valley

$f(x,y)=\frac12(x^2+100 y^2)$: GD zigzags in $y$; momentum carries progress along $x$.

## 5. Adaptive methods (Adam sketch)

Maintain exponential moving averages of gradient $m_k$ and squared gradient $v_k$; step

$$
x_{k+1}=x_k-\eta\,\frac{\hat m_k}{\sqrt{\hat v_k}+\varepsilon}
$$

(with bias correction). Per-coordinate scaling helps sparse/noisy gradients.

**Practice notes:**

- Default for many deep nets  
- On simple convex problems, carefully tuned SGD/momentum often matches or beats final training loss  
- **AdamW:** decouple weight decay from adaptive scaling  
- Watch for large $\eta$ + sharp minima late in training — decay $\eta$  

## 6. Constraints and nonsmooth regularizers

### Projected gradient

$$
x_{k+1}=\Pi_C\bigl(x_k-\eta\nabla f(x_k)\bigr),
$$

$\Pi_C$ Euclidean projection onto closed convex $C$ (simplex, box, PSD cone with care).

### Proximal gradient (composite objectives)

For $f$ smooth + $h$ nonsmooth convex (e.g. $h=\lambda\|x\|_1$):

$$
x_{k+1}=\mathrm{prox}_{\eta h}\bigl(x_k-\eta\nabla f(x_k)\bigr).
$$

**Soft-thresholding** for $h=\lambda\|\cdot\|_1$:

$$
\bigl(\mathrm{prox}_{\eta\lambda\|\cdot\|_1}(z)\bigr)_j
=\mathrm{sign}(z_j)\max(|z_j|-\eta\lambda,0).
$$

Shrinks coordinates; exact zeros when small — the algorithmic heart of lasso.

### Mirror descent / natural gradients (pointer)

Geometry-aware first-order steps (Bregman divergences, Fisher metric) — use when parameters live on probability simplices or when preconditioning is structural.

## 7. Gradient clipping and stability (ML)

When $\|\nabla f\|$ is huge (RNNs, transformers early training):

$$
g \leftarrow g\cdot \min\Bigl(1,\frac{\tau}{\|g\|}\Bigr).
$$

Not a textbook convex algorithm, but a practical stabilizer. Combine with smaller $\eta$, better init, normalization layers.

## 8. Diagnostics checklist

| Symptom | Likely causes | Try |
|---------|---------------|-----|
| Loss → NaN/Inf | $\eta$ too large, log(0), bad data | lower $\eta$, grad clip, sanitize inputs |
| No progress | $\eta$ too small, bug, zero grads | raise $\eta$, check shapes / `detach` |
| Train↓ val↑ | overfit | regularize, early stop, more data |
| Oscillation | $\eta$ large, bad conditioning | lower $\eta$, momentum, precondition |
| Dead ReLU | bad init, high LR | Leaky ReLU, lower $\eta$, init |
| Exploding activations | depth, residual missing | norm layers, residuals, clip |

### Worked example 4 — learning rate range test

Sweep $\eta$ on a log grid for a few hundred steps; plot loss vs $\eta$; pick $\eta$ before the explosion region (Smith LR range test idea).

## 9. Complexity snapshot (order-of-magnitude)

| Setting | Iterations (oracle complexity flavor) |
|---------|----------------------------------------|
| Smooth convex GD | $\mathcal{O}(1/\varepsilon)$ |
| Smooth strongly convex GD | $\mathcal{O}(\kappa\log(1/\varepsilon))$ |
| Nesterov smooth convex | $\mathcal{O}(1/\sqrt{\varepsilon})$ |
| SGD convex (diminishing) | $\mathcal{O}(1/\varepsilon^2)$ typical |
| Finite-sum variance reduction | improved dependence on $n$ |

Constants and assumptions matter; use this as orientation, not a warranty.

## 10. When to go second-order

Newton / quasi-Newton (L-BFGS) worth it when:

- $d$ moderate  
- $f$ smooth, expensive to evaluate but $d^3$ or $d^2$ acceptable  
- High-accuracy solutions required (scientific computing)  

Avoid pure Newton on deep nets ($d$ millions+); use first-order + adaptive + normalization.

## 11. Practical training recipe (supervised ML)

1. Standardize / normalize inputs; sanity-check labels  
2. Start with AdamW or SGD+momentum; log-spaced $\eta$  
3. Weight decay + data augmentation as needed  
4. Monitor train **and** validation; early stop on val  
5. Decay $\eta$ when val plateaus  
6. Final test once  

### Worked example 5 — mini-batch scaling rule of thumb

If you multiply batch size by $k$, try scaling $\eta$ by $k$ (linear scaling rule) with warmup — not universal, but a common starting point.

## 12. Pitfalls

1. Tuning $\eta$ on the test set  
2. Comparing optimizers without equal tuning budget  
3. Forgetting that full-batch GD and SGD minimize the **same** $f$ in expectation but different paths  
4. Using proximal operators with wrong step scaling  
5. Interpreting training loss only — generalization is separate  

## 13. Checkpoint

- Write GD and SGD updates  
- State a safe constant step size for $L$-smooth $f$  
- Explain momentum’s effect on valleys  
- Soft-threshold for $L_1$  
- Run a diagnostic table mentally when loss misbehaves  
- Know when adaptive methods help  

## Exercises

### Easy

1. For $f(x)=\frac12 L x^2$, what happens if $\eta>2/L$ in GD?  
2. One advantage and one disadvantage of mini-batch size $1$ vs full batch.  
3. Soft-thresholding $\mathrm{prox}_{\lambda\|\cdot\|_1}$ — effect on coordinates?  
4. Why might gradient *direction* be more trustworthy than step length early in training?  
5. Name a problem class where Newton/L-BFGS is worth the cost.  

### Medium

6. Design a log-spaced $\eta$ grid protocol on a validation split.  
7. Show that for $f(x)=\frac12 x^\top A x$ with $A\succ 0$, GD contracts in the eigenbasis when $0<\eta<2/\lambda_{\max}$.  
8. Derive soft-thresholding as the proximal map of $\lambda\|x\|_1$ (coordinatewise).  
9. Explain bias correction in Adam (sketch).  
10. Projected GD onto the probability simplex: describe the projection idea (sorting / threshold).  

### Challenge

11. Prove that for $L$-smooth $f$, $\eta=1/L$ yields $f(x_{k+1})\le f(x_k)-\frac{1}{2L}\|\nabla f(x_k)\|^2$.  
12. Compare heavy-ball vs Nesterov on a 2D quadratic (simulate or analyze eigenvalues of the iteration matrix).  
13. Variance of mini-batch gradients: show $1/B$ scaling under i.i.d. sampling with replacement.  
14. Composite $f+h$: write the fixed-point equation of proximal gradient and connect to optimality $0\in\nabla f(x)+\partial h(x)$.  
15. Learning-rate warmup: argue why large $\eta$ at step $0$ with random init can be harmful.  

## Checks

1. Diverges / oscillates with increasing amplitude.  
3. Shrinks coefficients; exact zero if below threshold.  

## Summary

First-order methods move opposite the gradient with a carefully chosen step. GD is the clean baseline; SGD scales to data; momentum and adaptive methods stabilize and accelerate practice; projections and prox handle constraints and $L_1$. Most training failures are step size, conditioning, or data bugs — use the diagnostics table, validate honestly, and match the algorithm to smoothness, stochasticity, and scale.
