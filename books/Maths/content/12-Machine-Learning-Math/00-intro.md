# Mathematics for Machine Learning

Machine learning systems are optimization procedures applied to statistical models expressed with linear algebra and calculus. This part focuses on the mathematical objects that appear in almost every pipeline: data matrices, embeddings, losses, gradients, and the probabilistic semantics of prediction. The goal is not to catalog algorithms, but to make the math **legible** so you can read papers, debug training, and choose models deliberately.

## What an ML problem looks like mathematically

**Data.** $n$ examples with inputs $x_i\in\mathbb{R}^d$ and targets $y_i\in\mathcal{Y}$. Stack inputs as

$$
X=\begin{bmatrix}x_1^\top\\\vdots\\x_n^\top\end{bmatrix}\in\mathbb{R}^{n\times d},\qquad
y=\begin{bmatrix}y_1\\\vdots\\y_n\end{bmatrix}.
$$

**Model.** A parameterized map $f_w:\mathbb{R}^d\to\hat{\mathcal{Y}}$, e.g. linear $f_w(x)=w^\top x$, or a neural net $f_w=f^{(L)}\circ\cdots\circ f^{(1)}$.

**Loss.** $\ell(y,\hat{y})$ measures pointwise error (squared, logistic, cross-entropy, hinge, Huber, …).

**Objective.** Usually regularized empirical risk:

$$
J(w)=\frac{1}{n}\sum_{i=1}^n \ell\big(y_i,f_w(x_i)\big)+\lambda\Omega(w).
$$

**Training.** Compute $\hat{w}\approx\arg\min_w J(w)$ by gradient methods, convex solvers, or specialized algorithms.

**Evaluation.** Estimate true risk $R(w)=\mathbb{E}[\ell(y,f_w(x))]$ on held-out data; optionally calibrate probabilities, measure fairness, latency, robustness.

### Worked example 1 — linear regression in one line

$J(w)=\frac{1}{n}\|Xw-y\|_2^2+\lambda\|w\|_2^2$ with $\nabla J(w)=\frac{2}{n}X^\top(Xw-y)+2\lambda w$. Math used: matrix calculus, PSD Hessians, conditioning of $X^\top X+\lambda n I$.

## The four pillars

### 1. Linear algebra

- Vectors as examples/embeddings; matrices as datasets, linear maps, batches
- Norms and inner products: similarity, margins, regularization
- Eigen and singular structure: PCA, whitening, recommendation, attention scores as Gram-like structure
- Least squares and pseudoinverses: normal equations, min-norm solutions

### 2. Calculus and optimization

- Gradients / Jacobians / Hessians
- Chain rule $\Leftrightarrow$ backpropagation
- Convex vs nonconvex training dynamics
- Step sizes, momentum, adaptive methods (see Optimization part)

### 3. Probability and statistics

- Likelihood and maximum likelihood $\Leftrightarrow$ many losses
- Bias–variance, estimation error, confidence
- Bayesian posteriors and regularization-as-prior
- Calibration and proper scoring rules

### 4. Information theory (cross-cutting)

- Cross-entropy loss as coding cost
- KL regularization (VAEs, knowledge distillation)
- Mutual information in representation learning

## Supervised learning: decision theory sketch

Given features $x$, predict action $a$ (or label $\hat{y}$) to minimize expected loss. Bayes optimal predictor depends on loss:

- 0-1 loss $\Rightarrow$ predict $\arg\max_y P(y\mid x)$
- Squared loss $\Rightarrow$ predict $\mathbb{E}[y\mid x]$
- Absolute loss $\Rightarrow$ predict median of $y\mid x$

**Surrogate losses** (hinge, logistic) upper-bound or stand in for 0-1 loss to make optimization tractable.

### Worked example 2 — logistic regression as MLE

Bernoulli likelihood with $p_w(x)=\sigma(w^\top x)$ yields negative log-likelihood equal to binary cross-entropy. Convex in $w$ for linear models.

### Worked example 3 — softmax multiclass

$p_k=\frac{e^{z_k}}{\sum_j e^{z_j}}$, $z=Wx$. Cross-entropy with one-hot labels: $\ell=-\sum_k y_k\log p_k$. Jacobian of softmax is diagonal($p$)$-$pp^\top—central in backprop.

## Unsupervised and self-supervised (mathematical themes)

- **PCA / SVD:** maximize variance of projections; equivalent to low-rank approximation in Frobenius norm (Eckart–Young)
- **Clustering:** $k$-means objective $\sum_i \min_j \|x_i-\mu_j\|_2^2$ (nonconvex; alternating minimization)
- **Density models:** maximize $\sum_i \log p_\theta(x_i)$
- **Contrastive learning:** score similarity of positive pairs vs negatives—related to MI lower bounds

### Worked example 4 — PCA objective

$\max_{U^\top U=I_k}\ \mathrm{tr}(U^\top \hat{\Sigma} U)$ with $\hat{\Sigma}=\frac{1}{n}X^\top X$ (centered $X$). Solution: top $k$ eigenvectors of $\hat{\Sigma}$.

## Generalization: the mathematical tension

Training drives $\hat{R}_n(w)$ down; we care about $R(w)$. Bridging tools:

- Classical capacity control (VC, Rademacher)
- Stability and PAC-Bayes
- Overparameterized phenomena (double descent, benign overfitting)—still active research

**Practical math:** validation estimates of risk, confidence intervals for metrics, ablation as experimental design.

### Worked example 5 — train/val split as Monte Carlo

Val loss is an unbiased estimate of risk for a **fixed** $w$. After you tune using val, that estimate becomes optimistic—hence a final test set or nested CV.

## Roadmap in this book

| This part | Focus |
|-----------|--------|
| Linear algebra for ML | Data matrices, projections, SVD/PCA in learning, gradients of matrix objectives |
| Related parts | Calculus (`08`), Optimization (`11`), Probability advanced (`17`), Information theory (`10`), Numerical methods (`15`) |

Read **Linear Algebra for ML** next for concrete embeddings of these ideas in vectors/matrices. Use Optimization and Probability parts as references when training dynamics or statistical claims appear.

## Notation hygiene

- Scalars $a$, vectors $v$ (column by default), matrices $A$
- $\nabla_w J$ gradient; $D_w f$ Jacobian when $f$ is vector-valued
- $\|\cdot\|_2$ Euclidean; $\|\cdot\|_F$ Frobenius; $\|\cdot\|_*$ nuclear
- $\sigma(z)=1/(1+e^{-z})$ sigmoid; $\mathrm{softmax}$ as above

### Worked example 6 — shape checking

Batch matrix $X\in\mathbb{R}^{B\times d}$, weights $W\in\mathbb{R}^{d\times k}$, logits $XW\in\mathbb{R}^{B\times k}$. If shapes fail, the math—not the framework—should catch you first.

## CS systems angle

ML math becomes systems when:

- **Batching** is matrix multiplication throughput (BLAS/GPU)
- **Conditioning** of $X^\top X$ affects convergence and numeric stability
- **Sparsity** of features changes feasible algorithms (sparse matvec)
- **Quantization** approximates $w$ in low precision—error analysis matters
- **Distributed training** shards $X$ or $w$; gradients average (data parallel)

### Worked example 7 — complexity

One full-batch gradient of linear model: $O(nd)$ time. SGD with batch $B$: $O(Bd)$ per step. Wall-clock optimum depends on hardware, not only big-O of full gradient.

## Pitfalls

1. **Confusing training loss with risk.** Always hold out data.
2. **Nonconvex $\Rightarrow$ no global guarantees**—report seeds and variance.
3. **Leaky preprocessing** (scaling using test statistics).
4. **High-dimensional geometry:** distances concentrate; nearest neighbors need care.
5. **Probabilities from softmax are not calibrated** by default.
6. **Math model vs implementation:** broadcasting bugs are dimension errors.

## Checkpoint

- Write ERM + regularization as a precise optimization problem
- Map squared / logistic / cross-entropy losses to statistical principles
- Identify which pillar (LA / calculus / probability / info) a paper subsection uses
- Explain why validation is a Monte Carlo estimate of risk
- Track tensor shapes for a linear layer batch

## Exercises

1. Write $J(w)$ for ridge regression and compute $\nabla J(w)$.
2. Show that for linear regression with squared loss and $X$ full column rank, the critical point is unique.
3. Derive binary cross-entropy from Bernoulli NLL.
4. For one-hot $y$ and softmax $p$, show $\nabla_z \ell = p-y$.
5. Centered data matrix $X$: show that $\mathbf{1}^\top X=0$ if rows sum appropriately—why center before PCA?
6. Give Bayes optimal predictor for absolute loss (median)—one paragraph.
7. Explain the difference between $R(w)$ and $\hat{R}_n(w)$ with an overfitting sketch.
8. Complexity: cost of computing $X^\top X$ for $X\in\mathbb{R}^{n\times d}$.
9. When is hinge loss preferred over logistic? (margins vs probabilities)
10. Map dropout to an approximate ensemble / regularization story (qualitative).
11. Write $k$-means objective and argue it is nonconvex by giving a simple ambiguity (label switching).
12. Information theory: express multiclass cross-entropy as $H(\hat{p},p_{\mathrm{model}})$ on the empirical label distribution in a batch.
13. Systems: why mixed-precision training needs loss scaling (numeric, not ML folklore only).
14. Take a paper abstract you know and list the math objects ($X$, loss, constraint, probabilistic model).
15. Checkpoint project: pick one supervised dataset and write the full mathematical training specification (model, loss, regularizer, optimizer assumptions) without code.

## Summary

ML mathematics is the interplay of **representation** (linear algebra), **fitting** (optimization/calculus), and **uncertainty** (probability/information). Mastering the shared language lets you transfer insights across models—from linear baselines to deep networks—without treating frameworks as magic.
