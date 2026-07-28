# Convexity Foundations

Convexity is the structural property that turns optimization from a landscape of traps into a tractable geometry: **every local minimum is global**, first-order conditions are sufficient, and averaging feasible points stays feasible. This chapter develops convex sets and functions with characterizations, examples, and CS/ML payoffs.

## 1. Convex sets

**Definition.** A set $C \subseteq \mathbb{R}^n$ is **convex** if for all $x,y\in C$ and all $\theta\in[0,1]$,

$$
\theta x + (1-\theta)y \in C.
$$

The point $\theta x+(1-\theta)y$ is a **convex combination** of $x$ and $y$. Geometrically: the line segment between any two points of $C$ lies entirely in $C$.

### Examples of convex sets

- Empty set, singletons, $\mathbb{R}^n$
- Open/closed balls in any norm; ellipsoids $\{x:(x-c)^\top A(x-c)\le 1\}$ for $A\succ 0$
- Affine subspaces $\{x: Ax=b\}$
- Halfspaces $\{x: a^\top x \le b\}$ and polyhedra $\{x: Ax\le b\}$
- Probability simplex $\Delta^{n-1}=\{x: x\ge 0,\ \mathbf{1}^\top x=1\}$
- PSD cone $\mathbf{S}_+^n=\{M=M^\top: M\succeq 0\}$

### Non-examples

- Two disjoint balls (segment between centers leaves the set)
- Integer lattice $\mathbb{Z}^n$
- Unit circle $\{x:\|x\|_2=1\}$ (sphere surface)
- Rank-at-most-$k$ matrices (nonconvex for $0<k<\min$ dimensions)

### Worked example 1

Prove the simplex is convex: if $x,y\ge 0$, $\mathbf{1}^\top x=\mathbf{1}^\top y=1$, then $z=\theta x+(1-\theta)y\ge 0$ and $\mathbf{1}^\top z=1$.

### Operations preserving convexity of sets

- Intersection: arbitrary intersections of convex sets are convex
- Affine images: $C$ convex $\Rightarrow AC+b=\{Ac+b:c\in C\}$ convex
- Minkowski sums: $C,D$ convex $\Rightarrow C+D$ convex
- **Not** generally closed under unions

**Theorem.** A polyhedron $\{x:Ax\le b\}$ is convex.

**Proof.** Intersection of halfspaces; each halfspace is convex; intersection preserves convexity.

## 2. Convex functions

**Definition.** Let $C\subseteq\mathbb{R}^n$ be convex. $f:C\to\mathbb{R}$ is **convex** if for all $x,y\in C$ and $\theta\in[0,1]$,

$$
f\big(\theta x+(1-\theta)y\big) \le \theta f(x) + (1-\theta)f(y).
$$

$f$ is **strictly convex** if the inequality is strict for $x\neq y$ and $\theta\in(0,1)$.

$f$ is **concave** if $-f$ is convex.

**Epigraph characterization.** $f$ is convex iff its **epigraph**

$$
\mathrm{epi}\, f = \{(x,t): x\in C,\ f(x)\le t\}
$$

is a convex set in $\mathbb{R}^{n+1}$.

### Worked example 2

$f(x)=x^2$ on $\mathbb{R}$: expand $\theta x^2+(1-\theta)y^2 - (\theta x+(1-\theta)y)^2 = \theta(1-\theta)(x-y)^2\ge 0$. Convex; strictly convex.

### Worked example 3

$f(x)=x^3$ on $\mathbb{R}$ is **not** convex: midpoint of $-1$ and $1$ gives $f(0)=0 > \frac12(f(-1)+f(1))=-1$? Wait: $\frac12((-1)+1)=0=f(0)$, need a better test. Use second derivative $f''(x)=6x$, negative for $x<0$, so not convex on $\mathbb{R}$. On $[0,\infty)$ it is convex.

### Worked example 4

$f(x)=\|x\|$ any norm: triangle inequality + absolute homogeneity $\Rightarrow$ convex. Not strictly convex for $\ell_1$ or $\ell_\infty$ (flat faces).

### Worked example 5 — logistic loss

$\ell(z)=\log(1+e^{-z})$ is convex in $z$ (composition rules / second derivative $\sigma(z)(1-\sigma(z))\ge 0$ after careful differentiation of related forms). Thus logistic regression ERM in $w$ is convex when $\ell$ is applied to linear predictors $y_i w^\top x_i$ with appropriate labeling conventions.

## 3. First-order characterization

**Theorem.** Let $f$ be differentiable on an open convex set $C$. Then $f$ is convex iff for all $x,y\in C$,

$$
f(y) \ge f(x) + \nabla f(x)^\top (y-x).
$$

**Interpretation:** the graph lies above all tangent hyperplanes. The linear approximation is a **global underestimator**.

**Proof sketch ($\Rightarrow$).** Write $y = x + t(d)$ path, use definition of directional derivative / difference quotient and take limits; or apply definition to $x_\theta=\theta y+(1-\theta)x$ and rearrange:

$$
\frac{f(x_\theta)-f(x)}{\theta} \le f(y)-f(x),
$$

let $\theta\to 0$.

**($\Leftarrow$):** Apply the inequality at $x_\theta$ toward $x$ and $y$, then convex-combine.

### Subgradients (nondifferentiable case)

**Definition.** $g$ is a **subgradient** of $f$ at $x$ if for all $y$,

$$
f(y)\ge f(x)+g^\top(y-x).
$$

The **subdifferential** $\partial f(x)$ is the set of all subgradients. For convex $f$, $\partial f(x)$ is nonempty on the relative interior of the domain (under mild conditions). Example: $\partial |x|$ at $0$ is $[-1,1]$.

## 4. Second-order characterization

**Theorem.** Let $f$ be twice continuously differentiable on open convex $C$. Then $f$ is convex iff $\nabla^2 f(x)\succeq 0$ (positive semidefinite) for all $x\in C$. Strict convexity is implied by $\nabla^2 f(x)\succ 0$ everywhere, but the converse needs care (e.g. $x^4$ is strictly convex with $f''(0)=0$).

### Worked example 6

$f(x)=\frac12 x^\top Q x + c^\top x + d$ with $Q=Q^\top$. Hessian is $Q$. Convex iff $Q\succeq 0$; strictly convex if $Q\succ 0$.

### Worked example 7 — least squares

$f(w)=\|Xw-y\|_2^2$ has Hessian $2X^\top X\succeq 0$, always convex; strictly convex iff $X$ has full column rank.

## 5. Global optimality theorems

**Theorem (local $\Rightarrow$ global).** Let $f$ be convex on convex $C$. If $x^\star$ is a local minimizer, then $x^\star$ is a global minimizer.

**Proof.** Suppose $f(y)<f(x^\star)$ for some $y\in C$. For $\theta\in(0,1)$ small, $x_\theta=\theta y+(1-\theta)x^\star$ is arbitrarily close to $x^\star$ and

$$
f(x_\theta)\le \theta f(y)+(1-\theta)f(x^\star) < f(x^\star),
$$

contradicting local minimality.

**Theorem (first-order sufficiency, unconstrained).** If $f$ is convex and differentiable on $\mathbb{R}^n$, then $x^\star$ minimizes $f$ **iff** $\nabla f(x^\star)=0$.

**Proof.** Necessity: standard calculus. Sufficiency: $f(y)\ge f(x^\star)+\nabla f(x^\star)^\top(y-x^\star)=f(x^\star)$.

**Theorem (subgradient optimality).** For convex $f$, $x^\star$ is a minimizer iff $0\in\partial f(x^\star)$.

## 6. Strong convexity

**Definition.** $f$ is **$\mu$-strongly convex** ($\mu>0$) if for all $x,y$ and $\theta\in[0,1]$,

$$
f(\theta x+(1-\theta)y)\le \theta f(x)+(1-\theta)f(y) - \frac{\mu}{2}\theta(1-\theta)\|x-y\|_2^2.
$$

Equivalent (differentiable): $f(y)\ge f(x)+\nabla f(x)^\top(y-x)+\frac{\mu}{2}\|y-x\|_2^2$.

Equivalent (twice diff.): $\nabla^2 f(x)\succeq \mu I$.

### Consequences

- Unique minimizer
- Linear convergence of gradient descent under $L$-smoothness with step $1/L$ (rate depends on condition number $L/\mu$)
- Stability of solutions under data perturbation (related to regularization)

### Worked example 8

Ridge objective $\|Xw-y\|_2^2+\lambda\|w\|_2^2$ is $\mu$-strongly convex with $\mu\ge 2\lambda$ (actually Hessian $2X^\top X+2\lambda I\succeq 2\lambda I$).

## 7. Calculus of convex functions (closure rules)

If $f,g$ convex and $\alpha,\beta\ge 0$, then $\alpha f+\beta g$ convex.

- Pointwise maximum: $x\mapsto \max_i f_i(x)$ convex if each $f_i$ is
- Affine composition: $f(Ax+b)$ convex if $f$ convex
- Nonnegative weighted sums and expectations: $x\mapsto \mathbb{E}_\xi[f(x,\xi)]$ convex if each $f(\cdot,\xi)$ is
- **Perspective**, **infimal convolution**, and many more advanced rules (see Boyd–Vandenberghe)

**Dangerous compositions:** $h(f(x))$ with $h$ increasing convex and $f$ convex is convex; but $h\circ f$ can destroy convexity if $h$ is not increasing (e.g. $h(t)=-t$, $f$ convex $\Rightarrow$ concave).

### Worked example 9 — ReLU networks

A single ReLU unit $w\mapsto \max(0,w^\top x)$ is convex in $w$ for fixed $x$. Composition of many layers with products of weights is **not** jointly convex in all parameters—the deep net loss is typically nonconvex.

## 8. Smoothness (companion property)

**Definition.** $f$ is **$L$-smooth** if $\nabla f$ is $L$-Lipschitz:

$$
\|\nabla f(x)-\nabla f(y)\|_2 \le L\|x-y\|_2.
$$

For twice differentiable $f$, equivalent to $-LI \preceq \nabla^2 f(x) \preceq LI$ in operator sense for convex smooth functions often stated as $0\preceq \nabla^2 f\preceq LI$.

Descent lemma: $f(y)\le f(x)+\nabla f(x)^\top(y-x)+\frac{L}{2}\|y-x\|_2^2$.

Smoothness + convexity $\Rightarrow$ standard GD rates $O(1/k)$ on function values; strong convexity upgrades this.

## 9. CS/ML connections

| Concept | Role |
|---------|------|
| Convex losses | Logistic, hinge, squared — tractable ERM |
| Simplex / PSD cone | Probabilities, covariance, SDP relaxations |
| Strong convexity via $\lambda\|w\|_2^2$ | Unique solution, faster opt, stability |
| Nonconvex deep nets | Rely on overparameterization + SGD dynamics |
| Convex relaxations | Max-cut SDP, matrix completion nuclear norm |

### Worked example 10 — hinge loss SVM

$\min_w \frac{\lambda}{2}\|w\|_2^2 + \sum_i \max(0,1-y_i w^\top x_i)$ is convex (sum of convex pieces + strongly convex regularizer). Subgradient methods apply; dual QP is the classic SVM dual.

## 10. Pitfalls

1. **Strict vs strong convexity.** $x^4$ is strictly but not strongly convex on $\mathbb{R}$.
2. **Convex domain required** in the definition; saying “$f$ is convex” includes the domain geometry.
3. **Level sets of convex $f$ are convex; converse false** ($f$ could be quasiconvex only).
4. **Product of convex nonnegative functions need not be convex.**
5. **Discrete sets** break segment arguments—integer programs need different theory.
6. **Numerical Hessians** with tiny negative eigenvalues due to roundoff: use tolerances carefully when testing PSD.

## 11. Checkpoint

- Define convex sets/functions and test with segments
- Use first- and second-order characterizations
- Prove local minima are global for convex $f$
- Explain strong convexity and one algorithmic consequence
- Know which ML losses are convex in parameters for linear models

## Exercises

### Easy

1. Prove that the intersection of any collection of convex sets is convex.
2. Show $f(x)=e^{a^\top x}$ is convex on $\mathbb{R}^n$.
3. Is $f(x,y)=xy$ convex on $\mathbb{R}^2$? On $\mathbb{R}_+^2$?
4. Prove any norm is convex using the triangle inequality.
5. Show that if $f$ is convex, then sublevel sets $\{x:f(x)\le \alpha\}$ are convex.

### Medium

6. Prove the first-order characterization of convexity for differentiable $f$ (both directions).
7. Determine convexity of $f(t)=t\log t$ on $(0,\infty)$ (extended by continuity at 0).
8. Show $f(X)=-\log\det(X)$ is convex on $X\succ 0$ (you may use known spectral facts or restrict to lines).
9. Prove that a strictly convex function has at most one minimizer.
10. For $f(w)=\|Xw-y\|_2^2+\lambda\|w\|_1$, is $f$ convex? Strongly convex? Differentiable?

### Challenge

11. Prove that $f$ convex and $L$-smooth implies $\|\nabla f(x)-\nabla f(y)\|_2^2 \le 2L\big(f(x)-f(y)-\nabla f(y)^\top(x-y)\big)$ (cocoercivity / standard inequality).
12. Give a quasiconvex function that is not convex; explain optimization consequences.
13. Show the nuclear norm $\|M\|_*=\sum_i \sigma_i(M)$ is convex (hint: dual characterization $\sup_{\|U\|_{2\to 2}\le 1}\langle U,M\rangle$).
14. Prove strong convexity of ridge regression with explicit $\mu$ in terms of $\lambda$ and optionally $\sigma_{\min}(X)$.
15. Construct a nonconvex $f$ with a unique global minimizer where gradient descent from some start converges to a suboptimal stationary point (1D sketch OK).

## Summary

Convexity is the geometry of segments and epigraphs. First- and second-order tests make it checkable; strong convexity upgrades uniqueness and rates; closure rules let you build large convex models from simple blocks. When convexity fails—as in deep learning—you must replace global guarantees with stationarity, structure, or empiricism.
