# Trees and Spanning Trees

## 1. Tree Definition

A tree is a connected acyclic undirected graph.

Equivalent characterizations for graph with `n` vertices:
- connected and has `n-1` edges
- acyclic and has `n-1` edges
- unique simple path between any two vertices

## 2. Theorem

If `T` is a tree with `n>=1` vertices, then `|E|=n-1`.

### Proof Sketch

Induction on `n` using existence of leaf (degree 1 vertex).
Remove leaf -> smaller tree with one less vertex and edge.

## 3. Rooted Trees

With chosen root:
- parent/child
- ancestor/descendant
- depth, height

Common CS trees:
- binary trees
- heaps
- tries
- syntax trees

## 4. Spanning Tree

A spanning tree of connected graph `G` includes all vertices and forms a tree.

If original graph has cycles, remove cycle edges while preserving connectivity.

## 5. Minimum Spanning Tree (MST)

Given weighted connected graph, MST minimizes total edge weight.

### Cut Property

For any cut, minimum-weight edge crossing the cut is safe for some MST.

### Cycle Property

In any cycle, a maximum-weight edge cannot belong to an MST.

## 6. Kruskal Algorithm

1. Sort edges by weight.
2. Add edge if it does not create cycle (DSU/Union-Find).
3. Stop after `n-1` edges.

Complexity: `O(E log E)`.

## 7. Prim Algorithm

1. Start from any vertex.
2. Repeatedly add smallest crossing edge to grow tree.

Heap implementation complexity: `O(E log V)`.

## 8. Worked Example

Edges:
`(A,B,1), (A,C,4), (B,C,2), (B,D,5), (C,D,1)`

Kruskal sorted: 1,1,2,4,5
Pick `(A,B,1)`, `(C,D,1)`, `(B,C,2)` -> done, total 4.

## Exercises

1. Prove every connected graph has a spanning tree.
2. Give graph where multiple distinct MSTs exist.
3. Implement DSU with path compression + union by rank.
4. Compare Prim vs Kruskal on dense and sparse graphs.

## Summary

Trees represent minimal connectivity. MST algorithms are a key example of provably correct greedy methods with strong systems applications.
