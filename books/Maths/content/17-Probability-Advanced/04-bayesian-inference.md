# Bayesian Inference

## 1. Bayes Rule

`P(theta|data) = P(data|theta)P(theta)/P(data)`.

Components:
- Prior `P(theta)`
- Likelihood `P(data|theta)`
- Posterior `P(theta|data)`
- Evidence `P(data)`

## 2. Conjugate Priors

Conjugacy gives posterior in same family:

- Beta prior + Bernoulli/Binomial likelihood -> Beta posterior
- Gamma prior + Poisson likelihood -> Gamma posterior
- Normal prior + Normal likelihood -> Normal posterior

## 3. Beta-Binomial Worked Example

Prior `Beta(2,2)` and observe 8 successes, 2 failures.
Posterior: `Beta(10,4)`.
Posterior mean: `10/(10+4)=0.714...`.

## 4. MAP vs MLE

- MLE maximizes likelihood only
- MAP maximizes posterior (likelihood + prior)

MAP adds regularization-like effect.

## 5. Predictive Distribution

Goal is often `P(new data | observed data)`, not only parameter estimate.

## 6. Practical Computation

Closed form for conjugate cases; otherwise use approximate methods:
- Laplace approximation
- MCMC
- variational inference

## Exercises

1. Update Beta(1,1) after 3 successes and 1 failure.
2. Compare posterior means under weak vs strong priors.
3. Explain why MAP can outperform MLE on small data.
4. Derive posterior for Gaussian mean with known variance.
