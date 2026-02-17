# Randomized and Approximation Complexity

## 1. Randomized Algorithms

Randomness can simplify algorithms or improve expected runtime.

Key guarantees:
- expected time bounds
- bounded failure probability

## 2. Amplification

Repeat independent trials and combine outcomes (majority/verification) to reduce error exponentially.

## 3. Approximation Algorithms

For hard optimization tasks, return near-optimal solutions with provable ratio.

## 4. Example Guarantees

- 2-approximation Vertex Cover
- logarithmic Set Cover approximation

## 5. Hardness Perspective

Some approximation factors are impossible unless major complexity collapses occur.

## 6. Engineering Tradeoffs

- exact (slow but optimal)
- approximation (fast with guarantee)
- heuristic (fast, no worst-case guarantee)

## Exercises

1. Implement and test 2-approx Vertex Cover.
2. Compare exact ILP vs approximation on random graphs.
3. Estimate confidence interval of randomized algorithm success rate.
4. Explain when heuristic may still be preferred over approximation.
