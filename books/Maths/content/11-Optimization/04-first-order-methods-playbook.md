# First-Order Methods Playbook

Between pure math of convexity and code for training: a **playbook** of first-order algorithms, step sizes, and diagnostics. Complements gradient-methods material with a structured recipe sheet.

## Diagram: algorithm family

```text
  gradient available?
       │
      yes
       │
       v
  full-batch GD ──► SGD / mini-batch ──► momentum / Adam
       │                  │
       └── projection / proximal for constraints & L1
```

## 1. Gradient descent

$x_{k+1}=x_k-\eta\nabla f(x_k)$.

**Step size rules (convex smooth):** constant $\eta<2/L$ if $L$-smooth; line search; diminishing $\eta_k$.

## 2. SGD

$$
x_{k+1}=x_k-\eta_k g_k,\quad \mathbb{E}[g_k\mid x_k]=\nabla f(x_k)
$$

(noisy unbiased gradient). Variance helps escape sharp bad regions sometimes; hurts final precision.

## 3. Momentum

Velocity accumulates gradients:

$$
v_{k+1}=\beta v_k+\nabla f(x_k),\quad x_{k+1}=x_k-\eta v_{k+1}.
$$

Damps oscillations in narrow valleys.

```text
  zigzag GD:    /\/\/\/
  momentum:     ─────→  smoother
```

## 4. Adaptive methods (Adam sketch)

Track exponential moving averages of gradient and squared gradient; per-coordinate step sizes. Default for deep nets; for simple convex problems, carefully tuned SGD often matches or wins final optimum.

## 5. Constraints

- **Projection:** $x\leftarrow \Pi_C(x-\eta\nabla f)$  
- **Proximal:** soft-thresholding for $L_1$  
- **Lagrange / KKT:** see constrained-optimization chapter

## 6. Diagnostics checklist

| Symptom | Try |
|---------|-----|
| Loss → NaN | lower $\eta$, grad clip, check data |
| No progress | raise $\eta$, check grad scale / bugs |
| Train↓ val↑ | regularize, early stop, more data |
| Oscillation | lower $\eta$, add momentum carefully |

## 7. Complexity intuition

Smooth convex: GD $\mathcal{O}(1/\varepsilon)$ iterations to accuracy $\varepsilon$ (order-of-magnitude; exact rates depend on assumptions).  
Strongly convex: linear convergence possible.

## Exercises

1. For $f(x)=\frac12 L x^2$, what happens if $\eta>2/L$ in GD?  
2. Write one advantage and one disadvantage of mini-batch size $1$ vs full batch.  
3. Why is gradient *direction* more trustworthy than step length early in training?  
4. Soft-thresholding $\mathrm{prox}_{\lambda\|\cdot\|_1}$ — describe effect on coordinates.  
5. **Experiment design:** how would you pick $\eta$ with a log-spaced grid on a validation split?  
6. Name a problem class where second-order / Newton is worth it despite cost.

## Checks

1. Diverges / oscillates with increasing amplitude.  
4. Shrinks coefficients; exact zero if small.
