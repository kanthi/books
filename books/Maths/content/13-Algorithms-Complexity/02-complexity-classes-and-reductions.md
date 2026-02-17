# Complexity Classes and Reductions

## 1. Core Classes

- `P`: deterministic polynomial-time solvable
- `NP`: polynomial-time verifiable certificates
- `coNP`: complements of NP languages
- `PSPACE`: polynomial-space solvable

Containments:
`P subseteq NP subseteq PSPACE`.

## 2. Reductions

Polynomial reduction `A <=p B` preserves yes/no structure via polynomial-time mapping.

Use reductions to transfer hardness.

## 3. NP-Completeness Method

1. show target in NP
2. reduce known NP-complete source to target
3. prove iff correctness

## 4. Worked Reduction Sketch

VERTEX-COVER to CLIQUE via complement graph relationship in decision form.

## 5. Proof Hygiene Checklist

- direction of reduction correct
- runtime explicitly polynomial
- mapping correctness both directions
- edge-case handling

## Exercises

1. Write formal reduction definition in language terms.
2. Show SAT to 3-SAT transformation intuition.
3. Identify reduction direction error in a flawed proof and fix it.
4. Convert optimization problem to equivalent decision variant.
