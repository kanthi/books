# Neural Networks: A Mathematical Sketch

A neural net is a **composition of affine maps and nonlinearities**. Depth creates hierarchical features; training uses gradients of a scalar loss. This chapter is the math skeleton — not a framework tutorial.

## Diagram: one hidden layer

```text
  x ∈ R^d
    │
    │  W1, b1
    v
  z = W1 x + b1
    │
    │  σ elementwise
    v
  h = σ(z) ∈ R^h
    │
    │  W2, b2
    v
  ŷ = W2 h + b2
```

## 1. Building blocks

### Affine layer

$$
z = Wx + b,\qquad W\in\mathbb{R}^{h\times d},\ b\in\mathbb{R}^h.
$$

### Activations $\sigma$ (elementwise unless noted)

| $\sigma$ | Formula | Notes |
|----------|---------|--------|
| ReLU | $\max(0,z)$ | sparse grads; default MLP |
| Leaky ReLU | $\max(\alpha z,z)$ | avoids dead units somewhat |
| sigmoid | $(1+e^{-z})^{-1}$ | saturates; rare in deep hidden |
| tanh | $\tanh z$ | zero-centered |
| GELU / SiLU | smooth ReLU-like | transformers / modern nets |
| softmax | on vector | output distributions |

### Residual connections

$$
y = x + F(x)
$$

eases deep training: identity path keeps gradients from vanishing purely by depth; $F$ learns residuals.

### Universal approximation (intuition)

A single hidden layer with suitable $\sigma$ and enough width can approximate continuous functions on compact sets arbitrarily well. Depth often needs fewer parameters for hierarchical structure (images, language) — theory and practice both matter.

## 2. Parameter count and FLOPs

Dense layer $d\to h$: $dh + h$ parameters (weights + biases).

### Worked example 1 — MLP $10\to 32\to 32\to 1$

$$
\begin{aligned}
&10\cdot 32+32 + 32\cdot 32+32 + 32\cdot 1+1\\
&=320+32+1024+32+32+1=1441.
\end{aligned}
$$

(If you saw $1473$ elsewhere, recount with the same bias convention — always state whether biases are included.)

Matrix multiplies dominate FLOPs: roughly $2dh$ for a dense multiply-add of one example (order-of-magnitude).

## 3. Composition and feature hierarchy

Write $f = f_L\circ f_{L-1}\circ\cdots\circ f_1$. Early layers often detect simple patterns; later layers mix them. Mathematically each $f_\ell$ is affine+$\sigma$ (or attention, norm, etc.).

**Critical:** if every $\sigma$ is identity (or affine), the whole net collapses to **one** affine map — nonlinear $\sigma$ is essential for depth to add expressive power.

## 4. Jacobian and local linearization

Near a point,

$$
f(x+\delta)\approx f(x)+J_f(x)\,\delta.
$$

Backprop multiplies Jacobians efficiently for **scalar** losses without materializing full $J_f$ when only $v^\top J$ or $J u$ products are needed (autodiff VJPs/JVPs).

### Layer Jacobian sketch (elementwise $\sigma$)

For $h=\sigma(Wx+b)$, 

$$
\frac{\partial h_i}{\partial x}
= \sigma'(z_i)\, W_{i,:}
$$

(row-wise scaling of $W$ by $\sigma'(z)$).

## 5. Vanishing and exploding gradients

Backprop to early layers multiplies many Jacobians:

$$
\frac{\partial\ell}{\partial W_1}
\sim
\Bigl(\prod_{\ell=2}^{L} J_\ell\Bigr)
\frac{\partial\ell}{\partial\mathrm{out}}.
$$

```text
  ∂ℓ/∂ early layer  ≈  (many matrices) × ∂ℓ/∂ late
                       │
            singular values <1 ──► vanish
            singular values >1 ──► explode
```

**Mitigations (conceptual):** residual links, normalization (Batch/LayerNorm), careful initialization (He/Xavier), gated RNNs / transformers replacing naive deep stacks, gradient clipping.

## 6. Normalization layers (math role)

**LayerNorm** (idea): for activation vector $h$, standardize coordinates then affine rescale with learned $\gamma,\beta$. Stabilizes distributions of pre-activations so optimization sees better-conditioned landscapes. Not just “engineering” — it changes the geometry of $J(w)$.

## 7. Loss heads

| Task | Head |
|------|------|
| Regression | linear output + squared / Huber |
| Binary | sigmoid + BCE |
| Multi-class | softmax + CE |
| Embeddings | contrastive / InfoNCE |

Training minimizes empirical risk on the head’s loss; backbone features are whatever gradients request.

## 8. Overfitting and capacity

More parameters + flexible $\sigma$ ⇒ can interpolate noise.

**Controls:** more data, weight decay, dropout (multiplicative noise / ensemble intuition), early stopping, architecture constraints (CNNs share weights; attention has structure), data augmentation.

Double descent phenomena: classical U-curve incomplete in overparameterized regimes — still use validation.

## 9. Convolution and parameter sharing (sketch)

A conv layer applies the same small kernel at every spatial location — **tied weights**. Fewer parameters than dense on images; equivariance to translations (approximately, with boundary effects). Math: linear map with Toeplitz/circulant structure + nonlinearity.

## 10. Attention as similarity (sketch)

Queries $Q$, keys $K$, values $V$:

$$
\mathrm{Attention}(Q,K,V)=\mathrm{softmax}\Bigl(\frac{QK^\top}{\sqrt{d}}\Bigr)V.
$$

Rows of the softmax are probability distributions over positions — a data-dependent linear combination of value vectors. Linear algebra + softmax probability; no mystic step.

## 11. Initialization (order-of-magnitude)

Goal: keep activation and gradient variances $\mathcal{O}(1)$ across layers at start.

- **Xavier/Glorot:** $\mathrm{Var}(W)\sim 1/d_{\mathrm{in}}$ (tanh-like)  
- **He:** $\mathrm{Var}(W)\sim 2/d_{\mathrm{in}}$ (ReLU)  

Bad init ⇒ immediate vanish/explode before learning starts.

## 12. What math to study next

| Topic | Why |
|-------|-----|
| Matrix calculus | gradients w.r.t. $W$ |
| Probability | losses as likelihoods |
| Optimization | SGD, momentum, Adam |
| Linear algebra | attention as similarity, PCA of activations |
| Information theory | CE, KL, MI bounds |

## 13. Pitfalls

1. Stacking linear layers without nonlinearities  
2. Counting parameters wrong (forgetting biases or embeddings)  
3. Interpreting deep success as “non-convex is easy” universally  
4. Ignoring depth-related gradient issues until loss is NaN  
5. Comparing architectures without matched optimization effort  

## 14. Checkpoint

- Write a one-hidden-layer net formula  
- Count parameters of a small MLP  
- Explain why identity activations collapse depth  
- State residual connection formula  
- Describe vanishing gradients as Jacobian products  
- Name two capacity controls  

## Exercises

### Easy

1. Count parameters of MLP $10\to 32\to 32\to 1$ with biases.  
2. Compute ReLU derivative almost everywhere.  
3. Why is identity activation stacked still just one affine map?  
4. Name two reasons mini-batch SGD is used instead of full-batch GD on big data.  
5. Softmax on equal logits: what distribution?  

### Medium

6. Sketch how residual $y=x+F(x)$ changes the “multiply many Jacobians” story.  
7. For $h=\mathrm{ReLU}(Wx)$, write $\partial h_i/\partial W_{ik}$ when $z_i>0$ vs $z_i<0$.  
8. Compare parameter count: dense $d\to d$ vs $3\times 3$ conv with $c$ channels (same $c$, spatial size $N\times N$) order-of-magnitude.  
9. Attention: show each row of $\mathrm{softmax}(QK^\top/\sqrt{d})$ sums to $1$.  
10. He init variance: argue why factor $2$ appears for ReLU (half neurons active).  

### Challenge

11. Prove that a composition of affine maps is affine (induct on layers).  
12. Lipschitz constant of a deep net: bound via product of Lipschitz constants of layers.  
13. Dead ReLU: construct a 1D example where a unit never activates for a data set.  
14. Gradient check a 2-layer net Jacobian-vector product numerically.  
15. Relate weight decay on $W$ to a Gaussian prior MAP story from the probability chapter.  

## Checks

1. $10\cdot32+32+32\cdot32+32+32\cdot1+1=1441$.  
3. Composition of affines is affine.  
5. Uniform $1/K$.  

## Summary

Neural nets compose affine transforms with nonlinearities; depth only buys power when nonlinearities (or data-dependent maps like attention) prevent collapse to a single linear model. Parameter counts, Jacobians, and residual/normalization geometry explain trainability. Losses at the head define the probabilistic goal; the backbone is a flexible feature map optimized by gradient methods. Keep the linear-algebra and chain-rule picture — frameworks implement it; they do not replace it.
