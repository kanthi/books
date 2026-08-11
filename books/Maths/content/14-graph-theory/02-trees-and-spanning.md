# Trees and Spanning Trees

Trees are minimally connected graphs—enough edges to link vertices, none wasted on cycles. They structure filesystems, decision procedures, heaps, and the backbone of **minimum spanning tree (MST)** algorithms used in clustering, network design, and approximation schemes.

## 1. Characterizations of trees

**Definition.** An undirected graph $T$ is a **tree** if it is connected and acyclic.

**Theorem (equivalent characterizations).** For a graph $T$ with $n\ge 1$ vertices, TFAE:

1. $T$ is a tree (connected + acyclic)
2. $T$ is connected and has $n-1$ edges
3. $T$ is acyclic and has $n-1$ edges
4. There is a unique simple path between every pair of vertices
5. $T$ is connected, but removing any edge disconnects $T$
6. $T$ is acyclic, but adding any missing edge creates exactly one cycle

**Proof sketch of (1)$\Rightarrow$(2).** Proceed by induction on $n$. A tree with $n\ge 2$ has a leaf (degree 1)—prove via “longest path ends at a leaf.” Remove leaf: remaining graph is a tree on $n-1$ vertices with one fewer edge. $\blacksquare$

### Worked example 1

A path on $n$ vertices: tree with 2 leaves. A star: one center, $n-1$ leaves, still $n-1$ edges.

### Worked example 2

Two components each trees: a **forest**. Edges $=n-c$ for $c$ components if acyclic.

## 2. Leaves and counting

**Lemma.** Every tree with $n\ge 2$ has at least two leaves.

**Proof.** Longest path’s endpoints have no further extension $\Rightarrow$ degree 1. $\blacksquare$

### Worked example 3

Can a tree have degrees $(4,3,1,1,1)$? Sum $=10=2|E|\Rightarrow |E|=5$, but $n=5$ needs $|E|=4$ for a tree—impossible.

## 3. Rooted trees in CS

Choose root $r$. Define parent, children, ancestors, depth, height, subtrees.

**Binary trees, heaps, BSTs, tries, segment trees, abstract syntax trees** are rooted trees with extra labels/orderings.

### Worked example 4 — heap property vs tree shape

Binary heap: complete binary tree shape + heap order on keys. Graph-theoretically still a tree; algorithms exploit array indexing $i\mapsto 2i,2i+1$.

### Worked example 5 — LCA

Lowest common ancestor queries on rooted trees underpin tarjan offline algorithms and binary lifting—used in hierarchical data and some string algorithms.

## 4. Spanning trees

**Definition.** A **spanning tree** of connected undirected $G$ is a subgraph that is a tree on all vertices of $G$.

**Theorem.** $G$ connected $\Leftrightarrow$ $G$ has a spanning tree.

**Proof sketch.** If connected, repeatedly delete an edge on a cycle until acyclic; connectivity preserved. Converse obvious. $\blacksquare$

Number of spanning trees of $K_n$ is $n^{n-2}$ (Cayley’s formula)—classic enumerative result.

### Worked example 6

Cycle $C_n$: exactly $n$ spanning trees (delete any one edge).

## 5. Minimum spanning trees

**Input.** Connected undirected $G$ with weights $w(e)$.  
**Goal.** Spanning tree $T$ minimizing $w(T)=\sum_{e\in T}w(e)$.

### Cut property

**Theorem (cut property).** For any cut $(S,V\setminus S)$ with $S$ neither empty nor $V$, if $e$ is a lightest edge crossing the cut, then some MST contains $e$.

**Proof idea.** Take any MST $T$. If $e\in T$, done. Else $T+e$ has a cycle; that cycle crosses the cut on some $e'$. Swap $e'$ for $e$: weight does not increase; new spanning tree. $\blacksquare$

### Cycle property

**Theorem.** For any cycle $C$, if $e$ is a strictly heaviest edge on $C$, then $e$ lies in no MST.

### Worked example 7 — uniqueness

If all edge weights are distinct, the MST is unique (standard corollary of cut/cycle properties).

## 6. Kruskal’s algorithm

1. Sort edges by increasing weight  
2. Initialize Union-Find on vertices  
3. For each edge $uv$ in order: if $u,v$ in different components, add $uv$ and unite  
4. Stop at $n-1$ edges  

**Correctness:** each added edge is a lightest edge across the cut between components (cut property).  
**Time:** $O(m\log m)$ dominated by sorting (or $O(m\alpha(n))$ after sort with Union-Find).

### Worked example 8

Edges: $(A,B,1),(C,D,1),(B,C,2),(A,C,4),(B,D,5)$.  
Kruskal adds $AB$, $CD$, $BC$; total weight $4$. Rejects $AC,BD$ as cycles.

## 7. Prim’s algorithm

Grow a tree from start vertex $s$: repeatedly add the lightest edge from the tree set $S$ to $V\setminus S$.

Implementation: binary heap of candidate edges/vertices $\Rightarrow O(m\log n)$; Fibonacci heap $O(m+n\log n)$ theoretically.

**Correctness:** each addition applies the cut property to $(S,V\setminus S)$.

### Worked example 9 — Prim on same graph

Start at $A$: take $AB$ (1), then $BC$ (2) or compare $AC$ (4), then to $D$ via $CD$ (1). Same MST weight $4$.

## 8. Kruskal vs Prim

| | Kruskal | Prim |
|--|---------|------|
| Nature | Global sort + DSU | Grow one component |
| Sparse graphs | Excellent | Good with heaps |
| Dense graphs | Sort $n^2$ edges costly | Can be competitive |
| Parallelism | Sorting parallelizable | Less natural |
| Online weights | Needs all edges | Same |

## 9. Applications

- **Network design:** cheapest cable connecting sites
- **Clustering:** single-linkage clustering related to MST
- **Approximation:** MST is a 2-approx building block for metric TSP (Christofides goes further)
- **Image segmentation / vision:** graph cuts more flow-based, but MST used in some hierarchical methods
- **Physics / percolation intuition:** lightest edges first

### Worked example 10 — single-linkage

Merge clusters by min inter-cluster edge—same process as Kruskal; dendrogram is hierarchical clustering.

## 10. Directed and other variants

- **Arborescence / branching:** directed analogues (Edmonds’ algorithm)—harder
- **Minimum bottleneck spanning tree:** minimize the max edge weight—related but different objective; still uses MST ideas
- **Steiner tree:** must span a **subset** of terminals—NP-hard

## 11. Pitfalls

1. Running MST algorithms on disconnected graphs (get forest; detect $c>1$)
2. Assuming uniqueness when weights repeat
3. Using directed edges with Kruskal naively
4. Floating-point weight comparisons without stable tie breaks
5. Confusing MST with shortest-path tree (different objectives!)

### Worked example 11 — SPT $\neq$ MST

A graph can have a shortest-path tree from $s$ that is not a minimum spanning tree. Shortest paths optimize distances from $s$; MST optimizes total edge weight globally.

## 12. Checkpoint

- List equivalent tree characterizations and prove $|E|=n-1$ by induction
- State cut property and why Kruskal/Prim are safe
- Execute Kruskal and Prim on a 5-edge graph
- Contrast MST vs shortest-path tree
- Choose Kruskal vs Prim for a sparse instance

## Exercises

### Easy

1. Prove that a tree with exactly two leaves is a path.
2. Show a connected graph with $n$ vertices and $n$ edges contains exactly one cycle (as a set of edges? carefully: at least one).
3. Run Kruskal on a weighted $K_4$ of your choice.
4. Prove: adding an edge to a tree creates exactly one cycle.
5. Cayley: how many spanning trees does $K_3$ have? Check by hand.

### Medium

6. Complete the induction that trees have $\ge 2$ leaves for $n\ge 2$.
7. Prove the cycle property from the cut property (or vice versa).
8. Show that if weights are distinct, MST is unique.
9. Give a counterexample graph where some shortest-path tree is not an MST.
10. Analyze Union-Find Kruskal complexity with path compression + union by rank.

### Challenge

11. Prove Cayley’s formula for $n\le 5$ by enumeration; outline Prüfer code idea for general $n$.
12. Design an algorithm for minimum bottleneck spanning tree; prove correctness.
13. Show metric TSP has a 2-approximation via MST + Euler tour shortcut (classic).
14. Discuss implementation: when to store edges vs adj lists for Prim.
15. Research: Borůvka’s algorithm and its role in parallel MST / history of the problem.

## Summary

Trees are the unique minimal connectors of a vertex set. Spanning trees always exist in connected graphs; MSTs optimize total weight via the cut property. Kruskal and Prim are correct greedy algorithms with complementary implementation profiles—and they reappear across clustering, networking, and approximation algorithms.
