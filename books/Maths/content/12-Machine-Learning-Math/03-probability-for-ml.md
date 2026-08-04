# Probability for Machine Learning

ML models are often **conditional probability machines**: $p(y\mid x)$ or density estimators $p(x)$. This chapter connects Bayes, likelihood, calibration, and common predictive distributions to training objectives.

## Diagram: generative vs discriminative

```text
  discriminative:          generative:
  x ──► p(y|x) ──► ŷ      assume p(x,y)=p(y)p(x|y)
                              │
                              └── predict via Bayes p(y|x)
```

## 1. Likelihood and maximum likelihood

Given i.i.d. data and model $\{p_w\}$, the **likelihood** is

$$
L(w)=\prod_{i=1}^n p_w(y_i\mid x_i)
$$

(or $p_w(x_i)$ unsupervised). Equivalently maximize the log-likelihood

$$
\ell(w)=\sum_{i=1}^n \log p_w(y_i\mid x_i).
$$

**MLE:** $\hat w=\arg\max_w \ell(w)$.  
Minimizing negative log-likelihood (NLL) is the same problem; for categorical models NLL = cross-entropy on labels.

### Worked example 1 — Bernoulli / logistic

$y\in\{0,1\}$, $p_w(y=1\mid x)=\sigma(w^\top x)=\hat y$.

$$
\log L = \sum_i\bigl(y_i\log\hat y_i+(1-y_i)\log(1-\hat y_i)\bigr).
$$

Maximizing this yields logistic regression (no regularizer yet).

### Worked example 2 — Gaussian regression

$y=w^\top x+\varepsilon$, $\varepsilon\sim\mathcal{N}(0,\sigma^2)$. MLE for $w$ ≡ least squares. NLL ≡ squared loss up to constants and $\sigma$.

## 2. MAP estimation and regularization

**Prior** $p(w)$ encodes beliefs before data.

$$
p(w\mid\mathrm{data})\propto L(w)\,p(w).
$$

**MAP:** $\hat w=\arg\max_w L(w)p(w)=\arg\max_w\bigl(\log L(w)+\log p(w)\bigr)$.

| Prior | Penalty $\Omega(w)$ flavor |
|-------|----------------------------|
| $w\sim\mathcal{N}(0,\tau^2 I)$ | $\propto \|w\|_2^2$ (ridge) |
| Laplace (i.i.d.) | $\propto \|w\|_1$ (lasso-like) |

```text
  posterior ∝ likelihood × prior
  log posterior = log lik − Ω(w) + const
```

### Worked example 3 — Gaussian prior strength

If $w\sim N(0,\tau^2 I)$, MAP penalty strength scales like $1/\tau^2$: small $\tau$ ⇒ strong shrink to $0$.

## 3. Bayes rule in prediction

$$
p(y\mid x)=\frac{p(x\mid y)p(y)}{p(x)}.
$$

**Generative classifiers** model $p(x\mid y)$ and $p(y)$; **discriminative** model $p(y\mid x)$ directly.

**Naive Bayes:** assume features independent given class:

$$
p(x\mid y)=\prod_{j=1}^d p(x_j\mid y).
$$

Crude independence, often strong baseline for text (bag-of-words).

### Worked example 4 — equal priors

Two classes, $p(y=1)=p(y=0)=\frac12$. Bayes chooses class 1 when $p(x\mid y=1)>p(x\mid y=0)$, i.e. likelihood ratio $>1$.

## 4. Softmax as multi-class Bernoulli generalization

Logits $z\in\mathbb{R}^K$:

$$
p_k=\frac{e^{z_k}}{\sum_{j=1}^K e^{z_j}}.
$$

Properties: $p_k>0$, $\sum_k p_k=1$. Shift-invariant: $z+c\mathbf{1}$ same softmax (identifiability: often fix one logit $0$).

### Worked example 5

$z=(0,0,1)$: $p\propto(1,1,e)$, normalize by $2+e$:

$$
p\approx(0.212,0.212,0.576).
$$

## 5. Calibration

A predicted probability $\hat p=0.8$ is **calibrated** if among all cases with $\hat p\approx 0.8$, about $80\%$ are positive (long-run frequency).

| Tool | Role |
|------|------|
| Reliability diagram | plot empirical frequency vs predicted bin |
| Brier score | $\frac1n\sum(\hat p_i-y_i)^2$ |
| Log loss | CE; penalizes confident wrong answers hard |
| ECE | expected calibration error (binned) |

**High accuracy ≠ calibrated.** A model can get argmax labels right while distorting probabilities (common after overtraining or temperature-unaware decoding).

### Worked example 6 — overconfidence

Neural net outputs $0.99$ on many examples but is only $90\%$ accurate in that bin ⇒ overconfident; temperature scaling or isotonic regression can recalibrate post hoc.

## 6. Bias–variance (probabilistic view)

For squared error and many estimators of a regression function,

$$
\mathbb{E}\bigl[(f_{\hat w}(x)-y)^2\bigr]
=\mathrm{Bias}^2+\mathrm{Variance}+\sigma^2,
$$

where $\sigma^2$ is irreducible noise.

```text
  error
    ^
    |  \        /
    |   \ bias / variance
    |    \    /
    |     \  /
    |      \/
    +----------------► model complexity
```

Underfitting: high bias. Overfitting: high variance. Regularization and more data move the tradeoff.

## 7. Decision rules and utility

Given $p(y\mid x)$, optimal actions depend on **costs**. For binary classification with asymmetric false positive/negative costs, threshold $\hat p$ at $c$ not necessarily $1/2$:

$$
\text{predict }1 \text{ if } p(y=1\mid x)\ge \tau(c).
$$

Probability models + utility ≠ always maximize accuracy.

## 8. Common predictive distributions in ML

| Task | Typical $p(y\mid x)$ |
|------|----------------------|
| Binary clf | Bernoulli(sigmoid) |
| Multi-class | Categorical(softmax) |
| Regression | Gaussian (or Laplace / Student-t robust) |
| Count data | Poisson / negative binomial |
| Sequences | Autoregressive categorical tokens |

Choosing $p$ **is** choosing the loss (NLL).

## 9. Latent variables (preview)

Mixture models, VAEs, HMMs: introduce $z$ with $p(x)=\sum_z p(x\mid z)p(z)$ or integral. Training uses EM or variational bounds (ELBO) involving KL terms — links to the information-theory chapters.

## 10. Train / validation / test as risk estimation

- **Train:** fit $w$ (possibly with early stopping signals from val)  
- **Validation:** estimate risk for model selection / hyperparameters  
- **Test:** final unbiased-ish estimate — touch once  

All are Monte Carlo estimates of expectations under (hopefully) the deployment distribution. Distribution shift breaks the story.

## 11. Pitfalls

1. Interpreting softmax outputs as calibrated without checking  
2. MLE without regularization in overparameterized models  
3. Naive Bayes independence taken as literal truth  
4. Optimizing accuracy when probabilities drive decisions  
5. Using test set for model selection (optimistic bias)  

## 12. Checkpoint

- Write MLE and MAP objectives  
- Connect Gaussian prior to L2  
- Softmax formula and shift invariance  
- Define calibration vs accuracy  
- State bias–variance components for squared error  
- Choose Bernoulli vs categorical vs Gaussian likelihoods  

## Exercises

### Easy

1. Show that maximizing Bernoulli likelihood yields logistic log-loss.  
2. If prior $w\sim N(0,\tau^2 I)$, what regularizer appears in MAP?  
3. Give an example where a model is accurate but poorly calibrated.  
4. For two classes with equal prior, when does Bayes choose class 1?  
5. Compute softmax of $z=(0,0,1)$ (approx values).  
6. Explain train/val split as estimating generalization risk.  

### Medium

7. Derive NLL for $y\sim\mathcal{N}(w^\top x,\sigma^2)$ and relate to least squares.  
8. Show softmax is invariant to adding a constant to all logits.  
9. Brier score vs 0-1 loss: construct a tiny dataset where rankings differ.  
10. Naive Bayes for binary features: write $\log p(y\mid x)$ up to constants.  
11. Temperature $T$: $p\propto e^{z/T}$. What do $T\to 0$ and $T\to\infty$ do?  

### Challenge

12. MAP with Laplace prior: connect to L1 geometry (soft-thresholding intuition).  
13. Proper scoring rules: why is log loss proper? (definition + one-line idea).  
14. Class imbalance: how does changing prior $p(y)$ affect the Bayes threshold?  
15. Sketch ELBO: $\log p(x)\ge \mathbb{E}_q\log p(x\mid z)-D_{\mathrm{KL}}(q(z)\|p(z))$ role of each term.  

## Checks

2. $\|w\|_2^2$ penalty strength $\propto 1/\tau^2$.  
5. $p\propto(1,1,e)$ normalized $\approx(0.21,0.21,0.58)$.  

## Summary

Probabilistic ML treats predictions as distributions: likelihoods define losses, priors define regularizers, and Bayes combines them. Softmax and Bernoulli models cover most classification heads; calibration and utility decide whether probabilities are decision-ready. Bias–variance and data splits remind you that fitting $p_w$ on a sample is not the same as knowing the world — validate under the distribution you care about.
