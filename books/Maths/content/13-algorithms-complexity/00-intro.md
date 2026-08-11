# Algorithms and Computational Complexity

Algorithms transform inputs into outputs with finite resources. **Complexity theory** classifies how those resources scale and which problems admit efficient solutions at all. This part builds the mathematical toolkit for analyzing algorithms (asymptotics, recurrences, amortization) and for reasoning about hardness (classes, reductions, randomization, approximation).

## Why complexity is practical

| Question | Complexity answer |
|----------|-------------------|
| Will this service hold at 100× traffic? | Growth rate of time/memory vs $n$ |
| Is a faster algorithm possible? | Lower bounds / conditional hardness |
| Exact optimum too slow—what now? | Approximation, heuristics, parameterization |
| Can randomness help? | Monte Carlo / Las Vegas; RP, BPP intuition |
| Is my proof of “NP-complete” valid? | Reduction hygiene |

Complexity is not only academia: billing, capacity planning, cryptography assumptions, and compiler optimization all rest on resource reasoning.

**Next step:** for hardness proofs and space classes, continue in **part 19 Complexity-Theory** (this part emphasizes analyzing concrete algorithms).

## Two complementary activities

### 1. Algorithm analysis

Given a **specific procedure**, bound its worst-case (or average, amortized) time and space as functions of input size $n$.

Tools:

- Asymptotic notation $O,\Omega,\Theta$
- Loop counting and recurrence solving (Master theorem, substitution, trees)
- Amortized analysis (aggregate, accounting, potential)
- High-probability bounds for randomized algorithms

### 2. Problem complexity

Given a **problem** (a language or function), classify its intrinsic difficulty independent of any one algorithm.

Tools:

- Models of computation (Turing machines, RAM) at a conceptual level
- Classes $\mathbf{P},\mathbf{NP},\mathbf{PSPACE},\ldots$
- Polynomial-time reductions
- Completeness (NP-complete, PSPACE-complete)
- Approximation classes and hardness of approximation

### Worked example 1

Sorting $n$ comparable keys: many $O(n\log n)$ algorithms; information-theoretic lower bound $\Omega(n\log n)$ for comparison sorts. Problem complexity and algorithm analysis meet.

### Worked example 2

SAT: verify a satisfying assignment in poly time (in **NP**); no known poly-time algorithm; NP-complete. Algorithm analysis of DPLL/CDCL is separate from the class-theoretic status.

## Models and cost

We count elementary operations in a RAM-like model unless stated: arithmetic on words, memory access, comparisons. Bit complexity matters for big integers and crypto. Parallel and distributed models add communication rounds and processors.

**Input size $n$:** bits of the encoding, or number of elements for arrays/graphs with weights assumed unit-cost when standard.

### Worked example 3

Graph with $v$ vertices, $e$ edges: BFS is $O(v+e)$ time with adjacency lists—state both parameters, not a vague $O(n)$.

## Roadmap of this part

1. **Asymptotic analysis** — $O/\Omega/\Theta$, recurrences, amortization, practical vs asymptotic
2. **Complexity classes and reductions** — $\mathbf{P}$, $\mathbf{NP}$, poly-time reductions, completeness method
3. **Randomized and approximation algorithms** — error amplification, approximation ratios, tradeoffs

Section `19-Complexity-Theory` deepens NP-completeness proofs, space classes, and advanced randomized/approximation themes.

## Correctness before speed

An $O(1)$ wrong algorithm is worthless. Standard proof patterns:

- Loop invariants
- Induction on input size
- Exchange arguments (greedy)
- Potential functions (amortized + correctness together)

### Worked example 4 — invariant

Binary search: “target is in `lo..hi` if present.” Each step preserves the invariant and shrinks the interval $\Rightarrow$ correctness + $O(\log n)$ iterations.

## Average, worst, high probability

- **Worst-case:** max cost over inputs of size $n$ — standard for guarantees
- **Average-case:** expectation under a distribution — needs a realistic model
- **High-probability:** randomized algorithms with failure prob $\le n^{-c}$
- **Amortized:** average over a **sequence** of operations (not over random inputs)

### Worked example 5

Hash table insert: worst-case $O(n)$ on bad chains; expected $O(1)$ with good hashing; amortized $O(1)$ for dynamic array **regardless of randomness** when doubling.

## Reductions as a reusable idea

A reduction from problem $A$ to problem $B$ is an efficient transform showing “$B$ is at least as hard as $A$” (for decision problems, in the usual many-one sense). Used for:

- Reusing algorithms ($A\le B$ and $B$ solvable $\Rightarrow A$ solvable)
- Proving hardness ($A$ hard and $A\le B\Rightarrow B$ hard)

### Worked example 6

If you poly-time reduce SAT to your new scheduling decision problem and show the latter is in **NP**, you get NP-hardness / completeness (with care).

## Approximation and heuristics

For NP-hard optimization:

| Approach | Guarantee |
|----------|-----------|
| Exact exponential (ILP, DP on subsets) | Optimal; limited $n$ |
| Approximation algorithm | Provable ratio |
| FPTAS / PTAS | Near-optimal with time tradeoffs |
| Heuristic / ML-based | Often good; no worst-case proof |

### Worked example 7

Vertex cover: greedy 2-approximation vs exact exponential ILP—pick based on $n$ and need for optimality certificates.

## Pitfalls

1. **Dropping parameters** ($O(n)$ for graphs without $e$)
2. **Claiming $\Theta$ without matching lower bound**
3. **Average-case without stating the distribution**
4. **Reduction in the wrong direction** for hardness proofs
5. **Confusing NP-hard decision vs optimization** versions
6. **Ignoring constants and locality** when $n$ is moderate (cache, constants matter)

## Checkpoint

- Separate algorithm analysis from problem classification
- State time bounds with correct parameters
- Know when to use worst-case vs amortized vs high-probability
- Sketch what a poly-time reduction is for
- Name strategies when exact poly-time algorithms are unlikely

## Exercises

1. Give worst-case time for inserting into a balanced BST vs unsorted array (search+insert).
2. Why is “average runtime $O(1)$” incomplete without a probability model?
3. Explain amortized vs average-case using dynamic arrays vs hashing.
4. Binary search recurrence $T(n)=T(n/2)+\Theta(1)$: solve by unrolling.
5. List three problems in **P** and one believed not in **P**.
6. What does it mean that problem $B$ is NP-hard?
7. Give a case where an $O(n^2)$ algorithm beats $O(n\log n)$ in practice (constants/input sizes).
8. For matrix multiplication, state naive complexity and note that better exponents exist (no need to prove).
9. Write a loop invariant for insertion sort’s outer loop.
10. Why is verifying a graph coloring with $k$ colors easy but finding one potentially hard?
11. Define approximation ratio for a minimization problem.
12. Sketch how randomness helps in checking polynomial identity (Schwartz–Zippel intuition).
13. Capacity planning: if latency grows as $\Theta(n^2)$, what happens when $n$ doubles?
14. Explain why cryptographic hardness assumptions are **stronger/different** than “not known to be in P.”
15. Pick a feature in a system you know (routing, build system, DB) and identify the core algorithmic problem + resource metric.

## Summary

Complexity mathematics lets you predict scale, prove limits, and choose between exact, approximate, and randomized solutions. The following chapters turn these ideas into precise definitions, proof templates, and worked analyses.
