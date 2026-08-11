# Randomized and Approximation Algorithms

When deterministic exact algorithms are too slow or too rigid, two standard escapes appear: **use randomness** (speed or simplicity with controlled failure) and **approximate** (provably near-optimal solutions). This chapter builds the mathematical language for both, with CS applications from hashing to covering problems.

## Part A — Randomized algorithms

## 1. What randomness buys

A randomized algorithm may flip coins during execution. Analysis is over coin tosses (and sometimes over input distributions).

**Las Vegas:** always correct; runtime is a random variable (e.g. randomized quicksort expected $O(n\log n)$).

**Monte Carlo:** may err; runtime often fixed (e.g. probabilistic primality tests historically; fingerprinting).

### Worked example 1 — randomized quicksort

Pivot uniformly at random: expected comparisons $O(n\log n)$ for any input (expectation over pivots). Failure mode: none for correctness; only slow runs with small probability.

## 2. Error modes and amplification

For Monte Carlo decision algorithms:

- **One-sided error:** e.g. always correct on NO, may err on YES (or vice versa)—classically related to $\mathbf{RP}$
- **Two-sided error:** may err either way—related to $\mathbf{BPP}$

**Amplification theorem (intuition).** If a Monte Carlo algorithm errs with probability $\le 1/3$, then $k$ independent repetitions with majority vote (two-sided) or OR/AND combination (one-sided) drive error to $2^{-\Theta(k)}$.

### Worked example 2

Error $1/3$ per trial, majority of $100$ trials: Chernoff bounds give exponentially small error. Cryptographic and fingerprinting applications rely on this.

### Chernoff bound (useful form)

For independent Bernoullis $X_i$ with $X=\sum X_i$, $\mu=\mathbb{E}[X]$, and $\delta\in(0,1)$,

$$
P(X<(1-\delta)\mu)\le e^{-\mu\delta^2/2},\qquad
P(X>(1+\delta)\mu)\le e^{-\mu\delta^2/3}.
$$

(Constants vary by textbook form; the message is exponential concentration.)

## 3. Fingerprinting and polynomial identity

**Schwartz–Zippel lemma (statement).** Let $P\in\mathbb{F}[x_1,\ldots,x_n]$ be nonzero of total degree $d$. If $r_i$ drawn independently uniformly from finite $S\subseteq\mathbb{F}$, then

$$
P(P(r_1,\ldots,r_n)=0)\le \frac{d}{|S|}.
$$

**Application:** test $P\equiv 0$ by evaluation at a random point—core of probabilistic polynomial identity testing and some parallel algorithms.

### Worked example 3 — communication-free checking

Alice holds matrix $A$, Bob $B$; check $AB=C$ by multiplying $A(Br)$ vs $Cr$ for random $r$—error probability controlled, faster than full multiply verification in some models.

## 4. Hashing and dictionaries

Universal hash families: for $x\neq y$, $P_{h\sim\mathcal{H}}(h(x)=h(y))\le 1/m$. Expected chain length $O(1+\alpha)$ in chaining.

### Worked example 4

With load factor $\alpha=n/m=O(1)$ and 2-universal hashing, expected search time $O(1)$. High-probability bounds need stronger tail arguments or perfect hashing variants.

## 5. Markov, Chebyshev, and median-of-means

- **Markov:** $P(X\ge t)\le\mathbb{E}[X]/t$ for $X\ge 0$
- **Chebyshev:** $P(|X-\mu|\ge t)\le\mathrm{Var}(X)/t^2$
- **Median-of-means:** reduce dependence on variance for robust mean estimation with fewer moments assumptions

### Worked example 5 — Las Vegas to high probability

If Las Vegas runtime $T$ has $\mathbb{E}[T]=O(f(n))$, Markov says $P(T> c f(n))\le 1/c$. Restart strategies convert expectation bounds into high-probability bounds.

## Part B — Approximation algorithms

## 6. Optimization and approximation ratio

For a minimization problem with optimum $\mathrm{OPT}(I)$ on instance $I$, algorithm $\mathcal{A}$ has **approximation ratio** $\rho\ge 1$ if for all $I$,

$$
\mathcal{A}(I)\le \rho\cdot \mathrm{OPT}(I).
$$

For maximization, $\mathcal{A}(I)\ge \mathrm{OPT}(I)/\rho$ (conventions vary; always state which).

**PTAS:** $(1+\varepsilon)$-approx for every $\varepsilon>0$ with time $n^{f(1/\varepsilon)}$.  
**FPTAS:** time $\mathrm{poly}(n,1/\varepsilon)$.

### Worked example 6 — load balancing

Assign jobs with times $t_j$ to $m$ machines to minimize makespan. List scheduling: $\rho=2-\frac{1}{m}$. Greedy LPT improves constants. Analysis uses lower bounds $\mathrm{OPT}\ge\max(\max t_j,\ \frac{1}{m}\sum t_j)$.

## 7. Vertex cover 2-approximation

**Problem.** Min vertices hitting all edges.

**Algorithm:** while edges remain, pick any edge, add **both** endpoints to cover, delete incident edges.

**Theorem.** This is a 2-approximation.

**Proof.** Selected edges form a matching $M$; cover size $2|M|$. Any cover needs $\ge|M|$ vertices (hit each matching edge). Thus $\mathcal{A}=2|M|\le 2\,\mathrm{OPT}$.

### Worked example 7

Path of 3 edges: algorithm may take 4 vertices if unlucky in implementation order? On a simple path $v1—v2—v3—v4$, pick middle edge first carefully—work through a concrete graph and compare to OPT.

Better: maximal matching based 2-approx is standard; LP rounding also yields 2-approx.

## 8. Set cover greedy

Universe $U$, $|U|=n$, sets $S_1,\ldots,S_m$. Greedy repeatedly picks set covering the most remaining elements.

**Theorem.** Approximation ratio $H_n=1+\frac12+\cdots+\frac1n\le \ln n+1$.

**Proof idea.** Charge cost of each step across newly covered elements using harmonic harmonic increments; compare to OPT fractional packing of elements.

### Worked example 8

This $O(\log n)$ ratio is essentially tight under complexity assumptions—cannot do much better in poly time for general set cover.

## 9. Greedy knapsack and FPTAS (sketch)

Fractional knapsack: greedy by value/weight optimal.  
0-1 knapsack: pseudo-poly DP in $O(nW)$; FPTAS scales values to get $(1-\varepsilon)$-approx in $\mathrm{poly}(n,1/\varepsilon)$.

### Worked example 9

When weights are huge, bit length makes $O(nW)$ exponential in input size—pseudo-polynomial, not polynomial. FPTAS restores poly-time near-optimality.

## 10. Hardness of approximation (awareness)

Some ratios are impossible unless $\mathbf{P}=\mathbf{NP}$ (or under stronger conjectures like UGC):

- General TSP without triangle inequality: no constant-factor approx
- Max-clique: extremely hard to approximate
- Set cover: no $(1-o(1))\ln n$ under standard assumptions

So approximation algorithms are not a free lunch; they come with a theory of limits.

## 11. Engineering tradeoff table

| Method | Pros | Cons |
|--------|------|------|
| Exact ILP/MIP | Optimal, certificates | Scales poorly |
| Approximation | Provable ratio, often fast | Ratio may be weak in practice |
| Heuristic / local search | Excellent empirics | No worst-case guarantee |
| Randomized exact (Las Vegas) | Simple, good expected time | Tail latency |
| Monte Carlo | Very fast checks | Residual error |

### Worked example 10 — production choice

CDN cache placement NP-hard: use greedy set cover style with $\ln n$ guarantee, or MIP for small instances overnight, or hybrid warm-start.

## 12. Pitfalls

1. **Expected time vs high-probability latency** (SLOs care about tails)
2. **One-sided vs two-sided error** mishandled in amplification
3. **Approximation ratio on wrong objective** (min vs max)
4. **Claiming greedy is optimal** without proof (activity selection yes; set cover no)
5. **Pseudo-poly DP** marketed as poly-time
6. **Average-case heuristics** presented as approximation algorithms

## 13. Checkpoint

- Distinguish Las Vegas / Monte Carlo and amplify error
- Apply Markov/Chernoff at a basic level
- Define approximation ratio and prove the matching vertex-cover 2-approx
- State greedy set cover’s harmonic ratio
- Choose among exact / approx / heuristic given constraints

## Exercises

### Easy

1. Is randomized quicksort Las Vegas or Monte Carlo? Why?
2. Amplify a one-sided error algorithm that errs only on YES instances with probability $1/2$: how to get error $2^{-k}$?
3. Apply Markov: if $\mathbb{E}[T]=2n$, bound $P(T\ge 100n)$.
4. Define approximation ratio for MAX-CUT style maximization.
5. Run the vertex-cover 2-approx by hand on a 4-cycle; compare to OPT.

### Medium

6. Prove the vertex-cover matching argument carefully.
7. Using Chebyshev, how many samples to estimate a mean with variance $\sigma^2$ within $\varepsilon$ with probability $\ge 1-\delta$?
8. Explain why list scheduling for makespan is at most $(2-1/m)\mathrm{OPT}$.
9. Give an instance where greedy set cover is asymptotically worse than OPT by a $\Theta(\log n)$ factor (classic construction sketch).
10. Schwartz–Zippel: bound error if $\deg P\le d$ and $|S|=2d$.

### Challenge

11. Derive (or look up and rephrase) Chernoff bound application for majority vote amplification of BPP-style algorithms.
12. Design a Monte Carlo algorithm to test bipartite perfect matching existence via algebraic techniques (Edmonds matrix) at high level.
13. Give an FPTAS sketch for knapsack: how values are scaled and why error stays $\le\varepsilon\cdot\mathrm{OPT}$.
14. Prove that if a minimization problem admits a poly-time $\rho$-approx for all $\rho>1$, something collapses—or explain for TSP without triangle inequality why no constant approx exists (gap-producing reduction idea).
15. Systems design prompt: pick an NP-hard allocation problem in cloud computing; propose an approximation or greedy scheme and state what ratio you can claim (or what remains heuristic).

## Summary

Randomness yields simpler algorithms, concentration-based guarantees, and powerful identity tests. Approximation algorithms trade optimality for speed with **provable** ratios—vertex cover, set cover, scheduling, and knapsack are templates. Complexity also limits how good those ratios can be, guiding honest engineering choices.
