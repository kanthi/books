# Random Variables and Common Distributions

A **random variable** turns the outcome of a random experiment into a number (or vector of numbers). Distributions are the rulebook for those numbers. This chapter is the bridge from “probability of events” to “models we can fit and simulate.”

## Diagram: the pipeline

```text
  sample space Ω
       │  ω outcome
       v
  X(ω) = number          ← random variable
       │
       ├── discrete:  PMF  p(x) = P(X=x)
       └── continuous: PDF f, CDF F
              │
              v
         E[X], Var(X), quantiles, simulations
```

## 1. Discrete vs continuous

| | Discrete | Continuous |
|--|----------|------------|
| Values | countable | intervals of reals |
| Law | PMF $p(x)$ | PDF $f(x)$ with $\int f=1$ |
| Probabilities | sum of PMF | areas under PDF |
| $P(X=a)$ | may be positive | usually $0$ for continuous |

**CDF** (always defined): $F(x)=P(X\le x)$.

Properties of $F$:

- non-decreasing
- right-continuous (standard construction)
- $\lim_{x\to-\infty}F(x)=0$, $\lim_{x\to+\infty}F(x)=1$

For continuous $X$ with PDF $f$: $F'(x)=f(x)$ where continuous, and

$$
P(a<X\le b)=F(b)-F(a)=\int_a^b f(t)\,dt.
$$

## 2. Expectation and variance

Discrete:

$$
\mathbb{E}[X]=\sum_x x\,p(x),\qquad
\mathrm{Var}(X)=\mathbb{E}[X^2]-(\mathbb{E}[X])^2.
$$

Continuous: replace sum by integral against $f$.

**Linearity always:** $\mathbb{E}[aX+bY]=a\mathbb{E}[X]+b\mathbb{E}[Y]$ (no independence needed).

**Variance of independent sum:** $\mathrm{Var}(X+Y)=\mathrm{Var}(X)+\mathrm{Var}(Y)$ if independent.

## 3. Catalog of workhorse distributions

### Bernoulli($p$)

$X\in\{0,1\}$, $P(X=1)=p$.  
$\mathbb{E}[X]=p$, $\mathrm{Var}(X)=p(1-p)$.

### Binomial($n,p$)

Number of successes in $n$ independent Bernoulli trials:

$$
P(X=k)=\binom{n}{k}p^k(1-p)^{n-k},\quad k=0,\ldots,n.
$$

$\mathbb{E}[X]=np$, $\mathrm{Var}(X)=np(1-p)$.

```text
  trial:  · · · · · · · · · ·   n flips
  success? Y N Y Y N ...
  X = count of Y
```

### Geometric($p$) (trials until first success)

$\mathbb{E}[X]=1/p$ (if $X$ counts trials). Model for retries until success.

### Poisson($\lambda$)

Counts of rare events in a fixed window:

$$
P(X=k)=e^{-\lambda}\frac{\lambda^k}{k!}.
$$

$\mathbb{E}[X]=\mathrm{Var}(X)=\lambda$.

### Exponential($\lambda$)

Waiting time between Poisson events; PDF $f(x)=\lambda e^{-\lambda x}$ for $x\ge 0$.  
**Memoryless:** $P(X>s+t\mid X>s)=P(X>t)$.

### Normal($\mu,\sigma^2$)

$$
f(x)=\frac{1}{\sigma\sqrt{2\pi}}\exp\Big(-\frac{(x-\mu)^2}{2\sigma^2}\Big).
$$

CLT: averages of i.i.d. noise often look approximately normal.

```text
                 ****
              **      **
           **            **
        **                  **
  -----*----------------------*-----  x
            μ-σ   μ   μ+σ
```

### Uniform($a,b$)

Equal density on $[a,b]$; base case for inverse-transform sampling.

## 4. Worked examples

**Example A.** $X\sim\mathrm{Binomial}(10,0.4)$.  
$\mathbb{E}[X]=4$, $\mathrm{Var}(X)=10\cdot0.4\cdot0.6=2.4$.

**Example B.** $X\sim\mathrm{Poisson}(5)$.  
$P(X=0)=e^{-5}\approx 0.0067$.

**Example C (standardize).** $X\sim N(\mu,\sigma^2)$, then $Z=(X-\mu)/\sigma\sim N(0,1)$.  
$P(X\le \mu+1.96\sigma)\approx 0.975$.

**Example D (CDF from PMF).** Support $\{0,1,2\}$ with $p=(0.2,0.5,0.3)$:

| $x$ | $F(x)$ |
|-----|--------|
| $0$ | $0.2$ |
| $1$ | $0.7$ |
| $2$ | $1.0$ |

## 5. Computer science map

| Model | CS use |
|-------|--------|
| Bernoulli / Binomial | A/B click, bit errors |
| Poisson | requests/sec, packet counts |
| Exponential | inter-arrival, simple reliability |
| Geometric | retry loops |
| Normal | measurement noise, CLT for metrics |
| Uniform | hash bucket idealization, RNG base |

## 6. How to choose a distribution (checklist)

1. Discrete counts or continuous measurements?
2. Bounded range or open-ended?
3. Rare events / memoryless waiting?
4. Symmetric noise around a mean?
5. Fit with QQ-plot / histogram vs model — don’t only “pick normal by default.”

## Exercises

1. **Derive** $\mathrm{Var}(X)$ for Bernoulli($p$) from $\mathbb{E}[X^2]-\mathbb{E}[X]^2$.
2. For $X\sim\mathrm{Binomial}(20,0.5)$, find $\mathbb{E}[X]$ and $\mathrm{Var}(X)$. Is $P(X=10)$ larger or smaller than $P(X=0)$? Why?
3. Build the CDF of a discrete RV with PMF $p(-1)=p(1)=1/4$, $p(0)=1/2$. Sketch the step function (ASCII is fine).
4. If failures arrive as Poisson($3$) per hour, approximate $P(\text{at least one failure in 20 minutes})$.
5. Explain in one paragraph when a normal approximation to Binomial($n,p$) is poor.
6. **Challenge:** Show memorylessness of Exponential: $P(X>s+t\mid X>s)=P(X>t)$.

## Quick answers (check after you try)

1. $p-p^2=p(1-p)$.  
2. Mean $10$, var $5$; $P(X=10)\gg P(X=0)$.  
4. Window $1/3$ hour → $\lambda=1$, $P(\ge 1)=1-e^{-1}$.  
5. When $np$ or $n(1-p)$ is small, or $n$ tiny — mass piles near boundary.
