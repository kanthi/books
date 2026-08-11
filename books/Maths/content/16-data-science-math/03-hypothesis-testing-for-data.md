# Hypothesis Testing for Data Work

A practical companion to formal inference: how data scientists use tests, what to report, and how not to fool yourself with dashboards. Pair with the sampling chapter — a significant p-value on a biased sample is still wrong for the target population.

## Diagram: decision pipeline

```text
  metric definition → data window → estimator
         │
         v
  pre-registered H0/H1 and α
         │
         v
  test + CI + effect size + plot
         │
         v
  decision + ship/hold + monitor
```

## 1. Pick the question first

**Bad:** “run t-tests on all columns.”  
**Good:** one **primary metric**, optional secondary metrics, written **before** peeking at outcomes.

Write:

- Population / time window / exclusions  
- Causal or descriptive claim?  
- Practical threshold worth caring about (not only statistical)

## 2. Hypotheses and errors

For a parameter $\theta$ (mean lift, difference of proportions, …):

- $H_0$: default (often “no difference” $\theta=0$)  
- $H_1$: alternative (one-sided or two-sided)

| Error | Meaning | Control |
|-------|---------|---------|
| Type I | reject $H_0$ when true | significance level $\alpha$ |
| Type II | fail to reject when $H_1$ true | power $1-\beta$ |

**p-value:** under a well-specified $H_0$ model, probability of data as extreme as observed (or more) in the direction of the test. **Not** $P(H_0\mid\mathrm{data})$.

### Worked example 1 — ranking CTR

$H_0$: new ranking does not change CTR ($\theta=0$).  
$H_1$: $\theta>0$ (one-sided) if only lift matters and regression is not a ship blocker — product policy chooses the side.

## 3. Common tests (when)

| Situation | Typical tool |
|-----------|----------------|
| Mean vs constant | one-sample $t$ |
| Two group means | two-sample $t$ / **Welch** |
| Two proportions | $z$-test / $\chi^2$ |
| Paired before/after | paired $t$ |
| Many categories | $\chi^2$ goodness / independence |
| Non-normal small $n$ | rank tests / **bootstrap** |
| Many predictors | regression coefficients + robust SE |

### Welch vs Student

Welch’s $t$-test does not assume equal variances — usually preferred for two web variants with unequal traffic or heteroscedasticity.

## 4. Confidence intervals first-class

A $(1-\alpha)$ CI is the set of parameter values not rejected at level $\alpha$ (for many standard tests). Report:

$$
\hat\theta \pm z_{1-\alpha/2}\cdot\mathrm{SE}
$$

(large-sample) **and** interpret width vs practical importance.

### Worked example 2

$\bar x=10$, $s=2$, $n=100$: $\mathrm{SE}=0.2$, approx 95% CI

$$
10\pm 1.96\cdot 0.2 \approx [9.61,\,10.39].
$$

## 5. Effect size always

Examples:

- Difference of means $\mu_B-\mu_A$  
- Relative lift $(p_B-p_A)/p_A$  
- Cohen’s $d=(\bar x_1-\bar x_2)/s_{\mathrm{pooled}}$  

A tiny lift can be “significant” with huge traffic and still not worth engineering cost. **Statistical significance ≠ practical significance.**

### Worked example 3

Baseline conversion $10\%$, lift $+0.05$ percentage points absolute, $n$ enormous ⇒ $p<0.001$ but maybe irrelevant if redesign costs months.

## 6. Bootstrap intuition

Resample the sample with replacement many times; build empirical distribution of $\hat\theta^\star$.

```text
  original sample:  ● ● ● ● ●
  bootstrap 1:      ● ● ● ● ●  (with replacement)
  bootstrap 2:      ● ● ● ● ●
  ...
  → histogram of θ̂*  → percentile CI
```

**Pros:** few analytic assumptions; good for messy statistics.  
**Cons:** still assumes sample ≈ population of interest; i.i.d. resampling wrong for dependence (time series, clusters) without block bootstrap variants.

### Bootstrap vs normal CI

| Normal / analytic | Bootstrap |
|-------------------|-----------|
| Fast, closed form | Flexible for complex $\hat\theta$ |
| Needs SE formula / asymptotics | Needs compute and exchangeability |

## 7. Multiple metrics and peeking

### Multiple testing

$m$ independent true-null tests at level $\alpha$ ⇒ chance of at least one false positive $\approx 1-(1-\alpha)^m$.

**Fixes:** primary metric only for go/no-go; Bonferroni / FDR for exploration; hierarchical testing.

### Optional stopping

Checking the A/B dashboard every hour and stopping when $p<0.05$ **inflates Type I error** (p-hacking / peeking).

**Fixes:** fixed horizon; sequential tests (alpha spending); always-valid inference methods; pre-commit sample size.

### Worked example 4

“We stopped when p hit 0.05 on day 3 of 14” — report is not a valid level-$\alpha$ fixed-horizon test.

## 8. Power and sample size (order of magnitude)

Roughly, for two proportions near $p$ and lift $\delta$, $n$ per arm scales like

$$
n \propto \frac{p(1-p)}{\delta^2}
$$

for fixed power and $\alpha$. Tiny $\delta$ ⇒ huge $n$. Underpowered tests produce noisy results and encourage chasing significance.

## 9. Practical report template

1. Hypothesis in plain language  
2. Population / time window / exclusions  
3. Sample sizes (per arm)  
4. Estimator + CI  
5. Test + p-value (if used)  
6. Effect size vs practical threshold  
7. Caveats (bias, seasonality, interference, SRM)  
8. Decision + monitoring plan  

## 10. Decision beyond p

| Scenario | Approach |
|----------|----------|
| Revenue up, latency worse | multi-objective / constraints |
| Significant but tiny lift | cost–benefit |
| Not significant, CI includes large lifts | inconclusive — more data or redesign |
| Significant on secondary only | do not silently promote to primary |

## 11. Bayesian glance (optional)

Posterior $p(\theta\mid\mathrm{data})$ and $P(\theta>0\mid\mathrm{data})$ answer different questions than p-values. Still requires priors and still fails under selection bias. Complementary, not magic.

## 12. Pitfalls

1. p-hacking via metric shopping  
2. Optional stopping without sequential correction  
3. Ignoring dependence (users in both arms, networks)  
4. Interpreting $p$ as effect size  
5. Two-sided vs one-sided chosen after seeing the sign  
6. $\chi^2$ with tiny expected cell counts  

## 13. Checkpoint

- Write $H_0,H_1$ for a product change  
- Prefer CI + effect size alongside $p$  
- Name Welch vs Student use case  
- Explain peeking’s Type I inflation  
- Bootstrap idea in one paragraph  
- Ship decisions with practical thresholds  

## Exercises

### Easy

1. Write $H_0,H_1$ for “new ranking increases CTR.”  
2. Why is Welch’s $t$-test often preferred over Student’s for two web variants?  
3. Bootstrap CI vs normal CI — one advantage each.  
4. You check the A/B dashboard every hour and stop when $p<0.05$. Name the problem.  
5. Compute rough 95% CI for mean with $\bar x=10$, $s=2$, $n=100$.  

### Medium

6. **Scenario:** significance on revenue, not on latency — how do you decide ship?  
7. Ten independent metrics, all true nulls, $\alpha=0.05$: approx $P(\text{at least one significant})$?  
8. Explain why $p$ is not $P(H_0\mid\mathrm{data})$.  
9. Paired vs unpaired test for before/after on the same users.  
10. Relative lift vs absolute difference: give a case where relative misleads.  

### Challenge

11. Simulate (conceptually) optional stopping: why Type I exceeds $\alpha$.  
12. Derive two-proportion $z$-statistic for $\hat p_1-\hat p_2$.  
13. FDR vs FWER: when prefer Benjamini–Hochberg?  
14. Power curve: sketch power vs $n$ for fixed $\delta,\alpha$.  
15. Cluster-randomized experiment: why user-level i.i.d. tests fail.  

## Checks

4. Optional stopping / p-hacking.  
5. $10\pm 1.96\cdot 0.2\approx[9.61,10.39]$.  
7. $1-(0.95)^{10}\approx 0.40$.  

## Summary

Hypothesis tests are decision tools under noise, not oracles of truth. Pre-register the primary metric, report effect sizes and CIs, respect multiple comparisons and peeking, and never confuse a small p-value with a large or useful effect. The best analysis is the one whose assumptions match how the data were sampled and how the product will use the result.
