# Induction and Invariants

**Mathematical induction** is the main proof tool for statements indexed by natural numbers. **Invariants** prove that algorithms and discrete processes never break a property — the heart of correctness arguments, from loop proofs to distributed protocols.

## Diagram: induction staircase

```text
  prove P(n0)           base
       │
       │  if P(k) then P(k+1)
       v
  P(n) for all n ≥ n0
```

## 1. Standard (weak) induction

To prove $\forall n\ge n_0:\, P(n)$:

1. **Base case:** prove $P(n_0)$ directly.  
2. **Inductive step:** assume $P(k)$ for some $k\ge n_0$ (**inductive hypothesis**, IH), then prove $P(k+1)$.

**Logical shape:** $P(n_0)$ and $\forall k\ge n_0\,(P(k)\Rightarrow P(k+1))$ together imply $\forall n\ge n_0\, P(n)$.

### Worked example 1 — sum formula

**Claim:** $P(n):\ \sum_{i=1}^n i = n(n+1)/2$ for $n\ge 1$.

**Base** $n=1$: $1=1\cdot 2/2$. ✓

**Step:** Assume true for $k$. Then

$$
\sum_{i=1}^{k+1} i = \frac{k(k+1)}{2} + (k+1) = (k+1)\Bigl(\frac{k}{2}+1\Bigr)=\frac{(k+1)(k+2)}{2}.
$$

So $P(k+1)$ holds.

### Worked example 2 — inequality

**Claim:** $2^n \ge n+1$ for all integers $n\ge 0$.

Base $n=0$: $1\ge 1$. IH: $2^k\ge k+1$. Then $2^{k+1}=2\cdot 2^k\ge 2(k+1)=2k+2\ge k+2$ for $k\ge 0$. ✓

## 2. Strong induction

**Strong form:** in the step, assume $P(n_0),\ldots,P(k)$ all true, prove $P(k+1)$.

Use when $P(k+1)$ depends on several earlier values, not only $P(k)$.

### Worked example 3 — every $n\ge 2$ has a prime factor

Base $n=2$: $2$ is prime.  
Assume every $m$ with $2\le m\le k$ has a prime factor. For $k+1$: if $k+1$ is prime, done; if composite, $k+1=ab$ with $1<a,b\le k$, so $a$ has a prime factor, which divides $k+1$.

### Worked example 4 — Fibonacci closed bound

Many Fibonacci identities need strong induction because $F_{k+1}=F_k+F_{k-1}$.

## 3. Structural induction

For recursively defined objects (lists, trees, formulas, well-formed expressions):

1. Prove property for base constructors  
2. Assume it for substructures; prove for the combined structure  

**Example:** every full binary tree with $n$ internal nodes has $n+1$ leaves — induct on tree structure, not only on $n$.

This is the same logic as induction on $\mathbb{N}$, but the “order” is construction depth.

## 4. Classic proof patterns

| Pattern | Typical claim |
|---------|----------------|
| Summation formulas | closed form for $\sum f(i)$ |
| Divisibility | $n^3-n$ divisible by $3$ |
| Inequalities | growth rates, binomial bounds |
| Algorithm correctness | recursive procedures match a recurrence |
| Combinatorial identities | Pascal: $\binom{n}{k}=\binom{n-1}{k}+\binom{n-1}{k-1}$ |

### Worked example 5 — geometric series

For $r\neq 1$,

$$
\sum_{i=0}^n r^i = \frac{r^{n+1}-1}{r-1}.
$$

Base $n=0$: $1=(r-1)/(r-1)$.  
Step: sum to $k$ plus $r^{k+1}$ yields $(r^{k+2}-1)/(r-1)$.

### Worked example 6 — $n! < n^n$ for $n\ge 2$

Base $n=2$: $2<4$.  
IH: $k!<k^k$. Then $(k+1)! = (k+1)k! < (k+1)k^k < (k+1)(k+1)^k=(k+1)^{k+1}$.

## 5. Loop invariants

For iterative algorithms, a **loop invariant** $I$ is a predicate such that:

1. **Initialization:** $I$ is true before the first iteration  
2. **Maintenance:** if $I$ is true at the start of an iteration and the loop body runs, $I$ is true at the end  
3. **Termination:** when the loop ends, $I$ and $\neg\mathrm{Cond}$ imply the postcondition  

```text
  // I holds here
  while Cond do
     // I true at start of body
     Body
     // I true at end of body
  // I ∧ ¬Cond  ⇒  postcondition
```

### Worked example 7 — linear search

Search for target $t$ in array $A[0..n-1]$.

**Invariant after $k$ probes of indices $0,\ldots,k-1$:** either we already returned success, or $t\notin\{A[0],\ldots,A[k-1]\}$.

At $k=n$, if not found, $t$ is absent. Correctness of “not found” follows.

### Worked example 8 — iterative factorial

```text
  r ← 1
  i ← 1
  while i ≤ n do
     r ← r * i
     i ← i + 1
  // r = n!
```

**Invariant:** at the start of the loop (and after each iteration), $r = (i-1)!$ and $1\le i\le n+1$.  
When $i=n+1$, $r=n!$.

### Worked example 9 — insertion into sorted prefix

Insertion sort invariant: after $i$ iterations, $A[0..i-1]$ is sorted and is a permutation of the original first $i$ elements.

## 6. Invariants in discrete structures

### Parity and modular invariants

- Sum of degrees in a graph is even (**handshaking lemma**) ⇒ number of odd-degree vertices is even  
- Invariant of $15$-puzzle: permutation parity + blank row distance  
- Digital root / sum of digits mod $9$ equals $n \bmod 9$

### Coloring arguments

Color a chessboard; show a mutilated board cannot be tiled by dominoes (each domino covers one black and one white; two same-color corners removed).

### Potential functions

Amortized analysis: a potential $\Phi$ stays nonnegative and accounts for “saved” work — an invariant-style accounting.

## 7. Invariants in concurrent / networked systems

Though this book is math-first:

- **Mutual exclusion:** at most one process in critical section (invariant on lock state)  
- **Conservation:** token count in a ring algorithm remains $1$  
- **CRDTs / merge:** certain merge operations preserve commutativity (algebraic invariant)

Thinking “what quantity never changes / always stays legal” is the same skill as loop invariants.

## 8. Common failures (and the horses paradox)

| Mistake | Fix |
|---------|-----|
| Missing or wrong base | check $n_0$ carefully; sometimes need two bases |
| Using $P(k+1)$ inside its own proof | only use IH on smaller instances |
| Vague $P(n)$ | write the predicate in full, with quantifiers |
| Off-by-one in loops | test $n=0,1$ and last iteration |
| Strong induction needed but weak used | if recurrence looks back $>1$, switch |

### Classic bug: “all horses are the same color”

Fake proof: any set of $1$ horse is monochromatic. Assume any $k$ horses same color; for $k+1$, drop one horse — first $k$ same color, last $k$ same color, share overlap ⇒ all $k+1$ same.

**Flaw:** for $k=1\to k+1=2$, the two groups of size $1$ have **empty overlap**, so colors need not match. Step fails exactly where the overlap assumption breaks.

## 9. Induction vs invariants — same idea

| Setting | “Base” | “Step” |
|---------|--------|--------|
| $\mathbb{N}$ | $P(n_0)$ | $P(k)\Rightarrow P(k+1)$ |
| Loop | init before loop | body preserves $I$ |
| Recursive data | constructors | combination preserves property |
| Algorithm | empty / $n=0$ input | one more element processed |

## 10. Writing good inductive proofs (checklist)

1. State $P(n)$ explicitly  
2. State the range of $n$  
3. Base case with arithmetic or direct check  
4. Clear “Assume $P(k)$…”  
5. Algebra that **uses** the IH  
6. Conclude $P(k+1)$ and thus $\forall n$  

For code: name the invariant in a comment; check init, preserve, exit.

## 11. Pitfalls

1. Inducting on the wrong quantity (try smaller size of structure)  
2. Base too small / too large for the inequality  
3. Circular reasoning in algorithm proofs (assuming correctness of recursive call without IH)  
4. Forgetting that $P(n)$ must be a **proposition** (true/false), not a number  
5. Using induction when a direct bijection or invariant is simpler  

## 12. Checkpoint

- Prove summation and inequality claims by weak induction  
- Use strong induction for prime factorization and multi-step recurrences  
- Write init/maintain/terminate for a simple loop  
- Spot the flaw in a broken inductive argument  
- Apply a parity or coloring invariant to a impossibility claim  

## Exercises

### Easy

1. Prove by induction $\sum_{i=0}^n r^i=(r^{n+1}-1)/(r-1)$ for $r\neq 1$.  
2. Prove $n!<n^n$ for $n\ge 2$.  
3. Write a loop invariant for computing factorial iteratively.  
4. Prove $\sum_{i=1}^n i^2 = n(n+1)(2n+1)/6$.  
5. Prove $3$ divides $n^3-n$ for all integers $n\ge 0$.  

### Medium

6. Strong induction: any integer $n\ge 2$ has a prime factor.  
7. Invariant: in a finite graph, the number of odd-degree vertices is even — prove from handshaking.  
8. Prove by induction that a tree with $n$ vertices has $n-1$ edges (use leaf removal).  
9. Binary search correctness: state a loop invariant on the search interval.  
10. Prove $\binom{n}{k}=\binom{n-1}{k}+\binom{n-1}{k-1}$ by induction on $n$ (for fixed ranges of $k$).  

### Challenge

11. **Bug hunt:** find the flaw in the fake proof that all horses are the same color.  
12. Prove correctness of Euclid’s algorithm via invariant: $\gcd(a,b)=\gcd(b,a\bmod b)$.  
13. Structural induction: every propositional formula has equally many left and right parentheses (for a standard grammar).  
14. Show that the $15$-puzzle’s half of permutations are unreachable (parity invariant sketch).  
15. Amortized: define a potential for a binary counter so that flipping bits costs $O(1)$ amortized per increment.  

## Checks

6. Base $n=1$ OK for horses; step fails when splitting into groups that do not share a horse for $n=2$.  
7. $\sum\deg=2|E|$ even ⇒ even number of odd summands.  

## Summary

Induction is the natural-number engine of discrete proofs; strong and structural variants cover recurrences and recursive data. Loop invariants and modular/parity invariants extend the same discipline to algorithms and impossibility results. Always write $P(n)$ clearly, nail the base, and ensure the step uses only legitimate earlier cases — that is most of mathematical maturity in CS foundations.
