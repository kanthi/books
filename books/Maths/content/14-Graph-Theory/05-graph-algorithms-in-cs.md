# Graph Algorithms in Real Systems

Textbook graph algorithms reappear—sometimes thinly disguised—in compilers, build systems, networks, databases, search engines, and ML. This chapter maps production problems to the math of previous chapters and highlights engineering constraints (scale, dynamism, approximation).

## 1. Ranking and the web graph: PageRank

**Model.** Web pages $V$, hyperlinks directed edges. Random surfer: with probability $\alpha$ follow a random out-link; with probability $1-\alpha$ jump by distribution $v$ (typically uniform).

**Iteration.**

$$
r^{(t+1)} = \alpha P^\top r^{(t)} + (1-\alpha)v,
$$

where $P$ is the row-stochastic matrix of the (dangling-node-fixed) graph.

**Math.** $r$ converges to the stationary distribution of a related Google matrix—dominant eigenvector of a positive matrix (Perron–Frobenius).

### Worked example 1

Tiny 3-page graph: write $P$, iterate from uniform $r$ a few steps; observe mass concentrating on well-linked pages.

### Worked example 2 — systems issues

- Power iteration on graphs with $10^{10}$ edges: sparse matvec, partitioning
- Dangling nodes (out-degree 0): special handling
- Spam and link farms: adversaries against the model

## 2. Build systems and package managers

**Model.** Targets/packages as vertices; dependency edges $A\to B$ meaning “$A$ depends on $B$” (direction conventions vary—fix them).

**Tasks.**

1. Cycle detection (DFS / SCC) $\Rightarrow$ error  
2. Topological scheduling of builds  
3. Incremental rebuild: recompute only descendants of changed nodes  
4. Parallel build: schedule ready zero-indegree tasks (Kahn online)

### Worked example 3 — Bazel / make

Change a leaf library: transitive reverse-deps invalidation is graph reachability in the reverse dependency graph.

### Worked example 4 — npm/cargo

Version resolution is harder than pure DAGs (constraints, diamonds); still, the backbone is dependency digraph analysis.

## 3. Compiler graphs

| Graph | Role |
|-------|------|
| Control-flow graph (CFG) | Blocks and branches; dominance, liveness |
| Call graph | Who calls whom; devirtualization limits |
| SSA def-use | Dataflow precision |
| Interference graph | Register allocation = graph coloring |

**Register allocation:** color interference graph with $k$ colors (registers). Graph coloring is NP-hard; compilers use heuristics (Chaitin-Briggs) and spilling.

### Worked example 5 — dominance

Dominator tree from CFG: $d$ dominates $n$ if all paths from entry to $n$ go through $d$. Computed by iterative dataflow or Lengauer–Tarjan—enables SSA construction.

### Worked example 6 — dead code

If a block is unreachable from entry in CFG, it can be removed—graph reachability.

## 4. Databases and query plans

Join orders and operator pipelines form trees/DAGs. Cost-based optimizers search a space of plan graphs with dynamic programming (System R style) or heuristics for large queries.

### Worked example 7

Bushy vs left-deep join trees: different graph shapes, different intermediate sizes. Math: cost models + search, not only SQL parsing.

**Foreign keys / transitive closure:** recursive CTEs implement graph reachability in the engine.

## 5. Networking and routing

- **OSPF / link-state:** routers flood topology; each runs shortest paths (Dijkstra) on weighted graphs  
- **Distance-vector:** Bellman–Ford-like distributed relaxation (with historical count-to-infinity issues)  
- **BGP:** path-vector with **policy**—not pure shortest path; export/import rules dominate

### Worked example 8

Traffic engineering: adjust link weights so shortest-path routing balances load—inverse optimization flavor.

### Worked example 9 — SDN

Central controller computes paths (often MCF multi-commodity flow approximations) and installs forwarding rules.

## 6. Distributed systems and consensus adjacency

- **Leader election / spanning trees** on network overlays  
- **Gossip:** epidemic spreading on graphs; cover times  
- **Service mesh:** dependency graphs for cascading failure analysis  
- **Causal order:** DAG of vector-clock consistent events

### Worked example 10 — blast radius

Call-graph of microservices: which services fail if $X$ dies? Reverse reachability / dependents.

## 7. ML and data

- **Knowledge graphs:** multi-relational digraphs; path queries, embeddings  
- **GNNs:** message passing $h_v^{(t+1)}=\psi(h_v^{(t)},\bigoplus_{u\in N(v)}\phi(h_u^{(t)},h_v^{(t)},e_{uv}))$  
- **Factor graphs / Bayesian networks:** inference structure (trees exact; loops need approx)  
- **Recommendation:** bipartite user–item graphs; random walks, spectral methods

### Worked example 11 — label propagation

Community detection / semi-supervised learning: iterative averaging on graph edges—related to harmonic functions and Laplacian systems.

## 8. Production concerns checklist

| Issue | Graph response |
|-------|----------------|
| Scale | Streaming algorithms, sketching, sampling |
| Dynamics | Dynamic MST/SP trees research; often recompute shards |
| Distribution | Graph partition (edge/vertex cut), Pregel/GraphX model |
| Latency | Precompute SCCs, landmarks for distances |
| Correctness | Property tests: no cycles in builds; flow conservation audits |
| Approximation | Sketch PageRank, approximate neighborhoods |

### Worked example 12 — partition quality

Edge-cut vs vertex-cut partitions change communication volume for GNN training and distributed PageRank.

## 9. Choosing algorithms under constraints

1. **Exact needed?** (compilers correctness vs ranking quality)  
2. **Static or streaming?**  
3. **Weighted? negative?**  
4. **Memory per machine?**  
5. **Is a 2-approx enough?** (matching, cover)  

### Worked example 13 — bipartite matching at scale

Ad assignment: Hopcroft–Karp or flow on huge graphs may be too slow; use greedy auction algorithms with approximation guarantees.

## 10. Capstone synthesis patterns

Map each system task:

$$
\text{System problem} \to \text{Graph model} \to \text{Algorithm class} \to \text{Failure mode}.
$$

Examples:

- Circular dependency $\to$ digraph cycle $\to$ DFS/SCC $\to$ hard error  
- Fast web rank $\to$ stochastic matrix $\to$ power iteration $\to$ spam  
- Low-latency route $\to$ weighted digraph $\to$ Dijkstra/A* $\to$ stale weights  

## 11. Pitfalls

1. Wrong edge direction in dependency modeling  
2. Treating BGP as OSPF-like shortest path  
3. Full Floyd on continental road networks  
4. Ignoring multi-edges / weights units (ms vs km)  
5. Coloring interference graphs with exponential exact solvers in the hot path  
6. GNN over-smoothing: too many message-passing layers collapse features  

## 12. Checkpoint

- Write PageRank’s update and name the stationary-distribution view  
- Schedule a build with topo sort and detect cycles  
- Connect register allocation to graph coloring  
- Contrast link-state vs path-vector routing mathematically  
- Reduce one ML graph task to message passing or spectral structure  

## Exercises

### Easy

1. Draw a 4-service microservice dependency graph; list rebuild order after one change.
2. Explain dangling nodes in PageRank in one paragraph.
3. Why is CFG reducibility historically important for compilers?
4. Give one reason BGP is not pure Dijkstra.
5. Name a bipartite graph in recommender systems.

### Medium

6. Pseudocode incremental rebuild: given changed set $C$, mark all reverse-reachable dependents.
7. Show a tiny interference graph needing 3 registers; attempt a greedy coloring.
8. Compare A* vs Dijkstra for point-to-point routes with a consistent heuristic.
9. Write the Google matrix $G=\alpha P+(1-\alpha)\mathbf{1}v^\top$ and argue primitivity for large enough teleport.
10. Model deadlock in lock-acquire graphs: what does a cycle mean?

### Challenge

11. Implement (pseudocode) power iteration with dangling-node fix; discuss convergence criterion $\|r^{t+1}-r^t\|_1$.
12. Research Lengauer–Tarjan dominators at high level: why linear-ish time matters.
13. Design a min-cut based image segmentation energy for a 3×3 pixel toy.
14. Propose a graph partitioning objective (edge cut + balance) and why it’s hard.
15. Capstone report outline: pick one production graph problem; specify model, algorithm, complexity, monitoring metrics, and degradation mode under graph growth.

## Summary

Graph theory in CS is operational infrastructure. Ranking, builds, compilers, routing, databases, and ML all instantiate connectivity, orderings, shortest paths, flows, and spectral iteration—under brutal constraints of scale and change. Fluent mapping from system need to graph problem is the professional skill this part aims to build.
