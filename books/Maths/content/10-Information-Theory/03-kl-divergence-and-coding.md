# KL Divergence, Cross-Entropy, and Coding

**Cross-entropy** and **KL divergence** connect coding length to how wrong a model distribution is. They are the mathematical reason ML uses “cross-entropy loss.”

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

Entropy:

$$
H(P)=-\sum_x P(x)\log P(x).
$$

Cross-entropy:

$$
H(P,Q)=-\sum_x P(x)\log Q(x).
$$

KL divergence:

$$
D_{\mathrm{KL}}(P\|Q)=\sum_x P(x)\log\frac{P(x)}{Q(x)}=H(P,Q)-H(P).
$$

**Gibbs inequality:** $D_{\mathrm{KL}}(P\|Q)\ge 0$, zero iff $P=Q$ (on support).

**Not symmetric:** $D_{\mathrm{KL}}(P\|Q)\neq D_{\mathrm{KL}}(Q\|P)$ in general.

## 2. Coding story

If you design codes assuming $Q$ but symbols come from $P$, average length ≈ $H(P,Q)$ (idealized).  
Extra length vs ideal is KL.

## 3. ML link

Training with one-hot labels $P$ and model probabilities $Q_\theta$:

$$
H(P,Q_\theta)=-\log Q_\theta(y_{\text{true}})
$$

= multi-class cross-entropy loss. Minimizing it pushes $Q$ toward $P$ on the data distribution.

## 4. Worked example

$P=(1/2,1/2)$, $Q=(3/4,1/4)$ on $\{0,1\}$.

$H(P)=1$ bit.  
$H(P,Q)=-\frac12\log_2\frac34-\frac12\log_2\frac14\approx 1.207$.  
$KL\approx 0.207$ bits.

## 5. Forward vs reverse KL (intuition)

- $D(P\|Q)$ heavy when $P$ has mass where $Q\approx 0$ (mode-covering pressures differ in variational inference).
- Choice of which KL appears changes algorithm behavior (beyond this chapter’s scope — flag for VI reading).

## Exercises

1. Prove $D_{\mathrm{KL}}(P\|P)=0$.  
2. Compute $H(P)$ for $P=(1,0,\ldots)$ (limit sense / discrete sure event).  
3. For $P=(0.9,0.1)$, $Q=(0.5,0.5)$, compute $H(P,Q)$ in bits.  
4. Why is $\log Q$ in the loss and not $\log P$?  
5. Show by inequality that $H(P,Q)\ge H(P)$.  
6. **Challenge:** KL not a metric — give a counterexample to symmetry with 2-point distributions.

## Checks

3. $-0.9\log_2 0.5-0.1\log_2 0.5=1$ bit.  
5. From $KL\ge 0$.
