# Regression and Experimental Design

## 1. Regression Model

`y = Xbeta + epsilon`.

Ordinary least squares finds `beta` minimizing squared residuals.

## 2. Assumptions (Classical OLS)

- linear relation in parameters
- independent errors
- zero-mean errors
- constant variance (homoscedasticity)
- low multicollinearity

## 3. Diagnostics

- residual vs fitted plot
- QQ plot for residual shape
- leverage/influence points
- variance inflation factor

## 4. Correlation vs Causation

Regression on observational data does not imply causal effect.
Need design/identification strategy.

## 5. Experimental Design

- randomization
- control group
- blocking/stratification
- blinding
- power and sample size

## 6. Worked CS Example

Model page-load time impact on bounce probability.
Discuss confounders and why randomized rollout gives stronger causal claim.

## Exercises

1. Fit simple linear regression and interpret coefficients.
2. Construct case where omitted variable biases estimate.
3. Design A/B test with control of one major confounder.
4. Explain why randomization supports causal inference.
