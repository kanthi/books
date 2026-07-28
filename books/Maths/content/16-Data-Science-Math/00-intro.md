# Mathematics for Data Science

Data science turns measurements into decisions under uncertainty. The mathematics is not a single theorem but a **stack**: descriptive summaries, probability models, estimation, hypothesis testing, prediction, and experimental design—implemented at scale with linear algebra and optimization. This part emphasizes statistical foundations with CS systems awareness (pipelines, A/B tests, metrics).

## The data science loop (mathematical view)

1. **Collect** samples from a process (ideally i.i.d. or with known dependence)
2. **Describe** with robust summaries and visualizations
3. **Model** $P(Y\mid X)$ or $P(X)$ or causal $P(Y\mid\mathrm{do}(X))$
4. **Estimate** parameters / predict with uncertainty
5. **Decide** (ship feature? alert? allocate?)
6. **Validate** on held-out data or sequential experiments

Skipping uncertainty quantification produces confident wrong products.

## Core mathematical areas

### Statistics and probability

- Descriptive statistics and exploratory data analysis (EDA)
- Estimation: bias, variance, MSE, consistency
- Confidence intervals and hypothesis tests
- Bayesian updating
- Bootstrap and resampling

### Linear algebra for tabular / embedding data

- Data matrix $X\in\mathbb{R}^{n\times d}$
- PCA / SVD for dimensionality reduction
- Least squares and regularized regression

### Optimization and calibration

- Fitting models by minimizing empirical risk
- Proper scoring rules (log loss, Brier)
- Threshold selection under class imbalance

### Causality and design (often neglected)

- Randomized experiments (A/B tests)
- Confounding in observational data
- Potential outcomes sketch

### Worked example 1 — metric vs estimator

“Average revenue per user” is a functional of a distribution. The sample mean estimates it; variance and dependence (users repeat) affect standard errors. Math separates **parameter** from **estimator**.

### Worked example 2 — classification pipeline

Labels $y\in\{0,1\}$, features $x$. Model $\hat p(x)\approx P(y=1\mid x)$. Threshold $\hat p\ge t$ yields decisions. Choosing $t$ is decision theory, not only “accuracy maximization.”

## Descriptive → inferential bridge

Descriptive stats summarize **the sample you have**. Inferential stats make claims about **the process that generated it**, requiring assumptions (random sampling, model class, independence).

### Worked example 3

Mean latency on yesterday’s logs describes yesterday. Inferring next week’s P99 needs a model of traffic mix and nonstationarity—often the hard part.

## Roadmap

1. **Statistical foundations** — summaries, estimation, testing, error types, power (detailed chapter)
2. Cross-links: Probability advanced (`17`), Linear algebra advanced (`18`), Optimization (`11`), Information theory (`10`)

## Notation

- Sample $(x_i)_{i=1}^n$ or pairs $(x_i,y_i)$
- Estimator $\hat\theta_n$; true $\theta$
- Empirical distribution $\hat P_n=\frac1n\sum\delta_{x_i}$
- Loss $\ell$; risk $R$; empirical risk $\hat R_n$

### Worked example 4 — empirical risk

$\hat R_n(f)=\frac1n\sum_i \ell(y_i,f(x_i))$ is a Monte Carlo estimate of $R(f)=\mathbb{E}[\ell(y,f(x))]$ when data are i.i.d.

## Systems constraints

| Constraint | Math impact |
|------------|-------------|
| Streaming data | Online estimators, sketching |
| Multiple testing | Family-wise error, FDR |
| Logging bias | Selection bias; counterfactual issues |
| Delayed outcomes | Censoring; off-policy evaluation |
| Privacy | Noise injection; bias-variance trade |

### Worked example 5 — peeking in A/B tests

Repeatedly testing until $p<0.05$ inflates Type I error. Sequential testing / always-valid p-values fix the math of early stopping.

## Estimands, estimators, and error

An **estimand** is the target quantity (population mean conversion, ATE, $P(Y=1\mid x)$). An **estimator** is a function of the sample (sample mean, difference-in-means, logistic MLE). Quality metrics:

$$
\mathrm{Bias}(\hat\theta)=\mathbb{E}[\hat\theta]-\theta,\qquad
\mathrm{Var}(\hat\theta)=\mathbb{E}[(\hat\theta-\mathbb{E}\hat\theta)^2],\qquad
\mathrm{MSE}=\mathrm{Bias}^2+\mathrm{Var}.
$$

### Worked example 6 — biased but useful

Ridge coefficients are biased toward zero yet can lower MSE under collinearity. “Unbiased” is not always the right product goal.

### Worked example 7 — standard error

For i.i.d. sample mean, $\mathrm{se}=\sigma/\sqrt{n}$. Doubling precision (halving se) needs roughly $4\times$ data—budgeting law of data science.

## Supervised learning as statistics

Prediction models estimate functionals of $P(Y\mid X)$. Classification thresholds implement decision theory; calibration asks whether $\hat p(x)\approx P(Y=1\mid X=x)$. Cross-validation estimates risk of the **selection procedure**, not only a fixed model.

### Worked example 8 — class imbalance

Accuracy can be $99\%$ by always predicting “negative” when base rate is $1\%$. Prefer precision/recall, PR-AUC, or expected cost under a loss matrix.

## Causal vs predictive summary table

| Question | Tool |
|----------|------|
| What will happen if we observe $X=x$? | Predictive model |
| What if we **set** $T=1$? | Causal estimand + design/ID |
| Which features associate with $Y$? | Regression / MI (not automatically causal) |
| Did the launch move the metric? | Experiment or quasi-experiment |

### Worked example 9 — logging policy

Bandit logs of $\pi(a\mid x)$ enable off-policy evaluation of a new policy $\pi'$ via importance weights—if support conditions hold. Pure supervised fit on logged rewards without correction is biased.

## Pitfalls

1. **p-hacking and metric shopping**  
2. **Train-test leakage** in feature pipelines  
3. **Simpson’s paradox** aggregation  
4. **Confusing prediction with causation**  
5. **Ignoring dependence** (time series, users, graphs)  
6. **Huge $n$ ≠ no bias** (systematic measurement error)  

## Checkpoint

- Separate description, inference, prediction, causation  
- Write risk vs empirical risk  
- Name bias/variance of an estimator  
- Explain why A/B tests beat naive before/after  
- List three pipeline leakages  

## Exercises

1. Define bias and variance of $\hat\theta$; give an example with nonzero bias.
2. Why can accuracy be a bad metric at 1% positive class?
3. Write an A/B test design: unit of randomization, primary metric, guardrails.
4. Explain bootstrap SE for the median at a high level.
5. Give a Simpson’s paradox contingency table (numbers).
6. When is MAP estimation “like regularization”?
7. PCA: what objective does the first PC optimize?
8. Multiple metrics: how does multiple testing arise in dashboards?
9. Streaming mean: write Welford update (or online mean formula).
10. Causal: why does “users who clicked had higher revenue” not prove clicks cause revenue?
11. Calibration: define ECE at a high level.
12. Checkpoint project: pick a KPI at work/school; identify estimand, estimator, assumption most likely false.

## Summary

Data science math is statistical decision-making with matrices and optimizers attached. Master estimands, estimators, uncertainty, and design—then scale with computation. The next chapter builds statistical foundations in depth.
