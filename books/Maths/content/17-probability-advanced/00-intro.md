# Advanced Probability for CS and AI

Probability is the mathematics of uncertainty. Advanced probability for CS/AI goes beyond coin flips: random variables and tails, concentration, limit theorems, Bayesian updating, and stochastic processes (especially Markov chains) that model systems over time.

## Why go beyond “basic stats”

| Task | Probability tool |
|------|------------------|
| Generalization bounds | Concentration inequalities |
| A/B testing at scale | CLT, sequential tests |
| Reliability / SLOs | Tail probabilities, Markov models |
| Bayesian ML | Priors, posteriors, predictives |
| MCMC / sampling | Markov chain stationary laws |
| Queues, caches | Birth-death / Markov processes |
| Randomized algorithms | Expectation + high probability |

## Learning path

```text
flow:
  B -> C
  B -> D
  C -> E
  D -> F
  E -> F
```

## Random experiments and models

A **probability space** $(\Omega,\mathcal{F},P)$ underpins everything; CS practice often works with explicit PMFs/PDFs and independence assumptions. Always ask: what is random—data, noise, algorithm coins, or adversary?

### Worked example 1

Hashing analysis: randomness over hash function choice. ML: randomness over training sample. Both use expectation, but the measure differs.

### Worked example 2 — heavy tails

Latency distributions often have heavy tails; means can mislead SLOs. Medians and quantiles need different concentration tools than sub-Gaussian bounds.

## Roadmap of chapters

1. Random variables and distributions  
2. Expectation, variance, covariance  
3. LLN, CLT, and consequences  
4. Bayesian inference  
5. Markov chains  

## Prerequisites

Discrete probability, basic calculus (for continuous densities), comfort with sums/series. Linear algebra helps for Markov chains ($\pi P=\pi$).

## Three calculation templates

### Expectation via indicators

To count events $A_i$, set $X=\sum_i \mathbf{1}_{A_i}$. Then $\mathbb{E}[X]=\sum_i P(A_i)$ even when the $A_i$ are dependent. This single trick powers balls-and-bins, hashing, and randomized algorithm analyses.

### Concentration sketch

Markov/Chebyshev give weak tails; Chernoff/Hoeffding give exponential tails for bounded or sub-Gaussian sums. High-probability bounds turn “expected $O(f(n))$” into “$O(f(n))$ except with probability $n^{-c}$.”

### Bayes update

Posterior $\propto$ likelihood $\times$ prior. For conjugate pairs (Beta–Binomial, Normal–Normal), the update is closed form; otherwise use MCMC or variational methods.

### Worked example 3 — A/B test math stack

Conversion indicators Bernoulli; difference of means; CLT se; optional Beta posteriors for $P(p_A>p_B\mid\mathrm{data})$. Same product question, multiple probabilistic languages.

### Worked example 4 — PageRank as probability

Random surfer is a Markov chain; rank is stationary mass. Teleportation ensures irreducibility so the stationary distribution exists and is unique.

## Measure-theoretic honesty (light)

Advanced texts use $\sigma$-algebras and almost-sure statements. For this book, discrete PMFs and continuous PDFs suffice, with the warning that continuous densities need care ($P(X=x)=0$) and that “with probability 1” is stronger than “in expectation.”

## Pitfalls

1. Assuming i.i.d. when data are dependent  
2. Confusing almost-sure, in-probability, and in-distribution convergence  
3. Using normal approximations for tiny $n$ or infinite variance  
4. Priors that dominate small data without noticing  
5. Mixing ensemble averages with time averages without ergodicity  
6. Treating correlation as independence  

## Checkpoint

- Name five CS uses of advanced probability  
- Distinguish PMF, PDF, CDF  
- State LLN and CLT in one line each  
- Write Bayes’ rule for parameters  
- Define Markov property  

## Exercises

1. Give examples of discrete vs continuous RVs in systems telemetry.
2. Why might $\mathbb{E}[T]$ be infinite for a positive RV used as a timer? (heavy tail sketch)
3. Explain independence vs uncorrelatedness.
4. What does “95% confidence interval” **not** mean about a fixed $\theta$?
5. Sketch a two-state Markov chain for a machine up/down model.
6. When does Monte Carlo integration error scale as $1/\sqrt{n}$?
7. Bayesian vs frequentist one-paragraph contrast on a coin bias.
8. Checkpoint: pick a randomized algorithm and identify the probability space.

## Summary

This part upgrades probability from formulas to modeling discipline: distributions, moments, limits, Bayesian updates, and Markov dynamics—the probabilistic spine of modern computing and ML.
