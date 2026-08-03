# Sampling, Bias, and Representativeness

Data science fails when the **sample is not the population you care about**. This chapter is the math and discipline of sampling design, bias, and simple error bars for proportions/means.

## Diagram: target vs sample

```text
  target population  (who you want to claim about)
         │
         │  sampling frame (who you can reach)
         v
  sample S ⊂ frame
         │
         v
  estimate θ̂   ──?──►  θ for target
```

If frame ≠ target (missing groups, volunteers only), even huge $n$ does not save you.

## 1. Bias vs variance (estimators)

$$
\mathrm{MSE}(\hat\theta)=\mathrm{Bias}^2+\mathrm{Var}.
$$

```text
  high bias, low var     low bias, high var
      ●●●●●                  ●        ●
        ●●●●                   ●  ●
         ●●                      ●
```

## 2. Common sampling schemes

| Scheme | Idea | Watch-out |
|--------|------|-----------|
| Simple random | equal chance | needs full list |
| Stratified | sample within groups | need strata sizes |
| Cluster | sample groups then members | design effect |
| Convenience | easy data | often biased |

## 3. Selection bias examples

- Survivorship (only “winners” logged)
- Voluntary response (strong opinions over-represented)
- Temporal (train on past, deploy on shifted future)
- Leakage (feature contains label information)

## 4. Standard errors (quick formulas)

Sample mean, i.i.d., variance $\sigma^2$:

$$
\mathrm{SE}(\bar X)\approx \frac{s}{\sqrt{n}}.
$$

Sample proportion $\hat p$:

$$
\mathrm{SE}(\hat p)\approx\sqrt{\frac{\hat p(1-\hat p)}{n}}.
$$

**Margin of error** for 95% ≈ $1.96\cdot\mathrm{SE}$ (large sample).

## 5. Worked example

Poll $\hat p=0.52$, $n=1000$:

$$
\mathrm{SE}\approx\sqrt{0.52\cdot0.48/1000}\approx0.0158,\quad
\text{95% ME}\approx0.031.
$$

Report $52\%\pm 3.1\%$ (approx), not false precision.

## 6. Train / validation / test

```text
  all labeled data
       │
       ├── train (fit)
       ├── validation (tune hyperparameters)
       └── test (final estimate of risk)  ← touch once if possible
```

Reusing test for decisions = optimistic bias.

## Exercises

1. If SE must be half as large, how must $n$ change (i.i.d. mean)?  
2. Give a real-world convenience sample that misleads product metrics.  
3. Compute SE for $\hat p=0.1$, $n=400$.  
4. Why stratified sampling can beat simple random for the same $n$?  
5. Distinguish **sampling bias** vs **measurement bias**.  
6. **Design:** You only log users who click “Help”. What population is that?

## Checks

1. $n\times 4$.  
3. $\sqrt{0.09/400}=0.015$.
