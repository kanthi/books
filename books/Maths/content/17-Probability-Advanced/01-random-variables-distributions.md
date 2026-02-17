# Random Variables and Distributions

## 1. Random Variables

A random variable (RV) maps outcomes to numeric values.

- Discrete RV: countable support, PMF `p(x)=P(X=x)`
- Continuous RV: density `f(x)`, with probabilities as integrals

CDF always defined:
`F_X(t)=P(X<=t)`.

## 2. Core Distribution Families

### Discrete

- Bernoulli(p)
- Binomial(n,p)
- Geometric(p)
- Poisson(lambda)

### Continuous

- Uniform(a,b)
- Normal(mu,sigma^2)
- Exponential(lambda)

## 3. Theorem (Poisson Approximation)

If `n` large and `p` small with `np=lambda`, then `Binomial(n,p)` approximates `Poisson(lambda)`.

Proof sketch from limit of binomial PMF.

## 4. Memoryless Property

Only geometric (discrete) and exponential (continuous) are memoryless:

`P(X>s+t|X>s)=P(X>t)`.

## 5. Worked CS Examples

1. Retries until success -> geometric model.
2. Request arrivals per minute -> Poisson model.
3. Sensor noise -> often normal approximation.

## 6. Distribution Selection Checklist

- Is variable count-like or real-valued?
- Is support bounded or unbounded?
- Is process arrival-based?
- Is approximation acceptable?

## Exercises

1. Compute mean and variance of Binomial(20,0.3).
2. Evaluate `P(X>=3)` for Poisson(2).
3. Prove CDF of any RV is non-decreasing and right-continuous.
4. Show exponential is memoryless by direct calculation.
