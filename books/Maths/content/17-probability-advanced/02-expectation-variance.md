# Expectation, Variance, and Covariance

Expectation is the probability-weighted average; variance measures spread; covariance and correlation measure linear co-movement. These moments drive algorithm analysis, risk metrics, and the bias–variance decomposition in learning.

## 1. Expectation

**Discrete:** $\mathbb{E}[X]=\sum_x x\, p(x)$ (absolutely convergent when needed).  
**Continuous:** $\mathbb{E}[X]=\int_{-\infty}^{\infty} x f(x)\,dx$.

**Law of the unconscious statistician (LOTUS):**

$$
\mathbb{E}[g(X)]=\sum_x g(x)p(x)\quad\text{or}\quad\int g(x)f(x)\,dx,
$$

without finding the law of $g(X)$ first.

### Linearity (always true)

$$
\mathbb{E}[aX+bY+c]=a\mathbb{E}[X]+b\mathbb{E}[Y]+c,
$$

even when $X,Y$ dependent—most powerful property in CS proofs.

### Worked example 1 — indicator trick

If $A$ is an event, $\mathbf{1}_A$ has $\mathbb{E}[\mathbf{1}_A]=P(A)$. Counting: $X=\sum_i \mathbf{1}_{A_i}\Rightarrow\mathbb{E}[X]=\sum_i P(A_i)$ (linearity of expectation)—even with dependence.

### Worked example 2 — hashing collisions

Expected number of colliding pairs among $n$ balls $m$ bins: $\binom{n}{2}\cdot\frac1m$ order—classic.

### Worked example 3 — geometric mean trials

$\mathbb{E}[\mathrm{Geo}(p)]=1/p$ (trials until success, $P(X=k)=(1-p)^{k-1}p$).

## 2. Variance and standard deviation

$$
\mathrm{Var}(X)=\mathbb{E}[(X-\mathbb{E}[X])^2]=\mathbb{E}[X^2]-(\mathbb{E}[X])^2.
$$

$\mathrm{sd}(X)=\sqrt{\mathrm{Var}(X)}$.

**Scaling:** $\mathrm{Var}(aX+b)=a^2\mathrm{Var}(X)$.

### Worked example 4

Bernoulli: $\mathrm{Var}=p(1-p)\le 1/4$.  
Poisson$(\lambda)$: mean=variance=$\lambda$.  
Normal: $\mathrm{Var}=\sigma^2$ by definition of $N(\mu,\sigma^2)$.

### Worked example 5 — sum of independents

If $X\perp Y$, $\mathrm{Var}(X+Y)=\mathrm{Var}(X)+\mathrm{Var}(Y)$. Without independence, cross term $2\mathrm{Cov}$ appears.

## 3. Covariance and correlation

$$
\mathrm{Cov}(X,Y)=\mathbb{E}[(X-\mathbb{E}X)(Y-\mathbb{E}Y)]=\mathbb{E}[XY]-\mathbb{E}X\mathbb{E}Y.
$$

$$
\mathrm{Corr}(X,Y)=\frac{\mathrm{Cov}(X,Y)}{\mathrm{sd}(X)\mathrm{sd}(Y)}\in[-1,1]
$$

when sds positive.

**Cauchy–Schwarz:** $|\mathrm{Cov}(X,Y)|\le\mathrm{sd}(X)\mathrm{sd}(Y)$.

### Worked example 6

$\mathrm{Corr}= \pm 1$ iff $Y=aX+b$ a.s. with $a\neq 0$ (linear relationship almost surely).

### Worked example 7 — uncorrelated but dependent

$X$ symmetric $\pm 1$, $Y=X^2$ constant? Better: $X\sim\mathrm{Unif}\{-1,0,1\}$ carefully, or $X\sim N(0,1)$, $Y=X^2$: $\mathrm{Cov}(X,Y)=0$ but dependent. Classic: $X$ uniform on circle coordinates.

## 4. Conditional expectation

$\mathbb{E}[X\mid Y=y]$ is the mean of $X$ given $Y=y$. As a RV, $\mathbb{E}[X\mid Y]$ is a function of $Y$.

**Tower property:** $\mathbb{E}[\mathbb{E}[X\mid Y]]=\mathbb{E}[X]$.  
**Pull-out:** if $Y$ measurable w.r.t. condition, $\mathbb{E}[Y X\mid Y]=Y\mathbb{E}[X\mid Y]$.

### Worked example 8 — prediction

Under squared loss, $\mathbb{E}[Y\mid X=x]$ is the optimal predictor of $Y$ from $X$.

### Worked example 9 — bias-variance (regression)

For fixed $x$, decomposing $\mathbb{E}[(Y-\hat f(x))^2]$ yields noise + bias$^2$ + variance of $\hat f$.

## 5. Moment inequalities (starters)

**Markov:** $X\ge 0\Rightarrow P(X\ge t)\le\mathbb{E}[X]/t$.  
**Chebyshev:** $P(|X-\mu|\ge t)\le\mathrm{Var}(X)/t^2$.  
**Jensen:** for convex $\phi$, $\phi(\mathbb{E}X)\le\mathbb{E}\phi(X)$.

### Worked example 10 — Chebyshev CI sketch

Crude: $P(|\bar X_n-\mu|\ge t)\le \sigma^2/(n t^2)$. CLT gives tighter practical intervals.

### Worked example 11 — Jensen

$\mathbb{E}[X^2]\ge(\mathbb{E}X)^2$ recovers nonnegative variance.

## 6. Covariance matrices

For random vector $X\in\mathbb{R}^d$,

$$
\Sigma=\mathrm{Cov}(X)=\mathbb{E}[(X-\mu)(X-\mu)^\top]\succeq 0.
$$

Affine: $\mathrm{Cov}(AX+b)=A\Sigma A^\top$.

### Worked example 12 — PCA link

Principal components are eigenvectors of $\Sigma$ (or sample covariance)—directions of maximal variance.

## 7. CS applications

- Expected runtime of randomized algorithms  
- Load balancing: balls and bins expectations  
- Portfolio / risk: variance and covariance  
- Feature correlation screening (weak; prefer MI for nonlinear)  
- Kalman filters: propagating means and covariances  

## 8. Pitfalls

1. $\mathbb{E}[1/X]\neq 1/\mathbb{E}X$  
2. Dropping absolute convergence (conditional paradoxes)  
3. Variance of dependent sum without covariances  
4. Correlation as causation  
5. Infinite mean/variance distributions (Cauchy has no mean)  

## 9. Checkpoint

- Use linearity with indicators  
- Compute Var from $\mathbb{E}[X^2]-(\mathbb{E}X)^2$  
- Relate Cov, Corr, independence  
- State tower property  
- Apply Markov/Chebyshev  

## Exercises

### Easy

1. $\mathbb{E}[aX+b]$ and $\mathrm{Var}(aX+b)$.
2. Expected number of fixed points of a random permutation (indicators).
3. Cov matrix of $(X,X)$ in terms of $\mathrm{Var}(X)$.
4. Show $\mathrm{Var}(X)=\mathbb{E}[X(X-1)]+\mathbb{E}X-(\mathbb{E}X)^2$ useful for Poisson-like.
5. If $X\perp Y$, show $\mathbb{E}[XY]=\mathbb{E}X\mathbb{E}Y$.

### Medium

6. Prove Cauchy–Schwarz for covariance via $\mathrm{Var}(X-tY)\ge 0$.
7. Derive $\mathrm{Var}(X+Y)=\mathrm{Var}X+\mathrm{Var}Y+2\mathrm{Cov}$.
8. Compute $\mathbb{E}[X\mid X>0]$ for $X\sim N(0,1)$ (Mills ratio sketch OK).
9. Balls and bins: expected empty bins.
10. Show optimal squared-error predictor is conditional mean.

### Challenge

11. Prove Jensen for discrete finite support by induction / tangent line.
12. Law of total variance: $\mathrm{Var}(X)=\mathbb{E}[\mathrm{Var}(X\mid Y)]+\mathrm{Var}(\mathbb{E}[X\mid Y])$.
13. For multivariate Normal, zero correlation $\Leftrightarrow$ independence—why special?
14. Concentration: from Chebyshev, how large $n$ for $P(|\bar X-\mu|\ge 0.1\sigma)\le 0.05$?
15. Algorithmic: expected comparisons in randomized quicksort recurrence sketch.

## Summary

Moments turn distributions into scalars and matrices that algorithms can optimize and bound. Linearity of expectation is the Swiss army knife; variance and covariance quantify uncertainty and dependence—foundation for concentration, Gaussians, and PCA.
