# Graph Theory Workshop: Exercises and Diagrams

A practice chapter: definitions → diagrams → multi-step problems. Use after graph basics / trees / paths.

## Diagram bank

### Undirected simple graph

```text
    A——B
    | /|
    |/ |
    C——D
```

Vertices $\{A,B,C,D\}$; edges as drawn.

### Directed

```text
  A → B → C
  ↑    ↘  │
  └───── D ←┘   (sketch your own arrows carefully)
```

### Tree vs cyclic

```text
  tree:  A           not tree:
         / \            A—B
        B   C           | |
                        D—C   (cycle)
```

## 1. Degree and handshaking

**Problem.** Degrees $3,3,2,2,2$. Is there a simple graph? Draw one or prove impossible.

**Hint:** sum of degrees must be even; graphical sequences (Havel–Hakimi) optional.

## 2. Paths and connectivity

On the first diagram: list all simple paths from $A$ to $D$. Is the graph 2-connected?

## 3. BFS layers

From $A$, write BFS layers (assume adjacency order alphabetical).

```text
  layer 0: A
  layer 1: ...
  layer 2: ...
```

## 4. Spanning trees

How many different spanning trees does a triangle $K_3$ have? What about $K_4$ (Cayley: $n^{n-2}$ labeled trees on $n$ vertices)?

## 5. Shortest paths

```text
  A--1--B--4--D
  |     |     |
  2     1     1
  |     |     |
  C--3--E--1--F
```

Run Dijkstra from $A$; report distances to all nodes.

## 6. Topological order

DAG:

```text
  1 → 3 → 5
  ↓   ↓
  2 → 4
```

List all valid topological orders.

## 7. Flow cut (conceptual)

Explain max-flow min-cut in one paragraph with a 4-edge network of your drawing.

## 8. CS mapping

Match: (a) dependency install (b) garbage collector reachability (c) routing (d) social “friend of friend”

to: BFS / DFS / topo sort / shortest path.

## Solutions sketch (spoiler zone)

1. Sum $=12$ even; e.g. cycle $C_5$ with one chord works for multiset of degrees — verify by construction.  
4. $K_3$: $3$ spanning trees (each omit one edge). $K_4$: $4^{2}=16$.  
5. Distances depend on exact edges; recompute carefully.  
6. e.g. $1,2,3,4,5$ and $1,3,2,4,5$ variants.  
8. (a) topo (b) DFS/BFS reachability (c) shortest path (d) BFS layers.

## More practice

1. Prove a tree on $n$ vertices has $n-1$ edges.  
2. Prove that if $G$ is bipartite, every cycle is even.  
3. Give an example where Dijkstra fails with a negative edge.  
4. **Project:** implement BFS and check bipartite coloring; write the invariant.
