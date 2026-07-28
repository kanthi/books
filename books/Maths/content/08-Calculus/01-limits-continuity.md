# Limits and Continuity

Limits make precise the idea that $f(x)$ approaches a value as $x$ approaches a point. Continuity means the function’s value matches that limiting behavior. These notions underwrite derivatives, integrals, and the well-posedness of many numerical methods.

## 1. Informal idea

$\lim_{x\to a} f(x)=L$ means: $f(x)$ can be forced arbitrarily close to $L$ by taking $x$ sufficiently close to $a$ (but not necessarily equal to $a$).

### Worked example 1

$f(x)=(x^2-1)/(x-1)$ for $x\neq 1$. As $x\to 1$, $f(x)\to 2$, even though $f$ may be undefined at $1$.

## 2. Epsilon–delta definition

**Definition.** $\lim_{x\to a} f(x)=L$ means: for every $\varepsilon>0$ there exists $\delta>0$ such that if $0<|x-a|<\delta$, then $|f(x)-L|<\varepsilon$.

### Worked example 2 — linear function

Prove $\lim_{x\to 3}(2x+1)=7$. Given $\varepsilon>0$, need $|2x+1-7|=2|x-3|<\varepsilon$, so pick $\delta=\varepsilon/2$.

### Worked example 3 — quadratic sketch

$\lim_{x\to 2}x^2=4$: bound $|x^2-4|=|x-2||x+2|$; restrict $\delta\le 1$ so $|x+2|\le 5$, then $\delta=\min(1,\varepsilon/5)$.

## 3. One-sided limits

- Right-hand: $x\to a^+$ with $x>a$  
- Left-hand: $x\to a^-$ with $x<a$  

Two-sided limit exists iff both one-sided limits exist and are equal.

### Worked example 4 — jump

$f(x)=0$ for $x<0$, $f(x)=1$ for $x\ge 0$: $\lim_{x\to 0^-}f=0$, $\lim_{x\to 0^+}f=1$—no two-sided limit.

### Worked example 5 — absolute value

$\lim_{x\to 0}|x|=0$ even though not differentiable there—limits weaker than derivatives.

## 4. Infinite limits and asymptotes

$\lim_{x\to a}f(x)=\infty$ means $f$ grows without bound as $x\to a$ (vertical asymptote patterns). Horizontal asymptotes: $\lim_{x\to\pm\infty}f(x)=L$.

### Worked example 6

$1/x\to+\infty$ as $x\to 0^+$; $\to-\infty$ as $x\to 0^-$.  
$(1+1/n)^n\to e$ as $n\to\infty$—sequence limit important in CS interest rates / continuous compounding / Poisson processes.

## 5. Continuity

**Definition.** $f$ continuous at $a$ if:

1. $f(a)$ defined  
2. $\lim_{x\to a}f(x)$ exists  
3. $\lim_{x\to a}f(x)=f(a)$  

Continuous on an interval if continuous at every point (one-sided at endpoints).

### Worked example 7

Polynomials, exp, sin, cos are continuous everywhere on $\mathbb{R}$. Rational functions continuous where denominator $\neq 0$.

### Worked example 8 — removable discontinuity

Define $f(1)=2$ for the simplified $(x^2-1)/(x-1)$ to make continuous at $1$.

## 6. Types of discontinuities

| Type | Behavior |
|------|----------|
| Removable | limit exists, ≠ $f(a)$ or $f(a)$ missing |
| Jump | one-sided limits differ |
| Infinite | blow-up |
| Oscillatory | e.g. $\sin(1/x)$ as $x\to 0$ |

### Worked example 9

$\sin(1/x)$ as $x\to 0$: no limit (oscillates wildly).

## 7. Algebra of limits

If $\lim f=L$, $\lim g=M$:

- $\lim(f\pm g)=L\pm M$  
- $\lim(fg)=LM$  
- $\lim(f/g)=L/M$ if $M\neq 0$  
- $\lim g\circ f = g(L)$ if $g$ continuous at $L$  

### Worked example 10

$\lim_{x\to 0}\frac{\sin x}{x}=1$ (standard theorem)—foundation for derivative of $\sin$.

### Worked example 11

$\lim_{x\to 0}\frac{e^x-1}{x}=1$—derivative of $\exp$ at 0.

## 8. Intermediate Value Theorem (IVT)

**Theorem.** If $f$ continuous on $[a,b]$ and $N$ between $f(a)$ and $f(b)$, then $\exists c\in[a,b]$ with $f(c)=N$.

**CS use:** bisection root finding requires a sign change and continuity—IVT guarantees a root.

### Worked example 12

$f(x)=x^3-x-2$ on $[1,2]$: $f(1)<0<f(2)$ $\Rightarrow$ root exists.

## 9. Extreme Value Theorem

Continuous $f$ on compact $[a,b]$ attains min and max. Underpins optimization existence on closed bounded sets.

## 10. CS connections

- Stability of numerical methods needs continuous dependence on data  
- Activation functions: sigmoid smooth; ReLU continuous, not everywhere differentiable  
- Floating-point “limits” are not mathematical limits—watch cancellation near removable holes  
- Algorithm analysis: $\lim_{n\to\infty} T(n)/g(n)$ for asymptotics (discrete $n$, same language)  

### Worked example 13 — softplus

$\mathrm{softplus}(x)=\log(1+e^x)$ continuous smooth approximation to $\mathrm{ReLU}$—limits as $x\to\pm\infty$ match ReLU asymptotics.

## 11. Pitfalls

1. Plugging $x=a$ when $f$ undefined (always simplify first)  
2. Assuming limit equals function value without continuity  
3. $\infty-\infty$ or $0/0$ indeterminate forms without algebra  
4. Sequence limits vs real variable limits confusion  
5. Claiming IVT for discontinuous $f$  

## 12. Checkpoint

- State $\varepsilon$–$\delta$ definition  
- Compute standard trig/exp limits  
- Classify discontinuities  
- Apply IVT to guarantee roots  
- Explain continuity of common ML activations  

## Exercises

### Easy

1. $\varepsilon$–$\delta$ proof for $\lim_{x\to 1}(5x-2)=3$.
2. One-sided limits of $\mathrm{sign}(x)$ at 0.
3. Make $(x^2-9)/(x-3)$ continuous at 3 by defining $f(3)$.
4. Does $\lim_{x\to 0}x\sin(1/x)$ exist?
5. Why bisection needs continuity + sign change?

### Medium

6. Prove algebra rule for sum of limits (outline).
7. Show polynomials are continuous using algebra of limits.
8. Classify discontinuities of a floor function and $1/(x-1)$.
9. Use IVT to show any continuous $f:[0,1]\to[0,1]$ has a fixed point (hint: $f(x)-x$).
10. Compute $\lim_{h\to 0}\frac{(x+h)^n-x^n}{h}$ as preview of power rule.

### Challenge

11. Full $\varepsilon$–$\delta$ for $\lim_{x\to a}x^2=a^2$.
12. Prove $\lim_{x\to 0}\sin x/x=1$ using geometric arguments or known inequalities.
13. Show $\sin(1/x)$ has no limit as $x\to 0$ rigorously.
14. Heine definition: sequential characterization of limits; use to disprove a limit.
15. Discuss continuity of neural network maps built from continuous activations and affine layers.

## Summary

Limits formalize approachable values; continuity glues limit and function value. Algebra rules, IVT, and standard limits are the working toolkit—and they justify root-finding, asymptotic reasoning, and the smoothness assumptions behind much of continuous optimization.
