# Space Complexity

Space complexity measures memory as a function of input size. Many natural problems that seem to need exponential time still fit in small space; others are complete for large space classes. This chapter introduces $\mathbf{L}$, $\mathbf{NL}$, $\mathbf{PSPACE}$, reductions, and Savitch’s theorem.

## 1. Model of space

Standard model: Turing machine with

- read-only input tape  
- read/write work tapes (count cells used)  
- optional write-only output tape (for transducers)

**Space $s(n)$:** max work cells on inputs of length $n$.  

$\log n$ space is already nontrivial: indices into the input fit in binary.

### Worked example 1

Scanning input to test if first symbol = last symbol uses $O(1)$ work space (plus input head positions as state)—careful accounting uses $O(\log n)$ to store positions if required by formal model variants.

## 2. Space classes

| Class | Definition (sketch) |
|-------|---------------------|
| $\mathbf{L}$ | deterministic $O(\log n)$ space |
| $\mathbf{NL}$ | nondeterministic $O(\log n)$ space |
| $\mathbf{PSPACE}$ | deterministic $\mathrm{poly}(n)$ space |
| $\mathbf{NPSPACE}$ | nondeterministic poly space |

**Containments:**

$$
\mathbf{L}\subseteq\mathbf{NL}\subseteq\mathbf{P}\subseteq\mathbf{NP}\subseteq\mathbf{PSPACE}=\mathbf{NPSPACE}\subseteq\mathbf{EXPTIME}.
$$

Equality $\mathbf{PSPACE}=\mathbf{NPSPACE}$ is **Savitch’s theorem**. Whether $\mathbf{L}=\mathbf{NL}$ is open (like a log-space $\mathbf{P}$ vs $\mathbf{NP}$).

### Worked example 2

Any $O(s(n))$ space machine runs in time at most exponential in $s(n)$ (configuration count)—hence $\mathbf{PSPACE}\subseteq\mathbf{EXPTIME}$.

## 3. Configuration graphs

A configuration: state, work-tape contents, head positions. For space $s(n)$, #configs $\le |\Gamma|^{O(s(n))}\cdot\mathrm{poly}(n)=2^{O(s(n)+\log n)}$.

Reachability in the configuration graph $\Leftrightarrow$ acceptance.

### Worked example 3

Nondeterministic log-space computation $\Leftrightarrow$ $s$–$t$ connectivity in digraphs of poly size with implicit edge checks—motivates NL-completeness of connectivity.

## 4. NL-complete problem: graph reachability

**PATH / STCON:** given digraph $G$, nodes $s,t$, is $t$ reachable from $s$?

**Theorem.** STCON is NL-complete under log-space reductions.

**In NL:** nondeterministically walk up to $n$ steps from $s$, storing only current node ($O(\log n)$ bits).  
**Hardness:** configure-graph reachability reduces to STCON in log space.

### Worked example 4 — undirected reachability

Undirected $s$–$t$ connectivity is in $\mathbf{L}$ (Reingold’s theorem)—breakthrough derandomizing SL=L.

## 5. Savitch’s theorem

**Theorem.** $\mathbf{NSPACE}(s(n))\subseteq\mathbf{DSPACE}(s(n)^2)$ for space-constructible $s(n)\ge\log n$.

**Corollary.** $\mathbf{PSPACE}=\mathbf{NPSPACE}$.

**Proof idea.** Recursive check $\mathrm{Reach}(u,v,k)$: exists midpoint $w$ with $\mathrm{Reach}(u,w,\lfloor k/2\rfloor)$ and $\mathrm{Reach}(w,v,\lceil k/2\rceil)$. Depth $O(\log \#\mathrm{configs})$; reuse space $\Rightarrow$ quadratic blowup. $\blacksquare$

### Worked example 5

Nondeterministic poly space collapses to deterministic poly space—unlike time, where $\mathbf{NP}$ vs $\mathbf{P}$ remains open.

## 6. PSPACE-complete problems

**QBF / TQBF:** fully quantified Boolean formulas $\exists x_1\forall x_2\exists x_3\ldots\phi$ truth.

**Theorem.** TQBF is PSPACE-complete.

### Worked example 6 — games

Many two-player games (generalized geography, some chess-on-$n\times n$ variants) are PSPACE-complete—alternating moves $\approx$ quantifiers.

### Worked example 7 — model checking fragments

Some linear-time logic model checking problems are PSPACE-complete—verification complexity.

## 7. Log-space reductions

$A\le_L B$: log-space computable many-one reduction. Finer than poly-time reductions; needed for L/NL completeness.

### Worked example 8

Composition of log-space reductions remains log-space (careful with recompute vs store).

## 8. Relationships and hierarchy

Space hierarchy theorem: more space yields strictly more languages (under constructibility). So $\mathbf{L}\subsetneq\mathbf{PSPACE}$ etc. in appropriate forms.

Time vs space: $\mathbf{NL}\subseteq\mathbf{P}$ because config graph poly-size BFS, but $\mathbf{P}\subseteq\mathbf{PSPACE}$ obvious; separations between intermediate classes largely open.

### Worked example 9

Poly-time algorithms may use poly space; streaming algorithms aim for sublinear space—closer to L-style constraints in spirit.

## 9. CS practice connections

| Domain | Space angle |
|--------|-------------|
| Streaming / sketching | $o(n)$ or $\mathrm{polylog}$ memory |
| Embedded / IoT | hard RAM caps |
| Verifiers | certificate checking in small space |
| Game AI on large state spaces | PSPACE-hard exact solvers $\Rightarrow$ heuristics |
| Compilers | analyses in low memory for huge codebases |

### Worked example 10 — streaming distinct count

Exact distinct elements needs linear space hard lower bounds; approximate sketches (HyperLogLog) use tiny space—complexity lower bounds guide necessity of approximation.

### Worked example 11 — reachability in huge implicit graphs

State spaces of protocols: NL-style nondeterministic search vs deterministic Savitch (impractical quadratic) vs BDD symbolic methods.

## 10. Complementary classes

$\mathbf{coNL}$: complements of NL languages. Immerman–Szelepcsényi theorem: $\mathbf{NL}=\mathbf{coNL}$—surprising collapse via inductive counting.

### Worked example 12

Non-reachability is in NL—not obvious from the walking certificate for reachability.

## 11. Pitfalls

1. Counting input tape as work space incorrectly  
2. Claiming STCON in L without undirected/Reingold context  
3. Assuming $\mathbf{NPSPACE}$ bigger than $\mathbf{PSPACE}$  
4. Poly-time reduction when log-space needed for NL-completeness  
5. Exponential configuration graphs “algorithms” that still use exponential space if naively stored  

## 12. Checkpoint

- Define work-tape space and $\mathbf{L}/\mathbf{NL}/\mathbf{PSPACE}$  
- Explain STCON in NL  
- State Savitch and $\mathbf{PSPACE}=\mathbf{NPSPACE}$  
- Name TQBF as PSPACE-complete  
- Know $\mathbf{NL}=\mathbf{coNL}$ existence  

## Exercises

### Easy

1. Why does $O(\log n)$ space suffice to store an index $i\in\{1..n\}$?
2. Show $\mathbf{P}\subseteq\mathbf{PSPACE}$.
3. Give a language obviously in L (e.g., regular language decision).
4. What is a configuration of a TM?
5. Why is TQBF in PSPACE (recursive evaluation sketch)?

### Medium

6. Prove that a machine using space $s$ has at most $2^{O(s+\log n)}$ configs.
7. Detail nondeterministic log-space algorithm for STCON.
8. Write Savitch recurrence $\mathrm{Reach}(u,v,k)$ pseudocode; space analysis.
9. Explain why Savitch does not put $\mathbf{NP}$ in $\mathbf{P}$.
10. Reduce a small quantified formula evaluation to a game interpretation.

### Challenge

11. Outline Immerman–Szelepcsényi inductive counting idea.
12. Prove TQBF PSPACE-hard sketch (from space-bounded TM computations).
13. Discuss streaming lower bound idea for exact distinct count (communication complexity awareness).
14. Compare log-space reductions vs poly-time reductions with an example of care needed.
15. Research Reingold’s undirected connectivity in L: what combinatorial object (zig-zag product) appears?

## Summary

Space classes reveal a different hierarchy than time: Savitch collapses nondeterministic poly space to deterministic, STCON captures NL, and TQBF captures PSPACE. Log-space computation models tight-memory algorithms and streaming ideals, while PSPACE-completeness explains the hardness of games and rich verification questions.
