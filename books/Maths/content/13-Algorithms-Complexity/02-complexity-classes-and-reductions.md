# Complexity Classes and Reductions

Complexity classes group decision problems by the resources needed to solve them. Reductions compare problems: if $A$ efficiently reduces to $B$, then $B$ is “at least as hard as” $A$. Together they yield the modern theory of NP-completeness and a discipline for hardness proofs in CS.

## 1. Decision problems and languages

A **decision problem** asks a yes/no question about an input string $x$. Identify the problem with a **language** $L\subseteq\{0,1\}^*$:

$$
x\in L \iff \text{the answer on }x\text{ is YES}.
$$

Examples:

- $\mathrm{PATH}=\{\langle G,s,t\rangle:$ graph $G$ has an $s$–$t$ path$\}$
- $\mathrm{SAT}=\{\langle\phi\rangle:$ Boolean formula $\phi$ is satisfiable$\}$
- $\mathrm{TSP}_{\mathrm{DEC}}=\{\langle G,k\rangle:$ graph $G$ has a tour of length $\le k$\}$

Optimization problems convert to decision versions by thresholding the objective—needed for class theory stated on languages.

### Worked example 1

Shortest path length optimization $\leftrightarrow$ decision: “is $\mathrm{dist}(s,t)\le k$?” Binary search on $k$ recovers the optimum if decisions are efficient and bounds are integral/polynomial.

## 2. The class $\mathbf{P}$

**Definition.** $L\in\mathbf{P}$ if there is a deterministic algorithm deciding $L$ in time $O(n^c)$ for some constant $c$ (polynomial in input length $n=|x|$).

Informally: **efficiently solvable** (coarse but powerful abstraction).

### Examples in $\mathbf{P}$

- Sorting-related decisions, median finding
- Shortest paths with nonnegative weights (Dijkstra)
- Linear programming (weakly poly / practical poly; theoretical status nuanced historically but LP is poly-time solvable)
- Matching in general graphs (Edmonds)—nontrivial membership in $\mathbf{P}$

### Worked example 2

Connectivity in undirected graphs: BFS/DFS in $O(v+e)$ time $\subseteq\mathbf{P}$.

## 3. The class $\mathbf{NP}$

**Definition (verifier).** $L\in\mathbf{NP}$ if there exists a polynomial $p$ and a deterministic polynomial-time **verifier** $V$ such that:

$$
x\in L \iff \exists\, u\in\{0,1\}^{p(|x|)}\text{ with }V(x,u)=1.
$$

The string $u$ is a **certificate** / witness. So $\mathbf{NP}$ is “efficiently verifiable YES answers,” not “non-polynomial” (a common misreading of the name).

**Nondeterministic view (equivalent):** a nondeterministic TM guesses $u$ and checks in poly time.

### Worked example 3 — SAT certificates

Certificate: assignment to variables. Verifier evaluates the formula in linear time in formula size.

### Worked example 4 — what is **not** obviously a short certificate?

Tautology (true under **all** assignments): a single assignment is not a certificate of universality. Tautology is in $\mathbf{coNP}$ (see below).

### Worked example 5 — composite numbers

Certificate: nontrivial factor. Verification: multiply (historically placed intuition for $\mathbf{NP}$; primality is now known to be in $\mathbf{P}$ via AKS, a deep result).

## 4. $\mathbf{coNP}$ and containments

**Definition.** $L\in\mathbf{coNP}$ iff $\overline{L}\in\mathbf{NP}$ (complements).

- $\mathbf{P}\subseteq\mathbf{NP}$ and $\mathbf{P}\subseteq\mathbf{coNP}$
- $\mathbf{NP}\subseteq\mathbf{PSPACE}$ (try all certificates with poly space reuse—more carefully: NP $\subseteq$ PSPACE)
- Open: $\mathbf{P}\stackrel{?}{=}\mathbf{NP}$, $\mathbf{NP}\stackrel{?}{=}\mathbf{coNP}$

### Worked example 6

UNSAT $=\overline{\mathrm{SAT}}$ is $\mathbf{coNP}$-complete (standard). Short certificates for UNSAT are not known in general (would collapse things if always short in certain ways).

## 5. Polynomial-time reductions

**Definition (Karp / many-one reduction).** $A\le_p B$ if there is a poly-time computable $f$ such that

$$
x\in A \iff f(x)\in B.
$$

**Meaning:** if $B$ is decidable in poly time, so is $A$ ($x\mapsto f(x)$ then decide $B$). Contrapositively: if $A$ is “hard,” so is $B$.

### Properties

- Reflexive and transitive
- If $A\le_p B$ and $B\in\mathbf{P}$ then $A\in\mathbf{P}$
- If $A\le_p B$ and $A$ is NP-hard then $B$ is NP-hard

### Worked example 7 — direction discipline

To show **new problem $B$ is hard**, reduce **known hard $A$ to $B$**: $A\le_p B$.  
Reducing $B\le_p A$ would show $B$ is **no harder than** $A$—useful for algorithms, wrong direction for hardness.

## 6. NP-hardness and NP-completeness

**Definition.** $B$ is **NP-hard** if for every $A\in\mathbf{NP}$, $A\le_p B$.  
$B$ is **NP-complete** if $B$ is NP-hard and $B\in\mathbf{NP}$.

**Cook–Levin theorem (statement).** SAT is NP-complete.

Thereafter, new NP-completeness proofs usually:

1. Show $B\in\mathbf{NP}$ (give verifier / certificates)
2. Pick known NP-complete $A$
3. Construct poly-time $f$ with $x\in A\iff f(x)\in B$
4. Prove both directions of the iff (the part people skip—and get wrong)

### Worked example 8 — independent set $\leftrightarrow$ clique

Given $G=(V,E)$, complement edges $\overline{G}=(V,\binom{V}{2}\setminus E)$. Then $G$ has an independent set of size $k$ iff $\overline{G}$ has a clique of size $k$. Reduction is poly-time (build complement carefully; for dense encoding watch size).

### Worked example 9 — vertex cover

$S$ is a vertex cover of size $k$ iff $V\setminus S$ is an independent set of size $n-k$. Yields NP-completeness transfers among these problems.

### Worked example 10 — 3-SAT sketch

From general SAT: rewrite clauses to length $\le 3$ by introducing fresh variables:

$$
(\ell_1\lor\ell_2\lor\ell_3\lor\ell_4)\ \leadsto\ (\ell_1\lor\ell_2\lor y)\land(\neg y\lor\ell_3\lor\ell_4).
$$

Preserve satisfiability; polynomial blowup. (Full Cook–Levin is harder; this is the SAT$\to$3-SAT step.)

## 7. Proof hygiene checklist

When writing a reduction proof:

1. **Specify $f$ completely** (including how numbers/graphs are encoded)
2. **Runtime:** argue $|f(x)|$ and construction time are poly in $|x|$
3. **YES $\Rightarrow$ YES:** if $x\in A$, construct witness/structure showing $f(x)\in B$
4. **NO $\Rightarrow$ NO:** if $x\notin A$, prove $f(x)\notin B$ (often the subtle direction)
5. **No exponential enumeration** inside $f$
6. **Decision vs optimization:** reduce decision to decision unless using Turing reductions carefully

## 8. Beyond NP (map)

| Class | Resource intuition |
|-------|--------------------|
| $\mathbf{PSPACE}$ | Poly space; includes quantified Boolean formulas (QBF) |
| $\mathbf{EXPTIME}$ | Exponential time |
| $\mathbf{PH}$ | Polynomial hierarchy (alternations of quantifiers) |

Containments: $\mathbf{P}\subseteq\mathbf{NP}\subseteq\mathbf{PSPACE}\subseteq\mathbf{EXPTIME}$, with some inequalities known (time hierarchy), many separations open.

## 9. CS practice connections

- **Compilers / verification:** many static analyses touch undecidability or hard subproblems; restrict languages to recover $\mathbf{P}$
- **Cryptography:** needs average-case hardness, not only worst-case NP-hardness
- **Operations research:** NP-complete scheduling $\Rightarrow$ ILP + heuristics
- **Parameterization:** NP-hard in $n$ but FPT in small parameter $k$ (treewidth, solution size)

### Worked example 11 — product decision

“Can we place facilities so every user is within distance $D$ using $\le k$ facilities?” (dominating set / facility variants)—expect NP-complete; use ILP or approximation.

## 10. Pitfalls

1. **NP = “not polynomial”** — wrong etymology in practice
2. **Showing a poly algorithm for special cases** does not place the general problem in $\mathbf{P}$
3. **Reduction direction reversed**
4. **Certificate of exponential size** — not valid for $\mathbf{NP}$
5. **Assuming $\mathbf{P}\neq\mathbf{NP}$** without stating it when claiming “no poly algorithm”
6. **Heuristic works on my instances** $\neq$ proof of tractability

## 11. Checkpoint

- Define $\mathbf{P}$ and $\mathbf{NP}$ via time / verifiers
- State $\le_p$ and use the correct direction for hardness
- Execute the 3-step NP-completeness method
- Convert an optimization problem to a decision language
- Avoid the common fallacies above

## Exercises

### Easy

1. Prove $\mathbf{P}\subseteq\mathbf{NP}$ from the definitions.
2. Give certificates for: Hamiltonian cycle, subset sum, graph $k$-colorability.
3. Why is a brute-force “try all subsets” algorithm not a proof of membership in $\mathbf{P}$?
4. Formalize CLIQUE as a language.
5. If $A\le_p B$ and $B\le_p C$, show $A\le_p C$.

### Medium

6. Prove that if any NP-complete problem is in $\mathbf{P}$, then $\mathbf{P}=\mathbf{NP}$.
7. Detail the independent set $\leftrightarrow$ clique reduction with both directions.
8. Show that deciding whether a DFA accepts some string is in $\mathbf{P}$ (graph reachability on the automaton).
9. Explain why tautology is in $\mathbf{coNP}$.
10. Find the bug: “I reduce my problem $B$ to SAT, and SAT is hard, so $B$ is hard.”

### Challenge

11. Write a careful SAT$\le_p$3-SAT proof for clauses of length $>3$.
12. Define coNP-completeness and name one coNP-complete problem.
13. Research: what is a **Turing reduction** (Cook reduction), and why is Karp reduction preferred for NP-completeness definitions?
14. Show SUBSET-SUM is in $\mathbf{NP}$; sketch why pseudo-polynomial DP does not place it in $\mathbf{P}$ in the strong sense (bit length of numbers).
15. Formulate a real scheduling question as a language and outline an NP-completeness proof strategy (choice of source problem + intended gadgets at high level).

## Summary

$\mathbf{P}$ captures efficient solvability; $\mathbf{NP}$ captures efficient verifiability. Polynomial reductions transfer both algorithms and hardness. NP-completeness is a precise badge earned by membership plus a correct many-one reduction from a known complete problem—direction and both iff sides included.
