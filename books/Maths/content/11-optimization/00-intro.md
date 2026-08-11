# Optimization Theory for Computer Science

Optimization is the mathematical study of **choosing the best feasible point**. Almost every modern CS stack hides an optimizer: training a model, allocating resources, compiling code, routing traffic, or packing VMs. This part develops the language (objectives, constraints, convexity), the guarantees (global vs local minima, duality), and the algorithms (gradients, projections, regularized objectives) that make those systems work.

## Chapters in this part

| Chapter | Focus |
|---------|--------|
| Convexity | Convex sets/functions, why local = global |
| Constrained optimization | Feasibility, KKT intuition |
| Regularization | Ridge/Lasso and generalization |
| First-order methods playbook | GD, SGD, momentum, Adam diagnostics |
| Gradient methods | Deeper gradient algorithms |

## The canonical problem

$$
\begin{aligned}
\operatorname{minimize}_{x \in \mathcal{X}} &\quad f(x) \\
\operatorname{subject\ to} &\quad g_i(x) \le 0, \quad i=1,\ldots,m, \\
&\quad h_j(x) = 0, \quad j=1,\ldots,p.
\end{aligned}
$$

- $f$: **objective** (loss, cost, negative reward)
- $g_i$: **inequality constraints** (capacity, risk, nonnegativity)
- $h_j$: **equality constraints** (conservation, normalization)
- $\mathcal{X}$: ambient space, often $\mathbb{R}^n$ or a discrete set

A point is **feasible** if it satisfies all constraints. A feasible $x^\star$ is a **global minimizer** if $f(x^\star)\le f(x)$ for every feasible $x$. It is a **local minimizer** if this holds in a neighborhood of $x^\star$.

### Maximization

Maximizing $f$ is minimizing $-f$. All theory is stated for minimization without loss of generality.

## A taxonomy that actually helps

### By decision variables

| Type | Variables | Typical tools |
|------|-----------|---------------|
| Continuous | $x\in\mathbb{R}^n$ | Gradient methods, Newton, interior-point |
| Discrete / integer | $x\in\mathbb{Z}^n$ or combinatorial | Branch-and-bound, dynamic programming, approximation |
| Mixed-integer | continuous + integer | MILP/MIQP solvers |
| Functional / infinite-dim | functions, measures | calculus of variations, optimal control |

### By structure of $f$ and constraints

- **Linear program (LP):** linear objective and constraints — polynomial-time solvable in theory; extremely scalable in practice.
- **Quadratic program (QP):** quadratic objective, linear constraints — core of SVM duals, portfolio optimization.
- **Convex program:** convex $f$, convex inequality constraints, affine equalities — **local = global**.
- **Nonconvex:** neural net training, many combinatorial relaxations — local minima, saddles, initialization matter.

### By information used

- Zeroth-order: only $f$ values (black-box, bandits)
- First-order: gradients $\nabla f$ (SGD, Adam)
- Second-order: Hessians $\nabla^2 f$ (Newton, quasi-Newton)

## Why convexity is the “dividing line”

For a **convex** problem, any local minimum is global, first-order stationarity $\nabla f(x^\star)=0$ (unconstrained, differentiable) characterizes optima, and duality theory is strong under mild conditions. For nonconvex problems, you usually settle for **stationarity**, **approximate optimality**, or **problem-specific structure** (e.g. matrix completion under incoherence).

This is why ML theory obsesses over convex surrogates even when the “true” goal is combinatorial (0-1 loss).

## Optimization appears everywhere in CS

### Machine learning

- Empirical risk minimization: $\min_w \frac{1}{n}\sum_i \ell(y_i, f_w(x_i)) + \lambda \Omega(w)$
- Constrained training: fairness, safety, simplex constraints on probabilities
- Hyperparameter search: bilevel / black-box optimization

### Algorithms and theory

- Shortest paths and flows as combinatorial optimization
- Approximation algorithms: provable ratios for NP-hard objectives
- Online optimization: regret minimization

### Systems

- Compiler register allocation and instruction scheduling (ILP-ish)
- Database query plan selection (search over trees with cost models)
- Autoscaling and bin packing in cloud orchestration
- Congestion control as feedback optimization

### Worked example 1 — ridge regression as optimization

$$
\min_w \|Xw - y\|_2^2 + \lambda \|w\|_2^2.
$$

This is **strictly convex** for $\lambda>0$; the unique minimizer solves the linear system $(X^\top X+\lambda I)w=X^\top y$. Optimization theory tells you existence, uniqueness, and a stable algorithm (linear solve), not just “run GD.”

### Worked example 2 — resource allocation

Maximize $\sum_i \log(r_i)$ subject to $\sum_i r_i \le C$, $r_i\ge 0$ (proportional fairness). KKT conditions yield water-filling-like structure; used in networking and scheduling.

### Worked example 3 — nonconvex neural loss

$f(w)=\frac{1}{n}\sum_i \ell(y_i, f_w(x_i))$ for a deep net is nonconvex. Theory gives: smooth optimization finds **stationary points**; generalization needs statistics; practice uses SGD + overparameterization + regularization. Do not import convex guarantees blindly.

## Roadmap of this part

1. **Convexity** — sets, functions, first- and second-order characterizations, strong convexity, preservation rules.
2. **Constrained optimization** — Lagrangians, KKT conditions, dual problems, geometric intuition.
3. **Regularization and generalization** — ridge/lasso geometry, bias–variance, early stopping as implicit regularization.
4. **Gradient methods** — GD, SGD, momentum, adaptive methods, rates under smoothness/convexity.

## Prerequisites

- Multivariable calculus: gradients, Hessians, chain rule
- Linear algebra: norms, eigenvalues, PSD matrices
- Probability: expectations for stochastic optimization
- Comfort with “for all / exists” statements in definitions

## Modeling skill (underrated)

Bad models make perfect solvers useless. Good practice:

1. State decision variables **explicitly**.
2. Write the objective as a real-valued function (not vibes).
3. Encode hard requirements as constraints; soft preferences as penalties.
4. Check units and scaling (features, stepsizes).
5. Ask: convex? smooth? sparse? stochastic?

### Worked example 4 — modeling a deadline

“Finish jobs quickly” might be:

- minimize $\max_i C_i$ (makespan), or
- minimize $\sum_i C_i$ (total completion), or
- minimize $\sum_i w_i C_i$ (weighted).

These are **different mathematical problems** with different algorithms and hardness.

## Complexity reality check

| Problem class | Typical status |
|---------------|----------------|
| LP, convex QP (reasonable size) | Tractable |
| General integer linear programs | NP-hard; solvable at medium scale with solvers |
| Nonconvex continuous | Hard in worst case; heuristics + structure |
| Hyperparameter search | Expensive black box; Bayesian opt / bandits |

## Pitfalls

1. **Local vs global.** Reporting a training loss minimum is not global optimality unless convex (or proven otherwise).
2. **Constraints forgotten.** Unconstrained GD on probabilities can leave the simplex.
3. **Scaling.** Features with different magnitudes warp gradients and condition numbers.
4. **Discrete treated as continuous.** Rounding LP solutions needs approximation theory.
5. **Confusing modeling error with solver error.** A wrong objective is not fixed by Adam.

## Checkpoint

You should be able to:

- Write a general constrained optimization problem and define feasibility / global min
- Classify a problem as LP / convex / nonconvex at a glance
- Give three CS domains where optimization is the core mathematical problem
- Explain why convexity changes the meaning of “solving”
- Convert a vague product goal into variables + objective + constraints (at least roughly)

## Exercises

1. Write ERM for logistic regression with L2 penalty in the canonical $\min f$ form. Identify $f$ and $\mathcal{X}$.
2. Is $f(x)=x^4$ convex on $\mathbb{R}$? Is it strictly convex? Strongly convex?
3. Maximize $x(1-x)$ on $[0,1]$ by converting to a minimization problem.
4. Give a feasible set that is nonconvex; explain why projected gradient may fail if used naively.
5. Model: assign $n$ jobs to $m$ machines to minimize makespan. What are variables and constraints? (ILP sketch)
6. Why is $\min \|w\|_0$ s.t. $Xw=y$ harder than ridge regression?
7. Explain the difference between a **stationary point** and a **global minimizer**.
8. For $f(x,y)=x^2+y^2$ s.t. $x+y=1$, guess the optimum by geometry (closest point to origin on the line).
9. List two reasons SGD is preferred over full-batch GD for large $n$ in ML.
10. A team says “we optimized accuracy.” Rewrite as a precise mathematical objective (at least two legitimate versions).
11. Give an example where a local minimum is terrible compared to the global one (nonconvex 1D sketch).
12. Research prompt: what does “polynomial-time solvable” mean for LP in theory vs practical simplex?

## Summary

Optimization is the shared mathematical backbone of learning, resource control, and algorithmic decision-making. The rest of this part builds the convex foundation, the KKT/duality toolkit, regularization geometry, and gradient algorithms you will use constantly in ML and systems.
