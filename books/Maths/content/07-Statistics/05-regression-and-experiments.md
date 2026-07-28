# Regression and Experimental Design

Regression models relationships between variables; experimental design produces data that can support causal claims. Together they power A/B testing, forecasting, and scientific product decisions. This chapter covers linear models, diagnostics, the correlation–causation gap, and randomized experiments.

## 1. Linear regression model

$$
y = X\beta + \varepsilon,
$$

where $y\in\mathbb{R}^n$ responses, $X\in\mathbb{R}^{n\times p}$ design matrix (often with a column of ones for intercept), $\beta\in\mathbb{R}^p$ coefficients, $\varepsilon$ errors.

**Ordinary least squares (OLS):**

$$
\hat\beta = \arg\min_\beta \|y-X\beta\|_2^2 = (X^\top X)^{-1}X^\top y
$$

when $X$ has full column rank.

### Worked example 1 — simple regression

$y_i=\beta_0+\beta_1 x_i+\varepsilon_i$. Slope $\hat\beta_1$ is $\mathrm{Cov}(x,y)/\mathrm{Var}(x)$ on the sample. Interpret: expected change in $y$ per unit $x$, **holding the model true**.

### Worked example 2 — multiple regression

Include multiple predictors; $\hat\beta_j$ is partial effect controlling for other columns of $X$ (linearly).

## 2. Classical OLS assumptions

1. Linearity in parameters: $\mathbb{E}[y\mid X]=X\beta$  
2. Random sampling / correct conditioning on $X$  
3. Full rank $X$ (no perfect multicollinearity)  
4. $\mathbb{E}[\varepsilon\mid X]=0$ (exogeneity)  
5. Homoscedasticity: $\mathrm{Var}(\varepsilon\mid X)=\sigma^2 I$ (for classical SE)  
6. Optional: Gaussian errors for exact finite-sample $t$ tests  

Violations change interpretation and valid inference methods (robust SE, GLS, nonlinear models).

### Worked example 3 — omitted variable bias

True model includes confounder $z$ correlated with $x$ and $y$. OLS of $y$ on $x$ alone attributes $z$’s effect to $x$—biased for causal $\beta_x$.

## 3. Fitted values, residuals, $R^2$

$\hat y=X\hat\beta=Hy$ with hat matrix $H=X(X^\top X)^{-1}X^\top$.  
Residuals $e=y-\hat y=(I-H)y$.  

$R^2=1-\frac{\|e\|^2}{\|y-\bar y 1\|^2}$ measures in-sample linear fit—not causality, not guarantee of prediction on new data.

### Worked example 4

High $R^2$ with nonsense predictors on small $n$: overfitting. Prefer adjusted $R^2$, CV error, or information criteria for model comparison.

## 4. Inference for coefficients

Under classical Gaussian assumptions,

$$
\hat\beta_j \sim N\big(\beta_j,\ \sigma^2 (X^\top X)^{-1}_{jj}\big).
$$

$t$-statistics test $H_0:\beta_j=0$. Use heteroscedasticity-robust (Eicker–Huber–White) SEs when variance is non-constant.

### Worked example 5 — confidence interval

Approx $\hat\beta_j \pm t_{1-\alpha/2}\cdot\mathrm{se}_j$. Large $n$: $z_{1-\alpha/2}\approx 1.96$ for 95%.

## 5. Diagnostics

| Tool | What it catches |
|------|-----------------|
| Residuals vs fitted | nonlinearity, heteroscedasticity |
| QQ plot of residuals | non-Gaussian tails |
| Leverage $H_{ii}$ | high-influence design points |
| Cook’s distance | influential observations |
| VIF | multicollinearity |

### Worked example 6

One extreme $x$ with ordinary $y$ can dominate slope—check leverage and leave-one-out.

### Worked example 7 — log transform

Right-skewed positive $y$ (traffic, revenue): model $\log y$ often stabilizes variance and linearizes multiplicative effects.

## 6. Regularized regression (link)

Ridge/lasso when $p$ large or columns collinear—see Optimization regularization chapter. Prediction vs interpretation tradeoffs remain.

### Worked example 8

With $p\approx n$, OLS variance explodes; ridge shrinks coefficients and improves MSE prediction.

## 7. Correlation is not causation

Observational regression estimates associations. Causal claims need:

- Randomized experiment, or  
- Credible identification (instruments, RD, differences-in-differences, structural assumptions)

### Worked example 9 — ice cream and drowning

Both rise in summer; temperature confounds. Regression of drowning on ice cream sales is not a causal effect of ice cream.

### Worked example 10 — product metrics

Users who use feature $F$ have higher retention. Maybe power users adopt $F$. Need experiment or quasi-experiment to claim $F$ causes retention.

## 8. Experimental design and A/B tests

**Randomized controlled experiment:** assign treatment $T$ randomly; compare outcomes.

### Core principles

1. **Randomization** balances confounders in expectation  
2. **Control group** provides counterfactual baseline  
3. **Unit of randomization** (user, session, cluster) matches interference structure  
4. **Blinding** when subjective outcomes / experimenter effects matter  
5. **Pre-registration / primary metric** fights p-hacking  
6. **Power and sample size** before launching  

### Worked example 11 — sample size sketch

To detect effect $\delta$ on a mean with sd $\sigma$, two-sided $\alpha=0.05$, power $80\%$, roughly

$$
n \approx 2\cdot\frac{(z_{1-\alpha/2}+z_{1-\beta})^2 \sigma^2}{\delta^2}
$$

per arm (order of magnitude; use exact calculators in practice).

### Worked example 12 — SRM

Sample ratio mismatch: if assignment should be 50/50 but is 48/52 systematically, instrumentation bug—do not trust results until fixed.

## 9. Threats to validity

| Threat | Example |
|--------|---------|
| Interference / network effects | treated users affect controls |
| Novelty effects | short-term lift fades |
| Selection into logging | only survivors observed |
| Multiple testing | 20 metrics, one “significant” by chance |
| Peeking | optional stopping inflates Type I error |

### Worked example 13 — sequential testing

Always-valid p-values or group sequential designs allow monitoring without naive inflation.

### Worked example 14 — CUPED / variance reduction

Use pre-period covariates to reduce variance of estimators—more power, same causal justification under randomization.

## 10. From experiment to regression

Randomized $T$: OLS of $Y$ on $T$ estimates ATE under SUTVA/no interference. Add covariates for precision (ANCOVA), not for “fixing selection” that randomization already handled.

### Worked example 15 — heterogeneous effects

Interact $T$ with segment indicators—or better, pre-specify subgroups to avoid fishing.

## 11. Pitfalls

1. Causal language for observational $\hat\beta$  
2. Stepwise regression as automatic truth  
3. Extrapolating far outside observed $X$ range  
4. A/B tests without power → noisy ship decisions  
5. Multiple comparisons uncorrected  
6. Cluster randomization analyzed as if independent users  

## 12. Checkpoint

- Write OLS objective and solution  
- List classical assumptions and one violation fix  
- Run residual diagnostics conceptually  
- Explain why randomization enables causation  
- Design a basic A/B test (unit, metric, power)  

## Exercises

### Easy

1. Fit by hand: three points, line through origin $y=\beta x$.
2. Interpret $\hat\beta_1=2.5$ for $x=$ hours studied, $y=$ score (with caveats).
3. Why include an intercept column of ones?
4. Define residual; show they sum to 0 when intercept present.
5. What does $R^2=1$ mean? Is it always good?

### Medium

6. Derive normal equations from $\nabla_\beta\|y-X\beta\|^2=0$.
7. Construct a numeric omitted-variable bias example (small simulation table).
8. Compute leverage intuition: which $x$ is high leverage on a line?
9. Design A/B: primary metric, guardrail metric, randomization unit for a social feed change.
10. Explain why peeking inflates false positives.

### Challenge

11. Prove $\hat\beta$ unbiased under $\mathbb{E}[\varepsilon\mid X]=0$ and full rank.
12. Heteroscedasticity: write sandwich SE formula sketch.
13. Cluster-randomized experiment: why usual SE understate uncertainty.
14. Instrumental variables: one-paragraph identification idea.
15. Capstone: write analysis plan for an A/B test including SRM check, CUPED option, and multiple-testing policy.

## Summary

Regression quantifies associations with transparent assumptions and diagnostics; experiments create the conditions for causal claims. Sound data science keeps the two distinct, designs for power and validity, and refuses to overclaim from observational fits alone.
