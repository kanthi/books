# Recurrence Relations

Recurrences describe sequences by relating $a_n$ to earlier terms. They appear in algorithm runtime ($T(n)=2T(n/2)+\Theta(n)$), combinatorics, and dynamic programming.

## Diagram: expand a recurrence

```text
  T(n)
   ├── T(n/2)
   │     ├── T(n/4)
   │     └── T(n/4)
   └── T(n/2)
         ├── ...
         └── ...

  levels ≈ log n, work per level depends on form
```

## 1. Linear homogeneous (constant coeff)

Example: $a_n=5a_{n-1}-6a_{n-2}$.  
Characteristic $r^2-5r+6=0=(r-2)(r-3)$,  
$a_n=A\cdot 2^n+B\cdot 3^n$, fit $A,B$ from initials.

## 2. Fibonacci

$F_n=F_{n-1}+F_{n-2}$, $F_0=0,F_1=1$.  
Closed form Binet: $\varphi^n/\sqrt{5}$ rounded.

## 3. Master theorem (algorithmic)

For $T(n)=aT(n/b)+f(n)$ with $a\ge 1$, $b>1$:

Compare $f(n)$ to $n^{\log_b a}$:

| Case | Relation | $T(n)$ |
|------|----------|--------|
| 1 | $f=O(n^{\log_b a-\varepsilon})$ | $\Theta(n^{\log_b a})$ |
| 2 | $f=\Theta(n^{\log_b a}\log^k n)$ | $\Theta(n^{\log_b a}\log^{k+1}n)$ (k=0 classic) |
| 3 | $f=\Omega(n^{\log_b a+\varepsilon})$ + regularity | $\Theta(f(n))$ |

**Example:** merge sort $T=2T(n/2)+\Theta(n)$ ⇒ $\Theta(n\log n)$.

## 4. Substitution / tree method

Guess form, prove by induction; or draw recursion tree and sum levels.

## 5. Generating functions (preview)

Encode $(a_n)$ as $A(x)=\sum a_n x^n$; recurrences become equations for $A$.

## Exercises

1. Solve $a_n=3a_{n-1}$, $a_0=2$.  
2. Solve $a_n=a_{n-1}+2a_{n-2}$, $a_0=1,a_1=1$.  
3. Apply Master theorem to $T(n)=4T(n/2)+n$.  
4. $T(n)=T(n-1)+\Theta(n)$ — what is $T(n)$?  
5. Write a recurrence for number of binary strings of length $n$ with no two consecutive 1s.  
6. **Challenge:** Prove by induction your closed form in (1).

## Checks

1. $a_n=2\cdot 3^n$.  
3. $n^{\log_2 4}=n^2$, $f=n=O(n^{2-\varepsilon})$ ⇒ $\Theta(n^2)$.  
4. $\Theta(n^2)$.
