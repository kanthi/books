# Law of Large Numbers and Central Limit Theorem

Limit theorems explain why averages stabilize and why normal distributions appear throughout science and engineering. They justify confidence intervals, Monte Carlo error rates, and many ML asymptotics.

## 1. Modes of convergence (brief)

For RVs $X_n$, $X$:

- **In probability:** $P(|X_n-X|>\varepsilon)\to 0$ for every $\varepsilon>0$
- **Almost sure:** $P(\{\omega: X_n(\omega)\to X(\omega)\})=1$
- **In distribution:** $F_{X_n}(t)\to F_X(t)$ at continuity points of $F_X$
- **In $L^p$:** $\mathbb{E}|X_n-X|^p\to 0$

Implications (roughly): a.s. $\Rightarrow$ in prob $\Rightarrow$ in distribution; $L^2\Rightarrow$ in prob. CLT is in distribution; strong LLN is a.s.

## 2. Law of large numbers

Let $X_i$ i.i.d. with $\mathbb{E}|X_1|<\infty$, $\mu=\mathbb{E}[X_1]$, $\bar X_n=\frac1n\sum_{i=1}^n X_i$.

**Weak LLN:** $\bar X_n\to\mu$ in probability.  
**Strong LLN:** $\bar X_n\to\mu$ almost surely.

### Interpretation

Long-run sample averages track the true mean. Foundation of Monte Carlo, empirical risk, and frequency interpretation of probability.

### Worked example 1

Coin flips: $\bar X_n\to p$. After $10^4$ flips, typically within $O(1/\sqrt{n})$ of $p$ (see CLT).

### Worked example 2 — Monte Carlo integration

$\mathbb{E}[g(U)]\approx\frac1n\sum g(U_i)$ for $U_i\sim\mathrm{Unif}$. Error typically $O_p(\sigma/\sqrt{n})$.

## 3. Proof sketch of weak LLN (finite variance)

If $\mathrm{Var}(X_i)=\sigma^2<\infty$, then $\mathrm{Var}(\bar X_n)=\sigma^2/n$. Chebyshev:

$$
P(|\bar X_n-\mu|\ge\varepsilon)\le\frac{\sigma^2}{n\varepsilon^2}\to 0.
$$

(Full strong LLN needs more machinery.)

## 4. Central limit theorem

**Theorem (classical CLT).** $X_i$ i.i.d. with mean $\mu$ and variance $\sigma^2\in(0,\infty)$. Then

$$
Z_n=\frac{\bar X_n-\mu}{\sigma/\sqrt{n}} \xrightarrow{d} N(0,1).
$$

Equivalently $\sqrt{n}(\bar X_n-\mu)\xrightarrow{d} N(0,\sigma^2)$.

### Worked example 3 — SE of the mean

Standard error $\mathrm{se}=\sigma/\sqrt{n}$. Estimated by $s/\sqrt{n}$ with sample sd $s$.

### Worked example 4 — latency

Mean 100 ms, sd 30 ms, $n=64$: $\mathrm{se}=3.75$ ms. Approx 95% CI for mean: $100\pm 1.96\cdot 3.75$.

### Worked example 5 — binomial / polls

$\hat p=\bar X$ for Bernoulli: $\mathrm{se}\approx\sqrt{\hat p(1-\hat p)/n}$. Rule of thumb $n\hat p\ge 10$ etc. for normal approx quality.

## 5. Lindeberg / Lyapunov (awareness)

CLT extends beyond identical distributions under Lindeberg conditions—important for triangular arrays and some dependent settings (with extra work).

## 6. Berry–Esseen (rate)

Bounds $\sup_t |P(Z_n\le t)-\Phi(t)|$ by $O(\rho/(\sigma^3\sqrt{n}))$ involving third moments. Message: convergence rate is about $1/\sqrt{n}$, worse with heavy skew/kurtosis.

### Worked example 6 — skewed Bernoulli

$p=0.01$: need larger $n$ for $\hat p$ normal approx than for $p=0.5$.

## 7. Delta method

If $\sqrt{n}(\hat\theta_n-\theta)\to N(0,\tau^2)$ and $g$ differentiable at $\theta$ with $g'(\theta)\neq 0$, then

$$
\sqrt{n}(g(\hat\theta_n)-g(\theta))\to N(0,(g'(\theta))^2\tau^2).
$$

### Worked example 7

$g(p)=\mathrm{logit}(p)$ or $g=\log$ for positive parameters—SEs for transformed estimates.

## 8. Multivariate CLT

$\sqrt{n}(\bar X_n-\mu)\to N(0,\Sigma)$ for i.i.d. vectors with covariance $\Sigma$. Basis of multivariate confidence ellipsoids and Wald tests.

## 9. Consequences in CS/ML

| Application | Use of LLN/CLT |
|-------------|----------------|
| Empirical risk $\to$ risk | LLN (uniform versions need VC/Rademacher) |
| Bootstrap | often justified by CLT-like behavior |
| A/B test $z$-tests | CLT for means |
| SGD noise | asymptotic normality results (advanced) |
| Hashing load | concentration + CLT approximations |

### Worked example 8 — Monte Carlo error

To cut error in half, need $\approx 4\times$ samples ($1/\sqrt{n}$ law)—fundamental budgeting fact.

### Worked example 9 — why not $1/n$ error?

Average of independents has variance $1/n$; sd $1/\sqrt{n}$. Unless using variance reduction / QMC, you rarely beat this without structure.

## 10. When CLT fails

- Infinite variance (stable laws with heavy tails)  
- Strong dependence (long memory)  
- Non-identical extremes dominated by one term  
- Very small $n$  

### Worked example 10 — Cauchy

Sample mean of Cauchy does **not** concentrate on a mean (undefined)—LLN fails.

## 11. Pitfalls

1. “CLT says data are normal”—no, **means** are approximately normal  
2. 95% CI does not mean $P(\theta\in\mathrm{CI}\mid\mathrm{data})=0.95$ in frequentist interpretation  
3. Multiple looks without correction  
4. Using $z$ critical values with tiny $n$ and unknown variance ($t$ better)  
5. Ignoring dependence in time series SE  

## 12. Checkpoint

- State weak LLN and classical CLT  
- Compute se of the mean  
- Build a normal CI for a mean  
- Explain $1/\sqrt{n}$ Monte Carlo rate  
- Know when normal approximation is shaky  

## Exercises

### Easy

1. If $\sigma=2$, how large $n$ so Chebyshev guarantees $P(|\bar X-\mu|\ge 0.5)\le 0.05$?
2. SE for $\hat p$ when $n=1000$, $\hat p=0.4$.
3. Simulate (mentally) why averaging reduces noise.
4. Distinguish convergence in probability vs distribution with one sentence each.
5. CI for mean: write formula with known $\sigma$.

### Medium

6. Prove weak LLN via Chebyshev under finite variance.
7. Apply delta method to $g(\mu)=\mu^2$.
8. Binomial: continuity correction intuition for $P(X\le k)$.
9. Explain why $\bar X_n$ is consistent for $\mu$ (definition of consistency).
10. Multivariate: interpret $\Sigma$ diagonal vs strong off-diagonals for joint means.

### Challenge

11. Sketch proof idea of CLT via characteristic functions (expand $\log\phi$).
12. Berry–Esseen: discuss effect of third moment on needed $n$.
13. Counterexample: i.i.d. with infinite mean where $\bar X_n$ misbehaves.
14. Dependent vars: give example where $\mathrm{Var}(\bar X_n)\not\sim\sigma^2/n$.
15. Design: sample size for A/B test detecting effect $\delta$ with power $1-\beta$ (formula with $\sigma$).

## Summary

LLN guarantees stabilization of averages; CLT quantifies Gaussian fluctuations at scale $1/\sqrt{n}$. Together they underwrite estimation, testing, and Monte Carlo—while heavy tails, dependence, and small samples define their limits.
