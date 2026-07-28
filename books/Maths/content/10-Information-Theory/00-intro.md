# Information Theory for Computer Science

Information theory quantifies **uncertainty**, **information**, and **communication limits**. Claude Shannon's 1948 framework answers questions that still drive systems design: How many bits do you need to store a source? How fast can you send data reliably over a noisy channel? How much does one random variable tell you about another?

This section is mathematical, but every definition maps to engineering practice: compression codecs, error-correcting codes, ML loss functions, feature selection, and privacy leakage analysis.

## What “information” means here

Everyday language treats “information” as content or meaning. Shannon information is **not** about semantics. It is about **surprise under a probability model**.

- A fair coin flip carries 1 bit of self-information per outcome.
- A nearly deterministic event carries almost 0 bits: you already expected it.
- A rare event carries many bits: learning that it occurred is highly informative.

Formally, if an event $A$ has probability $p(A) > 0$, its **self-information** (in bits) is

$$
I(A) = -\log_2 p(A).
$$

Entropy, mutual information, and channel capacity are built from this atomic idea by averaging, conditioning, and optimizing.

## The three core problems

Shannon's theory organizes around three canonical problems.

### 1. Source coding (compression)

Given a random source $X$ producing symbols with distribution $p_X$, how many bits per symbol are needed on average for lossless encoding?

**Answer (source coding theorem, informal):** You need about $H(X)$ bits per symbol, where $H(X)$ is the Shannon entropy. You cannot do better (in the large-block limit), and good codes approach $H(X)$.

### 2. Channel coding (reliable communication)

Given a noisy channel $p(y \mid x)$, what is the highest rate (bits per channel use) at which you can communicate with vanishing error probability?

**Answer (channel coding theorem, informal):** That rate is the **channel capacity**

$$
C = \max_{p(x)} I(X;Y),
$$

the maximum mutual information over input distributions.

### 3. Statistical dependence

How much does observing $Y$ reduce uncertainty about $X$?

**Answer:** Mutual information $I(X;Y) = H(X) - H(X \mid Y)$. It is zero if and only if $X$ and $Y$ are independent (for discrete variables under standard technical conditions).

## Why CS and ML practitioners need this

| Area | Information-theoretic role |
|------|----------------------------|
| Compression | Huffman, arithmetic coding, Lempel–Ziv; rate–distortion for lossy codecs |
| Networking | Capacity limits, ACK/NACK efficiency, FEC vs retransmission tradeoffs |
| Storage | RAID/erasure codes; entropy of data for backup sizing |
| ML training | Cross-entropy loss = coding cost under model $q$ for data from $p$ |
| Representation learning | MI bounds, InfoNCE, variational information bottlenecks |
| Feature selection | Rank features by $I(X_j; Y)$ or conditional MI |
| Privacy | Mutual information as a leakage metric between secrets and releases |
| Security | Entropy of keys; min-entropy for unpredictability |

### Worked intuition: cross-entropy as a loss

Suppose labels follow $p$, and a model predicts $q$. The average number of bits to encode true labels using code tailored to $q$ is the **cross-entropy** $H(p,q)$. Training often minimizes $H(p,q)$ (or an empirical version). The excess cost over the ideal $H(p)$ is the **KL divergence** $D_{\mathrm{KL}}(p \| q)$:

$$
H(p,q) = H(p) + D_{\mathrm{KL}}(p \| q).
$$

So “fitting the distribution” is literally “learning a good code for the data.”

## Mathematical prerequisites

You should be comfortable with:

- Discrete probability: joint, marginal, and conditional distributions
- Logarithms (especially base 2 for bits; natural log for nats)
- Expectation as a weighted sum
- Basic inequalities (Jensen) for convexity arguments
- Optional later: continuous densities for differential entropy caveats

Notation used throughout:

- $\log$ means $\log_2$ unless stated otherwise (bits)
- $H(X)$ entropy; $H(X \mid Y)$ conditional entropy
- $I(X;Y)$ mutual information
- $D_{\mathrm{KL}}(p \| q)$ Kullback–Leibler divergence

## Roadmap of this part

1. **Entropy and information content** — self-information, Shannon entropy, joint/conditional entropy, cross-entropy, KL divergence, information gain, compression links.
2. **Mutual information and capacity** — MI definitions and properties, data processing inequality, channels, BSC capacity, applications in ML and systems.

Planned extensions (not required for the core path): rate–distortion theory, explicit code constructions (Huffman, LDPC/turbo intuition), and information bottleneck methods in deep learning.

## A first calculation you should master

**Example.** Binary source with $P(X=1)=p$, $P(X=0)=1-p$. Entropy:

$$
H_2(p) = -p\log_2 p - (1-p)\log_2(1-p)
$$

(with the convention $0\log 0 = 0$).

- $H_2(0.5) = 1$ bit (maximum uncertainty)
- $H_2(0.1) \approx 0.469$ bits (biased source is more compressible)
- $H_2(0) = H_2(1) = 0$ (deterministic)

**Checkpoint:** Why does a highly biased source compress better? Because typical sequences have fewer “surprising” patterns; good codes assign short codewords to common symbols.

## Units: bits, nats, and dits

Entropy depends on the log base:

- base 2 → **bits** (standard in CS)
- base $e$ → **nats** (common in analysis and ML papers)
- base 10 → **dits/hartleys** (rare)

Conversion: $H_{\mathrm{bits}} = H_{\mathrm{nats}} / \ln 2$. Always check units when reading formulas that omit the base.

## Pitfalls (read before the next chapter)

1. **Entropy is not “amount of meaning.”** High-entropy noise is not “informative” in the human sense.
2. **$0\log 0$:** Define as 0 by continuity; never leave raw $\log 0$ in code.
3. **Differential entropy** of continuous r.v.s can be negative and is **not** a pure “information content” analogue of discrete entropy.
4. **KL is not a metric:** $D_{\mathrm{KL}}(p\|q) \neq D_{\mathrm{KL}}(q\|p)$ in general; triangle inequality fails.
5. **Empirical entropy** from finite samples underestimates true entropy without care (especially for large alphabets).

## How to study these chapters

For each definition:

1. State it formally.
2. Compute it on a 2-outcome and a 4-outcome toy distribution.
3. Connect it to one CS artifact (codec, loss, feature score, channel).
4. Do the exercises that force a short proof or inequality, not only numerical plugging.

## Exercises (warm-up)

1. Compute self-information of drawing an ace from a 52-card deck (in bits).
2. Show $H_2(p) = H_2(1-p)$ from the definition.
3. Argue without heavy machinery why entropy is maximized for a uniform distribution on a fixed finite alphabet (use symmetry or Jensen's inequality sketch).
4. A file of English text is compressed from 100 MB to 30 MB losslessly. What does this say about empirical entropy **relative to** 8 bits/byte ASCII? What does it **not** say about “true language entropy”?
5. Explain in one paragraph why cross-entropy loss for classification is an information-theoretic coding cost.
6. List three systems where mutual information is more natural than correlation as a dependence measure.
7. Convert $2$ nats to bits.
8. Why is password strength sometimes discussed in **bits of entropy**? What distributional assumption is often smuggled in?
9. If $X$ is deterministic, prove $H(X)=0$ from the definition.
10. Give an example of two variables with zero correlation but nonzero mutual information (describe qualitatively).

## Checkpoint

You should now be able to:

- Explain Shannon information without invoking “meaning”
- State the source coding and channel coding problems in one sentence each
- Compute binary entropy $H_2(p)$ and interpret bias vs compressibility
- Map entropy / KL / MI to at least one ML or systems tool each
- Avoid the main conceptual traps (semantics, continuous entropy, asymmetric KL)

Next: **Entropy and Information Content** develops the full discrete entropy toolkit with proofs, examples, and exercises.
