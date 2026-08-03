# Statistical Inference: Confidence and Hypothesis Tests

**Inference** turns a finite sample into statements about an unknown population — with explicit uncertainty. This chapter covers confidence intervals, hypothesis tests, errors, power, and A/B testing discipline.

## Diagram: inference loop

```text
  population parameter θ  (unknown)
           ▲
           │  probabilistic claim
           │
      sample X1..Xn  ──►  statistic T  ──►  CI / test / p-value
           │
           └── design: sample size, bias, multiple testing
```

## 1. Point estimates vs interval estimates

- **Point estimate:** single guess $\hat\theta$ (mean, proportion, median).
- **Interval estimate:** set of plausible $\theta$ values at a chosen confidence level.

A good estimator is unbiased (or nearly), low variance, and robust to mild outliers when needed.

## 2. Confidence intervals (means)

For i.i.d. sample with mean $\bar x$, sample sd $s$, large $n$ (or normal data):

$$
\bar x \pm z_{\alpha/2}\cdot \frac{s}{\sqrt{n}}
$$

(for known $\sigma$ use $\sigma$; for small $n$ use $t$ critical values).

**Correct interpretation:**  
If you repeat the *procedure* many times, about $(1-\alpha)$ of the intervals cover the true $\theta$.  
After you see one interval, $\theta$ is fixed — do **not** say “there is 95% probability $\theta$ is in this interval” in the frequentist reading.

```text
  many replications
  ──── CI ────  covers θ
  ──── CI ────  covers θ
  ──── CI ────  misses
  ──── CI ────  covers θ
  coverage ≈ 1-α
```

## 3. Hypothesis testing workflow

1. State $H_0$ (status quo) and $H_1$ (research claim).
2. Choose test statistic and null distribution.
3. Compute **p-value** = probability, under $H_0$, of data as extreme as observed (or more).
4. Compare to significance level $\alpha$ (e.g. $0.05$).
5. Report **effect size** and a CI — not only reject/fail-to-reject.

```text
  H0 true world ──► sampling distribution of T
                         │
                    observed t_obs
                         │
                    tail probability = p
                         │
              p < α ? ──yes──► reject H0
                     └──no───► do not reject H0
```

## 4. Type I, Type II, power

| | $H_0$ true | $H_0$ false |
|--|------------|-------------|
| Reject $H_0$ | Type I error ($\alpha$) | correct (power) |
| Keep $H_0$ | correct | Type II error ($\beta$) |

**Power** $=1-\beta$ increases with larger $n$, larger true effect, smaller noise, and (sometimes) better design.

## 5. Two-proportion A/B sketch

Conversion rates $\hat p_A$, $\hat p_B$ with sizes $n_A$, $n_B$.

Pooled proportion under $H_0:p_A=p_B$:

$$
\hat p=\frac{x_A+x_B}{n_A+n_B},\quad
z=\frac{\hat p_A-\hat p_B}{\sqrt{\hat p(1-\hat p)(1/n_A+1/n_B)}}.
$$

Always pair the test with a **CI for $p_A-p_B$** and a business threshold (0.1% lift may be statistically significant and operationally irrelevant — or the reverse).

## 6. Multiple testing

Running $m$ independent tests at $\alpha=0.05$ yields expected $m\alpha$ false positives under global null.

Controls:

- **Bonferroni:** use $\alpha/m$ (conservative).
- **FDR** (Benjamini–Hochberg): control expected fraction of false discoveries among rejects.

```text
  tests: T1 T2 T3 ... Tm
  without correction → false alarms accumulate
  with FDR/Bonferroni → threshold adapted
```

## 7. Sample size (ballpark)

For a z-test on means, detecting difference $\delta$ with variance $\sigma^2$, power related to

$$
n \propto \frac{\sigma^2}{\delta^2}.
$$

Halving the detectable effect roughly **quadruples** required $n$.

## 8. Pitfalls

| Pitfall | Fix |
|---------|-----|
| “p=0.04 proves H1 true” | p is tail prob under H0 only |
| Peeking at dashboards then testing | pre-register or sequential methods |
| Tiny effect, huge $n$, “significant” | report effect size + CI |
| Underpowered study | compute power *before* launch |
| p-hacking many metrics | multiple-testing control / primary metric |

## 9. Worked mini example

$n=100$, $\bar x=52$, $s=10$. 95% CI for mean (large-sample):

$$
52 \pm 1.96\cdot \frac{10}{10}=52\pm 1.96=[50.04, 53.96].
$$

Test $H_0:\mu=50$ vs two-sided: $z=(52-50)/(10/\sqrt{100})=2$, p≈0.045 → reject at 5%, but effect is only 2 units — interpret practically.

## Exercises

1. Compute a 95% CI given $\bar x=12$, $s=4$, $n=64$ (normal/large-sample).
2. For the CI in (1), what happens to width if $n$ becomes $256$?
3. Define Type I and Type II in an A/B test for “new checkout converts better.”
4. Explain why a 95% CI and a two-sided test at $\alpha=0.05$ are linked.
5. You run 20 independent tests of null features at $\alpha=0.05$. Expected false positives under all-null?
6. **Design:** Want to detect lift $\delta=0.02$ in conversion with baseline $p=0.1$. Qualitatively, why is $n$ large?
7. Distinguish **confidence interval** vs **prediction interval** for a new observation.

## Quick checks

1. $12\pm 1.96\cdot 0.5 \approx [11.02, 12.98]$.  
2. Width halves when $n\times 4$.  
5. About $1$ false positive in expectation.  
7. CI for mean parameter; prediction interval for a new draw (wider).
