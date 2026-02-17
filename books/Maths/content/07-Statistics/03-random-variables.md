# Random Variables and Common Distributions

## 1. From Outcomes to Variables

A random variable maps experiment outcomes to numerical values.

- Discrete variables use PMF
- Continuous variables use PDF/CDF

## 2. CDF Properties

`F(x)=P(X<=x)` is:
- monotone non-decreasing
- right-continuous
- tends to 0 at `-infinity` and 1 at `+infinity`

## 3. Important Distributions

### Bernoulli / Binomial

Useful for success/failure modeling and repeated trials.

### Poisson

Models event counts in fixed interval with rate `lambda`.

### Normal

Central model for aggregated noise due to CLT.

### Exponential

Waiting time model in Poisson process.

## 4. Moments

- mean
- variance
- skewness/kurtosis (shape diagnostics)

## 5. Worked Examples

1. If `X~Binomial(10,0.4)`, compute `E[X]=4`, `Var(X)=2.4`.
2. If `X~Poisson(5)`, `P(X=0)=e^-5`.

## 6. CS Use Cases

- failures per hour (Poisson)
- latency jitter (normal approximation)
- retries to success (geometric)

## Exercises

1. Compute CDF from PMF for a 3-point discrete variable.
2. Derive variance of Bernoulli.
3. Simulate Poisson arrivals and compare empirical histogram.
4. Explain when normal approximation to binomial is poor.
