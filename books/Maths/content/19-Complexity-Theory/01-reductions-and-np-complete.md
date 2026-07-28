# Reductions and NP-Completeness

NP-completeness is the standard badge of “unlikely to have a poly-time algorithm.” Earning it requires membership in $\mathbf{NP}$ plus a correct polynomial-time reduction from a known complete problem. This chapter drills the definitions, the Cook–Levin gateway, and classic gadget reductions.

## 1. Languages and decision problems

Encode instances as strings. Language $L$ = YES instances. Algorithms **decide** $L$ if they accept $x\in L$ and reject $x\notin L$.

### Worked example 1

$\mathrm{HAMCYCLE}=\{\langle G\rangle: G\text{ has a Hamiltonian cycle}\}$.

## 2. Classes $\mathbf{P}$ and $\mathbf{NP}$

**$\mathbf{P}$:** decidable in deterministic poly time $O(n^c)$.

**$\mathbf{NP}$:** exists poly-time verifier $V(x,u)$ and poly bound $p$ s.t.

$$
x\in L \iff \exists u,\,|u|\le p(|x|),\ V(x,u)=1.
$$

### Worked example 2 — certificates

- SAT: assignment  
- CLIQUE: vertex set of size $k$  
- SUBSET-SUM: subset bit vector  
- COMPOSITES: nontrivial factor (historical interest; PRIMES $\in\mathbf{P}$)

### Worked example 3 — coNP

UNSAT has short certificates only if $\mathbf{NP}=\mathbf{coNP}$ (unknown). Universal claims differ from existential ones.

## 3. Karp reductions

$A\le_p B$ via poly-time $f$ with $x\in A\Leftrightarrow f(x)\in B$.

**Lemma.** If $A\le_p B$ and $B\in\mathbf{P}$ then $A\in\mathbf{P}$.  
**Lemma.** If $A\le_p B$ and $A$ NP-hard then $B$ NP-hard.

### Worked example 4 — direction

Hardness of $B$: prove $A\le_p B$ for hard $A$. Algorithm for $A$: reduce to easier $B$ if you have a solver for $B$.

## 4. NP-hard and NP-complete

- **NP-hard:** every language in $\mathbf{NP}$ reduces to it (at least as hard as all of $\mathbf{NP}$)  
- **NP-complete:** NP-hard and in $\mathbf{NP}$

If any NP-complete language is in $\mathbf{P}$, then $\mathbf{P}=\mathbf{NP}$.

## 5. Cook–Levin theorem (statement)

**Theorem.** SAT is NP-complete.

**Idea.** For any language in $\mathbf{NP}$ with verifier $V$, map $x$ to a Boolean formula $\phi_x$ that is satisfiable iff there exists a witness $u$ such that $V(x,u)$ accepts—by encoding the computation tableau of $V$ with local Boolean constraints.

After Cook–Levin, hardness proofs reduce from SAT/3-SAT/etc., not from arbitrary NP machines.

## 6. NP-completeness proof template

1. **Membership:** $X\in\mathbf{NP}$ (certificate + verifier + poly bounds)  
2. **Source:** pick known complete $Y$ (3-SAT, VERTEX-COVER, …)  
3. **Construction:** poly-time $f$  
4. **Correctness:** $y\in Y\Leftrightarrow f(y)\in X$ (both directions!)  
5. **Runtime:** argue $|f(y)|$ and construction are poly  

## 7. Classic reductions (sketches)

### 3-SAT $\le_p$ CLIQUE

For formula with clauses $C_1,\ldots,C_m$, build graph: vertices = literals occurrences in clauses; edges between compatible literals in different clauses (not negations of each other). Clique of size $m$ $\Leftrightarrow$ satisfying assignment selecting one literal per clause consistently.

### Independent set / vertex cover

$\alpha(G)+\beta(G)=n$ relationships: clique in $G$ $\leftrightarrow$ independent set in complement; vertex cover complements independent set.

### Worked example 5

Pathological check: empty formula? Unit clauses? Encode carefully so $f$ handles edge cases.

### 3-SAT $\le_p$ SUBSET-SUM (idea)

Digits encode variable choices and clause satisfaction carries—classic number gadgets.

### Worked example 6 — PARTITION / KNAPSACK decision

Pseudo-poly algorithms exist; still weakly NP-complete—bit length matters.

### Hamiltonian cycle $\le_p$ TSP decision

Assign weight 1 to edges of $G$, weight 2 (or large) to non-edges in complete graph; threshold $n$ forces using only original edges.

### Worked example 7

Metric TSP remains NP-hard; approximation behavior differs from non-metric.

## 8. Optimization vs decision

NP-completeness is for decision. Optimization hardness follows: if you optimize in poly time, you decide thresholds in poly time.

### Worked example 8

Max-CLIQUE optimization poly $\Rightarrow$ CLIQUE decision poly $\Rightarrow$ $\mathbf{P}=\mathbf{NP}$ if Max-CLIQUE always poly.

## 9. Proof hygiene examples of bugs

1. Reduction exponential in $k$ or $n$  
2. Only proving YES$\Rightarrow$YES  
3. Gadgets that accidentally create extra solutions  
4. Assuming $\mathbf{P}\neq\mathbf{NP}$ without stating when claiming “no poly algorithm”  
5. Using Turing reductions while claiming Karp-completeness without care  

### Worked example 9 — wrong direction essay

“I reduced my scheduling problem to SAT and SAT is hard, so scheduling is hard.” This shows scheduling is **no harder than SAT**, not hardness.

## 10. Beyond: strong NP-completeness, APX, etc.

- **Strongly NP-complete:** remains hard when numbers are small (unary)—rules out pseudo-poly algorithms unless $\mathbf{P}=\mathbf{NP}$  
- **APX-hard:** hardness of approximation classes  

### Worked example 10

BIN PACKING strongly NP-hard; still has good approximations—hardness of exact vs approx diverge.

## 11. Pitfalls

1. Certificate not poly-time checkable  
2. Non-deterministic “guess poly solutions” without verifier clarity  
3. Graph encodings that blow size superpoly  
4. Confusing NP-hard search problems with decision languages  
5. Citing NP-completeness for problems over reals without encoding model  

## 12. Checkpoint

- Define verifier-based $\mathbf{NP}$  
- Use $\le_p$ in the correct direction  
- Outline Cook–Levin’s role  
- Execute clique/cover relationships  
- Audit a reduction for both iff sides  

## Exercises

### Easy

1. Prove $\mathbf{P}\subseteq\mathbf{NP}$.
2. Give certificates for 3-COLORABILITY.
3. Formalize VERTEX-COVER as a language.
4. If $A\le_p B\le_p C$ show $A\le_p C$.
5. Why is a poly-time algorithm for special graphs not enough for general NP-completeness collapse?

### Medium

6. Detail independent set $\leftrightarrow$ clique reduction.
7. Prove: if any NP-complete problem is in P then P=NP.
8. Write verifier carefully for HAMCYCLE.
9. Identify the bug in a fictional reduction that maps SAT to “always-yes” language.
10. Explain weak vs strong NP-completeness with SUBSET-SUM vs 3-SAT.

### Challenge

11. Write a full 3-SAT $\le_p$ CLIQUE proof with both directions.
12. Sketch Cook–Levin tableau constraints (local windows).
13. Reduce 3-SAT to 3-COLOR (high-level gadgets).
14. Show decision TSP NP-complete from HAMCYCLE with weights argument.
15. Research: NP-completeness of Minesweeper / Sudoku—what is the formal language?

## Summary

NP-completeness is membership plus hardness via poly-time many-one reductions from a known complete problem. Cook–Levin opens the floodgates; gadget reductions populate the catalog. Discipline about direction, certificates, and both sides of $\Leftrightarrow$ separates correct theory from folklore.
