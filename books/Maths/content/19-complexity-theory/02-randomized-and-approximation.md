# Randomized and Approximation Complexity

Randomness and approximation refine the $\mathbf{P}$ vs $\mathbf{NP}$ story: some problems admit fast randomized algorithms with tiny error; some NP-hard optimization problems admit provable approximations while others resist even weak ratios. This chapter surveys classes and classic positive/negative results.

## 1. Randomized complexity classes (informal)

| Class | Error pattern | Intuition |
|-------|---------------|-----------|
| $\mathbf{RP}$ | one-sided on YES | random poly time; YES accepted with prob $\ge 1/2$; NO never accepted |
| $\mathbf{coRP}$ | one-sided on NO | complements of RP |
| $\mathbf{ZPP}$ | zero error, expected poly time | $\mathbf{RP}\cap\mathbf{coRP}$ |
| $\mathbf{BPP}$ | two-sided, error $\le 1/3$ | “efficient randomized practical” |

**Containment folklore:** $\mathbf{P}\subseteq\mathbf{ZPP}\subseteq\mathbf{RP}\subseteq\mathbf{BPP}$. Relation of $\mathbf{BPP}$ to $\mathbf{NP}$ is subtle; widely believed $\mathbf{BPP}=\mathbf{P}$ (derandomization under hardness assumptions).

### Worked example 1 — polynomial identity testing

Schwartz–Zippel yields coRP-style algorithms for identity testing—no known simple deterministic poly algorithm of same generality historically (derandomization progress exists).

### Worked example 2 — primality

Miller–Rabin: historically RP-style Monte Carlo; AKS later put PRIMES in $\mathbf{P}$.

## 2. Error reduction

Independent repetition + majority (BPP) or OR/AND (one-sided) drives error to $2^{-\mathrm{poly}}$. Amplification is why “error $1/3$” vs “$1/n^{100}$” are equivalent definitions up to poly time.

### Worked example 3

Chernoff bounds: majority of $O(\log(1/\delta))$ trials achieves error $\delta$.

## 3. Approximate counting and sampling (glimpse)

$\#\mathbf{P}$ counts accepting witnesses (permanent, \#SAT). Approximate counting and almost-uniform sampling connect via MCMC for some combinatorial structures (Jerrum–Valiant–Vazirani paradigm).

### Worked example 4

Permanent of nonnegative matrices: exact $\#\mathbf{P}$-hard; FPRAS exists via MCMC for the permanent (deep result).

## 4. Approximation algorithms complexity

For optimization problem $\Pi$, algorithm has ratio $\rho$ if it always returns solutions within $\rho$ of OPT (definitions min/max).

**Classes (informal):**

- **APX:** constant-factor approximable in poly time  
- **PTAS:** $(1+\varepsilon)$-approx for all $\varepsilon>0$  
- **FPTAS:** PTAS with time $\mathrm{poly}(n,1/\varepsilon)$  

### Worked example 5

Knapsack admits FPTAS; general TSP without metric assumptions does not admit any constant ratio unless $\mathbf{P}=\mathbf{NP}$.

## 5. Positive classics

| Problem | Guarantee |
|---------|-----------|
| Vertex cover | 2-approx (matching) |
| Metric TSP | 1.5 (Christofides); 2 via MST |
| Set cover | $H_n\approx\ln n$ greedy |
| Max-cut | 0.878 SDP (Goemans–Williamson) |
| Knapsack | FPTAS |

### Worked example 6

Vertex cover 2-approx proof: maximal matching lower bound—see Algorithms part; complexity view: in APX.

### Worked example 7 — gap from integrality

LP/SDP relaxations + rounding yield ratios; integrality gaps prove limits of that relaxation.

## 6. Hardness of approximation

Using PCPs (Probabilistically Checkable Proofs), one proves: if $\mathbf{P}\neq\mathbf{NP}$, some problems cannot be approximated better than $\rho$ in poly time.

### Worked example 8 — set cover

No $(1-o(1))\ln n$-approx unless $\mathbf{NP}$ has slightly superpoly algorithms (Feige et al. line of work)—greedy essentially optimal.

### Worked example 9 — clique

Extremely hard to approximate; related to PCP theorem corollaries.

### Worked example 10 — metric vs non-metric TSP

Non-metric: no constant approx (gap-producing reductions). Metric: constant possible.

## 7. PCP theorem (statement level)

**PCP theorem.** $\mathbf{NP}=\mathbf{PCP}(O(\log n),O(1))$—proofs checkable by reading constantly many bits with random coins log-many.

This is the engine of modern hardness of approximation. Details are graduate-level; know the existence and purpose.

## 8. Promise problems and gaps

Hardness reductions often produce **gap problems**: YES instances have OPT $\ge c$, NO instances OPT $\le s$, with $c/s=\rho$. Distinguishing them in poly time would approximate within better than $\rho$.

### Worked example 11

Label-cover / unique games (UGC) conjectures refine constant-factor hardness landscapes (e.g. for vertex cover beyond 2 under UGC).

## 9. Engineering reading of the map

| Situation | Theory advice |
|-----------|---------------|
| Need exact small $n$ | ILP/DP/exponential OK |
| Large $n$, need guarantee | Seek APX/PTAS literature |
| Even weak approx hard | Heuristics + empirics; change model |
| Randomization natural | Fingerprinting, hashing, MCMC |

### Worked example 12 — product

CDN placement: greedy set cover $\ln n$ guarantee + MIP overnight for regions—hybrid of approx class and exact methods.

## 10. Pitfalls

1. Monte Carlo error not amplified for SLOs  
2. Calling any heuristic an “approximation algorithm” without ratio  
3. Using non-metric TSP approx that assume triangle inequality  
4. Pseudo-poly exact algorithms misread as poly  
5. Assuming BPP algorithms always derandomize easily in practice (PRNGs usually fine; theory subtler)  

## 11. Checkpoint

- Define BPP/RP error patterns  
- Amplify two-sided error conceptually  
- Place problems in FPTAS/APX vs inapprox  
- State what PCP buys for hardness  
- Choose algorithm class given product constraints  

## Exercises

### Easy

1. Is randomized quicksort in ZPP-style thinking? Explain.
2. Why is error $1/3$ vs $1/100$ equivalent for BPP up to poly time?
3. Define approximation ratio for a maximization problem carefully.
4. Name one FPTAS and one problem without constant approx (unless P=NP).
5. What does one-sided error mean for RP?

### Medium

6. Prove majority amplification reduces two-sided error (Chernoff sketch).
7. Show metric TSP 2-approx via MST + Euler tour shortcut outline.
8. Explain gap-producing reduction idea for inapproximability.
9. Contrast weak NP-completeness of KNAPSACK with existence of FPTAS.
10. Why does triangle inequality matter for TSP approximation?

### Challenge

11. Goemans–Williamson: state SDP relaxation for max-cut at high level.
12. PCP theorem: explain in your words how query complexity $O(1)$ enables gap hardness.
13. Unique Games Conjecture: one implication for vertex cover approx.
14. FPRAS vs FPTAS definitions; example of counting vs optimization.
15. Design brief: pick NP-hard resource allocation; cite best known approx ratio class you can claim.

## Summary

Randomized classes formalize fast algorithms with controlled error; approximation classes formalize near-optimal optimization. PCPs and gap reductions show many ratios are unimprovable if $\mathbf{P}\neq\mathbf{NP}$. The practical art is matching your problem to a positive algorithm or proving you should stop seeking one.
