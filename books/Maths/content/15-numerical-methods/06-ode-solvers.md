# Numerical Methods for Ordinary Differential Equations

An ordinary differential equation (ODE) tells you how a state **changes**; a solver tells you where the state **goes**. Orbits, circuits, chemical kinetics, epidemics, control loops, physics engines, and the "neural ODE" family all reduce to the same computational question: given $y'(t)=f(t,y)$ and a starting value, produce a trustworthy sequence $y_0,y_1,y_2,\ldots$ that tracks the true trajectory.

This chapter builds the working toolkit: Euler and Runge–Kutta methods, order of accuracy and how to *measure* it, absolute stability and **stiffness**, implicit methods, adaptive step-size control with embedded pairs, symplectic integrators for long-time mechanics, and how to drive a production solver (`scipy.integrate.solve_ivp`) without fooling yourself.

## 1. The initial value problem

An **initial value problem (IVP)** is

$$
y'(t)=f(t,y(t)),\qquad y(t_0)=y_0,\qquad t\in[t_0,T],
$$

where $y\in\mathbb{R}^m$ may be a vector (the state of the whole system).

**Theorem (Picard–Lindelöf, informal).** If $f$ is continuous in $t$ and **Lipschitz** in $y$, i.e. $\|f(t,y)-f(t,z)\|\le L\|y-z\|$, then the IVP has a unique solution on some interval around $t_0$.

The Lipschitz constant $L$ also bounds how fast nearby trajectories can separate: $\|y(t)-z(t)\|\le e^{L(t-t_0)}\|y_0-z_0\|$. That factor $e^{L(T-t_0)}$ reappears in every global error bound below—it is the **conditioning** of the IVP.

### Higher order becomes first order

Every explicit higher-order ODE is a first-order system. For $x''=g(t,x,x')$ set $y=(x,v)$ with $v=x'$:

$$
\begin{pmatrix}x\\ v\end{pmatrix}'=\begin{pmatrix}v\\ g(t,x,v)\end{pmatrix}.
$$

Solvers only ever see the first-order form.

### Worked example 1 — a pendulum as a system

$\theta''=-\frac{g}{\ell}\sin\theta$ becomes $y=(\theta,\omega)$, $f(t,y)=(\omega,\,-\tfrac{g}{\ell}\sin\theta)$. Two scalar unknowns, one vector ODE.

## 2. Forward Euler and the meaning of "order"

Replace the derivative by a forward difference over a step $h$:

$$
y_{n+1}=y_n+h\,f(t_n,y_n),\qquad t_{n+1}=t_n+h.
$$

**Local truncation error.** Plug the exact solution into the step. Taylor expansion gives $y(t+h)=y(t)+h\,y'(t)+\tfrac{h^2}{2}y''(\xi)$, so one Euler step commits an error of size $\tfrac{h^2}{2}|y''|$: the **local** error is $O(h^2)$.

**Global error.** Reaching $T$ takes $N=(T-t_0)/h$ steps; local errors accumulate (and are amplified by at most $e^{L(T-t_0)}$):

$$
\max_n\|y(t_n)-y_n\|\le \frac{hM}{2L}\left(e^{L(T-t_0)}-1\right),\qquad M=\max\|y''\|.
$$

The global error is $O(h)$. Euler is a **first-order** method.

**Definition.** A one-step method has **order $p$** if its local error is $O(h^{p+1})$, hence its global error is $O(h^p)$. Halving $h$ divides the global error by about $2^p$.

### Worked example 2 — Euler by hand

$y'=-2y$, $y(0)=1$, $h=0.1$:

| $n$ | $t_n$ | Euler $y_n$ | exact $e^{-2t_n}$ | error |
|-----|-------|-------------|-------------------|-------|
| 0 | 0.0 | 1.0000 | 1.0000 | 0 |
| 1 | 0.1 | 0.8000 | 0.8187 | 0.0187 |
| 2 | 0.2 | 0.6400 | 0.6703 | 0.0303 |

Each step multiplies by $(1-2h)=0.8$ instead of $e^{-0.2}\approx 0.8187$; the error compounds.

## 3. Runge–Kutta methods

Euler samples the slope once, at the start of the step. **Runge–Kutta (RK)** methods sample it several times inside the step and combine the samples so that Taylor terms cancel to higher order.

**Heun's method (explicit trapezoid, order 2):**

$$
k_1=f(t_n,y_n),\quad k_2=f(t_n+h,\,y_n+hk_1),\quad y_{n+1}=y_n+\tfrac{h}{2}(k_1+k_2).
$$

**Classic RK4 (order 4):**

$$
\begin{aligned}
k_1&=f(t_n,y_n), & k_2&=f\!\left(t_n+\tfrac h2,\,y_n+\tfrac h2k_1\right),\\
k_3&=f\!\left(t_n+\tfrac h2,\,y_n+\tfrac h2k_2\right), & k_4&=f(t_n+h,\,y_n+hk_3),\\
y_{n+1}&=y_n+\tfrac h6\,(k_1+2k_2+2k_3+k_4).
\end{aligned}
$$

### Butcher tableaux

An $s$-stage RK method is fully described by coefficients $(c_i, a_{ij}, b_j)$:
$k_i=f\big(t_n+c_ih,\;y_n+h\sum_j a_{ij}k_j\big)$, $y_{n+1}=y_n+h\sum_j b_jk_j$. Written as a table:

```text
RK4:                         Heun:
  0  |                         0 |
 1/2 | 1/2                     1 | 1
 1/2 |  0   1/2               ---+---------
  1  |  0    0    1              | 1/2  1/2
-----+--------------------
     | 1/6  1/3  1/3  1/6
```

Strictly lower-triangular $A$ means **explicit**: each stage uses only earlier stages. A nonzero diagonal or upper part means **implicit**: stages must be solved for (Section 6).

### Worked example 3 — one Heun step

$y'=-2y$, $y_0=1$, $h=0.1$: $k_1=-2$, $k_2=-2(1-0.2)=-1.6$, $y_1=1+0.05(-3.6)=0.82$. Exact $0.818731$: error $1.3\times10^{-3}$, versus $1.9\times10^{-2}$ for Euler with the same $h$.

## 4. Measure the order — do not trust the label

The cheapest correctness test for any integrator: solve a problem with a known solution at $h, h/2, h/4,\ldots$ and compute the **observed order** $\log_2(e_h/e_{h/2})$. A buggy RK4 coefficient usually still "works" but drops to order 1 or 2—only this test catches it.

```python
# file: convergence_order.py
# Observed order of Euler, Heun (RK2) and classic RK4 on y' = -2ty, y(0)=1.
# Exact solution: y(t) = exp(-t^2).  Integrate to t = 2.
import math


def f(t, y):
    return -2.0 * t * y


def euler_step(f, t, y, h):
    return y + h * f(t, y)


def heun_step(f, t, y, h):
    k1 = f(t, y)
    k2 = f(t + h, y + h * k1)
    return y + 0.5 * h * (k1 + k2)


def rk4_step(f, t, y, h):
    k1 = f(t, y)
    k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
    k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
    k4 = f(t + h, y + h * k3)
    return y + (h / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4)


def integrate(step, n, T=2.0):
    h, t, y = T / n, 0.0, 1.0
    for _ in range(n):
        y = step(f, t, y, h)
        t += h
    return y


exact = math.exp(-4.0)
print(f"{'n':>6} {'Euler err':>11} {'Heun err':>11} {'RK4 err':>11}")
prev = None
for n in [20, 40, 80, 160, 320]:
    errs = [abs(integrate(s, n) - exact) for s in (euler_step, heun_step, rk4_step)]
    line = f"{n:>6} " + " ".join(f"{e:11.3e}" for e in errs)
    if prev:
        orders = [math.log2(p / e) for p, e in zip(prev, errs)]
        line += "   order≈ " + " ".join(f"{o:4.2f}" for o in orders)
    print(line)
    prev = errs
```

Run it (standard library only):

```bash
python3 convergence_order.py
```

Output:

```text
     n   Euler err    Heun err     RK4 err
    20   6.293e-03   1.258e-03   6.813e-06
    40   3.102e-03   2.749e-04   3.725e-07   order≈ 1.02 2.19 4.19
    80   1.539e-03   6.464e-05   2.177e-08   order≈ 1.01 2.09 4.10
   160   7.663e-04   1.570e-05   1.316e-09   order≈ 1.01 2.04 4.05
   320   3.824e-04   3.869e-06   8.085e-11   order≈ 1.00 2.02 4.02
```

The observed orders converge to 1, 2, 4. Notice the economics: RK4 at $n=20$ (80 slope evaluations) beats Euler at $n=320$ (320 evaluations) by a factor of about 60 in error.

### Worked example 4 — cost per digit

To gain one more decimal digit, a method of order $p$ needs $10^{1/p}$ times as many steps: $10\times$ for Euler, $1.78\times$ for RK4. High order wins whenever the solution is smooth.

## 5. Absolute stability and stiffness

Order describes what happens as $h\to 0$. Real computations use a **finite** $h$, and then a second question dominates: do errors *decay* or *grow* from step to step?

### The test equation

Apply a method to $y'=\lambda y$ with $\operatorname{Re}\lambda<0$ (true solution decays). Every RK method produces $y_{n+1}=R(z)\,y_n$ with $z=h\lambda$; $R$ is the method's **stability function**.

| Method | $R(z)$ | Stable on the negative real axis for |
|--------|--------|--------------------------------------|
| Forward Euler | $1+z$ | $-2\le z\le 0$ |
| Heun / RK2 | $1+z+\tfrac{z^2}{2}$ | $-2\le z\le 0$ |
| RK4 | $1+z+\tfrac{z^2}{2}+\tfrac{z^3}{6}+\tfrac{z^4}{24}$ | $-2.785\lesssim z\le 0$ |
| Backward Euler | $\dfrac{1}{1-z}$ | all $z\le 0$ (whole left half-plane) |
| Trapezoid (implicit) | $\dfrac{1+z/2}{1-z/2}$ | all $z\le 0$ (whole left half-plane) |

The **region of absolute stability** is $\{z\in\mathbb{C}:|R(z)|\le 1\}$. A method is **A-stable** if that region contains the entire left half-plane. For systems $y'=Jy$, the condition must hold for $z=h\lambda_i$ for **every** eigenvalue $\lambda_i$ of the Jacobian $J$.

**Fact.** The stability function of an explicit RK method is a polynomial, so $|R(z)|\to\infty$ as $z\to-\infty$: **no explicit RK method is A-stable**.

### Stiffness

A problem is **stiff** when the Jacobian has eigenvalues with large negative real part (fast, strongly damped modes) while the solution you care about evolves slowly. An explicit method must keep $h\,|\lambda_{\max}|$ inside its small stability interval to avoid blow-up—even long after the fast transient has died and accuracy alone would allow a much bigger step. The step size is set by **stability**, not by **accuracy**: that is the working definition of stiffness.

### Worked example 5 — Euler explodes, backward Euler shrugs

$y'=-a(y-\cos t)$, $y(0)=0$, $a=1000$. After a transient of duration $\sim 1/a$, the solution follows $\cos t$ closely. Forward Euler needs $h<2/a=0.002$.

**Backward (implicit) Euler** evaluates the slope at the *end* of the step:

$$
y_{n+1}=y_n+h\,f(t_{n+1},y_{n+1}).
$$

Here $f$ is linear in $y$, so each step is a scalar solve.

```python
# file: stiff_euler.py
# Stiff test problem: y' = -a (y - cos t), y(0) = 0, a = 1000, on [0, 0.2].
# After a transient of length ~1/a the solution hugs cos t.
# Forward Euler is stable only if h < 2/a; backward Euler is stable for all h > 0.
import math

A = 1000.0
T = 0.2


def exact(t):
    p = A * A / (1 + A * A)
    q = A / (1 + A * A)
    return p * math.cos(t) + q * math.sin(t) - p * math.exp(-A * t)


def forward_euler(h):
    t, y = 0.0, 0.0
    for _ in range(round(T / h)):
        y = y - h * A * (y - math.cos(t))
        t += h
    return y


def backward_euler(h):
    # y_{n+1} = y_n - h*A*(y_{n+1} - cos t_{n+1}): linear in y_{n+1}, solve directly
    t, y = 0.0, 0.0
    for _ in range(round(T / h)):
        t += h
        y = (y + h * A * math.cos(t)) / (1.0 + h * A)
    return y


print(f"exact y({T}) = {exact(T):.6f}")
for h in [0.0005, 0.0016, 0.002, 0.0025, 0.01, 0.05]:
    fe, be = forward_euler(h), backward_euler(h)
    print(f"h={h:<6}  h*a={h*A:5.1f}  forward={fe:12.5g}  backward={be:.6f}")
```

```bash
python3 stiff_euler.py
```

Output:

```text
exact y(0.2) = 0.980264
h=0.0005  h*a=  0.5  forward=     0.98026  backward=0.980264
h=0.0016  h*a=  1.6  forward=     0.98027  backward=0.980263
h=0.002   h*a=  2.0  forward=   -0.019735  backward=0.980263
h=0.0025  h*a=  2.5  forward= -1.2226e+14  backward=0.980263
h=0.01    h*a= 10.0  forward= -1.2158e+19  backward=0.980259
h=0.05    h*a= 50.0  forward= -5.7649e+06  backward=0.980240
```

Read the rows:

- $ha<2$: forward Euler is fine.
- $ha=2$ exactly: $R=-1$; the initial transient error (size $\approx 1$) neither grows nor decays—it flips sign every step, so the answer is off by almost exactly $1$.
- $ha>2$: $|R|>1$ and the error grows geometrically to $10^{14}$ and beyond.
- Backward Euler stays accurate to about $10^{-5}$ even with $h=0.05$ (only four steps), because $|1/(1+ha)|<1$ for every $h>0$.

## 6. Implicit methods in practice

For nonlinear $f$, each implicit step is a nonlinear system. For backward Euler:

$$
G(Y)=Y-y_n-h\,f(t_{n+1},Y)=0,\qquad G'(Y)=I-h\,J(t_{n+1},Y).
$$

Solvers apply (simplified) **Newton** iterations: factor $I-hJ$ once, reuse it across iterations and often across several steps, refactor only when convergence slows or $h$ changes a lot. Consequences:

| Consequence | Why it matters |
|-------------|----------------|
| Each step costs a linear solve | $O(m^3)$ dense, far less if $J$ is sparse/banded |
| A good Jacobian pays off | Supply `jac=` analytically or a sparsity pattern; finite-difference Jacobians cost $m$ extra $f$ calls |
| Fewer, much larger steps | The win on stiff problems is often 100–1000× in step count |

**Families you will meet:**

- **BDF** (backward differentiation formulas): implicit multistep, orders 1–5 in common codes. BDF1 is backward Euler; BDF1–2 are A-stable; higher orders trade a sliver of the left half-plane for accuracy.
- **Radau IIA**: implicit RK, order 5 in SciPy's `Radau`, A-stable and **L-stable** ($R(z)\to 0$ as $z\to-\infty$, so very stiff modes are damped in one step rather than merely kept bounded).
- **Trapezoid / Crank–Nicolson**: A-stable but $R(z)\to-1$ as $z\to-\infty$, so stiff modes ring (sign-flipping, slowly decaying). Fine for diffusion with moderate steps; poor for very stiff transients.

**Dahlquist's second barrier.** An A-stable *linear multistep* method has order at most 2. That is why high-order stiff solvers either relax A-stability (BDF3–5) or use implicit Runge–Kutta (Radau).

## 7. Adaptive step-size control

A fixed $h$ is either wasteful where the solution is smooth or inaccurate where it changes fast. Production solvers **choose $h$ per step** from an error estimate.

### Embedded pairs

Use two RK formulas of orders $p$ and $p-1$ that share the same stages. Their difference estimates the local error of the lower-order one almost for free:

$$
\text{err}=\left\|\frac{y^{[p]}_{n+1}-y^{[p-1]}_{n+1}}{\text{atol}+\text{rtol}\cdot|y_{n+1}|}\right\|.
$$

Accept the step if $\text{err}\le 1$; either way, update the step size with

$$
h_{\text{new}}=h\cdot\min\!\Big(f_{\max},\,\max\!\big(f_{\min},\;0.9\,\text{err}^{-1/p}\big)\Big),
$$

because the estimated error scales like $h^{p}$ (the lower-order formula has local error $O(h^p)$). The safety factor $0.9$ and clamps $[f_{\min},f_{\max}]$ prevent oscillation.

**Common pairs:** Bogacki–Shampine 3(2) (SciPy `RK23`, MATLAB `ode23`), Dormand–Prince 5(4) (SciPy `RK45`, MATLAB `ode45`), Dormand–Prince 8(5,3) (SciPy `DOP853`). These pairs propagate the **higher**-order solution ("local extrapolation") and are **FSAL**: the last stage of an accepted step equals the first stage of the next, saving one evaluation per step.

```python
# file: adaptive_bs23.py
# Adaptive Bogacki–Shampine 3(2) embedded Runge–Kutta pair with a standard step controller.
# Problem: y' = -2ty, y(0) = 1, exact y = exp(-t^2), integrate to t = 2.
import math


def f(t, y):
    return -2.0 * t * y


def bs23(f, t0, y0, t_end, rtol, atol, h=1e-2):
    t, y = t0, y0
    k1 = f(t, y)  # FSAL: first stage of the next step equals the last stage of this one
    accepted = rejected = 0
    while t < t_end:
        h = min(h, t_end - t)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.75 * h, y + 0.75 * h * k2)
        y3 = y + h * (2 * k1 + 3 * k2 + 4 * k3) / 9.0          # 3rd-order solution
        k4 = f(t + h, y3)
        y2 = y + h * (7 * k1 / 24 + k2 / 4 + k3 / 3 + k4 / 8)  # embedded 2nd-order
        scale = atol + rtol * max(abs(y), abs(y3))
        err = abs(y3 - y2) / scale                              # <= 1 means "acceptable"
        if err <= 1.0:
            t, y, k1 = t + h, y3, k4                            # accept, reuse k4
            accepted += 1
        else:
            rejected += 1
        # step-size update: error ~ h^3 for the lower-order estimate -> exponent 1/3
        factor = 0.9 * (1.0 / err) ** (1.0 / 3.0) if err > 0 else 5.0
        h *= min(5.0, max(0.2, factor))
    return y, accepted, rejected


exact = math.exp(-4.0)
print(f"{'rtol':>8} {'steps':>6} {'rejects':>7} {'f-evals':>7} {'abs err':>10}")
for rtol in [1e-3, 1e-5, 1e-7, 1e-9]:
    y, acc, rej = bs23(f, 0.0, 1.0, 2.0, rtol=rtol, atol=rtol * 1e-3)
    nfev = 1 + 3 * (acc + rej)
    print(f"{rtol:8.0e} {acc:6d} {rej:7d} {nfev:7d} {abs(y - exact):10.2e}")
```

```bash
python3 adaptive_bs23.py
```

Output:

```text
    rtol  steps rejects f-evals    abs err
   1e-03     11       2      40   1.22e-03
   1e-05     51       4     166   3.60e-06
   1e-07    236       5     724   3.13e-08
   1e-09   1100       6    3319   3.48e-10
```

Two lessons:

1. **Work scales like $\text{tol}^{-1/3}$** for a third-order method: each factor of 100 in tolerance costs $100^{1/3}\approx 4.6\times$ more steps (51 → 236 → 1100).
2. **Tolerances control local error, not global error.** Here the final error happens to sit near `rtol`, but for unstable or long-time problems the global error can be orders of magnitude larger than the tolerance. Verify by re-running at a tighter tolerance and comparing.

### Worked example 6 — choosing tolerances

A state with components of very different magnitudes (e.g. concentrations near $10^{-9}$ alongside temperatures near $300$) needs a **per-component** `atol`: a scalar `atol=1e-6` silently lets the tiny component be pure noise. SciPy accepts an array for `atol`.

## 8. Production solvers: `solve_ivp`

SciPy's `solve_ivp` exposes the families above behind one interface:

| `method=` | Type | Order | Use when |
|-----------|------|-------|----------|
| `RK45` (default) | explicit, Dormand–Prince 5(4) | 5 | non-stiff, moderate accuracy |
| `RK23` | explicit, Bogacki–Shampine 3(2) | 3 | loose tolerances, cheap $f$ |
| `DOP853` | explicit, Dormand–Prince 8 | 8 | non-stiff, tight tolerances |
| `Radau` | implicit RK (Radau IIA) | 5 | stiff, high accuracy |
| `BDF` | implicit multistep | 1–5 (variable) | stiff, large systems, sparse Jacobians |
| `LSODA` | Adams ↔ BDF switching (ODEPACK) | variable | unsure whether stiff |

Defaults are `rtol=1e-3`, `atol=1e-6`—loose. Set them explicitly. Also useful: `dense_output=True` (continuous interpolant between steps), `t_eval=` (report at chosen times without forcing step sizes), `events=` (root-find a condition such as "ball hits the floor"), `jac=` / `jac_sparsity=` for implicit methods.

### Worked example 7 — the Van der Pol stiffness benchmark

$x''-\mu(1-x^2)x'+x=0$. For $\mu=1$ it is a gentle limit cycle; for $\mu=1000$ it alternates slow drifts with abrupt jumps, and the Jacobian's fast eigenvalue is of order $-\mu$ on the slow branches.

```python
# file: vdp_solve_ivp.py
# Van der Pol oscillator  x'' - mu (1 - x^2) x' + x = 0  as a first-order system.
# mu = 1 is non-stiff; mu = 1000 is the classic stiff benchmark.
import time

import numpy as np
from scipy.integrate import solve_ivp


def vdp(mu):
    def rhs(t, y):
        x, v = y
        return [v, mu * (1 - x * x) * v - x]

    def jac(t, y):
        x, v = y
        return [[0.0, 1.0], [-2 * mu * x * v - 1.0, mu * (1 - x * x)]]

    return rhs, jac


for mu, t_end in [(1.0, 20.0), (1000.0, 3000.0)]:
    rhs, jac = vdp(mu)
    print(f"mu = {mu:g}, t in [0, {t_end:g}]")
    for method in ["RK45", "DOP853", "Radau", "BDF", "LSODA"]:
        kw = {"jac": jac} if method in ("Radau", "BDF", "LSODA") else {}
        t0 = time.perf_counter()
        sol = solve_ivp(rhs, (0.0, t_end), [2.0, 0.0], method=method,
                        rtol=1e-6, atol=1e-9, **kw)
        dt = time.perf_counter() - t0
        print(f"  {method:7s} ok={sol.success!s:5}  steps={sol.t.size - 1:7d}  "
              f"nfev={sol.nfev:8d}  njev={sol.njev:4d}  x(end)={sol.y[0, -1]: .6f}  {dt:6.2f}s")
```

```bash
python3 -m venv .venv && . .venv/bin/activate
pip install numpy scipy
python vdp_solve_ivp.py      # the two explicit stiff runs take about a minute each
```

Output (SciPy 1.18.1, NumPy 2.5.3, one Xeon core; timings vary by machine):

```text
mu = 1, t in [0, 20]
  RK45    ok=True   steps=    176  nfev=    1436  njev=   0  x(end)= 2.008149    0.01s
  DOP853  ok=True   steps=     69  nfev=    1070  njev=   0  x(end)= 2.008151    0.01s
  Radau   ok=True   steps=    498  nfev=    3773  njev=  41  x(end)= 2.008150    0.09s
  BDF     ok=True   steps=    666  nfev=    1616  njev=   1  x(end)= 2.008149    0.06s
  LSODA   ok=True   steps=    478  nfev=    1046  njev=   0  x(end)= 2.008148    0.00s
mu = 1000, t in [0, 3000]
  RK45    ok=True   steps=1689345  nfev=11825108  njev=   0  x(end)=-1.510606   64.48s
  DOP853  ok=True   steps= 874676  nfev=10498658  njev=   0  x(end)=-1.510606   52.66s
  Radau   ok=True   steps=   1282  nfev=   10746  njev= 306  x(end)=-1.510607    0.23s
  BDF     ok=True   steps=   1848  nfev=    5593  njev= 102  x(end)=-1.510585    0.18s
  LSODA   ok=True   steps=   1896  nfev=    3257  njev= 232  x(end)=-1.510584    0.01s
```

What the table says:

- **Non-stiff ($\mu=1$):** explicit methods win; `DOP853` takes the fewest steps at this tight tolerance. Implicit methods pay for Jacobians and linear solves they do not need.
- **Stiff ($\mu=1000$):** explicit methods still *succeed*—adaptivity keeps them stable—but need about $10^6$ steps and two to three orders of magnitude more wall time, because $h$ is pinned near the stability limit for the entire run. Implicit methods take about a thousand steps.
- `LSODA` used no Jacobian at $\mu=1$ (it stayed with non-stiff Adams formulas) and switched to BDF with Jacobians at $\mu=1000$.
- The `x(end)` values agree to about $2\times10^{-5}$ across methods: consistent with tolerances that bound local, not global, error on a trajectory with sharp jumps.

**Diagnostic rule:** if an explicit solver reports success but takes a huge number of tiny, nearly uniform steps where the solution looks smooth, the problem is stiff. Switch to `Radau`/`BDF`/`LSODA` and supply a Jacobian.

## 9. Long-time integration and geometric methods

For conservative mechanics (planets, molecules, ideal oscillators) small *systematic* errors matter more than small *random* ones: a method that loses 0.01% energy per orbit has lost most of it after $10^4$ orbits, regardless of its order.

A Hamiltonian system $q'=\partial H/\partial p$, $p'=-\partial H/\partial q$ has a flow that preserves phase-space area (it is **symplectic**). **Symplectic integrators** preserve that structure exactly. Backward error analysis shows they exactly conserve a *modified* energy $\tilde H=H+O(h^p)$, so the true energy error stays **bounded** over very long times instead of drifting.

**Störmer–Verlet (leapfrog)** for $H=\tfrac12p^2+V(q)$ ("kick–drift–kick"):

$$
p_{n+1/2}=p_n-\tfrac h2V'(q_n),\quad q_{n+1}=q_n+h\,p_{n+1/2},\quad p_{n+1}=p_{n+1/2}-\tfrac h2V'(q_{n+1}).
$$

Second order, explicit, one force evaluation per step, time-reversible.

```python
# file: energy_drift.py
# Harmonic oscillator q' = p, p' = -q; energy E = (p^2 + q^2)/2 should stay 0.5.
# Compare classic RK4 with Störmer–Verlet (leapfrog), a 2nd-order symplectic method.
def rk4(q, p, h):
    def f(q, p):
        return p, -q
    k1q, k1p = f(q, p)
    k2q, k2p = f(q + h / 2 * k1q, p + h / 2 * k1p)
    k3q, k3p = f(q + h / 2 * k2q, p + h / 2 * k2p)
    k4q, k4p = f(q + h * k3q, p + h * k3p)
    return (q + h / 6 * (k1q + 2 * k2q + 2 * k3q + k4q),
            p + h / 6 * (k1p + 2 * k2p + 2 * k3p + k4p))


def verlet(q, p, h):
    p_half = p - h / 2 * q        # kick
    q_new = q + h * p_half        # drift
    p_new = p_half - h / 2 * q_new  # kick
    return q_new, p_new


h = 0.5
print(f"h = {h}; energy error E - 0.5 after N steps")
print(f"{'N':>8} {'RK4':>12} {'Verlet':>12}")
qa, pa = 1.0, 0.0
qb, pb = 1.0, 0.0
checkpoints = {10, 100, 1000, 10000, 100000}
for n in range(1, 100001):
    qa, pa = rk4(qa, pa, h)
    qb, pb = verlet(qb, pb, h)
    if n in checkpoints:
        ea = 0.5 * (qa * qa + pa * pa) - 0.5
        eb = 0.5 * (qb * qb + pb * pb) - 0.5
        print(f"{n:>8} {ea:12.3e} {eb:12.3e}")
```

```bash
python3 energy_drift.py
```

Output:

```text
h = 0.5; energy error E - 0.5 after N steps
       N          RK4       Verlet
      10   -1.050e-03   -2.775e-02
     100   -1.040e-02   -2.232e-03
    1000   -9.481e-02   -5.571e-03
   10000   -4.389e-01   -2.751e-02
  100000   -5.000e-01   -4.552e-03
```

RK4 is *more accurate per step* (fourth order) yet bleeds energy monotonically: $|R(ih)|<1$ for this $h$, so the oscillation is artificially damped until it has essentially stopped. Verlet's energy error oscillates and never exceeds $h^2/8=0.03125$ over all $10^5$ steps (about 8,000 periods).

### Worked example 8 — pick by the question

- "Where is the satellite in 3 hours, to 1 m?" → high-order adaptive RK (`DOP853`), tight tolerances.
- "Is this planetary system stable over a million orbits?" → symplectic, fixed step.
- "Concentrations in a reaction network with rates from $10^{-3}$ to $10^{6}$ s⁻¹" → stiff solver (`BDF`/`Radau`) with a sparse Jacobian.

## 10. Multistep methods (map)

Instead of re-sampling inside each step, **linear multistep methods** reuse slopes from previous steps:

| Family | Example | Notes |
|--------|---------|-------|
| Adams–Bashforth (explicit) | $y_{n+1}=y_n+\tfrac h2(3f_n-f_{n-1})$ | One new $f$ per step; small stability region |
| Adams–Moulton (implicit) | trapezoid is AM2 | Used as corrector in predictor–corrector pairs |
| BDF (implicit) | $\tfrac32y_{n+1}-2y_n+\tfrac12y_{n-1}=hf_{n+1}$ (BDF2) | Stiff workhorse |

**Dahlquist equivalence theorem:** a linear multistep method converges if and only if it is **consistent** (order $\ge 1$) and **zero-stable** (its characteristic polynomial's roots lie in the closed unit disk, with roots on the circle simple). Multistep methods need a starter (an RK step or order ramp-up) and care when $h$ changes; mature codes handle both.

## 11. Pitfalls

1. **Explicit solver on a stiff problem.** It "works", slowly—or appears to hang. Watch the step count.
2. **Trusting default tolerances.** `rtol=1e-3` is three digits per step; the global error can be much worse.
3. **Scalar `atol` for multi-scale states.** Small components drown in absolute tolerance.
4. **Non-smooth right-hand sides** (`if`, `abs`, table lookups, controller saturations). Adaptive solvers shrink $h$ to crawl across kinks, and order is lost. Split the integration at known switching times or use `events=` to stop and restart.
5. **Checking only one $h$ or one tolerance.** Always re-run tighter; agreement is the evidence.
6. **Wrong Jacobian.** A buggy analytic `jac` makes implicit solvers take tiny steps or fail; test it against finite differences first.
7. **Energy drift misread as physics.** A slowly decaying "conservative" system usually means a non-symplectic integrator, not friction.
8. **Global error mistaken for local error.** For chaotic systems (positive Lyapunov exponent), *pointwise* accuracy is lost after a finite horizon no matter the tolerance; trust statistics, not individual long trajectories.

## 12. Checkpoint

- Convert a second-order ODE into a first-order system.
- Derive Euler's local error $O(h^2)$ and explain why the global error is $O(h)$.
- Write the RK4 stages and its Butcher tableau.
- Measure the observed order of a solver from errors at $h$ and $h/2$.
- Compute the stability function for Euler and backward Euler and state their step limits on $y'=\lambda y$.
- Define stiffness operationally and name two stiff solvers.
- Explain how an embedded pair estimates error and how $h$ is updated.
- Say when you would use a symplectic integrator instead of RK4.

## Exercises

### Easy

1. Write $x'''=x\,x'-t$ as a first-order system.
2. One Euler step and one Heun step for $y'=t+y$, $y(0)=1$, $h=0.1$. Compare to the exact $y=2e^t-t-1$.
3. For $y'=-50y$, what is the largest stable step for forward Euler? For RK4 (use the table)?
4. If a method's error drops from $3.2\times10^{-4}$ to $2.0\times10^{-5}$ when $h$ halves, what is its observed order?
5. Why does an FSAL pair cost one fewer $f$ evaluation per accepted step?

### Medium

6. Derive $R(z)$ for Heun's method and verify that it matches the Taylor series of $e^z$ through $z^2$.
7. Show that the trapezoid rule is A-stable but $R(z)\to-1$ as $z\to-\infty$. What does that imply for very stiff modes?
8. Modify `adaptive_bs23.py` to print the accepted step sizes and plot $h$ against $t$. Explain the shape.
9. For $y'=Jy$ with $J=\begin{pmatrix}-1&0\\0&-1000\end{pmatrix}$, which eigenvalue limits explicit Euler's step? Which one determines accuracy after $t=0.01$?
10. Re-run `vdp_solve_ivp.py` for $\mu=1000$ with `Radau` but *without* `jac=`. Compare `nfev` and explain the difference.

### Challenge

11. Implement the implicit midpoint rule for a nonlinear $f$ using Newton iterations. Verify order 2 and A-stability numerically.
12. Prove that Störmer–Verlet is symplectic for $H=\tfrac12p^2+V(q)$ (show that the step map has Jacobian determinant 1).
13. Derive the modified energy conserved by Verlet on the harmonic oscillator, and explain why the bound $h^2/8$ appears.
14. Add `events=` to the Van der Pol run to record every zero crossing of $x$; estimate the period for $\mu=1000$ and compare it with the asymptotic $(3-2\ln 2)\mu$.
15. Implement BDF2 with a fixed step for the stiff problem in `stiff_euler.py`; measure its order and compare its accuracy to backward Euler at $h=0.01$.

## Summary

An ODE solver is judged on three separate axes. **Order** governs how the error shrinks as $h\to 0$, and you should measure it rather than trust it. **Stability** governs whether errors grow at the step size you can actually afford; stiffness makes it the dominant constraint and is the reason implicit methods (BDF, Radau) exist. **Structure** governs long-time fidelity: symplectic methods keep energy bounded where higher-order generic methods drift. In practice: start with an adaptive explicit pair, set tolerances deliberately, watch the step count for signs of stiffness, switch to an implicit solver with a real Jacobian when needed, and always confirm a result by tightening the tolerance.

## Sources (for further reading)

- Hairer, Nørsett & Wanner, *Solving Ordinary Differential Equations I: Nonstiff Problems* (2nd ed., Springer) — order conditions, embedded pairs, step-size control.
- Hairer & Wanner, *Solving Ordinary Differential Equations II: Stiff and Differential-Algebraic Problems* (2nd ed., Springer) — stiffness, A-/L-stability, Radau IIA, the Van der Pol benchmark.
- Hairer, Lubich & Wanner, *Geometric Numerical Integration* (2nd ed., Springer) — symplectic methods, Störmer–Verlet, backward error analysis.
- Dormand & Prince (1980), "A family of embedded Runge–Kutta formulae"; Bogacki & Shampine (1989), "A 3(2) pair of Runge–Kutta formulas."
- Shampine & Reichelt (1997), "The MATLAB ODE Suite" — practical design of `ode23`/`ode45`/`ode15s`.
- SciPy documentation, `scipy.integrate.solve_ivp` — methods, tolerances, events, dense output.
