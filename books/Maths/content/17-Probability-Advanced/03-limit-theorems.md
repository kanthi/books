# Law of Large Numbers and Central Limit Theorem

## 1. Law of Large Numbers (LLN)

For i.i.d. `X_i` with mean `mu`, sample average
`Xbar_n = (1/n)sum X_i` converges to `mu`.

Interpretation: repeated sampling stabilizes estimates.

## 2. Weak vs Strong LLN

- Weak LLN: convergence in probability
- Strong LLN: almost sure convergence

## 3. Central Limit Theorem (CLT)

For i.i.d variables with finite variance `sigma^2`:

`(Xbar_n - mu)/(sigma/sqrt(n)) -> N(0,1)` in distribution.

CLT explains why normal approximations appear broadly.

## 4. Consequences

- approximate confidence intervals
- hypothesis testing foundations
- Monte Carlo error rates

## 5. Berry-Esseen Intuition

CLT approximation quality depends on sample size and tail behavior; convergence speed is finite, not instant.

## 6. Worked Example

If request latency has mean 100ms, std 30ms, sample size 64:
std error = `30/sqrt(64)=3.75ms`.
Approximate 95% mean interval uses normal multiplier ~1.96.

## Exercises

1. Simulate CLT for Bernoulli variables with increasing n.
2. Explain why heavy tails can slow normal approximation quality.
3. Derive standard error for sample mean.
4. Compare LLN and CLT in terms of what each guarantees.
