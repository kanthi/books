# Sampling, Bias, and Representativeness

Data science fails when the **sample is not the population you care about**. This chapter covers sampling design, bias versus variance, standard errors for means and proportions, and the train/validation/test discipline that keeps estimates honest.

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

If frame ≠ target (missing groups, volunteers only), even huge $n$ does not save you. Precision is not validity.

## 1. Populations, frames, and units

| Concept | Meaning |
|---------|---------|
| Target population | group your claim is about |
| Sampling frame | list/process that can be sampled |
| Sampling unit | person, session, device, day, … |
| Observation | measured fields on a unit |

**Mismatch examples:** claim about all users, frame = users who opened the app last week; claim about households, unit = individuals.

## 2. Bias vs variance of estimators

For estimator $\hat\theta$ of $\theta$:

$$
\mathrm{Bias}(\hat\theta)=\mathbb{E}[\hat\theta]-\theta,
\qquad
\mathrm{Var}(\hat\theta)=\mathbb{E}[(\hat\theta-\mathbb{E}\hat\theta)^2],
$$

$$
\mathrm{MSE}(\hat\theta)=\mathrm{Bias}^2+\mathrm{Var}.
$$

```text
  high bias, low var     low bias, high var
      ●●●●●                  ●        ●
        ●●●●                   ●  ●
         ●●                      ●
```

- **Bias:** systematic error (wrong frame, bad instrument, leakage)  
- **Variance:** noise from finite samples (reduce with larger $n$ or better design)

Huge $n$ kills variance; it does **not** kill selection bias.

## 3. Common sampling schemes

| Scheme | Idea | Watch-out |
|--------|------|-----------|
| Simple random (SRS) | equal chance | needs full list |
| Stratified | sample within groups | need strata sizes / weights |
| Cluster | sample groups then members | design effect; larger SE |
| Systematic | every $k$-th unit | periodicity risk |
| Convenience | easy data | often biased |
| Snowball | recruit via networks | hidden population bias |

### Worked example 1 — stratification

Estimate mean income in a city with $20\%$ high-income, $80\%$ low. Stratify and sample both groups; weight by population shares. Variance of the overall mean often smaller than SRS for the same $n$ when strata means differ.

### Worked example 2 — cluster design effect

Randomly sample classrooms then students: students in a class correlate. Effective sample size $<n$; SEs from i.i.d. formulas are too optimistic without design correction.

## 4. Selection bias catalogue

| Bias | Mechanism |
|------|-----------|
| Survivorship | only “winners” logged |
| Voluntary response | strong opinions over-represented |
| Coverage | frame misses parts of target |
| Temporal / drift | train on past, deploy on shifted future |
| Attrition | dropouts differ from stayers |
| Leakage | feature contains label information |
| Berkson | conditioning on a collider induces fake associations |
| Length-biased | longer sessions more likely sampled |

### Worked example 3 — help-click logs

You only log users who click “Help.” Population = help seekers, not all users. Metrics of “confusion” do not generalize to power users who never click Help.

### Worked example 4 — survivorship in startups

Studying only surviving companies’ practices ignores failed companies that did the same things — classic survivorship bias.

## 5. Measurement bias vs sampling bias

- **Sampling bias:** wrong units enter the sample  
- **Measurement bias:** units OK, but instrument systematically wrong (bad sensor, leading survey question, timezone bugs)

Both bias $\hat\theta$; fixes differ (redesign sample vs recalibrate instrument).

## 6. Standard errors (quick formulas)

Assume i.i.d. sample for the formulas below (cluster samples need different SE).

**Sample mean**, variance $\sigma^2$ estimated by $s^2$:

$$
\mathrm{SE}(\bar X)\approx \frac{s}{\sqrt{n}}.
$$

**Sample proportion** $\hat p$:

$$
\mathrm{SE}(\hat p)\approx\sqrt{\frac{\hat p(1-\hat p)}{n}}.
$$

**Margin of error** for approximate 95% CI (large sample):

$$
\mathrm{ME}\approx 1.96\cdot\mathrm{SE}.
$$

### Scaling law

To **halve** SE for an i.i.d. mean, need **$4\times$** sample size ($1/\sqrt{n}$).

### Worked example 5 — poll

$\hat p=0.52$, $n=1000$:

$$
\mathrm{SE}\approx\sqrt{0.52\cdot 0.48/1000}\approx 0.0158,
\quad
\text{95% ME}\approx 0.031.
$$

Report $52\%\pm 3.1\%$ (approx), not $52.173\%$.

### Worked example 6

$\hat p=0.1$, $n=400$: $\mathrm{SE}=\sqrt{0.1\cdot 0.9/400}=\sqrt{0.09/400}=0.015$.

## 7. Weighting and post-stratification

If sample strata proportions differ from population, **reweight**:

$$
\hat\theta = \sum_s w_s \hat\theta_s,
$$

with $w_s$ population shares. Incorrect weights ⇒ bias; correct weights can increase variance.

## 8. Train / validation / test

```text
  all labeled data
       │
       ├── train (fit)
       ├── validation (tune hyperparameters)
       └── test (final estimate of risk)  ← touch once if possible
```

Reusing test for decisions = optimistic bias (a form of selection on the evaluation path).

**Time-series:** split by time, not i.i.d. shuffle — random splits leak the future.

**Grouped data:** split by user/entity so the same user is not in train and test.

## 9. Online A/B sampling notes

- Randomize **units** (users) not events when interference exists  
- Spillover / network effects bias treatment effect estimates  
- Novelty effects: short windows mislead  
- SRM (sample ratio mismatch): check assignment proportions  

## 10. Power and planning (tie-in)

Before collecting data, rough SE formulas plan $n$ for a desired ME. Underpowered studies produce noisy $\hat\theta$ and encourage p-hacking — see hypothesis-testing chapter.

## 11. Pitfalls

1. “$n$ is large so we are fine” under biased sampling  
2. i.i.d. SE on clustered data  
3. Shuffled CV on time-dependent logs  
4. Convenience samples sold as representative panels  
5. Training on label-leaking features  

## 12. Checkpoint

- Distinguish target, frame, sample  
- Write MSE = bias² + var  
- Apply SE formulas for mean and proportion  
- Halving SE needs $4\times n$  
- Name major selection biases  
- Design train/val/test without leakage  

## Exercises

### Easy

1. If SE must be half as large, how must $n$ change (i.i.d. mean)?  
2. Give a real-world convenience sample that misleads product metrics.  
3. Compute SE for $\hat p=0.1$, $n=400$.  
4. Distinguish **sampling bias** vs **measurement bias**.  
5. **Design:** You only log users who click “Help”. What population is that?  

### Medium

6. Why stratified sampling can beat simple random for the same $n$?  
7. Poll $\hat p=0.52$, $n=1000$: compute approximate 95% ME.  
8. Explain design effect for cluster sampling in one paragraph.  
9. Why random train/test splits fail for forecasting next month’s demand?  
10. Survivorship bias: invent a tech industry example.  

### Challenge

11. Derive $\mathrm{Var}(\hat p)=p(1-p)/n$ for i.i.d. Bernoulli.  
12. Post-stratification: write a weighted mean estimator with two strata.  
13. Berkson bias: sketch a collider diagram that induces a spurious correlation.  
14. Bootstrap SE vs analytic SE: when prefer bootstrap?  
15. Plan $n$ so that 95% ME for a proportion near $0.5$ is at most $0.02$.  

## Checks

1. $n\times 4$.  
3. $\sqrt{0.09/400}=0.015$.  
7. $\approx 3.1$ percentage points.  
15. $1.96\sqrt{0.25/n}\le 0.02$ ⇒ $n\gtrsim (1.96\cdot 0.5/0.02)^2\approx 2401$.  

## Summary

Good data science starts with **who is in the data**. Bias from frames and selection cannot be fixed by collecting the same wrong population faster. Variance shrinks with $n$ and smart design; standard errors quantify that under stated assumptions. Keep evaluation splits as clean as your sampling story — both are about whether $\hat\theta$ means what you say it means.
