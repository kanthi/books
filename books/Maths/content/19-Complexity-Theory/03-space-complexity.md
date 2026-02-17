# Space Complexity and Computation Models

## 1. Space Complexity Basics

Space complexity counts memory used as function of input size.
Includes work tape memory (not read-only input tape).

## 2. Space Classes

- `L`: deterministic log-space
- `NL`: nondeterministic log-space
- `PSPACE`: polynomial-space

Known containments:
`L subseteq NL subseteq P subseteq NP subseteq PSPACE`.

## 3. Savitch's Theorem (High-Level)

`NSPACE(s(n)) subseteq DSPACE(s(n)^2)` for `s(n) >= log n`.
Corollary: `PSPACE = NPSPACE`.

## 4. Completeness Examples

- ST-CONNECTIVITY is NL-complete
- TQBF is PSPACE-complete

## 5. Time-Space Tradeoffs

Some tasks can trade extra time for less space and vice versa.
Critical for streaming algorithms and embedded systems.

## 6. Streaming and Sketching Lens

Space-limited algorithms keep compressed summaries, not full data.

Examples:
- count-min sketch
- HyperLogLog
- reservoir sampling

## 7. Practical Engineering Impact

- Memory bandwidth often bottleneck
- External-memory algorithms dominate for very large datasets
- Cache-aware designs outperform asymptotically similar alternatives

## Exercises

1. Show DFS can solve undirected connectivity in `O(V)` space.
2. Explain why storing full graph may be impossible in streaming setting.
3. Read and summarize intuition behind Savitch recursion.
4. Compare time-space tradeoff for dynamic programming vs memoized recursion.
