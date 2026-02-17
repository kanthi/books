# Mutual Information and Channel Capacity

## 1. Mutual Information

`I(X;Y) = H(X) - H(X|Y) = H(Y) - H(Y|X)`.

Equivalent form:
`I(X;Y)=sum_{x,y} p(x,y) log( p(x,y)/(p(x)p(y)) )`.

## 2. Properties

- Nonnegative
- Symmetric
- Zero iff independent
- Upper bounded by `min(H(X),H(Y))`

## 3. Data Processing Inequality

If `X -> Y -> Z` is Markov chain, then:

`I(X;Z) <= I(X;Y)`.

Interpretation: processing cannot create information about original source.

## 4. Channel Capacity

Capacity of channel `p(y|x)`:

`C = max_{p(x)} I(X;Y)`.

It is the highest reliable communication rate (bits/use).

## 5. Binary Symmetric Channel Sketch

Bit flips with probability `p`.
Capacity:
`C = 1 - H_2(p)` where `H_2` is binary entropy.

## 6. CS/ML Applications

- feature selection via MI
- representation learning objectives
- communication protocol efficiency
- privacy leakage analysis

## Exercises

1. Compute MI for simple 2x2 joint distribution.
2. Show MI is zero under independence.
3. Explain data processing inequality with an ML preprocessing pipeline.
4. Plot BSC capacity vs error probability p.
