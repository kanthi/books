# Hypothesis Testing for Data Work

A practical companion to formal inference: how data scientists use tests, what to report, and how not to fool yourself with dashboards.

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

Bad: “run t-tests on all columns.”  
Good: one **primary metric**, optional secondary, written before peeking.

## 2. Common tests (when)

| Situation | Typical tool |
|-----------|----------------|
| Mean vs constant | one-sample t |
| Two group means | two-sample t / Welch |
| Two proportions | z-test / χ² |
| Paired before/after | paired t |
| Many categories | χ² goodness / independence |
| Non-normal small n | rank tests / bootstrap |

## 3. Effect size always

Examples: difference of means, relative lift $(p_B-p_A)/p_A$, Cohen’s $d$.

A tiny lift can be “significant” with huge traffic and still not worth engineering cost.

## 4. Bootstrap intuition

Resample data with replacement many times; build empirical distribution of $\hat\theta$.

```text
  original sample:  ● ● ● ● ●
  bootstrap 1:      ● ● ● ● ●  (with replacement)
  bootstrap 2:      ● ● ● ● ●
  ...
  → histogram of θ̂*  → percentile CI
```

Great when analytic SE is messy; still assumes sample ≈ population of interest.

## 5. Multiple metrics and peeking

- Many KPIs ⇒ multiple testing.
- Continuous monitoring without correction ⇒ inflated false positives.
- Fix: primary metric, sequential testing methods, or holdout windows.

## 6. Practical report template

1. Hypothesis in plain language  
2. Population / time window / exclusions  
3. Sample sizes  
4. Estimator + CI  
5. Test + p-value (if used)  
6. Effect size vs practical threshold  
7. Caveats (bias, seasonality, interference)

## Exercises

1. Write $H_0,H_1$ for “new ranking increases CTR.”  
2. Why Welch’s t-test is often preferred over Student’s for two web variants?  
3. Bootstrap CI vs normal CI — one advantage each.  
4. You check the A/B dashboard every hour and stop when p<0.05. Name the problem.  
5. Compute rough 95% CI for mean with $\bar x=10$, $s=2$, $n=100$.  
6. **Scenario:** significance on revenue, not on latency — how do you decide ship?

## Checks

4. Optional stopping / p-hacking.  
5. $10\pm 1.96\cdot0.2\approx[9.61,10.39]$.
