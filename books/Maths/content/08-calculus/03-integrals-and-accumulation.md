# Integrals and Accumulation

Integration measures accumulation: area, total mass, probability, and net change. The Fundamental Theorem of Calculus (FTC) links integrals to antiderivatives, while numerical quadrature and Monte Carlo extend integration to settings without closed forms—common in CS, graphics, and ML.

## 1. Definite integral as accumulation

For $f$ on $[a,b]$, the definite integral $\int_a^b f(x)\,dx$ is the signed accumulation of $f$. If $f\ge 0$, it is area under the graph.

### Worked example 1

$\int_0^1 x^2\,dx=\frac13$ (area under parabola).

## 2. Riemann sums

Partition $a=x_0<\cdots<x_n=b$, widths $\Delta x_i=x_i-x_{i-1}$, sample $x_i^*\in[x_{i-1},x_i]$:

$$
\sum_{i=1}^n f(x_i^*)\Delta x_i.
$$

If these sums approach $I$ as mesh $\max\Delta x_i\to 0$, then $\int_a^b f=I$.

### Worked example 2

Right Riemann sum for $x^2$ on $[0,1]$ with $n$ equal parts: $\sum_{i=1}^n (i/n)^2\cdot(1/n)\to\int_0^1 x^2$.

## 3. Fundamental Theorem of Calculus

**FTC Part 1.** If $f$ continuous and $F(x)=\int_a^x f(t)\,dt$, then $F'(x)=f(x)$.

**FTC Part 2.** If $F'=f$ on $[a,b]$, then $\int_a^b f=F(b)-F(a)$.

### Worked example 3

$\int_0^\pi \sin x\,dx=[-\cos x]_0^\pi=2$.

### Worked example 4 — net change

If $v(t)$ is velocity, $\int_{t_1}^{t_2} v(t)\,dt$ is net displacement—not always total distance (use $\int|v|$).

## 4. Antiderivatives and techniques (brief)

Linearity: $\int(af+bg)=a\int f+b\int g$.  
Substitution and parts reverse chain/product rules.  

### Worked example 5

$\int 2x e^{x^2}\,dx=e^{x^2}+C$ via $u=x^2$.

## 5. Improper integrals

Replace infinite bounds or singularities by limits:

$$
\int_1^\infty x^{-p}\,dx \text{ converges iff } p>1.
$$

### Worked example 6

$\int_1^\infty \frac1{x^2}\,dx=1$; $\int_1^\infty \frac1x\,dx$ diverges—harmonic series continuous cousin.

### Worked example 7 — probability

A PDF $f$ needs $\int_{-\infty}^{\infty}f=1$; tails must integrate finitely.

## 6. Numerical integration

| Method | Idea | Error (smooth $f$) |
|--------|------|-------------------|
| Trapezoidal | piecewise linear | $O(h^2)$ global |
| Simpson | piecewise quadratic | $O(h^4)$ global |
| Monte Carlo | random samples | $O(1/\sqrt{N})$ statistical |

### Worked example 8

Trapezoid on $[0,1]$ for $x^2$ with 2 panels: approx $0.375$ vs true $1/3\approx 0.333$.

### Worked example 9 — high dimension

Grid methods suffer curse of dimensionality; Monte Carlo error depends weakly on dimension—key for rendering and Bayesian computation.

### Worked example 10 — importance sampling

Sample from proposal $q$, estimate $\int f=\mathbb{E}_q[f(X)/q(X)]$—variance reduction art.

## 7. Probability and expectation

Continuous RV with density $f_X$:

$$
P(a\le X\le b)=\int_a^b f_X,\qquad \mathbb{E}[g(X)]=\int g(x)f_X(x)\,dx.
$$

### Worked example 11

Exponential$(\lambda)$: $\int_0^\infty \lambda e^{-\lambda x}dx=1$; mean $\int_0^\infty x\lambda e^{-\lambda x}dx=1/\lambda$.

## 8. Multiple integrals (preview)

$\iint_D f$ accumulates over 2D regions—mass, probabilities for joint densities. Fubini’s theorem justifies iterated integrals under integrability.

### Worked example 12

Uniform density on unit square: area 1; $P(X+Y\le 1)=\frac12$.

## 9. CS applications

- Softmax partition functions / free energies as integrals/sums  
- Continuous-time system total cost $\int L(x(t),u(t))\,dt$  
- Image irradiance integrals in graphics  
- Kernel density estimation and smoothing  
- Discrete sums approximated by integrals (Euler–Maclaurin)  

### Worked example 13 — average case analysis

Integral method for sums: $\sum_{k=1}^n k\log k \sim \int x\log x\,dx$.

## 10. Pitfalls

1. Forgetting absolute value for arc length / distance  
2. Divergent improper integrals treated as finite  
3. Trapezoid on non-smooth $f$ (error rates drop)  
4. Monte Carlo without variance reporting  
5. Confusing antiderivative $+C$ with definite integral values  

## 11. Checkpoint

- Write Riemann sum $\to$ integral  
- Apply FTC to evaluate simple definite integrals  
- Test $p$-integral convergence at infinity  
- Compare trapezoid vs Monte Carlo regimes  
- Connect PDF integrals to probabilities  

## Exercises

### Easy

1. $\int_0^2 (3x^2-1)\,dx$.
2. Riemann sum definition for $\int_0^1 e^x$ with $n=4$ right endpoints (compute number).
3. Antiderivative of $1/(1+x^2)$.
4. Does $\int_0^1 x^{-1/2}\,dx$ converge?
5. Trapezoid rule formula for one panel.

### Medium

6. Prove FTC Part 2 assuming Part 1 and mean value ideas (outline).
7. Compare trapezoid and Simpson on $\sin$ over $[0,\pi]$ with $n=4$.
8. Monte Carlo estimate of $\pi$ via unit disk indicator; SE scaling.
9. Show $\int_1^\infty x^{-p}$ convergence criterion.
10. Expectation of Uniform$(a,b)$ via integral.

### Challenge

11. Euler–Maclaurin: state how sums relate to integrals + Bernoulli corrections.
12. Importance sampling variance formula; when it fails.
13. Change of variables in 1D integrals carefully with limits.
14. Gaussian integral $\int_{-\infty}^{\infty}e^{-x^2}dx=\sqrt{\pi}$ (use polar trick outline).
15. Graphics: write the rendering integral for radiance (high-level) and say why MC is used.

## Summary

Integrals accumulate continuous contributions; FTC computes them via antiderivatives when available. Numerical and Monte Carlo methods handle the rest. Probability, simulation, and analysis of algorithms all rely on this accumulation viewpoint.
