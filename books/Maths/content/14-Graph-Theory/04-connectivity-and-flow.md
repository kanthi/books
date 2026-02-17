# Connectivity, Components, and Network Flow

## 1. Connectivity

Undirected graph:
- Connected component = maximal reachable subgraph.

Directed graph:
- Strongly connected component (SCC): each vertex reachable from each other.

## 2. SCC Algorithms

### Kosaraju

1. DFS to compute finish order.
2. Reverse graph.
3. DFS in reverse finish order to extract SCCs.

Complexity: `O(V+E)`.

### Tarjan

Single DFS using low-link values.

## 3. Topological Sort (DAG)

A linear ordering where each edge goes forward.

### Kahn's algorithm

- compute in-degree
- push zero in-degree nodes to queue
- pop and reduce neighbors

If processed count < `V`, graph had a cycle.

## 4. Network Flow Basics

Flow network with source `s`, sink `t`.
Constraints:
- capacity bounds
- flow conservation

Objective: maximize total `s->t` flow.

## 5. Ford-Fulkerson and Edmonds-Karp

- augment along residual paths
- update residual capacities

Edmonds-Karp uses BFS augmenting path.
Complexity: `O(VE^2)`.

## 6. Max-Flow Min-Cut Theorem

Maximum feasible flow value equals capacity of minimum `s-t` cut.

This provides both constructive algorithm and certificate of optimality.

## 7. CS Applications

- Bipartite matching
- Task assignment
- Traffic engineering
- Image segmentation (graph cuts)

## Exercises

1. Compute SCCs of a directed graph with 8 vertices.
2. Prove topological ordering exists iff graph is DAG.
3. Model bipartite matching as flow network.
4. Run Edmonds-Karp on small example and compute max flow manually.

## Summary

Connectivity algorithms reveal graph structure; flow algorithms optimize transfer through that structure. Together they form a powerful toolkit for systems and optimization problems.
