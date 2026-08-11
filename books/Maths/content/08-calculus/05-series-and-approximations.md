# Taylor Series and Approximations

Taylor series represent functions as infinite polynomials built from derivatives at a point. Finite Taylor polynomials are the local models behind Newton methods, numeric `exp`/`sin` implementations, small-angle approximations, and many asymptotic arguments in algorithms.

## 1. Taylor polynomials

If $f$ is $n$ times differentiable at $a$,

$$
T_n(x)=\sum_{k=0}^n \frac{f^{(k)}(a)}{k!}(x-a)^k.
$$

**Remainder** $R_n(x)=f(x)-T_n(x)$. Lagrange form: exists $\xi$ between $x$ and $a$ with

$$
R_n(x)=\frac{f^{(n+1)}(\xi)}{(n+1)!}(x-a)^{n+1}.
$$

### Worked example 1

$f(x)=e^x$, $a=0$: $T_2(x)=1+x+x^2/2$. $e^{0.1}\approx 1.105$ vs true $\approx 1.1051709$.

### Worked example 2

$f(x)=\sin x$, $a=0$: $T_3(x)=x-x^3/6$. $\sin(0.2)\approx 0.198666\ldots$ vs $0.198669\ldots$.

## 2. Classic Maclaurin series

$$
\begin{aligned}
e^x&=\sum_{k=0}^\infty \frac{x^k}{k!},\\
\sin x&=\sum_{k=0}^\infty \frac{(-1)^k x^{2k+1}}{(2k+1)!},\\
\cos x&=\sum_{k=0}^\infty \frac{(-1)^k x^{2k}}{(2k)!},\\
\frac{1}{1-x}&=\sum_{k=0}^\infty x^k\quad(|x|<1),\\
\log(1+x)&=\sum_{k=1}^\infty (-1)^{k+1}\frac{x^k}{k}\quad(|x|<1).
\end{aligned}
$$

### Worked example 3

Geometric series sums finite geometric progressions in algorithm analysis ($1+r+\cdots+r^{n-1}$).

### Worked example 4

$\log(1+x)\approx x-x^2/2$ for small $x$—used in multiplicative weights / continuous compounding approximations.

## 3. Convergence radius

Power series $\sum c_k(x-a)^k$ converge for $|x-a|<R$ (radius $R$). Inside the disk, termwise differentiation/integration often valid.

### Worked example 5

$1/(1-x)$ series fails at $x=1$ even though function blows up there—radius limited by nearest singularity in complex plane (here $x=1$).

## 4. Big-O and little-o expansions

Write $f(x)=T_n(x)+O((x-a)^{n+1})$ as $x\to a$. Asymptotic notation packages remainder control for algorithm and numeric reasoning.

### Worked example 6

$\sqrt{1+x}=1+\frac12 x-\frac18 x^2+O(x^3)$ as $x\to 0$.

### Worked example 7 — softmax stability

$\log\sum_i e^{z_i}=m+\log\sum_i e^{z_i-m}$ with $m=\max z_i$—algebraic rewrite; Taylor not required, but local linearizations of $\log$ and $\exp$ appear in analyses.

## 5. Taylor in optimization

Quadratic model $f(x+\Delta)\approx f(x)+\nabla f^\top\Delta+\frac12\Delta^\top H\Delta$ is multivariate Taylor. Newton chooses $\Delta$ to minimize this model.

### Worked example 8

For 1D $f$, Newton $x-f'/f''$ matches root finding on $f'$ when minimizing.

### Worked example 9 — GD step sizes

Descent lemma for $L$-smooth $f$: $f(y)\le f(x)+\nabla f(x)^\top(y-x)+\frac{L}{2}\|y-x\|^2$—a globalized Taylor-with-remainder inequality.

## 6. Series in algorithms and discrete math

- Generating functions encode sequences; singularities $\to$ asymptotics (Flajolet–Odlyzko)  
- Exponential series in continuous-time Markov chains $e^{tQ}$  
- $\sum 1/k^2$ etc. in analysis of algorithms constants  

### Worked example 10

Expected coupon collector $\sim n\log n$ uses harmonic numbers $H_n=\log n+\gamma+O(1/n)$—integral/series approximation of harmonics.

## 7. Numerical evaluation caveats

Naive power series for large $|x|$ is unstable or slow; use range reduction ($e^x=e^{n\log 2+r}=2^n e^r$) then series on small $r$.

### Worked example 11

Computing $e^{-100}$ via series of $e^x$ at $-100$ is a bad idea—overflow intermediate terms; rewrite.

### Worked example 12 — cancellation

$e^x-1$ for small $x$: use `expm1` or series $x+x^2/2+\cdots$—direct subtraction cancels.

## 8. Fourier teaser (optional horizon)

Taylor is local polynomial; Fourier series are global trigonometric expansions on intervals—signal processing backbone. Different approximation theory (Gibbs, rates for smooth periodic $f$).

## 9. Pitfalls

1. Using Taylor far outside radius of usefulness  
2. Truncating alternating series without error bound  
3. Confusing formal power series with convergent functions  
4. Applying geometric series at $|x|\ge 1$  
5. Multivariate Taylor without controlling remainder in high $d$  

## 10. Checkpoint

- Write $T_n$ and Lagrange remainder  
- Expand $e^x,\sin x,\log(1+x)$  
- Use $O(\cdot)$ expansions for small $x$  
- Connect quadratic Taylor to Newton  
- Practice stable evaluation patterns for $\exp$  

## Exercises

### Easy

1. $T_3$ for $\cos$ at 0; approximate $\cos(0.1)$.
2. Geometric sum formula for $|r|<1$ infinite case.
3. Derive $\lim_{x\to 0}(e^x-1)/x=1$ from series.
4. Linear approximation of $\sqrt{1+x}$ near 0.
5. Why is $T_1$ the tangent line?

### Medium

6. Bound $|R_4|$ for $e^x$ on $|x|\le 1$ using Lagrange remainder.
7. Expand $\log(1-x)$ for $|x|<1$.
8. Show binomial series idea for $(1+x)^\alpha$ first three terms.
9. Relate second-order Taylor to Newton step for 1D minimization.
10. Harmonic number integral bound: $\int_1^{n+1}\frac1x\le H_n\le 1+\int_1^n\frac1x$.

### Challenge

11. Prove uniqueness of power series coefficients for analytic $f$.
12. Radius of convergence via ratio test for $e^x$ coefficients.
13. Multivariate Taylor to order 2; write Hessian form.
14. Explain range reduction for $\sin$ using $\pi$ periodicity and series on $[-\pi/4,\pi/4]$.
15. Generating function for Fibonacci; pole $\to$ Binet asymptotic sketch.

## Summary

Taylor polynomials are controlled local models with explicit remainders; classic series for exp/trig/log fuel both analysis and numeric libraries. In CS they appear as optimization models, asymptotic expansions, and stable algorithm design for elementary functions.
