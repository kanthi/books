# Regularization and Generalization

A model that fits training data perfectly can still fail on new data. **Regularization** is the mathematical practice of preferring simpler or more stable solutions when minimizing empirical risk. This chapter connects penalized objectives, geometry of $\ell_1$/$\ell_2$ balls, bias–variance tradeoffs, and implicit regularization from early stopping and gradient methods.

## 1. The generalization problem

Data $(x_i,y_i)_{i=1}^n$ drawn i.i.d. from unknown $P$. Hypothesis $f_w$ with parameters $w\in\mathcal{W}$.

**True risk:**

$$
R(w)=\mathbb{E}_{(x,y)\sim P}\big[\ell(y,f_w(x))\big].
$$

**Empirical risk:**

$$
\hat{R}_n(w)=\frac{1}{n}\sum_{i=1}^n \ell(y,f_w(x_i)).
$$

ERM: $\hat{w}\in\arg\min_w \hat{R}_n(w)$. Without restriction, if $\mathcal{W}$ is huge, $\hat{R}_n(\hat{w})$ can be near zero while $R(\hat{w})$ is large (**overfitting**).

**Generalization gap:** $R(w)-\hat{R}_n(w)$ (or absolute value). Learning theory bounds this gap via complexity of $\mathcal{W}$ (VC dimension, Rademacher complexity, covering numbers, stability, PAC-Bayes, etc.).

### Worked example 1 — polynomial overfitting

Fitting degree-$n-1$ polynomial through $n$ noisy points: training error $\approx 0$, test error huge. High-capacity interpolators need regularization or implicit bias.

## 2. Regularized empirical risk

$$
\min_w \hat{R}_n(w) + \lambda \Omega(w).
$$

- $\Omega$: regularizer (complexity penalty)
- $\lambda\ge 0$: tradeoff hyperparameter

Equivalent constrained form (under mild conditions, Lagrange duality):

$$
\min_w \hat{R}_n(w)\quad\text{s.t.}\quad \Omega(w)\le \tau.
$$

### Common regularizers

| Name | $\Omega(w)$ | Effect |
|------|-------------|--------|
| Ridge (Tikhonov) | $\|w\|_2^2$ | Shrinkage, unique min if $\lambda>0$ |
| Lasso | $\|w\|_1$ | Sparsity, feature selection |
| Elastic net | $\alpha\|w\|_1+(1-\alpha)\|w\|_2^2$ | Sparse + grouped stability |
| Group lasso | $\sum_g \|w_g\|_2$ | Group sparsity |
| Nuclear norm | $\|W\|_*$ | Low-rank matrices |
| Total variation | $\|\nabla w\|_1$ | Piecewise smooth signals |

## 3. Ridge regression in closed form

$$
\min_w \|Xw-y\|_2^2 + \lambda \|w\|_2^2, \quad \lambda>0.
$$

**Normal equations:**

$$
(X^\top X + \lambda I)w = X^\top y.
$$

**Solution:**

$$
w_\lambda = (X^\top X+\lambda I)^{-1}X^\top y = X^\top(XX^\top+\lambda I)^{-1}y
$$

(the second form helps when $n\ll d$).

### Worked example 2 — collinearity

If two features are nearly identical, $X^\top X$ is ill-conditioned; OLS coefficients explode with opposite signs. Ridge eigenvalues of $X^\top X+\lambda I$ are at least $\lambda$, stabilizing the solve.

### Spectral view

If $X=U\Sigma V^\top$ (economy SVD), ridge shrinks singular components: directions with small singular values get damped more—**spectral filtering**.

## 4. Lasso and sparsity geometry

$$
\min_w \frac{1}{2n}\|Xw-y\|_2^2 + \lambda \|w\|_1.
$$

**Geometry:** $\ell_1$ balls are diamonds (in 2D). Contours of quadratic loss meet the diamond preferably at axes $\Rightarrow$ coordinates set to zero.

**Soft-thresholding** (orthogonal design $X^\top X=I$ after scaling):

$$
\hat{w}_j = S_{\lambda}(z_j),\quad S_\lambda(z)=\mathrm{sign}(z)\max(|z|-\lambda,0).
$$

### Worked example 3

$z=(3,0.2,-1.5)$, $\lambda=0.5$: soft-threshold $\to (2.5,0,-1.0)$. Small coefficient wiped out.

### Worked example 4 — when lasso fails uniqueness

Highly correlated features: lasso may pick one arbitrarily. Elastic net mixes $\ell_2$ to stabilize groups.

## 5. Bias–variance tradeoff

For squared error and many estimators,

$$
\mathbb{E}\big[(f_{\hat{w}}(x)-y)^2\big] = \mathrm{Bias}^2 + \mathrm{Variance} + \sigma^2.
$$

Increasing $\lambda$:

- **Bias up:** solution pulled toward $0$ (or other prior)
- **Variance down:** less sensitive to training noise

Optimal $\lambda$ balances the two on **validation** data, not training loss.

### Worked example 5 — ridge path

As $\lambda:0\to\infty$, $w_\lambda$ moves from OLS (or min-norm interpolator) to $0$. Cross-validation picks intermediate $\lambda$ minimizing estimated risk.

## 6. Early stopping as implicit regularization

Iterate $w_{k+1}=w_k-\alpha\nabla \hat{R}_n(w_k)$ from $w_0=0$. Stopping at iteration $k$ often behaves like spectral filtering similar to ridge: early iterates align with high-curvature (important) directions first.

**Practical rule:** monitor validation loss; stop when it rises (**early stopping**).

### Worked example 6

Unregularized linear regression with GD on an overparameterized least-squares problem: without stopping, you may drift toward large-norm interpolators; early stop keeps smaller effective norm.

## 7. Implicit bias of optimizers

Even without explicit $\Omega$, algorithm + initialization select a particular minimizer among many.

- **Gradient descent on underdetermined least squares** from $0$ converges to the **minimum $\ell_2$-norm** interpolator.
- **Coordinate descent / certain sign patterns** relate to $\ell_1$ biases in some settings.
- **SGD noise** can prefer flatter regions (heuristic / active research).

This is why “we didn't use regularization” is often false in deep learning—the optimizer is the regularizer.

## 8. Structural risk and capacity control

Penalized ERM is one implementation of **structural risk minimization**: choose a nested family $\mathcal{W}_1\subset\mathcal{W}_2\subset\cdots$ with increasing capacity; pick level via validation or complexity penalties.

Related classical tools:

- AIC / BIC (parametric model selection)
- MDL (minimum description length)—links to coding/information theory
- Dropout, data augmentation, stochastic depth: **implicit / algorithmic** regularizers

### Worked example 7 — weight decay in deep nets

PyTorch `weight_decay` in AdamW decouples $\ell_2$ penalty from adaptive scaling—practitioners treat it as ridge-like shrinkage on weights, crucial for generalization in large models.

## 9. Double descent (modern nuance)

Classical U-shaped risk vs capacity curves are incomplete for interpolating regimes. **Double descent:** risk can decrease again past the interpolation threshold as models grow, with min-norm / benign overfitting phenomena in some linear and random-feature models.

Regularization still matters, but “always increase $\lambda$ until underfit” is too crude for modern overparameterized ML. Use validation, not folklore alone.

### Worked example 8 — conceptual sketch

Risk vs model size: descent, peak near interpolation, second descent for very wide models with appropriate training. Explicit ridge can shift the peak and improve finite-sample risk.

## 10. Practical workflow

1. Split **train / validation / test** (or cross-validation); freeze test until the end.
2. Choose $\Omega$ matching inductive bias (sparse? low-rank? smooth?).
3. Sweep $\lambda$ on a log grid; plot train vs val curves.
4. Inspect coefficients / sparsity / norms—not only scalar loss.
5. For iterative methods, jointly consider early stopping and explicit penalties.
6. Report test metrics **once** with uncertainty if possible.

### Worked example 9 — validation curve reading

If train loss $\ll$ val loss and gap grows with capacity, overfit: increase $\lambda$, reduce features, or add data. If both losses high, underfit: decrease $\lambda$ or enrich model class.

### Worked example 10 — calibration note

Regularization that improves $0$-$1$ accuracy may still hurt probability calibration; for decision systems, track proper scoring rules (log loss, Brier) too.

## 11. CS/systems connections

- **Ill-conditioned least squares** in graphics/scientific computing: Tikhonov regularization
- **Compressed sensing:** $\ell_1$ recovery of sparse signals under RIP
- **Recommender systems:** regularized matrix factorization
- **Control:** process noise / state penalties analogous to priors
- **Robust statistics:** penalties related to influence function control

## 12. Pitfalls

1. **Tuning $\lambda$ on the test set** — leaks and invalidates claims.
2. **Comparing unnormalized features** — $\ell_2$ penalty assumes comparable scales; standardize.
3. **Thinking lasso always selects the “true” features** — inconsistent under strong correlations without conditions (irrepresentable condition, etc.).
4. **Ignoring implicit bias** — different optimizers $\ne$ same solution in overparameterized models.
5. **Only watching training loss** — will systematically overfit.
6. **Huge $\lambda$** — model collapses to prior; “stable” but useless.

## 13. Checkpoint

- Write regularized ERM and its constrained twin
- Derive ridge closed form and explain conditioning
- Explain $\ell_1$ vs $\ell_2$ geometry and sparsity
- Describe bias–variance vs $\lambda$ and how to choose $\lambda$
- Name two implicit regularizers (early stopping, min-norm bias)

## Exercises

### Easy

1. Show that $\lambda\|w\|_2^2$ is equivalent (via Lagrange) to constraining $\|w\|_2\le\tau$ for appropriate paired $(\lambda,\tau)$ at optimality (sketch).
2. Compute ridge solution for 1D: $x_i\in\mathbb{R}$, closed form $w=(\sum x_i^2+\lambda)^{-1}\sum x_i y_i$.
3. Apply soft-thresholding $S_{0.3}$ to $(1.0,-0.2,0.5)$.
4. Why standardize features before ridge/lasso?
5. Sketch train and val error vs $\lambda$ for a typical well-specified problem.

### Medium

6. Derive the normal equations for ridge from $\nabla_w=0$.
7. Prove that for $\lambda>0$, ridge objective is strongly convex even if $X^\top X$ is singular.
8. Explain why elastic net can select groups of correlated features more stably than lasso (geometry/heuristic OK).
9. Show that GD on $\frac12\|Xw-y\|_2^2$ from $w_0=0$ stays in the row space of $X$ (span of feature vectors)—link to min-norm solution.
10. Design a 5-fold CV protocol for choosing $\lambda$; list leakage mistakes to avoid.

### Challenge

11. For orthogonal design $X^\top X=nI$, derive lasso soft-thresholding explicitly.
12. Read/prove a simple stability bound: regularization $\Rightarrow$ algorithmic stability $\Rightarrow$ generalization (outline).
13. Compare explicit ridge vs early-stopped GD on a diagonal least-squares problem in the eigenbasis (spectral filters $1/(\sigma^2+\lambda)$ vs $(1-(1-\alpha\sigma^2)^k)$).
14. Nuclear norm regularized matrix completion: write the optimization problem and one proximal-gradient step sketch.
15. Discuss double descent: when might increasing model size **and** decreasing $\lambda$ both improve test error?

## Summary

Regularization encodes inductive bias—shrinkage, sparsity, low rank—into the objective or algorithm. Ridge stabilizes and shrinks; lasso selects; early stopping and optimizer bias regularize even without penalties. Generalization is about controlling the gap to true risk: use validation, respect feature scaling, and remember that modern overparameterized regimes still use regularizers, just sometimes implicit ones.
