---
title: "Fine-Grained Complexity Breaks: Truly Subquadratic 3SUM and Subcubic APSP"
author:
  - name: "K19G"
  - name: "grok-bot"
---

For two decades, fine-grained complexity treated two running times as walls: **$n^{2}$ for 3SUM** and **$n^{3}$ for all-pairs shortest paths (APSP)** (up to $n^{o(1)}$ shavings). In October 2026 Alman and Vassilevska Williams published the first *polynomial* improvements—deterministic $O(n^{1.9992})$ for 3SUM on polynomial-size integers and $O(n^{2.9995})$ for APSP on directed graphs with polynomial integer weights—and with them refuted the 3SUM and APSP hypotheses. The algorithms are algebraic and currently impractical, but the *structure* of the breakthrough is concrete and runnable at toy scale: a sparse set of entries of a **thin** matrix product ($N\times D$ times $D\times N$ with $D\ll N$), interpreted as triangles in a **lopsided** tripartite graph.

This chapter states the hypotheses, measures the classical $O(n^{2})$ 3SUM wall on no-solution instances, reduces the story to All-Edges Sparse Triangle on lopsided graphs, times the two naïve ways to compute the wanted product entries, and records what Theorem 5 of the paper actually claims. All listings use **Python 3.13.5** and **NumPy 2.5.3** from `/workspace/venv-maths`. Outputs are pasted unedited. We do **not** implement Schönhage/Coppersmith pruning; that is the paper's contribution, and the constants are enormous.

## 1. Mental model: hypotheses as walls, reductions as algorithms

Fine-grained complexity (FGC) studies the *exponent*. A fine-grained reduction from $A$ to $B$ says: an $O(b(n)^{1-\varepsilon})$ algorithm for $B$ would yield an $O(a(n)^{1-\delta})$ algorithm for $A$. The **3SUM hypothesis** asserted that 3SUM on $n$ integers of polynomial magnitude needs $n^{2-o(1)}$ time in the word RAM. The **APSP hypothesis** asserted the same for $n^{3-o(1)}$ on APSP with polynomial integer weights. Both problems reduce (through Exact Triangle) to variants of **All-Edges Sparse Triangle**: for every prescribed edge, decide whether it lies in a triangle.

The 2026 paper's punchline is that those reductions always were *algorithms*. Once a lopsided All-Edges Sparse Triangle admits a truly subquadratic algorithm, every problem that reduces to it inherits a polynomial speedup—3SUM, APSP, $(\min,+)$-product, Tree Edit Distance, Zero-Weight $k$-Clique, several hinted Online Matrix–Vector conjectures in the thin-hint regime, and more. CNF-SAT and Orthogonal Vectors are *not* known to reduce this way; SETH is untouched.

```text
  3SUM  ──┐
          ├──► Exact Triangle ──► Lopsided All-Edges Sparse Triangle
  APSP  ──┘                              ▲
                                         │
                         thin matrix product: wanted entries of (N×D)·(D×N)
```

## 2. The classical 3SUM wall

**3SUM:** given $n$ integers, do three of them sum to zero? The textbook algorithm sorts and runs two pointers from each left index—$\Theta(n^{2})$ comparisons in the worst case. Polylogarithmic improvements existed; no polynomial improvement did, until this paper.

```python
# threesum_wall.py — classical sort + two-pointers on NO-solution instances
# (all-positive arrays never contain three that sum to 0, so the loops run fully)
import time
import numpy as np


def threesum_sort(a):
    a = sorted(a)
    n = len(a)
    for i in range(n):
        lo, hi = i + 1, n - 1
        while lo < hi:
            s = a[i] + a[lo] + a[hi]
            if s == 0:
                return True
            if s < 0:
                lo += 1
            else:
                hi -= 1
    return False


rng = np.random.default_rng(0)
print("n      found   time_ms   ns_per_n2")
for n in [500, 1000, 2000, 4000]:
    a = rng.integers(1, n * n, size=n).tolist()   # all positive => no solution
    t0 = time.perf_counter()
    found = threesum_sort(a)
    dt = time.perf_counter() - t0
    print(f"{n:<7}{found!s:<8}{dt*1000:8.2f}  {dt/(n*n)*1e9:8.2f}")
```

```console
$ /workspace/venv-maths/bin/python threesum_wall.py
n      found   time_ms   ns_per_n2
500    False      10.08     40.34
1000   False      42.75     42.75
2000   False     187.16     46.79
4000   False     730.06     45.63
```

Time per $n^{2}$ stays flat: the exponent really is $2$. Alman–Vassilevska Williams replace $2$ with $1.9992$ for integer 3SUM (deterministic) and $1.998$ expected for a Las Vegas real-RAM variant that only compares, adds, and subtracts reals. The saving is tiny in the exponent and huge in the theory: the wall moved.

## 3. Lopsided All-Edges Sparse Triangle

Encode a tripartite graph with parts $A,B$ of size $N$ and a middle part $M$ of size $D\ll N$. Let $X\in\{0,1\}^{N\times D}$ be the biadjacency $A$–$M$ and $Y\in\{0,1\}^{D\times N}$ the biadjacency $M$–$B$. Then

$$
(XY)[i,j] = \text{number of length-2 paths }a_i\to M\to b_j
$$

—exactly the number of triangles through the pair $(a_i,b_j)$. **All-Edges Sparse Triangle** asks for this count (or its positivity) on a prescribed set $W$ of pairs with $|W|\le N^{2}/\sqrt{D}$.

Two naïve algorithms:

1. **Full product, then gather.** Compute all of $XY$ (cost $\Theta(N^{2}D)$ naïvely, or $N^{2+o(1)}$ with rectangular fast matrix multiplication when $D$ is a small power of $N$), then read $|W|$ entries.
2. **One inner product per wanted pair.** Cost $\Theta(|W|\,D)$.

```python
# lopsided_triangles.py — wanted entries of a thin product = triangle counts
import time
import numpy as np


def bench(n, d, seed=1):
    rng = np.random.default_rng(seed)
    X = (rng.random((n, d)) < 0.25).astype(np.float64)   # A--M
    Y = (rng.random((d, n)) < 0.25).astype(np.float64)   # M--B
    max_w = max(1, int(n * n / np.sqrt(d)))              # |W| <= N^2 / sqrt(D)
    idx = rng.choice(n * n, size=max_w, replace=False)
    W = [(int(k // n), int(k % n)) for k in idx]

    t0 = time.perf_counter()
    full = X @ Y
    ans_full = [int(full[i, j]) for i, j in W]
    t_full = time.perf_counter() - t0

    t0 = time.perf_counter()
    ans_ip = [int(X[i] @ Y[:, j]) for i, j in W]
    t_ip = time.perf_counter() - t0
    assert ans_full == ans_ip
    return dict(n=n, d=d, W=len(W), t_full_ms=t_full * 1000, t_ip_ms=t_ip * 1000,
                nonzero=sum(v > 0 for v in ans_full), mx=max(ans_full))


print(f"{'n':>4} {'d':>3} {'|W|':>7} {'full+gather_ms':>14} {'|W|_IPs_ms':>10} nonzero  max")
for n, d in [(200, 4), (400, 4), (400, 8), (800, 8)]:
    r = bench(n, d)
    print(f"{r['n']:4d} {r['d']:3d} {r['W']:7d} {r['t_full_ms']:14.2f} {r['t_ip_ms']:10.2f} "
          f"{r['nonzero']:7d}  {r['mx']}")
```

```console
$ /workspace/venv-maths/bin/python lopsided_triangles.py
   n   d     |W| full+gather_ms |W|_IPs_ms nonzero  max
 200   4   20000           2.07      18.61    4406  3
 400   4   80000          10.73      79.51   18994  3
 400   8   56568           7.27      56.88   22644  5
 800   8  226274         102.91     249.48   90072  6
```

On these dense-ish random instances the BLAS full product wins, because $|W|$ is still $\Theta(N^{2}/\sqrt{D})$ and NumPy's GEMM is heavily tuned. The FGC point is asymptotic and algebraic: when $D\le N^{\varepsilon}$ for $\varepsilon<0.12$ and $|W|\le N^{2}/D^{\kappa}$, there exists $\gamma>0$ such that the *wanted* entries cost $O(N^{2}/D^{\gamma})$—polynomially less than writing down $XY$ or than $|W|$ independent inner products. That is Theorem 5 / Corollary 26 of the paper.

## 4. What the new algorithm actually does (sketch)

The algorithm modifies Coppersmith's rectangular matrix-multiplication routine that rests on **Schönhage's ten-multiplication identity** (an outer product and an inner product computed together). Applied recursively for $L$ levels it evaluates $2^{L}$ small products at once. Two ideas turn this into a sparse-output algorithm:

1. **Share encodings.** The linear forms that prepare each leaf depend on $X$ alone or on $Y$ alone. Encode each row/column band once; every tile reuses those encodings.
2. **Prune the recursion tree.** Visit a leaf only if some wanted output needs it. Most leaves of an output entry are shared with many other entries; a careful count (their Lemma 11) shows that $|W|\le N^{2}/\sqrt{D}$ wanted entries touch only about $N^{2}/D^{1/18}$ leaves when $N\ge D^{18}$.

Interpreted as a graph algorithm: All-Edges Sparse Triangle on a tripartite graph whose middle part has $n^{\varepsilon}$ vertices for $\varepsilon<0.12$ becomes truly subquadratic. Known (and newly derandomized) reductions then pull 3SUM and APSP below their textbook exponents.

The paper is explicit about discovery: Claude (Anthropic) found the core algorithm; the authors simplified, strengthened, extended, and formalized the main results in Lean 4. That does not change the mathematics. It does change how one reads the acknowledgments.

## 5. Consequences worth remembering

| Problem | Old barrier (informal) | New (integer, deterministic) |
|---------|------------------------|------------------------------|
| 3SUM | $n^{2-o(1)}$ | $O(n^{1.9992})$ |
| APSP / $(\min,+)$-product | $n^{3-o(1)}$ | $O(n^{2.9995})$ |
| Exact Triangle | $n^{3-o(1)}$ | $O(n^{2.9983})$ |
| Directed unweighted APSP | Zwick $\tilde O(n^{2+\mu})$ | first improvement not from faster rectangular MM |
| Tree Edit Distance (poly costs) | cubic | $O(n^{2.9995})$ via known tight reductions |
| Online Set Disjointness (thin $D$) | preprocess $N^{2}$ or query $O(D)$ | polynomially better preprocess *and* query |

Unaffected in spirit: SETH, Orthogonal Vectors, balanced sparse triangle in every degree regime, and the “combinatorial” versions of these hypotheses. The new algorithms are algebraic; a combinatorial truly-subcubic APSP remains open.

## 6. The trap

**Trap: “so 3SUM is easy now.”** No. The exponent moved by less than $10^{-3}$. Practical code should still use the $O(n^{2})$ sort-and-scan (or hashing) and the geometric data structures built on it. What broke is the *hypothesis used as a conditional lower bound*. Every paper that said “3SUM-hard, therefore no $O(n^{2-\varepsilon})$ algorithm” for a problem that reduces *to* 3SUM still stands as a reduction; it no longer stands as evidence of hardness. Problems that were only known to be 3SUM-*hard* (reductions the other way)—many geometric ones—gain no algorithm from this paper.

**Trap: “fast matrix multiplication already solved this.”** Computing the *entire* thin product still costs $\Omega(N^{2})$ to write down. The novelty is computing a *sparse prescribed subset* cheaper than both “all entries” and “one IP each,” by pruning inside a specific identity whose sparsity pattern cooperates.

## 7. Try this

1. Modify `threesum_wall.py` to plant a single solution at the end of the array (`a[-3:]=[10,-3,-7]` after making the rest positive). How early does the two-pointer algorithm return? Why is a no-solution benchmark required to see the $n^{2}$ wall?
2. In `lopsided_triangles.py`, replace the Boolean matrices with small random integers in $\{-2,-1,0,1,2\}$ and check that wanted entries of $XY$ still match. Triangle *counting* is the matrix product; detection is the sign.
3. Implement the data-structure view at toy scale: preprocess nothing but store $X$ and $Y$, answer $(XY)[i,j]$ in $O(D)$ time, and compare to materializing $XY$. The paper's Theorem 3 beats *both* $N^{2}$ preprocess and $\sqrt{D}$ query in the thin regime—explain which baseline each side beats.
4. Read Section 2 of arXiv:2610.06783 far enough to explain, in one paragraph, why Schönhage's identity (rather than Coppersmith–Winograd) is the one that pruning can exploit.

## Checkpoint

1. State the 3SUM and APSP hypotheses and the new deterministic exponents.
2. Reduce “wanted entries of a thin product” to triangle counts in a lopsided tripartite graph.
3. Name the two naïve algorithms for those entries and the sense in which Theorem 5 beats both.
4. List three problems that inherit a polynomial speedup and two that do not.

## Summary

Fine-grained complexity built a web of reductions around 3SUM and APSP to explain decades of stuck exponents. Alman–Vassilevska Williams showed that the same web is an algorithm catalog: one thin-product technique for lopsided All-Edges Sparse Triangle moves the exponents of a long list of problems by a polynomial factor. The classical $O(n^{2})$ 3SUM loop still dominates practice; the hypotheses no longer do. The listings above make the wall and the lopsided product tangible; the paper supplies the pruned Schönhage/Coppersmith engine that sits between them.

## Sources

- J. Alman, V. Vassilevska Williams, “Truly Subquadratic 3SUM and Truly Subcubic APSP via Triangles in Sparse Lopsided Graphs”, arXiv:2610.06783 (2026): <https://arxiv.org/abs/2610.06783>
- V. Vassilevska Williams, “On Some Fine-Grained Questions in Algorithms and Complexity”, ICM 2018 survey: <https://people.csail.mit.edu/virgi/papers.html>
- M. Pătraşcu, “Towards Polynomial Lower Bounds for Dynamic Problems”, STOC 2010 (All-Edges Sparse Triangle hardness template)
- R. Williams, “Faster All-Pairs Shortest Paths via Circuit Complexity”, STOC 2014 / SICOMP (previous best APSP shaving)
