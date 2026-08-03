# Induction and Invariants

**Mathematical induction** is the main proof tool for statements about all natural numbers. **Invariants** prove that algorithms never break a property — the heart of correctness arguments.

## Diagram: induction staircase

```text
  prove P(0) or P(1)     base
       │
       │  if P(k) then P(k+1)
       v
  P(n) for all n ≥ base
```

## 1. Standard induction

To prove $\forall n\ge n_0: P(n)$:

1. **Base:** prove $P(n_0)$.  
2. **Inductive step:** assume $P(k)$ (IH), prove $P(k+1)$.

## 2. Strong induction

Assume $P(n_0),\ldots,P(k)$ all true to prove $P(k+1)$.  
Needed when recurrence depends on multiple past values (e.g. Fibonacci identities).

## 3. Classic examples

- $\sum_{i=1}^n i=n(n+1)/2$  
- $2^n \ge n+1$ for $n\ge 0$  
- Correctness of recursive algorithms matching a recurrence

## 4. Loop invariants

For iterative algorithms:

```text
  // invariant I holds here
  while Cond do
     // I true at start of body
     Body
     // I true at end of body
  // I and not Cond ⇒ postcondition
```

**Example (linear search):** after $k$ steps, target not in first $k$ elements.

## 5. Invariants in discrete structures

- Coloring / parity arguments  
- Modular invariants (sum of digits mod 9)  
- Graph handshaking: sum of degrees even

## 6. Common failures

| Mistake | Fix |
|---------|-----|
| Missing base | check $n_0$ carefully |
| Using $P(k+1)$ in the proof of itself | only use IH on smaller |
| Vague $P(n)$ | write predicate explicitly |
| Off-by-one in loops | test $n=0,1$ |

## Exercises

1. Prove by induction $\sum_{i=0}^n r^i=(r^{n+1}-1)/(r-1)$ for $r\neq 1$.  
2. Prove $n!<n^n$ for $n\ge 2$.  
3. Write a loop invariant for computing factorial iteratively.  
4. Strong induction: any integer $n\ge 2$ has a prime factor.  
5. Invariant: in a graph, number of odd-degree vertices is even — prove from handshaking.  
6. **Bug hunt:** find the flaw in a fake proof that all horses are the same color (classic induction fail).

## Checks

6. Base $n=1$ OK; step fails when splitting into groups that don’t share a horse for $n=2$.
