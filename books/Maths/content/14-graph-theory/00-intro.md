# Graph Theory for Computer Science

Graphs model pairwise relationships: machines on a network, packages in a dependency tree, people in a social graph, basic blocks in a control-flow graph. Graph theory supplies the definitions; algorithms supply the computation. This part develops both with proofs, complexity, and systems examples.

## What is a graph?

An **undirected graph** is $G=(V,E)$ with finite vertex set $V$ and edge set $E\subseteq\{\{u,v\}:u,v\in V,\,u\neq v\}$ (simple graphs: no loops/multiedges unless stated).

A **directed graph** (digraph) uses ordered pairs $(u,v)\in V\times V$.

**Weighted graphs** attach $w:E\to\mathbb{R}$ (length, cost, capacity, latency).

### Worked example 1 — many skins, one math

| Domain | Vertices | Edges |
|--------|----------|-------|
| Internet routing | Routers | Links with latency/weight |
| Build systems | Targets | Dependencies |
| Social networks | Users | Follows / friendships |
| Compilers | Basic blocks | Control-flow transfers |
| Knowledge graphs | Entities | Relations |
| ML | Tokens / objects | Attention or GNN message edges |

## Core computational problems

1. **Representation:** adjacency lists vs matrices—complexity hinges on this choice
2. **Traversal:** BFS/DFS; connectivity; topological order
3. **Trees & MSTs:** minimal connected backbones
4. **Shortest paths:** BFS / Dijkstra / Bellman–Ford / Floyd–Warshall
5. **Connectivity structure:** CCs, SCCs, bridges, articulation points
6. **Flow:** max-flow / min-cut; bipartite matching
7. **Systems patterns:** PageRank, dependency scheduling, routing

```text
flow:
  B -> C
  A -> D
  D -> E
  D -> F
  B -> G
  G -> H
```

## Proof techniques you will reuse

| Technique | Typical use |
|-----------|-------------|
| Induction on $\|V\|$ or path length | Tree properties, correctness |
| Loop invariants | Dijkstra, BFS layers |
| Cut properties | MST optimality |
| Exchange arguments | Greedy edge swaps |
| Potential / residual graphs | Flow augmentation |
| Counting double-touch | Handshaking lemma |

### Worked example 2 — handshaking

$\sum_{v\in V}\deg(v)=2|E|$ because each edge contributes two to the degree sum. Corollary: number of odd-degree vertices is even.

## Complexity baseline

| Algorithm | Time (typical) |
|-----------|----------------|
| BFS/DFS | $\Theta(V+E)$ adj lists |
| Dijkstra (binary heap) | $O(E\log V)$ |
| Bellman–Ford | $O(VE)$ |
| Kruskal | $O(E\log E)$ |
| Edmonds–Karp max-flow | $O(VE^2)$ |
| Floyd–Warshall | $\Theta(V^3)$ |

Always state assumptions (weights nonnegative? directed?).

### Worked example 3 — sparse vs dense

Web graph: $V\sim 10^{10}$ scale conceptual, $E=O(V)$. Matrix $V\times V$ is impossible; adjacency lists (or compressed) are mandatory. Complete graph $K_n$: $E=\Theta(n^2)$—matrix may win for dense kernels.

## Correctness mindset

Graph algorithms are famous for subtle bugs: relaxing edges in the wrong order, mishandling $0$-weight cycles, confusing weak and strong connectivity, off-by-one in topo sort cycle detection.

**Habit:** write the invariant before the code.

### Worked example 4 — BFS invariant

When node $u$ is first reached, $d[u]$ is the minimum hop distance from $s$. Proof: induction on distance layers.

## Roadmap

1. Graph basics and representations  
2. Trees and spanning trees / MST  
3. Shortest paths  
4. Connectivity and flow  
5. Graph algorithms in real systems  

## Pitfalls

1. Using adjacency matrices on huge sparse graphs
2. Dijkstra with negative edges
3. Assuming undirected algorithms work unchanged on digraphs
4. Forgetting disconnected graphs (forests, multiple sources)
5. Treating PageRank iteration as “just a heuristic” without stochastic matrix intuition

## Checkpoint

- Model a system as $G=(V,E)$ with clear semantics for weights
- Choose list vs matrix representation with a complexity justification
- Name the right shortest-path algorithm from graph properties
- State one invariant-style proof idea (BFS or Dijkstra)
- Map MST and flow to at least one systems task each

## Exercises

1. Model a monorepo build as a digraph; what does a cycle mean?
2. Prove that the number of odd-degree vertices is even.
3. Give $V,E$ counts for $K_n$ and for a path on $n$ vertices.
4. When is an adjacency matrix preferable to lists?
5. Is BFS or DFS better to find shortest hop paths? Why?
6. Explain cut property for MSTs in one paragraph.
7. Why can’t Dijkstra handle negative edges? Give a tiny counterexample idea.
8. Define strongly connected component.
9. Reduce bipartite matching to max-flow at a high level.
10. Name three compiler analyses that use graphs.
11. Space complexity of adj list vs matrix for $E=\Theta(V)$.
12. What goes wrong if weights are positive but you use unweighted BFS for “shortest”?
13. Sketch how Union-Find supports Kruskal.
14. Give a real routing protocol and the graph problem it approximates.
15. Checkpoint: pick an app you use daily and formalize its core graph.

## Summary

Graphs are the default language for structure in computer science. The chapters ahead make that language computational: representations, trees, paths, connectivity, flows, and production systems that run on these ideas at scale.
