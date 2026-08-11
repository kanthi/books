# KL Divergence, Cross-Entropy, and Coding

**Cross-entropy** and **KL divergence** connect coding length to how wrong a model distribution is. They are the mathematical reason machine learning uses “cross-entropy loss,” and they quantify wasted bits when the code (or model) assumes the wrong distribution.

## Diagram: two distributions

```text
  true P          model Q
   ██                ▓▓
  ████              ▓▓▓▓
 ██████            ▓▓▓▓▓▓
 ────────────────────────► x

  H(P)      = ideal code length under P
  H(P,Q)    = code length if you use Q while truth is P
  KL(P∥Q)   = H(P,Q) − H(P)  ≥ 0   extra bits wasted
```

## 1. Definitions (discrete)

Let $P$ and $Q$ be probability mass functions on a finite alphabet $\mathcal{X}$. Use $\log$ for $\log_2$ (bits) unless noted; natural log yields nats.

**Entropy**

$$
H(P)=-\sum_{x\in\mathcal{X}} P(x)\log P(x),
$$

with the convention $0\log 0=0$.

**Cross-entropy**

$$
H(P,Q)=-\sum_{x} P(x)\log Q(x).
$$

Requires $Q(x)>0$ whenever $P(x)>0$ (absolute continuity on the support of $P$); otherwise $H(P,Q)=\infty$.

**Kullback–Leibler divergence**

$$
D_{\mathrm{KL}}(P\|Q)=\sum_{x} P(x)\log\frac{P(x)}{Q(x)}=H(P,Q)-H(P).
$$

### Fundamental properties

| Property | Statement |
|----------|-----------|
| Nonnegativity | $D_{\mathrm{KL}}(P\|Q)\ge 0$ (Gibbs / information inequality) |
| Identity of indiscernibles | $=0$ iff $P=Q$ (on $\mathrm{supp}\,P$) |
| Asymmetry | $D_{\mathrm{KL}}(P\|Q)\neq D_{\mathrm{KL}}(Q\|P)$ in general |
| Not a metric | triangle inequality fails |
| Units | bits or nats with the log base |

### Worked example 1 — binary

$P=(1/2,1/2)$, $Q=(3/4,1/4)$ on $\{0,1\}$.

$$
H(P)=1\ \text{bit}.
$$

$$
H(P,Q)=-\tfrac12\log_2\tfrac34-\tfrac12\log_2\tfrac14 \approx 0.2075+1=1.2075.
$$

$$
D_{\mathrm{KL}}(P\|Q)\approx 0.2075\ \text{bits}.
$$

### Worked example 2 — reverse KL differs

Same $P,Q$:

$$
D_{\mathrm{KL}}(Q\|P)=\tfrac34\log_2\frac{3/4}{1/2}+\tfrac14\log_2\frac{1/4}{1/2}
=\tfrac34\log_2\tfrac32+\tfrac14\log_2\tfrac12\approx 0.1887\neq D_{\mathrm{KL}}(P\|Q).
$$

## 2. Coding story (why the formulas look like that)

Idealized Shannon code: symbol $x$ gets length about $-\log Q(x)$ if you design for $Q$.

- If nature draws from $P$, average length $\approx \sum_x P(x)(-\log Q(x))=H(P,Q)$.  
- Best possible average length (large-block limit) is $H(P)$.  
- **Extra** average length is $H(P,Q)-H(P)=D_{\mathrm{KL}}(P\|Q)$.

So KL is literally **expected excess code length** from using the wrong distribution.

### Kraft and prefix codes (connection)

For prefix-free codes with lengths $\ell(x)$, Kraft: $\sum_x 2^{-\ell(x)}\le 1$. Setting $Q(x)\propto 2^{-\ell(x)}$ makes coding length and probability dual views of the same object.

## 3. ML link: cross-entropy loss

### Multi-class classification

One training example with true class $y$ (one-hot vector $e_y$) and model probabilities $Q_\theta(x)=p_\theta(\cdot\mid x)$:

$$
\ell(\theta;x,y)=-\log Q_\theta(y)=H(e_y,\,Q_\theta).
$$

Average over the empirical data distribution $\hat P$:

$$
\mathbb{E}_{(x,y)\sim\hat P}\bigl[-\log p_\theta(y\mid x)\bigr]
$$

is empirical cross-entropy. Minimizing it pushes $Q_\theta$ toward the conditional label distribution on the data.

### Binary logistic regression

$y\in\{0,1\}$, $\hat y=\sigma(w^\top x)$:

$$
\ell= -y\log\hat y-(1-y)\log(1-\hat y),
$$

which is $H\bigl((y,1-y),(\hat y,1-\hat y)\bigr)$.

### Softmax + CE gradient fact

With logits $z$ and $p=\mathrm{softmax}(z)$, for one-hot $y$:

$$
\nabla_z \ell = p-y.
$$

This algebraic simplification is a major reason the CE+softmax pair dominates multi-class training.

## 4. KL as expected log-likelihood gap

If data $\sim P$ and model $Q_\theta$,

$$
D_{\mathrm{KL}}(P\|Q_\theta)= \underbrace{-\mathbb{E}_P\log Q_\theta}_{\text{cross-entropy}} - H(P).
$$

$H(P)$ does not depend on $\theta$, so

$$
\arg\min_\theta D_{\mathrm{KL}}(P\|Q_\theta)=\arg\min_\theta H(P,Q_\theta)=\arg\max_\theta \mathbb{E}_P\log Q_\theta.
$$

**MLE on infinite data** = **minimize KL to the true distribution** (within the model family). Finite-sample MLE is the same program with $P$ replaced by the empirical distribution.

## 5. Forward vs reverse KL (mode behavior)

| Divergence | Heavy penalty when… | Typical behavior of $\arg\min_Q D$ |
|------------|----------------------|-------------------------------------|
| $D_{\mathrm{KL}}(P\|Q)$ “forward” | $P>0$ but $Q\approx 0$ | **Mode-covering**: $Q$ must put mass on all modes of $P$ |
| $D_{\mathrm{KL}}(Q\|P)$ “reverse” | $Q>0$ but $P\approx 0$ | **Mode-seeking**: $Q$ can collapse to one mode of $P$ |

Variational inference often minimizes reverse KL (or a bound); mass-covering objectives appear in other approximations. Choice of KL direction changes algorithm behavior.

```text
  multimodal P:   ^^^   ^^^
  forward KL Q:   ^^^^^^^^^^^   (covers both, may smear)
  reverse KL Q:      ^^^        (picks one mode)
```

## 6. Continuous case (caution)

For densities $p,q$ on $\mathbb{R}^d$:

$$
D_{\mathrm{KL}}(p\|q)=\int p(x)\log\frac{p(x)}{q(x)}\,dx.
$$

Differential entropy $h(p)=-\int p\log p$ can be **negative** and is not a pure “bits of content” analogue. Cross-entropy and KL remain meaningful as relative quantities; absolute continuous entropy needs care with units and reparameterization.

## 7. Related divergences (map)

| Name | Idea |
|------|------|
| Jensen–Shannon | Symmetrized, bounded KL mixture |
| Total variation | $L_1$ distance of measures |
| Wasserstein | Cost of transporting mass (geometry) |
| $f$-divergences | Family including KL, $\chi^2$, Hellinger |

Pinsker’s inequality links KL and total variation: $\mathrm{TV}(P,Q)^2\le \tfrac12 D_{\mathrm{KL}}(P\|Q)$ (in nats conventions vary — check constants).

## 8. Worked example 3 — sure event

If $P=(1,0,\ldots,0)$, then $H(P)=0$ and $H(P,Q)=-\log Q(x^\star)$ for the sure symbol $x^\star$. KL is $-\log Q(x^\star)$: certainty under $P$, model still pays if it is not certain.

### Worked example 4 — CE with uniform model

$P=(0.9,0.1)$, $Q=(0.5,0.5)$:

$$
H(P,Q)=-0.9\log_2 0.5-0.1\log_2 0.5=1\ \text{bit}.
$$

$H(P)=H_2(0.9)\approx 0.469$, so $D_{\mathrm{KL}}\approx 0.531$ bits.

## 9. Numerical and practical pitfalls in ML

1. **$\log 0$:** clamp probabilities or use `log_softmax` in the logit domain  
2. **Label smoothing:** replaces one-hot $P$ by a slightly mixed distribution — changes the CE target  
3. **Class imbalance:** average CE weights frequent classes more unless reweighted  
4. **Comparing models:** lower CE on the same data = better coding of labels; still need calibration / decision metrics  
5. **Asymmetry:** never treat KL as a distance without checking direction  

## 10. CS / systems connections

- Compression: wrong source model ⇒ larger files (excess ≈ KL per symbol)  
- Language models: perplexity $2^{H(P,Q)}$ on tokens (cross-entropy exponential)  
- Anomaly detection: high $-\log Q(x)$ under a background model  
- Privacy / leakage: KL between output laws under neighboring datasets (related to DP analysis variants)  

## 11. Checkpoint

- Write $H(P)$, $H(P,Q)$, $D_{\mathrm{KL}}(P\|Q)$ and the identity relating them  
- Explain excess code length  
- Derive why MLE minimizes KL to the data-generating distribution  
- Contrast forward vs reverse KL mode behavior  
- Compute a 2-point KL by hand  

## Exercises

### Easy

1. Prove $D_{\mathrm{KL}}(P\|P)=0$.  
2. Compute $H(P)$ for a deterministic $P=(1,0,\ldots)$ (limit / discrete sure event).  
3. For $P=(0.9,0.1)$, $Q=(0.5,0.5)$, compute $H(P,Q)$ in bits.  
4. Why is $\log Q$ in the classification loss and not $\log P$?  
5. Show $H(P,Q)\ge H(P)$ from nonnegativity of KL.  

### Medium

6. **Challenge starter:** KL is not a metric — give a numerical counterexample to symmetry with 2-point distributions.  
7. Show that for fixed $P$, $H(P,Q)$ is minimized at $Q=P$ with value $H(P)$.  
8. Binary CE: expand $-y\log\hat y-(1-y)\log(1-\hat y)$ and interpret each term.  
9. If $Q_\varepsilon=(1-\varepsilon)P+\varepsilon U$ mixes with uniform $U$, what happens to $H(P,Q_\varepsilon)$ as $\varepsilon\to 0$?  
10. Convert a KL of $0.5$ nats to bits.  

### Challenge

11. Prove Gibbs inequality $D_{\mathrm{KL}}\ge 0$ via Jensen on $-\log$ (or log-sum inequality).  
12. Softmax+CE: derive $\partial\ell/\partial z_k=p_k-y_k$.  
13. Construct $P,Q,R$ violating the triangle inequality for KL (or argue using asymmetry).  
14. Show that if $\mathrm{supp}\,P\not\subseteq\mathrm{supp}\,Q$ then $D_{\mathrm{KL}}(P\|Q)=\infty$.  
15. Relate label smoothing CE to CE against a mixture target; discuss gradient effect on overconfident models.  

## Checks

3. $-0.9\log_2 0.5-0.1\log_2 0.5=1$ bit.  
5. From $D_{\mathrm{KL}}(P\|Q)\ge 0$.  
10. $0.5/\ln 2\approx 0.721$ bits.  

## Summary

Cross-entropy is the average code length when nature uses $P$ and you code with $Q$; KL is the excess over the ideal $H(P)$. Machine learning’s cross-entropy loss is this coding cost on labels. KL is nonnegative, asymmetric, and direction-sensitive: forward vs reverse KL encode different approximation geometries. Keep the coding story in mind whenever you see $-\log p_\theta$ in a training objective.
