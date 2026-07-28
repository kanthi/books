# Random Variables and Distributions

Random variables (RVs) attach numbers to uncertain outcomes so we can compute probabilities, expectations, and algorithms that depend on chance. This chapter builds discrete and continuous RVs, CDFs, standard families, and CS-facing approximations.

## 1. Random variables

**Definition.** On a probability space $(\Omega,\mathcal{F},P)$, a random variable is a measurable function $X:\Omega\to\mathbb{R}$.

- **Discrete:** countable image; **PMF** $p_X(x)=P(X=x)$ with $\sum_x p_X(x)=1$
- **Continuous:** **PDF** $f_X$ with $P(X\in A)=\int_A f_X(x)\,dx$ and $\int f_X=1$
- **Mixed:** atoms + density (e.g. spike-and-slab)

**CDF:** $F_X(t)=P(X\le t)$, always defined, nondecreasing, right-continuous, $F(-\infty)=0$, $F(+\infty)=1$.

### Worked example 1

Die fair: $p(k)=1/6$ for $k=1..6$. $F(3.2)=P(X\le 3.2)=1/2$.

### Worked example 2

Uniform$(0,1)$: $f(x)=1$ on $(0,1)$, $F(t)=t$ for $t\in[0,1]$.

## 2. Transformations

If $Y=g(X)$ monotone smooth on support of continuous $X$,

$$
f_Y(y)=f_X(x(y))\left|\frac{dx}{dy}\right|.
$$

### Worked example 3

$X\sim N(0,1)$, $Y=\mu+\sigma X\Rightarrow Y\sim N(\mu,\sigma^2)$.

### Worked example 4 — inverse transform sampling

If $U\sim\mathrm{Unif}(0,1)$ and $F$ invertible, $X=F^{-1}(U)$ has CDF $F$. Basis of many generators.

## 3. Discrete families

| Family | PMF / meaning | CS use |
|--------|---------------|--------|
| Bernoulli$(p)$ | success bit | clicks, errors |
| Binomial$(n,p)$ | # successes in $n$ trials | A/B counts |
| Geometric$(p)$ | trials until first success | retries |
| Poisson$(\lambda)$ | rare events count | arrivals, defects |
| Zipf / power-law | heavy rank frequencies | words, degrees |

### Worked example 5 — Poisson limit

$n\to\infty$, $p\to 0$, $np\to\lambda$: $\mathrm{Bin}(n,p)\Rightarrow\mathrm{Poisson}(\lambda)$. Models rare hash collisions / faults.

**Theorem (Poisson approximation sketch).** Expand binomial coefficient and $(1-p)^{n-k}\to e^{-\lambda}$ under $np=\lambda$.

## 4. Continuous families

| Family | Density highlight | CS use |
|--------|-------------------|--------|
| Uniform$(a,b)$ | flat | sampling, hashing mods (care) |
| Normal$(\mu,\sigma^2)$ | bell; CLT limit | noise, asymptotics |
| Exponential$(\lambda)$ | $f(x)=\lambda e^{-\lambda x}$ $x>0$ | interarrival, memoryless |
| Gamma / Erlang | sums of exponentials | waiting times |
| Beta$(\alpha,\beta)$ | on $(0,1)$ | Bayesian rates |
| Log-normal | $\log X$ normal | some size distributions |

### Worked example 6 — Gaussian tails

$P(|Z|>3)\approx 0.0027$ for standard normal—rule-of-thumb anomaly thresholds (with caution on non-Gaussian data).

## 5. Memoryless property

**Theorem.** Among discrete laws on $\{1,2,\ldots\}$, geometric is memoryless:

$$
P(X>s+t\mid X>s)=P(X>t).
$$

Among continuous positive laws, exponential is memoryless.

### Worked example 7

Packet retransmission geometric trials: remaining trials given failures so far has the same law—modeling simplification (and limitation if wear-out exists).

## 6. Joint distributions and independence

Joint PMF $p(x,y)$; marginal $p_X(x)=\sum_y p(x,y)$.  
**Independence:** $p(x,y)=p_X(x)p_Y(y)$ (or $f(x,y)=f_X f_Y$).

**Conditional:** $p(x\mid y)=p(x,y)/p_Y(y)$.

### Worked example 8

Two independent Poissons: sum is Poisson. Not true for arbitrary families.

### Worked example 9 — Bayes in classification

$P(Y\mid X)\propto P(X\mid Y)P(Y)$—Naive Bayes assumes feature independence given class.

## 7. Quantiles and heavy tails

The $p$-quantile $q_p=\inf\{t:F(t)\ge p\}$. Medians are $q_{1/2}$.

Heavy tails: $P(|X|>t)$ decays slower than exponential; variance may be infinite—sample means unstable.

### Worked example 10 — Pareto

$P(X>x)=(x_m/x)^\alpha$ for $x\ge x_m$. If $\alpha\le 2$, variance infinite.

## 8. Moment-generating / characteristic functions (awareness)

$M(t)=\mathbb{E}[e^{tX}]$ (when finite) determines distributions and eases sums of independents. Characteristic function $\mathbb{E}[e^{itX}]$ always exists—tool for CLT proofs.

## 9. Pitfalls

1. Continuous RVs: $P(X=x)=0$ always for densities  
2. Misusing normal for bounded data without transform  
3. Assuming uniqueness of mean as “typical” under skew  
4. Independence assumed for convenience, false in time series  
5. Integer Poisson vs continuous approx without continuity correction when needed  

## 10. Checkpoint

- Define PMF/PDF/CDF and compute simple probabilities  
- Use Poisson approximation appropriately  
- State memoryless laws  
- Factor joints under independence  
- Discuss quantiles vs means for SLO metrics  

## Exercises

### Easy

1. Compute $P(X\ge 2)$ for $X\sim\mathrm{Bin}(5,1/2)$.
2. CDF of Exponential$(\lambda)$; median in terms of $\lambda$.
3. If $X\sim\mathrm{Unif}(0,1)$, law of $Y=-\log X$?
4. Show Bernoulli variance $p(1-p)$.
5. Give a joint PMF on $\{0,1\}^2$ with dependent coordinates.

### Medium

6. Prove geometric memoryless property from the PMF.
7. Derive Poisson limit from binomial (complete the algebra).
8. If $X,Y$ i.i.d. Exp$(\lambda)$, show $\min(X,Y)\sim\mathrm{Exp}(2\lambda)$.
9. For Normal, standardize $P(X\le a)$ via $\Phi$.
10. Zipf: argue why mean of degrees can be dominated by hubs.

### Challenge

11. Inverse transform: prove $F^{-1}(U)$ has CDF $F$ for continuous strictly increasing $F$.
12. Show that memoryless continuous positive RVs must be exponential (outline).
13. Mixture: $X\mid Z=z\sim N(z,1)$, $Z\sim N(0,\tau^2)$—marginal of $X$?
14. Total variation distance between $\mathrm{Bin}(n,p)$ and Poisson$(np)$ bound statement (Le Cam).
15. Systems: model request arrivals as Poisson process; relate interarrivals to Exp.

## Summary

RVs and standard families are the vocabulary of stochastic modeling. CDFs unify discrete and continuous; Poisson and normal approximations connect combinatorics and limits; memoryless laws and independence assumptions power algorithms—and must be checked against data.
