# Multivariable Calculus for ML

Machine learning optimizes scalar losses depending on many parameters. Multivariable calculus introduces gradients, directional derivatives, Jacobians, Hessians, and the chain rule on computational graphs—the mathematics of backpropagation and curvature-aware optimization.

## 1. Functions of several variables

$f:\mathbb{R}^n\to\mathbb{R}$ maps a vector $x=(x_1,\ldots,x_n)$ to a real loss or objective. Level sets $\{x:f(x)=c\}$ generalize contours.

### Worked example 1

$f(x,y)=x^2+y^2$ has circular level sets; minimum at origin.

## 2. Partial derivatives

$\partial f/\partial x_i$ differentiates treating other variables as constant.

### Worked example 2

$f(x,y)=x^2 y+\sin y$: $f_x=2xy$, $f_y=x^2+\cos y$.

## 3. Gradient

$$
\nabla f(x)=\begin{bmatrix}\partial f/\partial x_1\\\vdots\\\partial f/\partial x_n\end{bmatrix}.
$$

**Facts:**

- Points in direction of steepest ascent  
- $\|\nabla f\|$ is the steepest-ascent rate  
- $\nabla f=0$ at smooth critical points  

### Worked example 3

$f(x,y)=x^2+3xy+y^2$: $\nabla f=(2x+3y,\ 3x+2y)$. Critical point solve $\nabla f=0\Rightarrow(x,y)=(0,0)$.

### Worked example 4 — GD step

$x\leftarrow x-\alpha\nabla f(x)$ moves opposite the gradient—steepest descent for small $\alpha$.

## 4. Directional derivatives

For unit $u$, $D_u f=\nabla f\cdot u$. Maximized when $u\parallel\nabla f$, value $\|\nabla f\|$.

### Worked example 5

At $(1,1)$ for $f=x^2+y^2$, $\nabla f=(2,2)$, direction $u=(1,0)$: $D_u f=2$.

## 5. Chain rule and backpropagation

If $z=f(y)$, $y=g(x)$, then $Dz/Dx$ multiplies Jacobians.

**Scalar case:** $\frac{dz}{dx}=\frac{dz}{dy}\frac{dy}{dx}$.

**Vector case:** if $x\in\mathbb{R}^n$, $y\in\mathbb{R}^m$, $z\in\mathbb{R}$,

$$
\nabla_x z = (D_x y)^\top \nabla_y z.
$$

Backprop: recurse this identity on a graph of elementary ops.

### Worked example 6 — logistic

$z=w^\top x$, $p=\sigma(z)$, $\ell=-y\log p-(1-y)\log(1-p)$.  
$\partial\ell/\partial z=p-y$, then $\nabla_w\ell=(p-y)x$.

### Worked example 7 — Matmul layer

$Y=XW$ shapes: gradients w.r.t. $W$ are $X^\top G$ if $G=\partial L/\partial Y$—shape-check discipline.

## 6. Jacobian matrix

For $F:\mathbb{R}^n\to\mathbb{R}^m$, $J_F$ has $J_{ij}=\partial F_i/\partial x_j$. Linearization $F(x+h)\approx F(x)+J_F(x)h$.

### Worked example 8

Softmax $F:\mathbb{R}^k\to\mathbb{R}^k$ has Jacobian $\mathrm{diag}(p)-pp^\top$.

## 7. Hessian and curvature

$H_{ij}=\partial^2 f/(\partial x_i\partial x_j)$. For smooth $f$, $H$ symmetric (mixed partials equal).

At critical point $\nabla f=0$:

- $H\succ 0$: local minimum  
- $H\prec 0$: local maximum  
- indefinite: saddle  

### Worked example 9

$f=x^2+3xy+y^2$: $H=\begin{bmatrix}2&3\\3&2\end{bmatrix}$, eigenvalues $5,-1$—saddle at $0$ despite some positive curvature directions.

### Worked example 10 — quadratic bowl

$f(x)=\frac12 x^\top Q x$ with $Q\succ 0$: $\nabla f=Qx$, $H=Q$; GD condition number $\kappa=\lambda_{\max}/\lambda_{\min}$.

## 8. Multivariate Taylor

$$
f(x+\Delta)=f(x)+\nabla f(x)^\top\Delta+\frac12\Delta^\top H(x)\Delta+o(\|\Delta\|^2).
$$

Newton step solves $H\Delta=-\nabla f$ using the quadratic model.

### Worked example 11

Newton on strongly convex smooth $f$ converges quadratically near the min—when $H$ is cheap and well-conditioned enough to invert/solve.

## 9. Constrained gradients (preview)

On constraint $g(x)=0$, optima satisfy $\nabla f=\lambda\nabla g$ (Lagrange)—gradients align. See Optimization KKT chapter.

### Worked example 12

Maximize $x^\top a$ on $\|x\|_2=1$: solution $x=a/\|a\|$—Cauchy–Schwarz geometry.

## 10. Automatic vs symbolic vs numeric derivatives

| Method | Notes |
|--------|-------|
| Symbolic | exact; may explode expression size |
| Numeric finite diff | easy; cancellation & cost $O(n)$ |
| Forward/reverse AD | exact to FP; reverse ideal when $n$ large, scalar loss |

### Worked example 13

ML frameworks implement reverse-mode AD = backprop on tensors.

## 11. Pitfalls

1. Shape errors in Jacobian/transpose chain rule  
2. Assuming critical point is minimum without Hessian test  
3. Ill-conditioned $H$ $\Rightarrow$ slow GD / unstable Newton  
4. Nondifferentiable ops (max, ReLU at 0) in “gradient”  
5. Vanishing/exploding gradients in deep chains (product of Jacobians)  

## 12. Checkpoint

- Compute gradients and Hessians for simple $f$  
- State directional derivative max property  
- Apply chain rule to logistic loss  
- Classify critical points via $H$  
- Explain reverse-mode AD motivation  

## Exercises

### Easy

1. $\nabla(x^\top A x)$ for symmetric $A$ (result $2Ax$).
2. Directional derivative of $f=xy$ at $(1,2)$ along unit $u\propto(1,1)$.
3. Jacobian of $F(x,y)=(x^2,xy)$.
4. Hessian of $\|x\|_2^2$.
5. Why is $\nabla f$ orthogonal to level sets (intuition)?

### Medium

6. Derive $\nabla_w\frac12\|Xw-y\|_2^2$.
7. Softmax cross-entropy gradient w.r.t. logits.
8. Show mixed partials equal for $f=e^{xy}$ (compute both).
9. Eigenvalues of Hessian in Example 9; classify.
10. Chain rule for $f(g(h(x)))$ scalar case expanded.

### Challenge

11. Prove $D_u f=\nabla f\cdot u$ from definition of derivative of $t\mapsto f(x+tu)$.
12. Gauss–Newton Hessian approximation for nonlinear least squares.
13. Vanishing gradient: product of many $\sigma'(z)<1/4$ factors.
14. Riemannian gradient on the sphere (project Euclidean gradient).
15. Implement (pseudocode) reverse-mode for a tiny 2-node graph.

## Summary

Multivariable calculus upgrades one-dimensional derivatives to gradients, Jacobians, and Hessians. The chain rule on graphs is backpropagation; curvature matrices govern optimization difficulty. Mastering shapes, critical-point tests, and AD modes is essential ML mathematics.
