# Recurrence Relations

Recurrences describe sequences by relating $a_n$ to earlier terms. They appear in algorithm runtime ($T(n)=2T(n/2)+\Theta(n)$), combinatorics, dynamic programming, and amortized analysis. Mastering closed forms and the Master theorem is core discrete math for CS.

## Diagram: expand a recurrence

```text
  T(n)
   ├── T(n/2)
   │     ├── T(n/4)
   │     └── T(n/4)
   └── T(n/2)
         ├── ...
         └── ...

  levels ≈ log_b n, work per level depends on f(n)
```

## 1. What is a recurrence?

A **recurrence relation** defines a sequence $(a_n)$ by one or more base cases plus a rule that expresses $a_n$ in terms of previous values.

**Example (factorial via recurrence).**

$$
a_0 = 1,\qquad a_n = n\, a_{n-1}\ (n\ge 1)
\quad\Rightarrow\quad a_n = n!.
$$

**Example (divide-and-conquer cost).** Mergesort:

$$
T(1)=\Theta(1),\qquad T(n)=2T(n/2)+\Theta(n).
$$

### Why CS needs closed forms

- Compare algorithms asymptotically without expanding trees by hand every time
- Prove DP solutions match combinatorial counts
- Predict growth: exponential vs polynomial vs $n\log n$

## 2. Linear homogeneous recurrences (constant coefficients)

**Definition.** Order $k$ linear homogeneous:

$$
a_n = c_1 a_{n-1} + c_2 a_{n-2} + \cdots + c_k a_{n-k},
$$

with constant $c_i$ and $k$ initial conditions $a_0,\ldots,a_{k-1}$.

### Characteristic equation method

Guess $a_n = r^n$ ($r\neq 0$). Substitute:

$$
r^n = c_1 r^{n-1}+\cdots+c_k r^{n-k}.
$$

Divide by $r^{n-k}$:

$$
r^k - c_1 r^{k-1} - \cdots - c_k = 0.
$$

**Distinct real roots** $r_1,\ldots,r_k$: general solution

$$
a_n = A_1 r_1^n + A_2 r_2^n + \cdots + A_k r_k^n.
$$

Fit $A_i$ from initial conditions.

### Worked example 1 — second order

$$
a_n = 5a_{n-1}-6a_{n-2},\qquad a_0=2,\ a_1=5.
$$

Characteristic: $r^2-5r+6=0=(r-2)(r-3)$.

$$
a_n = A\cdot 2^n + B\cdot 3^n.
$$

$n=0$: $A+B=2$.  
$n=1$: $2A+3B=5$.  
Subtract: $A+2B=3$ wait carefully: from $2A+3B=5$ and $2A+2B=4$ ⇒ $B=1$, $A=1$.

$$
a_n = 2^n + 3^n.
$$

Check $n=2$: recurrence gives $5\cdot5-6\cdot2=13$; formula $4+9=13$. ✓

### Repeated roots

If root $r$ has multiplicity $m$, include factors $n^j r^n$ for $j=0,\ldots,m-1$.

**Example:** $a_n=4a_{n-1}-4a_{n-2}$ has double root $r=2$:

$$
a_n=(A+Bn)\,2^n.
$$

### Complex roots

Conjugate pairs $r=\rho e^{\pm i\theta}$ yield real form

$$
a_n = \rho^n\bigl(A\cos(n\theta)+B\sin(n\theta)\bigr).
$$

Useful for oscillatory sequences (e.g. certain signal models).

## 3. Fibonacci and Binet’s formula

Define $F_0=0$, $F_1=1$, $F_n=F_{n-1}+F_{n-2}$ for $n\ge 2$.

Characteristic $r^2-r-1=0$:

$$
\varphi=\frac{1+\sqrt{5}}{2},\qquad \hat\varphi=\frac{1-\sqrt{5}}{2}.
$$

**Binet:**

$$
F_n = \frac{\varphi^n - \hat\varphi^n}{\sqrt{5}}.
$$

Since $|\hat\varphi|<1$, $F_n$ is the integer closest to $\varphi^n/\sqrt{5}$.

### Worked example 2 — identity via recurrence

Prove $F_0+\cdots+F_n=F_{n+2}-1$ by induction, or derive from telescoping using $F_{k+2}-F_{k+1}=F_k$.

### CS appearances

- Naive recursive Fibonacci is exponential time; memoized / bottom-up is $O(n)$
- Fibonacci heaps, Zeckendorf representation, analysis of Euclidean algorithm (worst case related to Fibonacci ratios)

## 4. Non-homogeneous linear recurrences

$$
a_n = c_1 a_{n-1}+\cdots+c_k a_{n-k} + g(n).
$$

**General solution** = homogeneous general solution + one particular solution.

| $g(n)$ form | Particular ansatz (if not a root case) |
|-------------|----------------------------------------|
| constant $C$ | constant $K$ |
| polynomial degree $d$ | polynomial degree $d$ |
| $q^n$ | $K q^n$ |
| $q^n$ and $q$ is a root of mult. $m$ | $K n^m q^n$ |

### Worked example 3

$a_n=2a_{n-1}+3$, $a_0=1$.

Homogeneous: $a_n^{(h)}=A\cdot 2^n$.  
Particular: constant $K=2K+3$ ⇒ $K=-3$.  
General: $a_n=A\cdot 2^n-3$.  
$a_0=1$: $A-3=1$ ⇒ $A=4$. So $a_n=4\cdot 2^n-3=2^{n+2}-3$.

## 5. Master theorem (algorithmic divide-and-conquer)

For

$$
T(n)=a\,T(n/b)+f(n),\qquad a\ge 1,\ b>1,
$$

compare $f(n)$ to $n^{\log_b a}$ (the work of the leaves if $f\equiv 0$ up to constants).

| Case | Condition (rough) | Solution |
|------|-------------------|----------|
| 1 | $f(n)=O\bigl(n^{\log_b a-\varepsilon}\bigr)$ for some $\varepsilon>0$ | $T(n)=\Theta\bigl(n^{\log_b a}\bigr)$ |
| 2 | $f(n)=\Theta\bigl(n^{\log_b a}\log^k n\bigr)$, $k\ge 0$ | $T(n)=\Theta\bigl(n^{\log_b a}\log^{k+1}n\bigr)$ (classic $k=0$: $\Theta(n^{\log_b a}\log n)$) |
| 3 | $f(n)=\Omega\bigl(n^{\log_b a+\varepsilon}\bigr)$ + regularity | $T(n)=\Theta(f(n))$ |

**Regularity (case 3):** $a f(n/b)\le c f(n)$ for some $c<1$ and large $n$.

### Worked example 4 — merge sort

$T(n)=2T(n/2)+\Theta(n)$: $a=2$, $b=2$, $\log_b a=1$, $f=\Theta(n)=\Theta(n^{\log_b a})$. Case 2 ⇒ $\Theta(n\log n)$.

### Worked example 5 — binary search

$T(n)=T(n/2)+\Theta(1)$: $a=1$, $b=2$, $\log_b a=0$, $n^0=1$, $f=\Theta(1)$. Case 2 ⇒ $\Theta(\log n)$.

### Worked example 6 — case 1

$T(n)=4T(n/2)+n$: $\log_2 4=2$, $f=n=O(n^{2-\varepsilon})$. Case 1 ⇒ $\Theta(n^2)$.

### Worked example 7 — case 3

$T(n)=2T(n/2)+n^2$: $\log_2 2=1$, $f=n^2=\Omega(n^{1+\varepsilon})$. Regularity: $2(n/2)^2=n^2/2\le c n^2$ with $c=1/2$. Case 3 ⇒ $\Theta(n^2)$.

### When Master does not apply cleanly

- Uneven splits: $T(n)=T(\lfloor n/3\rfloor)+T(\lceil 2n/3\rceil)+\Theta(n)$ — use recursion tree / Akra–Bazzi
- $f$ oscillates or is not polynomial-comparable to $n^{\log_b a}$
- Floors/ceilings usually do not change asymptotics for standard cases

## 6. Recursion trees and substitution

### Tree method

Draw levels; sum work per level; sum over $\approx\log_b n$ levels (plus base).

**Merge sort tree:** each level $\Theta(n)$ work, $\Theta(\log n)$ levels ⇒ $\Theta(n\log n)$.

### Substitution (guess + induction)

1. Guess form, e.g. $T(n)\le cn\log n$
2. Prove by strong induction, carefully handling base and floors
3. Adjust constants; sometimes subtract lower-order terms ($cn\log n-dn$) to absorb edges

### Worked example 8 — linear scan recurrence

$T(n)=T(n-1)+\Theta(n)$, $T(1)=\Theta(1)$.  
Unroll: $T(n)=\Theta(1+2+\cdots+n)=\Theta(n^2)$.

## 7. Generating functions (preview)

Encode sequence as

$$
A(x)=\sum_{n=0}^{\infty} a_n x^n.
$$

A linear recurrence becomes an algebraic equation for $A(x)$; partial fractions recover closed forms.

**Fibonacci generating function:**

$$
\sum_{n=0}^{\infty} F_n x^n = \frac{x}{1-x-x^2}.
$$

Useful for hard counting recurrences and asymptotic extraction (singularity analysis — advanced).

## 8. Recurrences in dynamic programming

DP often writes:

$$
\mathrm{OPT}(n) = \min_{i}\bigl(\mathrm{cost}(i)+\mathrm{OPT}(n-i)\bigr)
$$

or similar. The recurrence is a **specification**; an algorithm evaluates it with memoization/tabulation in an order that respects dependencies.

**Classic:** $0/1$ knapsack, edit distance, matrix chain ordering — all recurrence-first designs.

### Worked example 9 — no consecutive 1s

Let $a_n$ = number of binary strings of length $n$ with no two consecutive $1$s.

- Ends in $0$: $a_{n-1}$ prefixes  
- Ends in $01$? Ends in $1$ ⇒ previous must end in $0$: $a_{n-2}$  

$$
a_n = a_{n-1}+a_{n-2},\quad a_1=2\ (0,1),\ a_2=3\ (00,01,10).
$$

So $a_n=F_{n+2}$ (shifted Fibonacci).

## 9. Solving checklist

1. Identify order and whether linear / constant coeff / homogeneous  
2. For D&C runtimes: try Master theorem first  
3. Else: unroll, tree, or characteristic equation  
4. Fit constants; verify small $n$  
5. State asymptotics with $\Theta$ carefully (constants matter for engineering, not only big-O class)

## 10. Pitfalls

1. Forgetting base cases when implementing recursive algorithms  
2. Applying Master case 2 when $f$ is not $\Theta(n^{\log_b a})$ (off by polylog needs the extended form)  
3. Assuming $T(n)=2T(n/2)+n$ without $\Theta$ hides constants that matter in practice  
4. Integer floors: $n/2$ vs $\lfloor n/2\rfloor$ — usually OK asymptotically, not always for exact closed forms  
5. Naive recursion exponential time even when closed form is simple (Fibonacci)

## 11. Checkpoint

- Solve second-order linear homogeneous recurrences via characteristic roots  
- State and apply all three Master cases with an example each  
- Unroll $T(n)=T(n-1)+f(n)$  
- Translate a counting problem into a recurrence  
- Explain when to prefer tree vs substitution vs Master  

## Exercises

### Easy

1. Solve $a_n=3a_{n-1}$, $a_0=2$.  
2. Solve $a_n=a_{n-1}+2a_{n-2}$, $a_0=1$, $a_1=1$.  
3. Apply Master theorem to $T(n)=4T(n/2)+n$.  
4. $T(n)=T(n-1)+\Theta(n)$ — what is $T(n)$?  
5. Write a recurrence for the number of binary strings of length $n$ with no two consecutive $1$s.  
6. Compute $F_6$ from the recurrence and compare to Binet rounding.

### Medium

7. Solve $a_n=6a_{n-1}-9a_{n-2}$, $a_0=1$, $a_1=6$ (repeated root).  
8. Solve $a_n=2a_{n-1}+n$, $a_0=0$ (non-homogeneous).  
9. Apply Master: $T(n)=9T(n/3)+n$, $T(n)=3T(n/2)+n^2$, $T(n)=2T(n/2)+n\log n$ (state case).  
10. Prove by induction that $F_n\le\varphi^{n-1}$ for $n\ge 1$ (adjust base carefully).  
11. Recursion tree for $T(n)=3T(n/2)+\Theta(n)$: sum geometric levels.  

### Challenge

12. Prove by induction your closed form in exercise 1.  
13. Derive Binet’s formula from the characteristic equation and initial conditions.  
14. Show that the Euclidean algorithm on $(F_{n+1},F_n)$ takes $n-1$ division steps (Lamé-type fact).  
15. Akra–Bazzi idea: for $T(n)=\sum a_i T(b_i n)+g(n)$, the exponent $p$ solves $\sum a_i b_i^p=1$. Compute $p$ for $T=T(n/3)+T(2n/3)+\Theta(n)$.  

## Checks

1. $a_n=2\cdot 3^n$.  
3. $n^{\log_2 4}=n^2$, $f=n=O(n^{2-\varepsilon})$ ⇒ $\Theta(n^2)$.  
4. $\Theta(n^2)$.  
5. $a_n=a_{n-1}+a_{n-2}$ with suitable base ($a_1=2$, $a_2=3$).  

## Summary

Recurrences turn recursive structure into equations. Linear constant-coefficient recurrences yield exponential closed forms via characteristic roots; algorithm costs often fall under the Master theorem or recursion trees. The same language specifies DP and counting problems. Practice moving fluidly among: write recurrence → solve or asymptote → verify on small $n$ → implement without exponential blow-up.
