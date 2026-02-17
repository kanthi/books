# Reductions and NP-Completeness

## 1. Decision Problems and Languages

A decision problem asks YES/NO.
Complexity classes are usually defined over languages (sets of YES instances).

## 2. Class Definitions (Core)

- `P`: solvable in polynomial time on deterministic TM
- `NP`: YES certificates verifiable in polynomial time

Open question: `P ?= NP`.

## 3. Polynomial-Time Reduction

`A <=p B` means there exists polynomial-time computable function `f` such that:

`x in A  <=> f(x) in B`.

If `A <=p B` and `B in P`, then `A in P`.

## 4. NP-Hard and NP-Complete

- NP-hard: at least as hard as every NP problem
- NP-complete: NP-hard and in NP

## 5. NP-Completeness Proof Template

To prove `X` NP-complete:
1. Show `X in NP` (polynomial verifier)
2. Choose known NP-complete `Y`
3. Construct polynomial reduction `Y <=p X`
4. Prove correctness of reduction (iff mapping)

## 6. Example Sketch: 3-SAT -> CLIQUE

Build graph with literal-vertices by clause positions.
Connect non-conflicting literals across clauses.
`k`-clique corresponds to consistent satisfying assignment.

## 7. Theorem (Cook-Levin, high-level)

SAT is NP-complete.

Consequence: proving SAT in P implies `P=NP`.

## 8. Common Pitfalls

- reducing wrong direction
- failing iff correctness proof
- hidden super-polynomial mapping
- mixing optimization and decision forms without formal conversion

## Exercises

1. Prove Vertex-Cover decision is in NP.
2. Show direction correctness for reduction from CLIQUE to VC.
3. Convert optimization TSP to decision TSP formally.
4. Write full reduction proof outline for SUBSET-SUM from PARTITION.
