# Probability for Machine Learning

ML models are often **conditional probability machines**: $p(y\mid x)$ or density estimators $p(x)$. This chapter connects Bayes, likelihood, and calibration to training objectives.

## Diagram: generative vs discriminative

```text
  discriminative:          generative:
  x ──► p(y|x) ──► ŷ      assume p(x,y)=p(y)p(x|y)
                              │
                              └── predict via Bayes p(y|x)
```

## 1. Likelihood

Given i.i.d. data and model $p_w$, the **likelihood** is

$$
L(w)=\prod_{i=1}^n p_w(y_i\mid x_i)
$$

(or $p_w(x_i)$ unsupervised). Maximize $L$ ⇔ minimize $-\sum\log p_w$ (**NLL** / cross-entropy).

## 2. MAP and regularization

**MLE:** $\hat w=\arg\max L(w)$.  
**MAP:** $\hat w=\arg\max L(w)\,p(w)$ with prior $p(w)$.

Gaussian prior on $w$ ↔ $L_2$ penalty; Laplace prior ↔ $L_1$ flavor.

```text
  posterior ∝ likelihood × prior
  log posterior = log lik − Ω(w) + const
```

## 3. Bayes rule in prediction

$$
p(y\mid x)=\frac{p(x\mid y)p(y)}{p(x)}.
$$

Naive Bayes: assume features independent given class — crude but strong baseline.

## 4. Calibration

Predicted probability $0.8$ should mean ~80% frequency in the long run.  
**Brier score**, reliability diagrams diagnose miscalibration. High accuracy ≠ calibrated.

## 5. Bias–variance (probabilistic view)

Expected test error decomposes into:

- bias² (wrong model class / underfit)
- variance (sensitivity to sample)
- irreducible noise

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

## 6. Softmax

For logits $z\in\mathbb{R}^K$:

$$
p_k=\frac{e^{z_k}}{\sum_j e^{z_j}}.
$$

Cross-entropy + softmax is the multi-class default.

## Exercises

1. Show that maximizing Bernoulli likelihood yields logistic log-loss.  
2. If prior $w\sim N(0,\tau^2 I)$, what regularizer appears in MAP?  
3. Give an example where a model is accurate but poorly calibrated.  
4. For two classes with equal prior, when does Bayes choose class 1?  
5. **Compute** softmax of $z=(0,0,1)$ (approx values).  
6. Explain train/val split as estimating generalization risk.

## Checks

2. $\|w\|_2^2$ penalty strength $\propto 1/\tau^2$.  
5. $p\propto(1,1,e)$ normalized ≈ $(0.21,0.21,0.58)$.
