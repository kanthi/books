# Constrained Optimization and KKT

## 1. Problem Form

Minimize `f(x)` subject to:
- equality constraints `g_i(x)=0`
- inequality constraints `h_j(x)<=0`

## 2. Lagrangian

`L(x,lambda,mu) = f(x) + sum lambda_i g_i(x) + sum mu_j h_j(x)`.

## 3. KKT Conditions

Under regularity assumptions, optimum satisfies:
1. stationarity: `grad_x L = 0`
2. primal feasibility
3. dual feasibility: `mu_j >= 0`
4. complementary slackness: `mu_j h_j(x)=0`

## 4. Geometric Intuition

At optimum, objective gradient lies in span/cone of active constraint gradients.

## 5. Worked Example

Minimize `x^2+y^2` subject to `x+y=1`.
Lagrangian gives solution `x=y=1/2`.

## 6. Convex Case

For convex problems with Slater condition, KKT are sufficient and strong duality often holds.

## Exercises

1. Solve constrained quadratic with one linear equality.
2. Identify active constraints in sample inequality system.
3. Verify KKT conditions numerically for simple problem.
4. Explain complementary slackness in plain language.
