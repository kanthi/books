# Information Theory Applications

Entropy is not only abstract: it shows up in compression, feature selection, decision trees, language-model evaluation, privacy leakage bounds, and ML objectives. This chapter maps the definitions from earlier chapters onto engineering practice.

## Diagram: map of applications

```text
  entropy H(X)
       │
       ├── compression / coding length
       ├── decision tree split (info gain)
       ├── feature selection (mutual information)
       ├── channel capacity (noisy pipes)
       ├── LM evaluation (perplexity)
       └── ML losses (cross-entropy / KL)
```

## 1. Compression and source coding

**Shannon source coding theorem (informal):** for an i.i.d. source with entropy $H(X)$, lossless compression needs about $H(X)$ bits per symbol in the large-block limit; you cannot do better on average, and good codes approach $H(X)$.

| Source property | Compressibility |
|-----------------|-----------------|
| Low $H(X)$ | highly predictable → shorter codes |
| Max entropy (uniform) | incompressible at symbol level |
| Dependence over time | use conditional / joint coding; rate $\approx H(X_t\mid\text{past})$ |

### Practical codecs (conceptual)

- **Huffman:** optimal prefix codes for known symbol frequencies (per-symbol)  
- **Arithmetic / ANS:** approach $H$ more closely for streams  
- **LZ family:** universal; learn repeats without an explicit $P$  

### Worked example 1

Fair six-sided die: $H=\log_2 6\approx 2.585$ bits/roll. No lossless scheme averages fewer bits per independent roll in the Shannon limit.

Biased coin $P(X=1)=0.1$: $H_2(0.1)\approx 0.469$ bits — much more compressible than a fair coin.

## 2. Information gain and decision trees

Split feature $A$ to reduce uncertainty about label $Y$:

$$
\mathrm{IG}(Y,A)=H(Y)-H(Y\mid A)=I(Y;A).
$$

```text
  before split:  H(Y) large (mixed labels)
       │
       ├── A=yes  → purer → small H
       └── A=no   → purer → small H
  weighted average H(Y|A) < H(Y) ⇒ positive gain
```

**Conditional entropy after split:**

$$
H(Y\mid A)=\sum_a P(A=a)\, H(Y\mid A=a).
$$

### Worked example 2 — pure split

Binary label $50/50$, $H(Y)=1$ bit. Split yields two pure leaves: $H(Y\mid A)=0$, so $\mathrm{IG}=1$ bit.

### Practical caveats

- **Greedy** IG can miss globally optimal feature sets  
- High-arity features can look good by fragmentation (many pure tiny leaves) — use gain ratio / regularization / min leaf size  
- Continuous features need thresholds; search is part of the algorithm  

## 3. Mutual information for features and dependence

$$
I(X;Y)=H(X)-H(X\mid Y)=H(Y)-H(Y\mid X)=D_{\mathrm{KL}}(P_{X,Y}\|P_X P_Y).
$$

- $I(X;Y)=0$ iff $X\perp Y$ (discrete case under standard conditions)  
- Feature ranking: score features by $\hat I(X_j;Y)$  
- **Caution:** estimating MI in high dimension is hard (bias, curse of dimensionality); use careful estimators or proxies  

### Worked example 3 — independence

If $X\perp Y$, then $P_{X,Y}=P_X P_Y$, so $D_{\mathrm{KL}}=0$ and $I(X;Y)=0$.

### Correlation vs MI

Uncorrelated does **not** imply independent. Example: discrete $X\in\{-1,0,1\}$ symmetric, $Y=X^2$. Correlation can be zero while $I(X;Y)>0$.

## 4. Channels and capacity (systems view)

Noisy channel: input $X$, output $Y$, law $p(y\mid x)$.

**Capacity**

$$
C=\max_{p(x)} I(X;Y)
$$

is the supremum of rates (bits per channel use) for reliable communication (channel coding theorem, informal).

| Setting | Role of capacity |
|---------|------------------|
| Wireless / modem design | ultimate rate ceiling |
| FEC vs retransmission | operate below $C$ with codes |
| Disk / flash | constrained coding + ECC |

### Worked example 4 — BSC intuition

Binary symmetric channel flip probability $p$: $C=1-H_2(p)$ bits (for fair-ish optimal input). At $p=0$, $C=1$; at $p=1/2$, $C=0$.

## 5. Perplexity and language models

For a model $q$ evaluated on tokens from $p$ (or on a test corpus treated as empirical $p$):

**Cross-entropy rate** (nats or bits per token) and **perplexity**

$$
\mathrm{PPL}=2^{H(p,q)}\quad\text{(bits convention)}
$$

or $e^{H}$ in nats. Interpretation: effective branching factor — how many sides a fair die would need to match the model’s average surprise.

Lower perplexity ↔ model less surprised by the test data (better coding of the corpus), not automatically better task utility.

### Worked example 5

If average CE is $3$ bits/token, $\mathrm{PPL}=2^3=8$.

## 6. ML training objectives (recap with applications)

| Objective | Information view |
|-----------|------------------|
| Cross-entropy classification | code labels with model $q_\theta$ |
| KL to teacher (distillation) | match soft distributions |
| InfoNCE / contrastive | lower bound / proxy related to MI |
| Variational bounds | ELBO involves KL to posterior |

Training with CE is not “just a loss hack”: it is maximum likelihood under a categorical model and coding-optimal under that model class.

## 7. Decision systems and expected information

Before an experiment or A/B test, **expected information gain** about a parameter $\theta$ from observing $Y$:

$$
\mathrm{EIG}=H(\theta)-H(\theta\mid Y)=I(\theta;Y).
$$

Bayesian optimal design picks interventions maximizing EIG (or related utilities). Same math as feature selection with a different “feature.”

## 8. Privacy and leakage (conceptual)

If $S$ is a secret and $R$ is a released message (query answer, model prediction, noisy aggregate):

$$
I(S;R)
$$

measures residual dependence — a leakage metric. Perfect privacy in the MI sense would require $I(S;R)=0$ (often too strong); differential privacy uses a different, worst-case neighboring-dataset guarantee, but MI still guides intuition about how much a release can say about individuals.

## 9. Hashing, randomness, and min-entropy

**Shannon entropy** averages surprise; **min-entropy**

$$
H_{\infty}(X)=-\log\max_x P(x)
$$

captures worst-case guessability (passwords, cryptographic keys). High Shannon entropy with a heavy atom can still be weak for security. CS security prefers min-entropy and extractors.

## 10. End-to-end worked case: email spam filter features

1. Labels $Y\in\{\mathrm{spam},\mathrm{ham}\}$ with empirical $H(Y)$.  
2. For each binary feature $A_j$ (“word $w$ present”), estimate $\mathrm{IG}(Y,A_j)$.  
3. Keep top-$k$ features or use MI filter then train logistic regression.  
4. Train with CE loss; report CE and calibration on a holdout.  
5. Compression analogy: a good model assigns short codes (high probability) to true labels.

## 11. Pitfalls

1. Treating high entropy as “meaningful content”  
2. Greedy IG trees without depth/leaf constraints  
3. MI feature selection without correcting for finite-sample bias  
4. Using perplexity alone to claim product quality  
5. Ignoring that capacity is an asymptotic, ideal-code limit  
6. Confusing Shannon entropy with cryptographic strength  

## 12. Checkpoint

- State source coding lower bound $H(X)$  
- Compute information gain for a pure binary split  
- Write $I(X;Y)$ three ways  
- Define channel capacity as max MI  
- Convert CE to perplexity  
- Distinguish Shannon vs min-entropy for security  

## Exercises

### Easy

1. Binary label 50/50, split yields two pure leaves. What is IG in bits?  
2. If $X\perp Y$, what is $I(X;Y)$?  
3. Compute $H$ of a fair six-sided die in bits ($\log_2 6$).  
4. Connect cross-entropy training to “coding with model $Q$.”  
5. Perplexity if CE $=2$ bits/token?  

### Medium

6. Why is estimating $I(X;Y)$ hard for high-dimensional continuous $X$?  
7. Name one failure mode of greedy info-gain tree splits.  
8. BSC: explain why $C\to 0$ as $p\to 1/2$.  
9. Feature $A$ independent of $Y$: what is $\mathrm{IG}(Y,A)$?  
10. Password distribution with $H(X)=20$ bits but one password has probability $2^{-5}$: bound $H_{\infty}$.  

### Challenge

11. Construct (small joint table) $X,Y$ with $\mathrm{Corr}=0$ but $I(X;Y)>0$.  
12. Gain ratio: define $\mathrm{IG}(Y,A)/H(A)$ and explain the high-arity bias fix.  
13. Show that $I(X;Y)\le \min\{H(X),H(Y)\}$.  
14. Sketch how arithmetic coding achieves average length near $H$ for a known $P$.  
15. Privacy sketch: adding noise to $R$ tends to decrease $I(S;R)$; discuss utility tradeoff $I(S;\hat t(R))$ for a target statistic $t$.  

## Checks

1. $H(Y)=1$, $H(Y\mid A)=0$, IG $=1$.  
2. $0$.  
3. $\approx 2.585$ bits.  
5. $\mathrm{PPL}=4$.  

## Summary

Information measures are engineering tools: $H$ bounds compression, $I$ scores dependence and channels, CE/KL train and evaluate probabilistic models, perplexity rephrases CE for language, and min-entropy speaks to worst-case unpredictability. Use the right functional for the job, and never forget estimation and asymptotics when moving from chalkboard to production data.
