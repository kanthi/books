# Root Finding: Bisection, Newton, and Secant

Root finding solves $f(x)=0$ for scalar (or later, system) nonlinear equations. It appears in implicit time steppers, calibration, inverse kinematics, threshold equations, and as a subroutine inside optimization (e.g. line search).

## 1. Problem statement

Given $f:\mathbb{R}\to\mathbb{R}$, find $x^\star$ with $f(x^\star)=0$. Multiple roots, no roots, or discontinuous $f$ change the game—always state assumptions.

### Worked example 1

$f(x)=x^3-x-2$: one real root near $1.52$ (since $f(1)=-2$, $f(2)=4$).

## 2. Bisection method

**Assumptions.** $f$ continuous on $[a,b]$, $f(a)f(b)<0$. By IVT, a root exists in $(a,b)$.

**Iteration.** Set $m=(a+b)/2$. If $f(a)f(m)\le 0$, set $b\leftarrow m$; else $a\leftarrow m$.

**Theorem (linear convergence).** After $k$ steps, interval width is $(b_0-a_0)/2^k$. To achieve width $\le\varepsilon$ need

$$
k\ge \log_2\big((b_0-a_0)/\varepsilon\big).
$$

**Proof.** Each step halves the bracket; IVT keeps a root inside. $\blacksquare$

### Worked example 2

$[1,2]$, $\varepsilon=10^{-3}$: need $k\ge \log_2(1000)\approx 10$ iterations.

**Pros:** robust, minimal assumptions. **Cons:** slow; needs a bracket; not easily generalized to high dimension.

## 3. Newton’s method

**Iteration.**

$$
x_{k+1}=x_k-\frac{f(x_k)}{f'(x_k)},
$$

assuming $f'(x_k)\neq 0$.

**Derivation.** Linearize $f(x_k)+f'(x_k)(x-x_k)=0$.

### Local quadratic convergence

**Theorem (informal).** If $f$ is $C^2$, $f(x^\star)=0$, $f'(x^\star)\neq 0$, and $x_0$ is close enough, then Newton converges and

$$
|x_{k+1}-x^\star| \le C |x_k-x^\star|^2
$$

for some $C$.

**Proof idea.** Taylor expand $f(x^\star)$ about $x_k$ and rearrange the Newton update; the leading error term is quadratic. $\blacksquare$

### Worked example 3

$f(x)=x^3-x-2$, $x_0=1.5$:

$f'(x)=3x^2-1$, $x_1=1.5-f(1.5)/f'(1.5)$ rapidly approaches $\approx 1.521379\ldots$

### Worked example 4 — failure modes

- $f'(x_k)\approx 0$: division blow-up  
- Poor start on non-monotone $f$: divergence or cycle  
- Multiple root $f(x^\star)=f'(x^\star)=0$: convergence drops to linear (need multiplicity-aware variants)

### Worked example 5 — square root

Solve $x^2-a=0$ $\Rightarrow$ Heron iteration $x\leftarrow \tfrac12(x+a/x)$, a Newton method—classic stable algorithm for $\sqrt{a}$.

## 4. Secant method

Derivative-free:

$$
x_{k+1}=x_k-f(x_k)\frac{x_k-x_{k-1}}{f(x_k)-f(x_{k-1})}.
$$

Approximates $f'$ by a finite difference using last two iterates.

**Convergence:** superlinear (order $\approx 1.618$ golden ratio) under standard smoothness and simple root assumptions—faster than bisection, typically slower than Newton per iteration but no $f'$.

### Worked example 6

Needs two starts $x_0,x_1$. If $f(x_k)\approx f(x_{k-1})$, formula unstable (cancellation / division by near-zero).

## 5. Hybrid strategies (practical)

**Brent’s method** combines bisection, secant, and inverse quadratic interpolation: guaranteed progress like bisection with faster typical speed. Production scalar solvers often use Brent-like algorithms.

**Strategy pattern:**

1. Bracket root (sampling, sign changes)  
2. Run safeguarded Newton (if $f'$ available): if Newton step leaves bracket or $f'$ tiny, fall back to bisection  
3. Stop on $|f(x)|$, $|x_{k+1}-x_k|$, and iteration cap  

### Worked example 7 — finance implied vol

Solve Black–Scholes price equation for $\sigma$: monotone in $\sigma$ on ranges $\Rightarrow$ robust bracket + Newton/Brent.

## 6. Systems of nonlinear equations

Solve $F(x)=0$ with $F:\mathbb{R}^n\to\mathbb{R}^n$.

**Newton:** $x_{k+1}=x_k - J_F(x_k)^{-1} F(x_k)$, i.e. solve linear system $J_F s = -F$.

Cost: Jacobian + linear solve each step. Inexact Newton / quasi-Newton (Broyden) reduce cost. Damping / trust region globalization.

### Worked example 8

Two equations equilibrium models: Newton with analytic Jacobian vs finite-difference Jacobian (noise and cost tradeoffs).

## 7. Connections to optimization

Critical points: solve $\nabla f(x)=0$—Newton for optimization uses Hessian, related but minimizes $f$ not only finds stationary points of a map. Line search and trust regions again globalize.

### Worked example 9

1D: minimize $g$ by Newton on $g'=0$ is Newton on $f=g'$. Same quadratic convergence story when $g''(x^\star)>0$.

## 8. Stopping criteria

Use combined tests:

- $|f(x_k)|<\tau_f$  
- $|x_{k+1}-x_k|<\tau_x(1+|x_k|)$ relative  
- $k>k_{\max}$ failure  

For noisy $f$ (simulators), tolerances must match noise floors.

### Worked example 10

Demanding $|f|<\tau$ alone may stop far from root if $f$ is flat; demanding step size alone may stop on a plateau of nonzero $f$. Prefer both.

## 9. Pitfalls

1. No bracket $\Rightarrow$ bisection inapplicable  
2. Newton without derivative checks  
3. Multiple roots slowing Newton  
4. Complex roots if only real arithmetic  
5. Treating FP “root” as exact for ill-conditioned $f$ (Wilkinson)  
6. Finite-difference Jacobians with bad $h$  

## 10. Checkpoint

- State bisection guarantees and iteration count  
- Derive Newton from linearization  
- Know quadratic vs linear vs superlinear rates  
- Safeguard Newton with brackets  
- Extend conceptually to $F(x)=0$ with Jacobians  

## Exercises

### Easy

1. Prove bisection error bound after $k$ steps.
2. Perform 3 bisection steps on $f(x)=x^3-x-2$ in $[1,2]$.
3. Perform 2 Newton steps from $x_0=1.5$ for the same $f$.
4. When is secant preferred over Newton?
5. Explain why $f(a)f(b)<0$ is sufficient but not necessary for a root in $[a,b]$ if discontinuities allowed.

### Medium

6. Show Newton for $x^2-a$ yields Heron’s method.
7. Analyze multiplicity: for $f(x)=x^2$, Newton iteration and rate from $x_0\neq 0$.
8. Implement (pseudocode) safeguarded Newton with bisection fallback.
9. Give a smooth $f$ and $x_0$ where Newton diverges.
10. Estimate iterations: bisection vs Newton to get $10^{-12}$ accuracy starting well.

### Challenge

11. Prove local quadratic convergence of Newton for simple roots (Taylor expansion proof).
12. Broyden’s method: state update formula and motivation (rank-one Jacobian approx).
13. Conditioning of a root: if $f(x^\star+\delta)\approx f'(x^\star)\delta$, how does residual map to root error?
14. Multivariate Newton: write algorithm; discuss when $J_F$ is singular.
15. Application: formulate inverse kinematics for a 1-joint toy as root finding; discuss brackets.

## Summary

Bisection is the reliable workhorse; Newton is the fast local engine; secant and hybrids balance derivative cost and guarantees. Understanding rates, failure modes, and stopping criteria makes scalar and small-system solvers trustworthy components in larger numerical pipelines.
