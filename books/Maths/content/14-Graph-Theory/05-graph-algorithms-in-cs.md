# Graph Algorithms in Real Systems

## 1. Search and Ranking

### PageRank Sketch

Web graph as directed graph.
Stationary distribution of random walk approximates importance.

Core iteration:
`r_{t+1} = alpha P^T r_t + (1-alpha) v`.

## 2. Build and Dependency Graphs

Package managers and build systems (Bazel, Maven, npm) rely on DAGs.

Tasks:
- cycle detection
- topological scheduling
- incremental rebuild by affected subgraph

## 3. Compiler Graphs

- Control Flow Graph (CFG)
- Call Graph
- SSA def-use graph

Graph analysis supports optimization passes and static analysis.

## 4. Databases and Query Planning

Query plans can be viewed as operator DAGs.
Cost-based optimization performs search over possible graph structures.

## 5. Networking

Routing protocols approximate shortest path or policy-constrained path computations.

- OSPF: weighted shortest path style
- BGP: policy path-vector style

## 6. ML and AI

- Knowledge graphs for entity-relation reasoning
- Graph neural networks on node/edge features
- Factor graphs and Bayesian networks

## 7. Production Concerns

- graph size and memory layout
- streaming updates
- distributed graph processing
- approximation vs exactness tradeoffs

## Capstone Exercises

1. Build a dependency analyzer: parse edges, detect cycles, topologically sort.
2. Implement weighted shortest path service (Dijkstra + parent reconstruction).
3. Build SCC detector and compress graph to DAG.
4. Benchmark adjacency list vs matrix for sparse/dense synthetic graphs.
5. Write report on algorithm selection tradeoffs for your measurements.

## Summary

Graph theory in CS is not academic decoration. It is operational infrastructure across compilers, build systems, networking, search, and ML.
