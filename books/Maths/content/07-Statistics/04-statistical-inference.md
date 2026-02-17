# Statistical Inference: Confidence and Hypothesis Tests

## 1. Goal of Inference

Use sample data to make probabilistic statements about unknown population parameters.

## 2. Confidence Intervals

For sample mean (large n):

`xbar +- z_{alpha/2} * s/sqrt(n)`.

Interpretation: long-run procedure coverage, not probability statement about fixed parameter after observing data.

## 3. Hypothesis Testing Workflow

1. State `H0` and `H1`
2. Choose statistic
3. Compute p-value
4. Compare against `alpha`
5. Report effect size and uncertainty

## 4. Type I and Type II Errors

- Type I: false alarm (`alpha`)
- Type II: miss
- Power: `1-beta`

## 5. Multiple Testing

Repeated tests inflate false positive rate.
Use controls like Bonferroni or FDR methods.

## 6. Worked A/B Test Example

Difference in conversion rates with two-proportion z-test.
Include confidence interval and practical effect interpretation.

## 7. Common Pitfalls

- p-value misinterpretation
- ignoring practical significance
- peeking without correction
- underpowered experiments

## Exercises

1. Compute 95% CI from sample mean/std/size.
2. Run one-sample t-test on toy data.
3. Explain difference between confidence interval and prediction interval.
4. Calculate required sample size for target detectable effect.
