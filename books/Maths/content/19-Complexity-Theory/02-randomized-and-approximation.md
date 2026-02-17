# Randomized and Approximation Complexity

## 1. Randomized Computation

Randomized algorithms use random bits during execution.

Classes (informal):
- RP: one-sided error for YES instances
- coRP: one-sided error for NO instances
- BPP: bounded two-sided error

## 2. Error Reduction

Repeated independent runs and majority vote reduce failure probability exponentially.

## 3. Approximation Algorithms

For NP-hard optimization, target near-optimal solutions with proven ratio.

If algorithm returns `A(I)` and optimum `OPT(I)`:
- minimization: `A(I) <= alpha * OPT(I)`
- maximization: `A(I) >= OPT(I)/alpha`

## 4. Classical Examples

- 2-approximation for Vertex Cover
- `O(log n)` approximation for Set Cover
- metric TSP approximations via MST-based ideas

## 5. Inapproximability

Some problems have hardness-of-approximation bounds unless `P=NP`.

## 6. Practical Strategy

When exact is infeasible:
1. try approximation with guarantee,
2. if unavailable, use heuristic and benchmark rigorously,
3. combine randomized methods for scalable performance.

## 7. Worked Example (Vertex Cover)

Take any uncovered edge `(u,v)`, include both endpoints, remove incident edges.
Result is at most 2x optimum (edge disjoint argument).

## Exercises

1. Prove 2-approximation guarantee for edge-picking VC algorithm.
2. Implement randomized quickselect and measure variance in runtime.
3. Compare exact vs approximation on increasing graph sizes.
4. Explain how confidence intervals can evaluate randomized algorithms.
