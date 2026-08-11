# Calculus for Computer Science and AI

Calculus studies continuous change: limits, derivatives, integrals, and infinite series. In CS and AI it is the language of optimization, learning dynamics, continuous probability, graphics, and the analysis of algorithms that involve growth and accumulation.

## Why calculus matters in CS/AI

| Area | Calculus role |
|------|----------------|
| Machine learning | Gradients, backprop, continuous losses |
| Optimization | Stationarity, Taylor models, Hessians |
| Computer graphics | Curves, surfaces, shading rates |
| Physics engines | ODEs, integration of motion |
| Probability | Densities, expectations as integrals |
| Algorithms | Continuous relaxations, potential functions |
| Signal processing | Transforms, filtering (continuous intuition) |

## What you will learn

1. **Limits and continuity** — precise “approaches $L$” language; when models are well-behaved  
2. **Derivatives** — local linear approximation; optimization and rates  
3. **Integrals** — accumulation, area, FTC, numerical quadrature  
4. **Multivariable calculus** — gradients, Jacobians, Hessians for ML  
5. **Series and approximations** — Taylor models used everywhere in numerics  

```text
flow:
  B -> C
  C -> D
  D -> E
  D -> F
  B -> G
  G -> H
  D -> I
```

## The derivative in one sentence

If $f$ is differentiable at $x$, then near $x$

$$
f(x+h)\approx f(x)+f'(x)h,
$$

with error $o(h)$ as $h\to 0$. Gradient descent, Newton methods, and sensitivity analysis are organized around this fact.

### Worked example 1 — sensitivity

If loss $L(w)$ has $L'(w)=0.01$, a step $\Delta w=-0.1$ predicts $\Delta L\approx -0.001$ to first order—step-size reasoning.

### Worked example 2 — non-differentiable ML

$|w|$ and $\mathrm{ReLU}(z)=\max(0,z)$ are not differentiable at kinks; practice uses subgradients / one-sided derivatives. Continuity still holds.

## The integral in one sentence

The definite integral $\int_a^b f$ accumulates $f$ over $[a,b]$—signed area, total mass, probability from a density, or total cost over time.

### Worked example 3

If $f_X$ is a PDF, $P(a\le X\le b)=\int_a^b f_X$. No density calculus, no continuous probability.

## Multivariable leap for ML

Parameters $w\in\mathbb{R}^d$: gradient $\nabla L(w)$ is the vector of partials; Hessian $\nabla^2 L$ encodes curvature. Backpropagation is the chain rule applied to computational graphs.

### Worked example 4

$L(w)=\frac12\|Xw-y\|_2^2\Rightarrow \nabla L=X^\top(Xw-y)$—matrix calculus as multivariable derivatives.

## Prerequisites

- Algebra of functions, polynomials, exp/log  
- Coordinates in $\mathbb{R}^2$ and $\mathbb{R}^3$  
- Optional: basic linear algebra for multivariable chapters  

## Study sequence (CS-oriented)

1. Limits and continuity mechanics  
2. Derivatives and 1D optimization  
3. Integrals and FTC; probability link  
4. Gradients/Jacobians/Hessians  
5. Taylor series for local models and numerics  

## Pitfalls

1. Treating all ML losses as everywhere differentiable  
2. Finite differences with $h$ too small (cancellation)  
3. Confusing partial vs total derivatives in time-dependent systems  
4. Integrating probability densities that do not normalize  
5. Trusting Taylor far from expansion point  

## Checkpoint

- Explain derivative as local linear map  
- State FTC linking derivatives and integrals  
- Write a gradient for a simple $f:\mathbb{R}^2\to\mathbb{R}$  
- Give two CS applications of series  
- Know when ReLU breaks classical derivative hypotheses  

## Exercises

1. Why is $f(x)=|x|$ not differentiable at $0$?
2. Differentiate $x^3 e^x$ (product rule).
3. Interpret $\int_0^1 v(t)\,dt$ if $v$ is velocity.
4. Give one optimization problem in CS modeled with derivatives.
5. Compute $\nabla f$ for $f(x,y)=x^2+y^2$.
6. What does a large Hessian condition number mean for GD?
7. Approximate $\sqrt{1+x}$ for small $x$ by first-order Taylor.
8. Link cross-entropy training to gradient steps on probabilities.
9. Explain continuity of $\mathrm{ReLU}$ vs differentiability.
10. Checkpoint project: write the gradient of logistic loss for one example $(x,y)$.

## Summary

Calculus gives CS the mathematics of local change and global accumulation. The chapters ahead make limits precise, turn derivatives into optimizers and backprop, connect integrals to probability and numerics, and extend everything to the multivariable setting of modern ML.
