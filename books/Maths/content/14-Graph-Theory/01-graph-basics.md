# Graph Basics and Representations

This chapter fixes vocabulary and data structures. Almost every later complexity claim—“$O(V+E)$,” “$O(1)$ edge query”—is really a claim about **representation**.

## 1. Formal definitions

**Undirected simple graph:** $G=(V,E)$, $E\subseteq\binom{V}{2}$.

**Directed graph:** $E\subseteq V\times V$ (loops $(v,v)$ optional by convention).

**Multigraph:** parallel edges allowed; **weighted:** $w:E\to\mathbb{R}$.

**Order** $n=|V|$, **size** $m=|E|$ (common CS notation: $n$ vertices, $m$ edges; also $V,E$ as numbers in asymptotics).

### Neighborhoods and degrees

- Undirected: $\deg(v)=|\{u:\{u,v\}\in E\}|$
- Directed: $\mathrm{indeg}(v)$, $\mathrm{outdeg}(v)$
- $N(v)$ open neighborhood; $N[v]=N(v)\cup\{v\}$ closed

### Paths and cycles

A **walk** is a sequence $v_0,e_1,v_1,\ldots,e_k,v_k$ with incident edges.  
A **path** is a walk with distinct vertices.  
A **cycle** returns to start with positive length and (usually) no repeated vertices except ends.

**Connected** (undirected): path between every pair.  
**Strongly connected** (directed): directed path $u\rightsquigarrow v$ and $v\rightsquigarrow u$ for all pairs.

### Worked example 1

$V=\{0,1,2,3\}$, undirected edges $\{0,1\},\{0,2\},\{1,3\},\{2,3\}$: a 4-cycle. Connected; every degree $2$.

## 2. Handshaking lemma

**Theorem.** In any undirected graph, $\sum_{v\in V}\deg(v)=2|E|$.

**Proof.** Each edge contributes $1$ to the degree of each endpoint, total $2$ per edge. $\blacksquare$

**Corollary.** The number of odd-degree vertices is even.

**Proof.** Sum of degrees even $\Rightarrow$ even number of odd summands. $\blacksquare$

### Worked example 2

Is there a graph with degrees $(3,3,3)$? Degree sum $9$ odd—impossible.

### Worked example 3 — directed version

$\sum_v \mathrm{indeg}(v)=\sum_v \mathrm{outdeg}(v)=|E|$.

## 3. Special families

| Family | Property |
|--------|----------|
| Path $P_n$ | $n$ verts, $n-1$ edges, connected, two degree-1 ends |
| Cycle $C_n$ | $n$ verts, $n$ edges, 2-regular connected |
| Complete $K_n$ | all $\binom{n}{2}$ edges |
| Bipartite | $V=L\cup R$, edges only between $L$ and $R$ |
| DAG | directed acyclic graph |
| Tree | connected acyclic undirected (next chapter) |

**Theorem.** $G$ bipartite $\Leftrightarrow$ no odd cycle.

**Proof sketch.** $(\Rightarrow)$ odd cycle not 2-colorable. $(\Leftarrow)$ BFS 2-color each component; monochrome edge would create odd cycle. $\blacksquare$

### Worked example 4

$C_4$ bipartite; $C_5$ not. Grid graphs bipartite; social “must have odd friendship cycle” jokes rest on this theorem.

## 4. Adjacency matrix

Order vertices $v_1,\ldots,v_n$. Matrix $A\in\{0,1\}^{n\times n}$:

$$
A_{ij}=\begin{cases}1&\{v_i,v_j\}\in E\text{ (or arc)}\\0&\text{otherwise.}\end{cases}
$$

Undirected $\Rightarrow A=A^\top$. Weighted: store weights instead of $1$.

**Costs:**

- Space $\Theta(n^2)$
- Edge query $O(1)$
- Iterate neighbors of $v$: $\Theta(n)$
- $A^k_{ij}=$ number of walks of length $k$ from $i$ to $j$ (unweighted)

### Worked example 5

For a path of 3 edges, $(A^2)_{1,3}=1$ (one walk of length 2 between ends? label carefully). Counting walks is a spectral graph theory entry point.

## 5. Adjacency lists

Array of $n$ lists: for each $v$, store neighbors (or out-neighbors).

**Costs:**

- Space $\Theta(n+m)$
- Edge query $O(\deg(v))$ (or $O(1)$ expected with hash sets)
- Iterate neighbors: $O(\deg(v))$
- Best default for **sparse** graphs $m\ll n^2$

### Worked example 6 — build from edge list

```text
function BuildAdjList(n, edges, directed):
  g ← array of n empty lists
  for (u,v) in edges:
    g[u].append(v)
    if not directed: g[v].append(u)
  return g
```

Time $\Theta(n+m)$.

## 6. Edge lists and CSR

- **Edge list:** array of pairs—simple I/O, slow queries
- **CSR (compressed sparse row):** offsets + neighbor array—cache-friendly static graphs in HPC/ML

### Worked example 7

CSR for directed graph: `offsets[i]` start of out-neighbors of $i$ in flat `heads[]` array. Matvec $x\mapsto Ax$ streams memory linearly.

## 7. Graph isomorphism (awareness)

$G\cong H$ if a bijection of vertices preserves edges. Hard in theory (GI in quasi-poly; not known NP-complete); in practice use canonical labeling tools. Do not confuse with **equality of representations**.

## 8. Traversal foundations: BFS and DFS

### BFS (queue)

From source $s$, explores by **distance layers**. Yields shortest paths in **unweighted** graphs.

**Invariant:** vertices dequeued in nondecreasing distance from $s$; first time reached, distance is final.

**Time:** $\Theta(n+m)$ adj lists.

### DFS (stack / recursion)

Explores depth-first; produces discovery/finish times; classifies edges (tree/back/forward/cross in digraphs). Foundation for topo sort, SCCs, bridge finding.

### Worked example 8 — BFS layers

On the 4-cycle from Example 1, BFS from $0$: layer0 $\{0\}$, layer1 $\{1,2\}$, layer2 $\{3\}$.

### Worked example 9 — DFS edge types (undirected)

In undirected DFS, non-tree edges are back edges to ancestors—detect cycles if you see a neighbor that is visited and not the parent.

## 9. Connectivity algorithms (basics)

**Undirected connected components:** DFS/BFS forest; each tree a component. Time $\Theta(n+m)$.

**Directed weak connectivity:** ignore directions, run undirected CC.

**Strong connectivity:** needs Kosaraju/Tarjan (later chapter).

### Worked example 10 — offline Union-Find

For undirected edges streaming, Union-Find builds components without full adj lists if only connectivity queries matter.

## 10. CS representation choices

| Workload | Prefer |
|----------|--------|
| Sparse social / web | Adj lists / CSR |
| Dense small $n$ DP on subsets | Matrix |
| Static repeated matvec | CSR |
| Dynamic insert/delete edges | Hash-set adj lists |
| GPU kernels | CSR/COO specialized |

## 11. Pitfalls

1. Off-by-one when $V=\{1..n\}$ vs $\{0..n-1\}$
2. Forgetting reverse edges in undirected build
3. Storing matrix for $n=10^6$
4. Using DFS recursion depth $n$ on huge graphs (stack overflow)—prefer explicit stack
5. Assuming simple graph when input has multis/loops
6. **Directed vs undirected** degree and path confusion

## 12. Checkpoint

- State handshaking and odd-degree corollary
- Compare matrix vs list on space and neighbor iteration
- Run BFS by hand and list distances
- Detect a cycle with DFS parent rule (undirected)
- Build adj lists from an edge list correctly

## Exercises

### Easy

1. Prove the odd-degree corollary carefully.
2. Compute $|E|$ for $K_n$ and for the complete bipartite $K_{a,b}$.
3. Draw all nonisomorphic undirected graphs on 3 vertices.
4. Give adj matrix and adj lists for a directed path $0\to1\to2\to3$.
5. Count space for lists vs matrix when $n=10^5$, $m=10^6$ (8-byte IDs).

### Medium

6. Prove that if $G$ is simple, $m\le\binom{n}{2}$. When is equality?
7. Show $A^2_{ii}=\deg(i)$ for simple undirected graphs.
8. Prove bipartite $\Leftrightarrow$ 2-colorable $\Leftrightarrow$ no odd cycle (fill details).
9. Implement (pseudocode) BFS returning `dist[]` and `parent[]`; reconstruct path.
10. Complexity of checking whether an edge exists in list vs matrix vs hash-set lists.

### Challenge

11. Prove that in a simple graph, if $\delta=\min\deg\ge 2$ then $G$ contains a cycle.
12. Give an $O(n+m)$ algorithm to recognize bipartite graphs or reject with an odd cycle.
13. Show how to detect a directed cycle using DFS colors (white/gray/black).
14. Spectral teaser: relate regular graph degree to largest eigenvalue of $A$ (state Perron–Frobenius intuition).
15. Design a memory layout for huge static undirected graphs with average degree $d=10$; justify.

## Summary

Graph vocabulary (degrees, paths, connectivity) plus representation (lists, matrices, CSR) determine what is computable efficiently. Handshaking and bipartite characterizations are first theorems; BFS/DFS are the first workhorse algorithms. Everything later—trees, shortest paths, flows—builds on these foundations.
