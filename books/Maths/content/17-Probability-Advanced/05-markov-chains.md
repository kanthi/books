# Markov Chains and Stochastic Processes

## 1. Markov Property

`P(X_{t+1}=j | X_t=i, X_{t-1},...) = P(X_{t+1}=j | X_t=i)`.

Future depends on present state only.

## 2. Transition Matrix

Matrix `P` with entries `P_ij` where rows sum to 1.

n-step transition probabilities are entries of `P^n`.

## 3. State Class Concepts

- communicating states
- irreducible chain
- periodic/aperiodic
- transient vs recurrent states

## 4. Stationary Distribution

`pi` stationary if `pi P = pi` and `sum pi_i = 1`.

For irreducible aperiodic finite chains, distribution converges to `pi` regardless of initial state.

## 5. Detailed Balance (Reversible Chains)

Condition:
`pi_i P_ij = pi_j P_ji`.

Useful in MCMC construction.

## 6. Worked Example

Two-state weather chain:

```
P = [[0.8, 0.2],
     [0.3, 0.7]]
```

Solve `pi = pi P` -> `pi = [0.6, 0.4]`.
Long-run rainy probability is 0.4.

## 7. CS Applications

- PageRank
- queueing and caching models
- hidden Markov models
- reinforcement learning transition dynamics

## Exercises

1. Compute `P^3` for a 2-state chain and interpret.
2. Find stationary distribution of a 3-state chain.
3. Give example of periodic chain and explain non-convergence behavior.
4. Show irreducibility for a fully connected graph random walk.
