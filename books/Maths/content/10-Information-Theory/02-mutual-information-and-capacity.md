# Mutual Information and Channel Capacity

Mutual information measures **shared information** between random variables: how much knowing one reduces uncertainty about the other. Channel capacity is mutual information optimized over input distributions—the fundamental rate limit for reliable communication. Together they connect statistics, coding, machine learning, and systems design.

## 1. Conditional entropy

Let $X,Y$ be discrete random variables with joint pmf $p(x,y)$.

**Definition (conditional entropy).**

$$
H(X \mid Y) = \sum_y p(y)\, H(X \mid Y=y) = -\sum_{x,y} p(x,y)\log p(x \mid y).
$$

Interpretation: average remaining uncertainty about $X$ after observing $Y$.

**Chain rule for entropy.**

$$
H(X,Y) = H(X) + H(Y \mid X) = H(Y) + H(X \mid Y).
$$

### Worked example 1

$X$ fair bit, $Y=X$ with probability $1$ (noiseless copy). Then $H(X \mid Y)=0$ and $H(X,Y)=H(X)=1$.

### Worked example 2

$X$ fair bit, $Y$ independent fair bit. Then $H(X \mid Y)=H(X)=1$ and $H(X,Y)=2$.

## 2. Mutual information: definitions

**Definition (mutual information).**

$$
I(X;Y) = H(X) - H(X \mid Y) = H(Y) - H(Y \mid X).
$$

Equivalent forms:

$$
I(X;Y) = H(X) + H(Y) - H(X,Y),
$$

$$
I(X;Y) = \sum_{x,y} p(x,y)\log \frac{p(x,y)}{p(x)p(y)} = D_{\mathrm{KL}}\!\big(p(x,y)\,\|\,p(x)p(y)\big).
$$

So MI is the KL divergence between the joint and the product of marginals—a pure measure of **dependence**.

### Units

With $\log_2$, $I(X;Y)$ is in **bits**. With $\ln$, **nats**.

## 3. Fundamental properties

**Theorem (nonnegativity).** $I(X;Y) \ge 0$, with equality iff $X \perp Y$ (independence).

**Proof sketch.** KL divergence is nonnegative (Gibbs / log-sum inequality / Jensen on $-\log$). Equality in KL holds iff the two distributions are identical, i.e. $p(x,y)=p(x)p(y)$ for all $x,y$.

**Symmetry.** $I(X;Y)=I(Y;X)$.

**Bounds.**

$$
0 \le I(X;Y) \le \min\{H(X), H(Y)\}.
$$

Indeed $I(X;Y)=H(X)-H(X\mid Y)\le H(X)$ because conditional entropy is nonnegative for discrete variables.

**Self-information identity.** $I(X;X)=H(X)$.

### Worked example 3 — $2\times 2$ joint

Joint table:

| | $Y=0$ | $Y=1$ |
|---|------:|------:|
| $X=0$ | $1/2$ | $0$ |
| $X=1$ | $1/4$ | $1/4$ |

Marginals: $p_X(0)=1/2$, $p_X(1)=1/2$; $p_Y(0)=3/4$, $p_Y(1)=1/4$.

Compute $H(X)=1$, $H(Y)=H_2(3/4)\approx 0.811$, and

$$
H(X,Y) = -\Big(\tfrac12\log\tfrac12 + \tfrac14\log\tfrac14 + \tfrac14\log\tfrac14\Big) = 1.5.
$$

Then $I(X;Y)=H(X)+H(Y)-H(X,Y)\approx 1+0.811-1.5=0.311$ bits.

### Worked example 4 — independence implies zero MI

If $p(x,y)=p(x)p(y)$, each term $\log\frac{p(x,y)}{p(x)p(y)}=\log 1=0$, so $I(X;Y)=0$.

### Worked example 5 — deterministic function

If $Y=g(X)$ deterministic, then $H(Y\mid X)=0$, so $I(X;Y)=H(Y)$. Observing $X$ reveals $Y$ completely; MI equals the entropy of the function's output distribution.

## 4. Conditional mutual information and chain rules

**Definition.**

$$
I(X;Y \mid Z) = H(X \mid Z) - H(X \mid Y,Z).
$$

**Chain rule for mutual information.**

$$
I(X_1,\ldots,X_n; Y) = \sum_{i=1}^n I(X_i; Y \mid X_1,\ldots,X_{i-1}).
$$

This is the information-theoretic backbone of sequential feature scoring and of many proofs about multipartite systems.

## 5. Data processing inequality (DPI)

**Definition (Markov chain).** $X \to Y \to Z$ means $p(x,y,z)=p(x)p(y\mid x)p(z\mid y)$, i.e. $X \perp Z \mid Y$.

**Theorem (data processing inequality).** If $X \to Y \to Z$, then

$$
I(X;Z) \le I(X;Y).
$$

**Proof sketch.** Expand $I(X;Y,Z)=I(X;Z)+I(X;Y\mid Z)=I(X;Y)+I(X;Z\mid Y)$. Markovity implies $I(X;Z\mid Y)=0$, and $I(X;Y\mid Z)\ge 0$, so $I(X;Z)\le I(X;Y)$.

**Interpretation:** no post-processing of $Y$ can create new information about $X$. Filtering, quantization, and learned encoders can only **destroy or preserve** (not invent) mutual information with the original source.

### Worked example 6 — ML pipeline

Let $X$ be raw features, $Y=\mathrm{PCA}(X)$ a linear projection, $Z=\mathrm{ReLU}(WY)$ a neural transform of $Y$. Then $X\to Y\to Z$, so $I(X;Z)\le I(X;Y)\le H(X)$. Feature engineering cannot magically increase total information about $X$; it can only reallocate what is useful for a **task label** $T$ (where $I(T;Z)$ may rise even as $I(X;Z)$ falls—task-relevant compression).

## 6. Channels and capacity

**Definition (discrete memoryless channel, DMC).** A channel is a conditional pmf $p(y\mid x)$ used independently each time: for input sequence $x^n$,

$$
p(y^n\mid x^n)=\prod_{i=1}^n p(y_i\mid x_i).
$$

**Definition (channel capacity).**

$$
C = \max_{p(x)} I(X;Y),
$$

where the joint is $p(x)p(y\mid x)$ and the max is over input distributions on the finite alphabet $\mathcal{X}$.

**Operational meaning (Shannon's channel coding theorem, informal).**

- Rates $R < C$: there exist codes with block length $n\to\infty$ and error probability $\to 0$.
- Rates $R > C$: error probability is bounded away from 0 for any code.

Capacity is not “what your current protocol achieves”; it is an **ultimate limit**.

## 7. Binary symmetric channel (BSC)

**Model.** Input bit $X\in\{0,1\}$. Output $Y=X$ with probability $1-p$, flipped with probability $p$ (crossover probability).

**Binary entropy.** $H_2(p)=-p\log_2 p-(1-p)\log_2(1-p)$.

**Theorem (BSC capacity).**

$$
C_{\mathrm{BSC}}(p) = 1 - H_2(p)\quad\text{(bits per channel use)}.
$$

**Derivation sketch.** For any input with $P(X=1)=\pi$,

$$
H(Y\mid X)=H_2(p)
$$

(independent of $\pi$: noise is symmetric). Then $I(X;Y)=H(Y)-H_2(p)$. $H(Y)$ is maximized at $1$ bit when $Y$ is fair, achieved at $\pi=1/2$. Hence $C=1-H_2(p)$.

### Worked example 7

| $p$ | $H_2(p)$ | $C=1-H_2(p)$ |
|----:|---------:|-------------:|
| $0$ | $0$ | $1$ |
| $0.11$ | $\approx 0.5$ | $\approx 0.5$ |
| $0.5$ | $1$ | $0$ |

At $p=1/2$, the channel output is independent of the input: capacity is zero—you cannot communicate reliably at any positive rate.

### Worked example 8 — Z-channel intuition (contrast)

A Z-channel flips $0\to 1$ never, but $1\to 0$ with probability $p$. Capacity is **not** $1-H_2(p)$; asymmetry changes the optimizing input distribution. (Computing it is a good exercise in maximizing $I(X;Y)$ numerically over $\pi$.)

## 8. Fano's inequality (why MI controls prediction)

**Theorem (Fano, informal).** If $\hat{X}=g(Y)$ estimates discrete $X$ with error probability $P_e=P(\hat{X}\neq X)$, then

$$
H(X \mid Y) \le H_2(P_e) + P_e\log(|\mathcal{X}|-1).
$$

Thus small $H(X\mid Y)$ (large $I(X;Y)$ relative to $H(X)$) is **necessary** for accurate recovery. This underpins converse theorems in communication and lower bounds in statistical learning.

## 9. CS and ML applications

### Feature selection

Score feature $X_j$ by $I(X_j; T)$ with target $T$. Prefer conditional MI $I(X_j; T \mid S)$ when set $S$ of features is already chosen (reduces redundancy).

### Representation learning

Many objectives maximize a lower bound on $I(Z; T)$ or $I(Z; X^+)$ (positive pairs) while compressing $I(Z; X)$ (information bottleneck). Contrastive losses (InfoNCE) are MI lower bounds under specific critic models.

### Privacy leakage

If secret $S$ and released data $R$ satisfy $I(S;R)\approx 0$, release reveals little about $S$ in the Shannon sense. (Note: cryptographic / differential privacy notions are stronger or different; MI is one leakage metric, not the only one.)

### Compression with side information

Slepian–Wolf coding: separate encoders for $X$ and $Y$ can still achieve joint rates near $H(X,Y)$ when decoding is joint—powered by conditional entropy and MI structure.

### Protocol and systems design

- FEC rate selection relative to estimated channel statistics
- Quantizer design: trade $I(X;\hat{X})$ vs bitrate
- Caching and prefetch: predictive value as reduction in entropy of next request

### Worked example 9 — information gain in trees

Split feature reduces class entropy: information gain $\mathrm{IG}=H(T)-H(T\mid X_j)$, which equals $I(T;X_j)$ for discrete features/labels. Decision trees greedily maximize MI with the label at each step (locally, not globally optimally).

### Worked example 10 — capacity vs SNR mindset

On a BSC, improving hardware to reduce $p$ from $0.1$ to $0.01$ raises capacity from $1-H_2(0.1)\approx 0.531$ to $1-H_2(0.01)\approx 0.919$ bits/use. That is a systems ROI argument phrased in nats/bits, not only “lower BER.”

## 10. Continuous caveat (differential MI)

For continuous variables, **differential entropy** $h(X)=-\int f\log f$ can be negative, but mutual information

$$
I(X;Y)=\int\int f(x,y)\log\frac{f(x,y)}{f(x)f(y)}\,dx\,dy
$$

remains nonnegative when defined. Still: estimation of continuous MI from samples is statistically delicate in high dimension.

## 11. Pitfalls

1. **Correlation vs MI.** Uncorrelated does not imply $I=0$ (nonlinear dependence).
2. **DPI direction.** Processing $Y$ cannot increase $I(X;\cdot)$; but processing can increase $I(T;\cdot)$ for a **different** target $T$ if you discard nuisance parts of $X$.
3. **Capacity is asymptotic.** Finite-blocklength codes need backoff from $C$; random coding bounds quantify the gap.
4. **Plug-in MI estimates** on continuous or high-cardinality discrete data are badly biased without binning / kNN / variational methods.
5. **Confusing $I(X;Y)$ with causation.** MI is symmetric and associational.
6. **Using $H(Y\mid X)=0$ for continuous equality.** Continuous “$Y=X$” needs care with densities.

## 12. Checkpoint

Before moving on, verify you can:

- Write three equivalent definitions of $I(X;Y)$
- Prove nonnegativity via KL (sketch)
- Apply the chain rule and DPI on a Markov chain
- Derive BSC capacity $1-H_2(p)$
- Connect MI to feature selection, tree splits, and channel limits

## Exercises

### Easy

1. Prove $I(X;Y)=H(X)+H(Y)-H(X,Y)$ from the definition $I=H(X)-H(X\mid Y)$.
2. Compute $I(X;Y)$ for the joint $p(0,0)=p(1,1)=1/2$ (perfect coupling of fair bits).
3. Show that if $X\perp Y$ then $I(X;Y)=0$ by direct substitution.
4. For BSC($p$), verify $H(Y\mid X)=H_2(p)$ for any input distribution.
5. Plot or tabulate $C_{\mathrm{BSC}}(p)$ for $p\in\{0,0.05,0.1,0.2,0.5\}$.

### Medium

6. For a fair bit $X$ and $Y=X\oplus Z$ with $Z\sim\mathrm{Bern}(p)$ independent, show $I(X;Y)=1-H_2(p)$.
7. Prove $I(X;Y)\le H(X)$ and interpret equality cases.
8. Let $X\to Y\to Z$. Prove $I(X;Y,Z)=I(X;Y)$.
9. Construct a pair $(X,Y)$ with $\mathrm{Corr}(X,Y)=0$ but $I(X;Y)>0$ (e.g. $Y=X^2$ with symmetric discrete $X$).
10. Explain why greedy information-gain tree learning can miss globally optimal feature sets (give a conceptual counterexample).

### Challenge

11. Numerically maximize $I(X;Y)$ over $\pi=P(X=1)$ for a Z-channel with flip probability $p=0.2$ on the $1\to 0$ transition; compare to BSC$(0.2)$.
12. Using Fano's inequality, argue that if $I(X;Y)$ is much smaller than $H(X)$, no decoder $\hat{X}(Y)$ can have tiny error probability when $|\mathcal{X}|$ is large.
13. Prove the chain rule $I(X_1,X_2;Y)=I(X_1;Y)+I(X_2;Y\mid X_1)$.
14. **Privacy sketch:** A mechanism releases $R=X+N$ with noise $N$. Discuss qualitatively how increasing noise variance affects $I(X;R)$ and utility $I(X;\hat{t}(R))$ for a target statistic $t$.
15. Read off DPI for the pipeline $X\to\mathrm{encode}\to\mathrm{channel}\to\mathrm{decode}\to\hat{X}$ and state the inequality chain for $I(X;\hat{X})$.

## Summary

Mutual information is entropy reduction and KL dependence in one package. Capacity is MI optimized over channel inputs—the sharp dividing line between reliable and impossible communication rates. The same mathematics scores features, justifies compression with side information, and constrains what any neural encoder can extract under Markov processing.
