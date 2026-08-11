# Shortest Paths

Shortest-path problems ask for minimum-cost routes in weighted graphs. The right algorithm depends on **weight signs**, **query type** (single-source vs all-pairs), and **graph density**. This chapter develops BFS, Dijkstra, Bellman–Ford, and Floyd–Warshall with invariants and failure modes.

## 1. Problem variants

Let $G=(V,E)$ with weight $w:E\to\mathbb{R}$. A path $P$ has weight $w(P)=\sum_{e\in P}w(e)$.

| Variant | Output |
|---------|--------|
| Single-pair | dist$(s,t)$ and a path |
| Single-source (SSSP) | dist$(s,\cdot)$ to all |
| All-pairs (APSP) | dist$(u,v)$ for all pairs |
| $k$-shortest / constrained | variants with extra structure |

**Assumption for “shortest path exists”:** no **negative cycle** reachable on the relevant portion of the graph (otherwise weights unbounded below).

### Worked example 1 — hop vs weight

Unweighted: minimize number of edges. Weighted: minimize sum. BFS solves the first, not the second (unless all weights equal).

## 2. Unweighted graphs: BFS

**Algorithm.** Queue from $s$; first time a node is discovered, set $\mathrm{dist}[v]=\mathrm{dist}[u]+1$.

**Theorem.** BFS computes hop-distances in $O(n+m)$ time.

**Invariant.** Nodes are processed by nondecreasing distance; when dequeued, distance is final.

### Worked example 2

Grid pathfinding without diagonal costs: BFS. With different terrain costs: Dijkstra.

## 3. Nonnegative weights: Dijkstra

**Assumption.** $w(e)\ge 0$ for all $e$.

**Idea.** Maintain tentative distances $d[v]$; repeatedly settle the unsettled vertex $u$ with smallest $d[u]$; relax all edges out of $u$.

**Relaxation:** if $d[v]>d[u]+w(u,v)$, set $d[v]\leftarrow d[u]+w(u,v)$ and parent $v\leftarrow u$.

**Theorem.** When $u$ is settled, $d[u]=\mathrm{dist}(s,u)$.

**Proof sketch.** Suppose not; consider the first wrongly settled $u$. On a true shortest path to $u$, look at the first unsettled edge leaving the settled set—nonnegative weights make the cut-crossing argument work (classical Dijkstra proof). $\blacksquare$

**Complexity.** Binary heap: $O(m\log n)$. Dial’s algorithm / radix structures for integer weights.

### Worked example 3

Edges: $S\to A(1), S\to B(4), A\to B(2), A\to C(6), B\to C(3)$.

Order settled: $S(0), A(1), B(3)$ via $A$, $C(6)$ via $B$. Path $S$-$A$-$B$-$C$ weight 6.

### Worked example 4 — failure with negatives

Edge $A\to B$ weight $1$, $S\to B$ weight $2$, $S\to A$ weight $3$, and $B\to A$ weight $-2$ can break the “settled forever” claim. Use Bellman–Ford when negatives exist.

## 4. Negative weights: Bellman–Ford

**Algorithm.** Initialize $d[s]=0$, others $\infty$. Repeat $n-1$ times: relax **all** edges. Optional $n$th pass: if any relaxation possible, a negative cycle is reachable.

**Theorem.** After $k$ full relaxation rounds, $d[v]$ equals the minimum weight of an $s$–$v$ path using at most $k$ edges (or $\infty$).

**Corollary.** $n-1$ rounds suffice for simple shortest paths (at most $n-1$ edges). Extra round detects negative cycles.

**Complexity.** $O(nm)$.

### Worked example 5 — negative cycle detect

If after $n-1$ rounds an edge still improves a distance, there is a walk of length $\ge n$ improving cost $\Rightarrow$ cycle with negative total weight in the predecessor graph.

### Worked example 6 — currency arbitrage

Log-transform exchange rates: product of rates $>1$ $\Leftrightarrow$ negative cycle in $-\log$ weights. Bellman–Ford detects arbitrage.

## 5. All-pairs: Floyd–Warshall

**DP.** Let $d_{ij}^{(k)}$ be shortest $i\to j$ path using intermediate vertices only from $\{1,\ldots,k\}$.

$$
d_{ij}^{(k)}=\min\big(d_{ij}^{(k-1)},\ d_{ik}^{(k-1)}+d_{kj}^{(k-1)}\big).
$$

In-place implementation with care about diagonal (negative cycle if $d_{ii}<0$).

**Complexity.** $\Theta(n^3)$ time, $\Theta(n^2)$ space.

**When to use.** Dense graphs, small $n$ ($\lesssim 400$–$1000$ depending on constants), need full matrix.

### Worked example 7

Compare: $n=1000$, $m=5000$ sparse SSSP many times with Dijkstra vs one Floyd—Dijkstra multi-source usually wins for sparse.

## 6. Johnson’s algorithm (sketch)

APSP on sparse graphs with negatives (no neg cycles): Bellman–Ford potentials from a super-source to reweight edges to nonnegative, then Dijkstra from each vertex. Time $O(n m + n^2\log n)$ with heaps.

## 7. Algorithm selection

```text
flow:
  B -> C  (all equal / unweighted)
  B -> D  (nonnegative)
  B -> E  (negatives)
  A -> F
  F -> G  (yes dense)
  F -> H  (yes sparse)
```

### Worked example 8 — maps

Road networks: nonnegative travel times $\Rightarrow$ Dijkstra + hierarchical speedups (contraction hierarchies, A* with landmarks)—engineering beyond textbook but based on the same invariants.

## 8. Path reconstruction

Store $\mathrm{parent}[v]$ on successful relaxations. Walk parents from $t$ to $s$, reverse. For Floyd, store $\mathrm{next}[i][j]$ intermediate hop.

### Worked example 9

From Example 3: parent[C]=B, parent[B]=A, parent[A]=S $\Rightarrow$ path S-A-B-C.

## 9. A* search (informed SSSP)

Priority key $d[u]+h(u)$ with heuristic $h$ estimating dist to target. **Admissible** $h$ (never overestimates) preserves optimality. **Consistent** heuristics keep Dijkstra-like properties.

### Worked example 10

Grid with Euclidean $h$: A* expands fewer nodes than Dijkstra toward a goal.

## 10. Pitfalls

1. Dijkstra + negative edges  
2. Not initializing distances to $\infty$ / not handling unreachable  
3. Floating weights and equality tests  
4. Overflow if using large “INF” in Floyd  
5. Confusing undirected edges (implement as two arcs) with Dijkstra on one direction only  
6. Reporting a path when a negative cycle can reach it—undefined / $-\infty$

## 11. Checkpoint

- Prove why BFS layers are hop-optimal  
- State Dijkstra’s invariant and nonnegativity need  
- Detect negative cycles with Bellman–Ford  
- Write Floyd recurrence and complexity  
- Reconstruct paths from parent pointers  

## Exercises

### Easy

1. Run BFS distances on a binary tree from the root (hop metric).
2. Execute Dijkstra by hand on a 6-edge digraph you draw.
3. Show a 3-node counterexample where Dijkstra fails with a negative edge.
4. Complexity of Bellman–Ford on a complete digraph.
5. When is APSP via $n$ Dijkstras better than Floyd?

### Medium

6. Prove BFS correctness by induction on distance.
7. Prove: if all weights are positive, shortest paths are simple (no cycles).
8. Implement (pseudocode) Bellman–Ford with negative-cycle vertex reporting via parent graph.
9. Show Floyd can detect negative cycles via diagonal.
10. Prove that reweighting $w'(u,v)=w(u,v)+h(u)-h(v)$ preserves shortest paths (potential method).

### Challenge

11. Derive Johnson’s algorithm fully and prove nonnegativity of reweighted edges when no neg cycle.
12. Analyze binary heap Dijkstra carefully (decrease-key counts).
13. A*: prove admissible heuristic $\Rightarrow$ optimal path when goal is settled.
14. Differential constraints: $x_j-x_i\le b_k$ as edges; feasibility via Bellman–Ford.
15. Systems: sketch how OSPF relates to shortest paths and what “metrics” mean.

## Summary

Shortest paths are settled by matching algorithm to weight structure: BFS, Dijkstra, Bellman–Ford, Floyd/Johnson. Invariants and negative-cycle handling separate correct systems from subtle production bugs.
