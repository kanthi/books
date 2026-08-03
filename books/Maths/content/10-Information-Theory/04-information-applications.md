# Information Theory Applications

Entropy is not only abstract: it shows up in compression, feature selection, decision trees, and ML objectives.

## Diagram: map of applications

```text
  entropy H(X)
       │
       ├── compression / coding length
       ├── decision tree split (info gain)
       ├── feature selection (mutual information)
       ├── channel capacity (noisy pipes)
       └── ML losses (cross-entropy / KL)
```

## 1. Compression

Average code length $\ge H(X)$ bits/symbol (Shannon source coding).  
Compressibility ↔ low entropy (predictable structure).

## 2. Information gain (decision trees)

Split feature $A$ reducing uncertainty about label $Y$:

$$
\mathrm{IG}(Y,A)=H(Y)-H(Y\mid A).
$$

```text
  before split:  H(Y) large (mixed labels)
       │
       ├── A=yes  → purer → small H
       └── A=no   → purer → small H
  weighted average H(Y|A) < H(Y) ⇒ positive gain
```

## 3. Mutual information

$$
I(X;Y)=H(X)-H(X\mid Y)=D_{\mathrm{KL}}(P_{X,Y}\|P_X P_Y).
$$

Zero iff independent. Used as a dependence score (careful with estimation in high $d$).

## 4. Channels (conceptual)

Noisy channel: input $X$, output $Y$.  
**Capacity** $C=\max_{p(x)} I(X;Y)$ — ultimate reliable communication rate.

## 5. Perplexity (language models)

For a distribution over tokens, perplexity is $2^{H}$ (or $e^{H}$ in nats) — effective branching factor. Lower perplexity ↔ model less “surprised.”

## Exercises

1. Binary label 50/50, split yields two pure leaves. What is IG in bits?  
2. If $X\perp Y$, what is $I(X;Y)$?  
3. Why is estimating $I(X;Y)$ hard for high-dimensional continuous $X$?  
4. Connect cross-entropy training to “coding with model $Q$.”  
5. Name one failure mode of greedy info-gain tree splits.  
6. **Compute** $H$ of fair six-sided die in bits ($\log_2 6$).

## Checks

1. $H(Y)=1$, $H(Y|A)=0$, IG $=1$.  
2. $0$.  
6. $\approx 2.585$ bits.
