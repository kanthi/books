# Markov Chains and Stochastic Processes

Markov chains model systems whose future depends on the past only through the present state. They power PageRank, MCMC, reinforcement learning, queues, and reliability analysis.

## 1. Markov property

A stochastic process $(X_t)_{t\ge 0}$ on a countable state space $\mathcal{S}$ is a **Markov chain** if

$$
P(X_{t+1}=j\mid X_t=i,X_{t-1}=i_{t-1},\ldots)=P(X_{t+1}=j\mid X_t=i).
$$

**Time-homogeneous:** transition probabilities $P_{ij}=P(X_{t+1}=j\mid X_t=i)$ do not depend on $t$.

### Worked example 1 — weather toy

States $\{\mathrm{Sun},\mathrm{Rain}\}$ with fixed transition probabilities—classic textbook chain.

### Worked example 2 — gambler’s ruin

Fortune as state; absorb at $0$ and $N$. Markov with absorbing barriers.

## 2. Transition matrix

$P=(P_{ij})$ is **row-stochastic**: $P_{ij}\ge 0$, $\sum_j P_{ij}=1$.

**n-step transitions:** $P^{(n)}=P^n$, i.e.

$$
P(X_n=j\mid X_0=i)=(P^n)_{ij}.
$$

### Worked example 3

Two-state:

$$
P=\begin{bmatrix}0.8&0.2\\0.3&0.7\end{bmatrix}.
$$

Compute $P^2$ by matrix multiply for two-step probabilities.

## 3. Classification of states

- **Communicate:** $i\to j$ and $j\to i$ with positive probability in some steps  
- **Irreducible:** all states communicate  
- **Period** of $i$: gcd of return times; **aperiodic** if period 1  
- **Recurrent vs transient:** return with probability 1 vs $<1$  
- **Positive recurrent:** finite mean return time  

### Worked example 4

A cycle graph with deterministic rotation is periodic with period $n$. Adding self-loops typically breaks periodicity.

## 4. Stationary distribution

$\pi$ is **stationary** if $\pi^\top P=\pi^\top$ (row vector convention) and $\pi_i\ge 0$, $\sum_i\pi_i=1$. Equivalently $P^\top\pi=\pi$.

**Balance:** $\pi_j=\sum_i\pi_i P_{ij}$.

### Existence/uniqueness (finite case)

Finite irreducible chain: unique stationary $\pi$. If also aperiodic, $P(X_t=\cdot)\to\pi$ from any start (**convergence theorem**).

### Worked example 5

For the two-state $P$ above, solve $\pi P=\pi$, $\pi_1+\pi_2=1$:

$\pi=(0.6,0.4)$ (verify: long-run fraction of time in state 2 is $0.4$).

### Worked example 6 — PageRank

Google matrix is a modified stochastic matrix; PageRank is its stationary distribution (with teleportation ensuring irreducibility/primitivity).

## 5. Detailed balance and reversibility

$\pi_i P_{ij}=\pi_j P_{ji}$ for all $i,j$ $\Rightarrow$ $\pi$ stationary (sum on $i$). Chains satisfying detailed balance for some $\pi$ are **reversible**.

### Worked example 7 — MCMC design

Metropolis–Hastings builds $P$ so that a **target** $\pi$ satisfies detailed balance—sample from $\pi$ without knowing the normalizing constant.

## 6. Hitting times and absorption

$T_A=\min\{t\ge 0: X_t\in A\}$. Expected hitting times solve linear equations from first-step analysis.

### Worked example 8 — gambler’s ruin

Probability of hitting $N$ before $0$ from fortune $k$ is $k/N$ for fair game—solve recurrence $h_k=\frac12 h_{k-1}+\frac12 h_{k+1}$.

## 7. Mixing time (awareness)

How large $t$ until $\|P^t(x,\cdot)-\pi\|_{\mathrm{TV}}$ small? Determines MCMC burn-in. Can be exponential in dimension for hard targets; good chains mix rapidly.

### Worked example 9

Random walk on the hypercube mixes in $O(d\log d)$ steps—classic.

## 8. Continuous time (sketch)

Exponential holding times + jump chain: rate matrix $Q$, Kolmogorov equations. Poisson process is a counting CTMC.

### Worked example 10 — M/M/1 queue

States = number in system; birth rate $\lambda$, death rate $\mu$; stationary geometric if $\lambda<\mu$.

## 9. CS applications map

| Domain | Chain |
|--------|-------|
| Ranking | PageRank / random surfer |
| Sampling | MCMC, Gibbs |
| RL | MDP state process under policy |
| Reliability | up/down component models |
| Caches | stack distance / Markovian request models (approx) |
| NLP (classical) | n-gram as Markov of order $n-1$ |

### Worked example 11 — RL

Policy $\pi(a\mid s)$ induces Markov chain on states with $P(s'|s)=\sum_a\pi(a\mid s)P(s'|s,a)$. Value functions solve linear systems on this chain (policy evaluation).

### Worked example 12 — Gibbs sampling

Coordinate-wise conditional updates form a Markov chain on configurations with stationary equal to target joint (under mild conditions).

## 10. Pitfalls

1. Assuming convergence without irreducibility/aperiodicity  
2. Confusing time average with ensemble average without ergodicity  
3. Using reducible PageRank graph without teleports  
4. MCMC without diagnostics (still correlated samples)  
5. High-order memory forced into first-order Markov poorly  

## 11. Checkpoint

- Write Markov property and row-stochastic $P$  
- Compute $\pi$ for a small chain  
- Define irreducible / aperiodic / stationary  
- State detailed balance use in MCMC  
- Connect PageRank to $\pi P=\pi$  

## Exercises

### Easy

1. Verify rows of a given $3\times 3$ matrix are stochastic or fix them.
2. For two-state chain, find $\pi$ in closed form from $P_{01},P_{10}$.
3. Explain absorbing state: $P_{ii}=1$.
4. Simulate three steps of weather chain by hand from Sun.
5. Why teleportation helps PageRank math?

### Medium

6. Prove detailed balance $\Rightarrow$ stationarity.
7. Solve gambler’s ruin fair case for absorption probabilities.
8. Show period divides return times; give period-2 example.
9. Policy evaluation: write $V=r+P^\pi V$ linear system.
10. Compute $P^n$ for two-state via diagonalization sketch.

### Challenge

11. Metropolis–Hastings acceptance probability derivation from detailed balance.
12. Mixing: define total variation; state coupling inequality idea.
13. Ehrenfest urn model: stationary is binomial; interpret.
14. Continuous time: write $Q$ for two-state CTMC; relate stationary to rates.
15. Project: model a simple cache replacement as Markov on a small state space; estimate miss rate via $\pi$.

## Summary

Markov chains reduce temporal dependence to a transition matrix and open the door to stationary analysis, absorption probabilities, and MCMC. From PageRank to queues to reinforcement learning, the same spectral/linear-algebraic equilibrium $\pi P=\pi$ reappears as the long-run law of a system.
