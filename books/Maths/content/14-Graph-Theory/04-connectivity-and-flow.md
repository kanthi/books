# Connectivity, Components, and Network Flow

Connectivity describes how a graph falls into pieces; flow describes how much commodity can move through capacitated edges. Together they power reliability analysis, bipartite matching, scheduling, and segmentation.

## 1. Undirected connectivity

A **connected component** is a maximal connected subgraph. Compute via DFS/BFS forest or Union-Find in $O(n+m)$ or nearly $O(m\alpha(n))$.

**Bridge (cut-edge):** edge whose removal increases the number of components.  
**Articulation point (cut-vertex):** vertex whose removal increases components.

DFS low-link values find bridges/articulation points in linear time.

### Worked example 1

Two cliques sharing a single vertex: that vertex is an articulation point; no bridge if cliques are large complete.

### Worked example 2 — reliability

In a network, bridges are single points of link failure. Designing edge-redundant networks means ensuring edge-connectivity $\ge 2$.

## 2. Edge- and vertex-connectivity

- $\kappa'(G)$: min edges to disconnect $G$ (edge-connectivity)
- $\kappa(G)$: min vertices to disconnect (vertex-connectivity)

**Menger’s theorem (informal):** max number of edge-disjoint $s$–$t$ paths equals min size of an $s$–$t$ edge cut. Vertex version analogous.

This is the combinatorial heart linking connectivity to flow.

## 3. Directed strong connectivity

**Strongly connected component (SCC):** maximal set where every pair is mutually reachable.

Condensing each SCC to a node yields a **DAG** of components.

### Kosaraju’s algorithm

1. DFS on $G$, push vertices in finish order  
2. Transpose graph $G^T$  
3. DFS on $G^T$ in decreasing finish order; each tree is an SCC  

**Time:** $\Theta(n+m)$.

### Tarjan’s algorithm

Single DFS with `low` and stack—same asymptotics, less graph copying.

### Worked example 3

A cycle with a dangling edge: one big SCC on the cycle; the dangling vertex may be its own SCC depending on directions.

### Worked example 4 — 2-SAT

Implication graph: SCCs decide satisfiability ($x$ and $\neg x$ not in same SCC). Classic CS application of strong connectivity.

## 4. Topological sort on DAGs

**Order** vertices so every edge $u\to v$ has $u$ before $v$.

**Theorem.** A digraph has a topological order iff it is a DAG.

### Kahn’s algorithm

Compute indegrees; queue zeros; pop and decrement successors. If fewer than $n$ pops, a cycle exists.

### DFS finishing times

Reverse finish order on a DAG is a topo order.

### Worked example 5 — build systems

Targets with dependencies: topo order is a valid build order; cycle $\Rightarrow$ circular dependency error.

### Worked example 6 — course prerequisites

Same pattern; detect cycles as curriculum bugs.

## 5. Flow networks

**Flow network:** digraph with source $s$, sink $t$, capacities $c(u,v)\ge 0$.

A **flow** $f$ satisfies:

1. **Capacity:** $0\le f(u,v)\le c(u,v)$ (or antisymmetric formulation)
2. **Conservation:** for $v\notin\{s,t\}$, $\sum_u f(u,v)=\sum_w f(v,w)$

**Value** $|f|=$ net flow out of $s$.

**Max-flow problem:** maximize $|f|$.

## 6. Residual graphs and augmenting paths

Residual capacity $c_f(u,v)=c(u,v)-f(u,v)$ plus reverse edges for canceling flow. An **augmenting path** is an $s\rightsquigarrow t$ path in the residual graph. Augment by the bottleneck residual capacity.

**Ford–Fulkerson method:** while augmenting path exists, augment.

**Termination:** if capacities integral, max flow integral and algorithm terminates. With pathological real capacities, need care (Edmonds–Karp).

### Edmonds–Karp

Choose **shortest** (BFS) residual augmenting path each time. Complexity $O(n m^2)$.

### Worked example 7 — tiny max flow

$s\to a(2), s\to b(2), a\to t(1), b\to t(2), a\to b(1)$. Compute augmentations until residual disconnects $s$ from $t$. Max flow value $3$ in a standard working of this shape (verify by hand).

## 7. Max-flow min-cut theorem

An **$s$–$t$ cut** is a partition $(S,T)$ with $s\in S$, $t\in T$. Capacity $c(S,T)=\sum_{u\in S,v\in T}c(u,v)$.

**Theorem (max-flow min-cut).** Maximum flow value equals minimum cut capacity.

**Proof idea.** Weak duality: any flow $\le$ any cut. When no residual $s$–$t$ path, set $S=$ residual-reachable from $s$; flow saturates the cut and equals its capacity. $\blacksquare$

**Certificate:** a min cut proves optimality of a flow without re-running search from scratch.

### Worked example 8

After max flow, residual unreachable set defines a bottleneck cut—useful in reliability (“these links are critical”).

## 8. Bipartite matching via flow

Bipartite graph $(L\cup R,E)$: add $s\to L$, $R\to t$, edges $L\to R$ capacity 1 (and $s,t$ edges capacity 1). Max flow = maximum matching cardinality.

**Hall’s marriage theorem** gives combinatorial existence conditions; flow gives an algorithm.

### Worked example 9 — assignment

Workers $L$, jobs $R$, edges “qualified”: max matching assigns as many as possible.

### Worked example 10 — König’s theorem

In bipartite graphs, max matching size = min vertex cover size—linked through flow/cut duality.

## 9. Other flow applications

- **Edge-disjoint paths:** unit capacities (Menger)
- **Circulation with demands:** reduce to max flow with extras
- **Project selection / closed graph cuts:** reduction to min cut
- **Image segmentation:** pixels as vertices; min cut separates foreground/background (Boykov–style energy)

## 10. Dinic and beyond (awareness)

Blocking flows / Dinic $O(n^2 m)$, unit network special cases faster; push-relabel practical; for huge graphs, approx or specialized matchings.

## 11. Pitfalls

1. Forgetting reverse residual edges (cannot “undo” flow)
2. Using DFS Ford–Fulkerson with bad paths $\Rightarrow$ exponential on some graphs
3. Non-integral capacities and termination
4. Confusing weak connectivity with SCCs
5. Topo sort on graphs with cycles without detection
6. Modeling undirected edges as one-way arcs in flow

## 12. Checkpoint

- Compute CCs and explain bridges  
- Run Kosaraju mentally on a 6-vertex digraph  
- Topo-sort a DAG with Kahn and detect cycles  
- State max-flow min-cut and residual augmentation  
- Reduce bipartite matching to max flow  

## Exercises

### Easy

1. Find SCCs of a digraph consisting of two cycles sharing a vertex (directions matter—draw carefully).
2. Topo-sort a small course-prerequisite DAG.
3. Define residual capacity after sending 3 units on a capacity-5 edge.
4. Why does a min cut certify max flow?
5. Build the matching flow network for $K_{2,2}$.

### Medium

6. Prove that the condensation of SCCs is a DAG.
7. Prove Kahn’s algorithm fails to place all vertices iff a cycle exists.
8. Execute Edmonds–Karp on a graph with at least two augmentations; list path lengths.
9. Prove weak duality: $|f|\le c(S,T)$ for every $s$–$t$ cut.
10. Show that integral capacities $\Rightarrow$ integral max flow exists (from FF augmentations).

### Challenge

11. Detail the 2-SAT SCC algorithm and prove correctness sketch.
12. Find bridges with DFS `low` values; prove the bridge criterion.
13. Model “edge connectivity between $s,t$” as a flow; invoke Menger.
14. Image cut: write unary and pairwise energy as flow edges (high-level is fine).
15. Compare Dinic vs Edmonds–Karp asymptotics and when it matters.

## Summary

Connectivity algorithms expose structure (components, cuts, DAGs of SCCs). Flow algorithms optimize throughput with residual augmentation and are certified by min cuts. Matching, disjoint paths, and many planning problems are flow in disguise.
