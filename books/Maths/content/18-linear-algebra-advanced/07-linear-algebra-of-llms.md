---
title: "The Linear Algebra Inside a Large Language Model"
author:
  - name: "K19G"
  - name: "grok-bot"
---

A large language model is mostly matrix multiplication, and the interesting questions about it are linear-algebra questions. Where do the parameters sit? What is the rank of an attention matrix, and why does it cost $n^2$? How can a product be re-associated to make attention linear in sequence length? Why can a rank-16 update fine-tune a model with billions of parameters? What does it mean to precondition a gradient that is itself a matrix?

This chapter answers each question with a short derivation and a script that checks it. The organizing reference is Baggag and Saad's 2026 survey *The Numerical Linear Algebra of Large Language Models*. Where the survey and a primary source disagree, the chapter goes with the primary source and says why. The listings were run with Python 3.13.5, NumPy 2.5.3 and SciPy 1.18.1 on Debian 13.7, and the outputs are pasted unedited. Timings depend on the machine; everything else is seeded.

**Prerequisites:** matrix products and rank, the SVD and Eckart–Young, eigendecomposition of symmetric matrices, gradient descent.

---

## 1. Where the parameters are

A decoder-only transformer with model width $d$ is a stack of $L$ identical blocks plus an embedding table and an output projection (the "LM head"). For a Llama-3-style block:

| Matrix | Shape | Count |
|---|---|---|
| $W_Q$, $W_O$ | $d\times d$ | $2d^2$ |
| $W_K$, $W_V$ (grouped-query attention, $h_{kv}$ heads of size $d_h$) | $d\times h_{kv}d_h$ | $2d\,h_{kv}d_h$ |
| SwiGLU MLP: gate, up, down | $d\times d_{ff}$ (×3) | $3d\,d_{ff}$ |
| Two RMSNorm gain vectors | $d$ (×2) | $2d$ |

Add $2Vd$ for an untied embedding and LM head ($V$ = vocabulary size) and $d$ for the final norm. There are no biases anywhere, and RMSNorm has a gain but no shift. The formula is easy to apply carelessly, so check it against the real checkpoints.

### Worked example 1 — count Llama 3 exactly

```python
# file: llm_params.py
# Count the parameters of a Llama-3-style decoder from its config, matrix by matrix,
# and compare with the totals Hugging Face reports for the released checkpoints.
configs = {  # values from each model's config.json
    "Llama-3-8B":     dict(d=4096,  d_ff=14336, layers=32,  heads=32,  kv_heads=8, vocab=128256),
    "Llama-3.1-405B": dict(d=16384, d_ff=53248, layers=126, heads=128, kv_heads=8, vocab=128256),
}
published = {"Llama-3-8B": 8_030_261_248, "Llama-3.1-405B": 405_853_388_800}  # safetensors metadata

for name, c in configs.items():
    d, f, L = c["d"], c["d_ff"], c["layers"]
    dh = d // c["heads"]
    attn = d * d + 2 * d * (c["kv_heads"] * dh) + d * d      # W_Q, W_K, W_V (GQA), W_O; no biases
    mlp = 3 * d * f                                          # gate, up, down (SwiGLU); no biases
    norms = 2 * d                                            # two RMSNorm gains, no beta
    emb = 2 * c["vocab"] * d                                 # untied input embedding and LM head
    total = L * (attn + mlp + norms) + d + emb               # + final RMSNorm
    print(f"{name}: d={d}, d_ff={f}, layers={L}, head_dim={dh}")
    for part, n in (("attention", L * attn), ("MLP", L * mlp), ("embeddings", emb),
                    ("norms", L * norms + d)):
        print(f"  {part:11} {n:>16,}  {100 * n / total:5.1f}%")
    print(f"  {'total':11} {total:>16,}  published {published[name]:,}  "
          f"{'MATCH' if total == published[name] else 'DIFF ' + format(total - published[name], ',')}")
    # Counted with GPT-style habits: MLP biases, LayerNorm gamma AND beta, no final norm.
    gpt_style = L * (attn + mlp + (2 * f + d) + 2 * (2 * d)) + emb
    print(f"  GPT-style count (biases, betas, no final norm): {gpt_style:,} "
          f"(+{gpt_style - total:,})")
```

```bash
python llm_params.py
```

Output:

```text
Llama-3-8B: d=4096, d_ff=14336, layers=32, head_dim=128
  attention      1,342,177,280   16.7%
  MLP            5,637,144,576   70.2%
  embeddings     1,050,673,152   13.1%
  norms                266,240    0.0%
  total          8,030,261,248  published 8,030,261,248  MATCH
  GPT-style count (biases, betas, no final norm): 8,031,567,872 (+1,306,624)
Llama-3.1-405B: d=16384, d_ff=53248, layers=126, head_dim=128
  attention     71,873,593,344   17.7%
  MLP          329,772,957,696   81.3%
  embeddings     4,202,692,608    1.0%
  norms              4,145,152    0.0%
  total        405,853,388,800  published 405,853,388,800  MATCH
  GPT-style count (biases, betas, no final norm): 405,872,984,064 (+19,595,264)
```

- The formula reproduces both published totals **to the parameter**. Those totals are the `safetensors` metadata on the Hugging Face model pages: 8,030,261,248 and 405,853,388,800.
- The MLP holds 70% of the 8B model and 81% of the 405B model. Attention is under a fifth. Grouped-query attention is part of the reason: with 8 KV heads, $W_K$ and $W_V$ are each only $d\times 1024$.
- The embeddings matter only for small models (13% at 8B, 1% at 405B), because they scale like $Vd$ while the blocks scale like $Ld^2$.

**The trap:** carrying over habits from a different block. GPT-2 and GPT-3 blocks have biases and LayerNorm with both $\gamma$ and $\beta$; Llama blocks have neither. Counting them anyway gives the last line of each block above. For the 405B model that comes to exactly **405,872,984,064**, which is the total in Table 4 of the Baggag–Saad survey, 19.6 million (0.005%) above the real checkpoint. The error is negligible in size but not in kind. A parameter count is a statement about the architecture, and a count that does not match the checkpoint describes a different model.

---

## 2. Attention as a matrix

For one head with $n$ tokens, $Q = XW_Q$, $K = XW_K$, $V = XW_V \in \mathbb R^{n\times d_h}$, and

$$
S = \frac{QK^\top}{\sqrt{d_h}}, \qquad P = \operatorname{softmax}_{\text{row}}(S), \qquad \text{output} = PV.
$$

Three linear-algebra facts:

1. **The scores are low rank.** $\operatorname{rank}(S) \le \operatorname{rank}(Q) \le d_h$, typically 64 or 128 while $n$ runs to many thousands. Bhojanapalli et al. (2020) argue that this bounds what one head can express and that splitting $d$ across many small heads makes it worse.
2. **$P$ is row-stochastic.** Its entries are positive and each row sums to 1. Each output row is a **convex combination** of the rows of $V$: attention averages, it does not extrapolate.
3. **The cost is quadratic.** Forming $S$ takes $2n^2d_h$ flops and $n^2$ memory per head. The softmax needs a whole row of $S$ before it can normalize, so the $n\times n$ intermediate cannot simply be re-associated away.

Fact 1 is often stated about $P$ instead of $S$. That is wrong.

### Worked example 2 — the rank of S and of P

```python
# file: attention_rank.py
# The score matrix QK^T has rank <= d_head. The attention matrix softmax(QK^T/sqrt(d))
# does not: the elementwise exponential destroys the low-rank structure.
import numpy as np

rng = np.random.default_rng(0)
n, d_model, d_head = 512, 256, 32
X = rng.standard_normal((n, d_model))
Wq, Wk, Wv = (rng.standard_normal((d_model, d_head)) / np.sqrt(d_model) for _ in range(3))
Q, K, V = X @ Wq, X @ Wk, X @ Wv

for scale in (0.1, 1.0, 4.0):                           # temperature: flat -> peaked attention
    S = scale * Q @ K.T / np.sqrt(d_head)
    P = np.exp(S - S.max(1, keepdims=True))
    P /= P.sum(1, keepdims=True)
    sv = np.linalg.svd(P, compute_uv=False)
    num_rank = int(np.sum(sv > 1e-10 * sv[0]))
    energy = np.cumsum(sv**2) / np.sum(sv**2)
    r99 = int(np.searchsorted(energy, 0.99) + 1)
    print(f"scale {scale:3}: rank(S) = {np.linalg.matrix_rank(S):3d}   rank(P) = {num_rank:3d}   "
          f"99% energy in {r99:3d} singular values   rows sum to 1: {np.allclose(P.sum(1), 1)}")

out = P @ V                                              # each output row: a convex mix of V rows
print("every output row inside the box of V's rows:",
      bool(np.all(out >= V.min(0) - 1e-12) and np.all(out <= V.max(0) + 1e-12)))
```

```bash
python attention_rank.py
```

Output:

```text
scale 0.1: rank(S) =  32   rank(P) = 512   99% energy in   2 singular values   rows sum to 1: True
scale 1.0: rank(S) =  32   rank(P) = 512   99% energy in 242 singular values   rows sum to 1: True
scale 4.0: rank(S) =  32   rank(P) = 512   99% energy in 247 singular values   rows sum to 1: True
every output row inside the box of V's rows: True
```

$S$ has rank exactly 32 $= d_h$. $P = \operatorname{softmax}(S)$ has full rank 512 at every temperature, because the elementwise exponential of a low-rank matrix is generically full rank. What changes with temperature is the *numerical* rank. Nearly flat attention (scale 0.1) is close to the rank-one matrix $\tfrac1n\mathbf 1\mathbf 1^\top$, and 2 singular values hold 99% of the energy. Sharper attention spreads energy over about 240 directions. The low-rank bottleneck is on the scores; the softmax is the nonlinearity that lets attention escape it. The last line confirms fact 2: every output coordinate lies between the minimum and maximum of the corresponding column of $V$.

---

## 3. Re-association and linear attention

Without the softmax, attention would be a product of three matrices, and matrix products are associative:

$$
(QK^\top)V = Q(K^\top V), \qquad \underbrace{2n^2 d}_{\text{left}} \quad\text{vs}\quad \underbrace{4nd^2}_{\text{right}}.
$$

The right-hand order never forms an $n\times n$ matrix, and it is cheaper whenever $n > 2d$. **Kernelized attention** keeps this structure by replacing $\exp(q\cdot k)$ with a factorizable similarity $\phi(q)\cdot\phi(k)$ for a positive feature map $\phi$. Katharopoulos et al. (2020) use $\phi(x) = \operatorname{elu}(x)+1$:

$$
\text{out}_i = \frac{\phi(q_i)^\top \sum_j \phi(k_j)v_j^\top}{\phi(q_i)^\top \sum_j \phi(k_j)}.
$$

With a causal mask the sums run over $j \le i$, so they can be carried forward as a $d\times d_v$ state $S_i = S_{i-1} + \phi(k_i)v_i^\top$ and a $d$-vector $z_i = z_{i-1} + \phi(k_i)$. Causal linear attention is literally a recurrent network. Generation then costs $O(d^2)$ per token and keeps no KV cache. Shen et al.'s efficient attention takes a related route: a row softmax on $Q$ and a column softmax on $K$.

### Worked example 3 — three forms, one operator

```python
# file: linear_attention.py
# Kernelized ("linear") attention: phi(Q) (phi(K)^T V) costs O(n d^2) instead of O(n^2 d),
# and its causal form is a recurrence with a d x d state. It is a different operator from
# softmax attention, not an approximation of it.
import time

import numpy as np

rng = np.random.default_rng(1)
phi = lambda x: np.where(x > 0, x + 1.0, np.exp(x))         # elu(x) + 1 > 0


def softmax_attn(Q, K, V, causal):
    S = Q @ K.T / np.sqrt(Q.shape[1])
    if causal:
        S = np.where(np.tril(np.ones(S.shape, bool)), S, -np.inf)
    P = np.exp(S - S.max(1, keepdims=True))
    return (P / P.sum(1, keepdims=True)) @ V


def linear_attn_quadratic(Q, K, V, causal):                 # the n x n form, for checking
    A = phi(Q) @ phi(K).T
    if causal:
        A = np.tril(A)
    return (A @ V) / A.sum(1, keepdims=True)


def linear_attn(Q, K, V):                                   # non-causal, reassociated
    fK = phi(K)
    return (phi(Q) @ (fK.T @ V)) / (phi(Q) @ fK.sum(0))[:, None]


def linear_attn_recurrent(Q, K, V):                         # causal: an RNN with state (S, z)
    d, dv = Q.shape[1], V.shape[1]
    S, z, out = np.zeros((d, dv)), np.zeros(d), np.empty((len(Q), dv))
    for t in range(len(Q)):
        k = phi(K[t])
        S += np.outer(k, V[t])
        z += k
        q = phi(Q[t])
        out[t] = q @ S / (q @ z)
    return out


n, d = 256, 32
Q, K, V = (rng.standard_normal((n, d)) for _ in range(3))
print("non-causal: reassociated == n x n form:",
      np.allclose(linear_attn(Q, K, V), linear_attn_quadratic(Q, K, V, False)))
print("causal:     recurrence  == masked n x n form:",
      np.allclose(linear_attn_recurrent(Q, K, V), linear_attn_quadratic(Q, K, V, True)))
ref = softmax_attn(Q, K, V, False)
lin = linear_attn(Q, K, V)
print(f"relative difference from softmax attention: {np.linalg.norm(lin - ref) / np.linalg.norm(ref):.2f}")

print(f"\n{'n':>6} {'softmax ms':>10} {'linear ms':>9} {'flops ratio n/d':>15}")
for n in (512, 2048, 8192):
    Q, K, V = (rng.standard_normal((n, d)) for _ in range(3))
    t0 = time.perf_counter(); softmax_attn(Q, K, V, False); t1 = time.perf_counter()
    linear_attn(Q, K, V); t2 = time.perf_counter()
    print(f"{n:6d} {1e3 * (t1 - t0):10.1f} {1e3 * (t2 - t1):9.2f} {n / d:15.0f}")
```

```bash
python linear_attention.py
```

Output:

```text
non-causal: reassociated == n x n form: True
causal:     recurrence  == masked n x n form: True
relative difference from softmax attention: 0.84

     n softmax ms linear ms flops ratio n/d
   512        6.1      0.45              16
  2048      140.4      2.84              64
  8192     8723.9     14.99             256
```

- The re-associated form matches the explicit $n\times n$ form, and the recurrence matches the causal masked form. These are exact identities, not approximations.
- Linear attention differs from softmax attention on the same $Q, K, V$ by 84%. It is a **different model**, with its own trained weights, not a fast approximation of a pretrained softmax model. Its fixed-size state also has to compress the whole past, a known source of weaker recall on retrieval-heavy tasks.
- The timing gap grows like $n/d$, as the flop count predicts. At $n = 8192$ the softmax form also pays for a 512 MB $n\times n$ matrix in float64.

---

## 4. Low-rank updates: LoRA and Eckart–Young

Fine-tuning changes a pretrained weight $W_0 \in \mathbb R^{d_{out}\times d_{in}}$ by some $\Delta W$. **LoRA** (Hu et al., 2021) constrains the change to rank $r$:

$$
W = W_0 + BA, \qquad B \in \mathbb R^{d_{out}\times r},\; A \in \mathbb R^{r\times d_{in}},\; r \ll \min(d_{in}, d_{out}).
$$

$W_0$ stays frozen and only $A$ and $B$ train, $r(d_{in}+d_{out})$ numbers instead of $d_{in}d_{out}$. $B$ starts at zero, so training starts exactly at the pretrained model. After training, $BA$ can be added into $W_0$ once, at no inference cost. The survey writes the same update as $W_0 + AB$ with the roles of the letters swapped.

What can rank $r$ capture? Eckart–Young answers exactly. The best rank-$r$ approximation of $\Delta W$ in Frobenius norm is its truncated SVD, with relative error $\sqrt{\sum_{i>r}\sigma_i^2 / \sum_i \sigma_i^2}$. LoRA works when the useful part of a fine-tuning update has a fast-decaying spectrum. The LoRA paper measured this directly, finding that the learned updates have very low "intrinsic rank".

### Worked example 4 — counts, the Eckart–Young limit, and reaching it

```python
# file: lora_lowrank.py
# LoRA's update W = W0 + B A (B: d_out x r, A: r x d_in) in numbers: trainable-parameter
# counts for Llama-3-8B, the Eckart-Young limit on what rank r can represent, and a
# check that gradient descent on (A, B) from LoRA's B = 0 start reaches that limit.
import numpy as np

# 1) Trainable parameters, Llama-3-8B (d=4096, kv dim 1024, d_ff=14336, 32 layers)
d, kv, f, L, r = 4096, 1024, 14336, 32, 16
shapes = {"q": (d, d), "k": (kv, d), "v": (kv, d), "o": (d, d),
          "gate": (f, d), "up": (f, d), "down": (d, f)}
lora = lambda names: L * sum(r * (shapes[m][0] + shapes[m][1]) for m in names)
print(f"r={r}: q,v only {lora(['q', 'v']):,} ({100 * lora(['q', 'v']) / 8_030_261_248:.3f}% of 8.03B); "
      f"all 7 projections {lora(shapes):,} ({100 * lora(shapes) / 8_030_261_248:.2f}%)")

# 2) Eckart-Young: the best rank-r approximation error depends only on the spectrum
rng = np.random.default_rng(2)
n = 512
print(f"\nbest relative error ||dW - dW_r||_F / ||dW||_F for a {n}x{n} update")
print(f"{'spectrum':22} {'r=4':>6} {'r=16':>6} {'r=64':>6}")
for label, s in (("sigma_i = i^-2", np.arange(1, n + 1) ** -2.0),
                 ("sigma_i = i^-1", np.arange(1, n + 1) ** -1.0),
                 ("sigma_i = i^-0.5", np.arange(1, n + 1) ** -0.5),
                 ("flat (noise-like)", np.ones(n))):
    errs = [np.sqrt(np.sum(s[k:] ** 2) / np.sum(s**2)) for k in (4, 16, 64)]
    print(f"{label:22} " + " ".join(f"{e:6.3f}" for e in errs))

# 3) Fit W0 + B A to a target by gradient descent, starting from B = 0 as LoRA does
n, r = 128, 8
s = np.arange(1, n + 1) ** -1.0
U, _ = np.linalg.qr(rng.standard_normal((n, n)))
Vt, _ = np.linalg.qr(rng.standard_normal((n, n)))
dW = (U * s) @ Vt                                       # the update a full fine-tune would make
A = rng.standard_normal((r, n)) / np.sqrt(n)            # LoRA: A random, B zero -> W = W0 at step 0
B = np.zeros((n, r))
lr = 0.5
for step in range(4001):
    R = B @ A - dW                                      # residual of the update
    if step in (0, 100, 1000, 4000):
        print(f"step {step:4d}: relative error {np.linalg.norm(R) / np.linalg.norm(dW):.4f}")
    gB, gA = R @ A.T, B.T @ R                           # gradients of 0.5 ||B A - dW||_F^2
    B -= lr * gB
    A -= lr * gA
best = np.sqrt(np.sum(s[r:] ** 2) / np.sum(s**2))
print(f"Eckart-Young optimum for r={r}: {best:.4f}")
```

```bash
python lora_lowrank.py
```

Output:

```text
r=16: q,v only 6,815,744 (0.085% of 8.03B); all 7 projections 41,943,040 (0.52%)

best relative error ||dW - dW_r||_F / ||dW||_F for a 512x512 update
spectrum                  r=4   r=16   r=64
sigma_i = i^-2          0.057  0.008  0.001
sigma_i = i^-1          0.365  0.189  0.091
sigma_i = i^-0.5        0.833  0.710  0.551
flat (noise-like)       0.996  0.984  0.935
step    0: relative error 1.0000
step  100: relative error 0.3480
step 1000: relative error 0.2607
step 4000: relative error 0.2589
Eckart-Young optimum for r=8: 0.2589
```

- Rank 16 on the query and value projections of Llama-3-8B trains 6.8 million parameters, 0.085% of the model. Applying it to all seven projections is still about half a percent.
- The spectrum decides everything. With $\sigma_i = i^{-2}$, rank 4 already captures all but 6% of the update. With a flat spectrum, which is what noise looks like, rank 64 out of 512 leaves 93% uncaptured.
- Plain gradient descent on the two factors, from LoRA's $B = 0$ start, converges to the Eckart–Young optimum (0.2589) even though the problem is nonconvex in $(A, B)$. This is a known property of low-rank matrix factorization: its local minima are global. It is why the "only train a thin product" idea is benign in practice.

---

## 5. Preconditioning when the gradient is a matrix

For a weight matrix $W \in \mathbb R^{m\times n}$ the gradient $G$ is also $m\times n$. A full second-order preconditioner would be $mn\times mn$, about $2.8\times 10^{14}$ entries for one $4096\times 4096$ layer, so every practical method imposes structure:

| Method | Preconditioner | Storage |
|---|---|---|
| Adagrad / Adam | diagonal, $(\sum g^2)^{-1/2}$ elementwise | $mn$ |
| K-FAC (Martens–Grosse) | Fisher block $\approx \mathbb E[aa^\top]\otimes\mathbb E[gg^\top]$, inverted factor by factor | $m^2+n^2$ |
| Shampoo (Gupta–Koren–Singer) | $W \leftarrow W - \eta\,L^{-1/4}GR^{-1/4}$, $L = \sum GG^\top$, $R = \sum G^\top G$ | $m^2+n^2$ |
| Muon (Jordan et al.) | $W \leftarrow W - \eta\,\operatorname{NS}_5(M)$, $M$ = momentum of $G$ | $mn$ |

The bridge between the last two rows is the **polar factor**. With no accumulation ($L = GG^\top$, $R = G^\top G$) and $G = U\Sigma V^\top$:

$$
L^{-1/4}GR^{-1/4} = U\Sigma^{-1/2}U^\top\, U\Sigma V^\top\, V\Sigma^{-1/2}V^\top = UV^\top.
$$

Shampoo without memory **orthogonalizes** the gradient: it keeps the singular directions and sets every singular value to 1. Bernstein and Newhouse (2024) read this as steepest descent under the spectral norm. Muon computes the orthogonalization directly, without any eigendecomposition, using a **Newton–Schulz** iteration. That is an odd matrix polynomial $X \leftarrow aX + b(XX^\top)X + c(XX^\top)^2X$, which acts on each singular value $\sigma$ as the scalar map $p(\sigma) = a\sigma + b\sigma^3 + c\sigma^5$ while leaving $U$ and $V$ alone. The classical cubic $(a, b, c) = (1.5, -0.5, 0)$ converges quadratically to $UV^\top$ once every $\sigma$ is near 1, but takes many steps to lift small singular values. Muon's quintic coefficients $(3.4445, -4.7750, 2.0315)$ were tuned to lift small singular values fast. The price is that they converge to a **band** around 1, not to 1.

### Worked example 5 — Shampoo, SVD, and two Newton–Schulz iterations

```python
# file: muon_ns.py
# Matrix preconditioning in three ways: Shampoo's L^-1/4 G R^-1/4, the SVD polar factor
# U V^T, and Newton-Schulz polynomial iterations (cubic, and Muon's tuned quintic) that
# use only matrix products.
import numpy as np

rng = np.random.default_rng(3)
m, n = 256, 128
U, _ = np.linalg.qr(rng.standard_normal((m, n)))
V, _ = np.linalg.qr(rng.standard_normal((n, n)))
sig = np.logspace(0, -3, n)                              # singular values from 1 down to 1e-3
G = (U * sig) @ V.T                                      # a "gradient" with a wide spectrum
polar = U @ V.T                                          # the target: U V^T


def inv_root(M, p, eps=1e-12):
    w, Q = np.linalg.eigh(M)
    return (Q * np.maximum(w, eps) ** (-1 / p)) @ Q.T


shampoo = inv_root(G @ G.T, 4) @ G @ inv_root(G.T @ G, 4)
print(f"Shampoo one-step L^-1/4 G R^-1/4 vs U V^T: rel. error {np.linalg.norm(shampoo - polar) / np.linalg.norm(polar):.1e}")


def newton_schulz(G, steps, coeffs):
    a, b, c = coeffs
    X = G / np.linalg.norm(G)                            # Frobenius norm puts all sigma <= 1
    for _ in range(steps):
        A = X @ X.T
        X = a * X + (b * A + c * A @ A) @ X              # odd polynomial in the singular values
    return X


print(f"\n{'iteration':24} {'steps':>5} {'min sigma':>9} {'max sigma':>9} {'rel. err vs UV^T':>16} {'matmuls':>7}")
for name, coeffs, steps_list, mm in (("cubic (1.5, -0.5, 0)", (1.5, -0.5, 0.0), (5, 10, 20, 30), 2),
                                     ("Muon quintic", (3.4445, -4.7750, 2.0315), (5, 10), 3)):
    for steps in steps_list:
        X = newton_schulz(G, steps, coeffs)
        s = np.linalg.svd(X, compute_uv=False)
        err = np.linalg.norm(X - polar) / np.linalg.norm(polar)
        print(f"{name:24} {steps:5d} {s.min():9.3f} {s.max():9.3f} {err:16.3f} {mm * steps:7d}")

# What the quintic does to one singular value, starting from sigma / ||G||_F
p = lambda s: 3.4445 * s - 4.7750 * s**3 + 2.0315 * s**5
s0 = np.logspace(-4, 0, 9) / np.linalg.norm(sig)
s5 = s0.copy()
for _ in range(5):
    s5 = p(s5)
print("\nquintic, 5 steps:  " + "  ".join(f"{a:.1e}->{b:.2f}" for a, b in zip(s0[::2], s5[::2])))
```

```bash
python muon_ns.py
```

Output:

```text
Shampoo one-step L^-1/4 G R^-1/4 vs U V^T: rel. error 1.6e-09

iteration                steps min sigma max sigma rel. err vs UV^T matmuls
cubic (1.5, -0.5, 0)         5     0.002     0.998            0.813      10
cubic (1.5, -0.5, 0)        10     0.019     1.000            0.612      20
cubic (1.5, -0.5, 0)        20     0.817     1.000            0.031      40
cubic (1.5, -0.5, 0)        30     1.000     1.000            0.000      60
Muon quintic                 5     0.155     1.202            0.356      15
Muon quintic                10     0.682     1.134            0.206      30

quintic, 5 steps:  3.2e-05->0.02  3.2e-04->0.16  3.2e-03->1.14  3.2e-02->1.13  3.2e-01->1.13
```

- One-step Shampoo reproduces $UV^\top$ to $10^{-9}$, confirming the identity above.
- The cubic iteration needs about 30 steps (60 matrix products) when singular values span three decades. After 5 steps the smallest are still near 0.002.
- Muon's quintic lifts the smallest singular value from about $10^{-4}$ (after the Frobenius scaling) to 0.16 in 5 steps and puts everything else in $[0.68, 1.2]$. It is **not** an accurate polar decomposition (error 0.36 against $UV^\top$), and 10 steps do not fix that because the iteration oscillates inside the band. For an optimizer this is a good trade: the update direction is what matters, 5 steps cost 15 products that run well in bfloat16 on tensor cores, and no SVD is ever needed. Muon's reference implementation also transposes tall matrices so that $XX^\top$ is the smaller Gram matrix.

The survey notes the practical outcome: a distributed Shampoo won the 2024 AlgoPerf training-algorithms competition, and Muon-family optimizers have since been used to train large models (Liu et al., 2025).

---

## 6. Pitfalls

| Pitfall | Symptom | Fix |
|---|---|---|
| Counting parameters with another architecture's habits | Totals that match no checkpoint | Derive from `config.json`; check against published totals |
| "Attention matrices are low rank" | Wrong conclusions about compressibility of $P$ | $S$ has rank $\le d_h$; $P$ is generically full rank, numerically rank-varying |
| Treating linear attention as a drop-in approximation | Large output differences on a pretrained model | It is a different operator; train with it |
| Expecting LoRA to capture any update | Poor results on tasks needing broad change | Check the spectrum of a full fine-tune delta, or raise $r$ |
| Thinking Muon computes an exact polar factor | Confusion when singular values are not 1 | The tuned quintic targets a band; use the cubic or an SVD for exact $UV^\top$ |
| Forming $mn\times mn$ preconditioners | Memory blow-up | Kronecker or two-sided structure ($m^2+n^2$) or orthogonalization ($mn$) |
| Fractional matrix powers without damping | NaNs from tiny eigenvalues | Add $\epsilon I$ (Shampoo initializes $L, R = \epsilon I$) |

---

## 7. Checkpoint

- Write the per-block parameter count of a Llama-style decoder and explain why the MLP dominates.
- Prove $\operatorname{rank}(QK^\top) \le d_h$, and explain why that bound does not carry over to $\operatorname{softmax}(QK^\top)$.
- Show that each attention output row is a convex combination of value rows.
- Derive the flop counts of $(QK^\top)V$ and $Q(K^\top V)$, and write causal linear attention as a recurrence.
- State Eckart–Young, and use it to say what rank-$r$ LoRA can and cannot represent.
- Show that $L^{-1/4}GR^{-1/4} = UV^\top$ when $L = GG^\top$ and $R = G^\top G$.
- Explain what a Newton–Schulz iteration does to singular values, and why Muon's coefficients do not converge to exactly 1.

---

## Exercises

### Easy

1. Using `llm_params.py`, count a model with $d = 8192$, $d_{ff} = 28672$, 80 layers, 64 heads, 8 KV heads and $V = 128256$ (the Llama-3-70B shape). What fraction is MLP?
2. For $d_h = 128$, above what sequence length is $Q(K^\top V)$ cheaper than $(QK^\top)V$?
3. How many trainable parameters does rank-8 LoRA add to one $4096\times 14336$ matrix?

### Medium

4. Show that softmax is invariant to adding a constant to each row of $S$, and use this to explain the `S - S.max(1, keepdims=True)` line.
5. Prove that for $X_0 = G/\lVert G\rVert_F$, every singular value of $X_0$ is at most 1. Why does the cubic Newton–Schulz iteration need that?
6. Modify `attention_rank.py` to use a causal mask. Is $P$ still full rank? (Hint: it becomes lower triangular with a positive diagonal.)
7. In `lora_lowrank.py`, replace the target spectrum by $\sigma_i = i^{-1}$ plus Gaussian noise of relative size 5%. How does the achievable error at $r = 8$ change, and does gradient descent still reach it?

### Challenge

8. Show that the K-FAC approximation $\mathbb E[(aa^\top)\otimes(gg^\top)] \approx \mathbb E[aa^\top]\otimes\mathbb E[gg^\top]$ is exact when $a$ and $g$ are independent, and give a two-variable example where it fails.
9. Find coefficients $(a, b, c)$ that maximize $p'(0) = a$ subject to $p$ mapping $[0, 1]$ into $[0.7, 1.3]$ after 5 iterations, and compare with Muon's.
10. Implement Shampoo with exponential moving averages of $GG^\top$ and $G^\top G$ on a least-squares problem $\min_W \lVert XW - Y\rVert_F^2$ with an ill-conditioned $X$, and compare its iteration count with gradient descent and with the orthogonalized update.

---

## Summary

The parameters of a Llama-style model can be counted exactly from its configuration, and most of them sit in the MLP. Counting biases and norm shifts that do not exist is an easy error, and it appears even in careful surveys. An attention head's scores have rank at most $d_h$, but the softmax makes the attention matrix full rank, with an effective rank set by temperature. The softmax is also what forces the $n^2$ cost. Remove it with a factorizable kernel and re-associate, and attention becomes linear in $n$, a recurrence with a fixed-size state, at the price of being a different model. LoRA's rank-$r$ updates are justified by Eckart–Young and by the fast-decaying spectra of fine-tuning updates, and gradient descent on the factors reaches the best rank-$r$ approximation. Matrix-shaped gradients admit structured preconditioners: Kronecker factors (K-FAC), two-sided roots (Shampoo), or plain orthogonalization (Muon). Newton–Schulz iterations compute the last with nothing but matrix products, deliberately trading exactness for speed.

---

## Sources (for further reading)

- A. Baggag, Y. Saad, "The Numerical Linear Algebra of Large Language Models", arXiv:2610.04631 (2026). §3.4.5 (rank bottleneck), §3.11.3 (parameter counting, Tables 3–4), §4.2 (LoRA), §4.3 (linear transformers), §5.3–5.5 (K-FAC, Shampoo, Muon).
- A. Vaswani et al., "Attention Is All You Need", NeurIPS 2017.
- Llama Team, "The Llama 3 Herd of Models", arXiv:2407.21783. Model `config.json` files and published parameter totals on Hugging Face (`meta-llama/Meta-Llama-3-8B`, `meta-llama/Llama-3.1-405B`).
- S. Bhojanapalli et al., "Low-Rank Bottleneck in Multi-head Attention Models", ICML 2020 (arXiv:2002.07028).
- A. Katharopoulos et al., "Transformers are RNNs: Fast Autoregressive Transformers with Linear Attention", ICML 2020 (arXiv:2006.16236). Z. Shen et al., "Efficient Attention: Attention with Linear Complexities", WACV 2021 (arXiv:1812.01243).
- E. J. Hu et al., "LoRA: Low-Rank Adaptation of Large Language Models", ICLR 2022 (arXiv:2106.09685). C. Eckart, G. Young, "The approximation of one matrix by another of lower rank", *Psychometrika* 1 (1936).
- J. Martens, R. Grosse, "Optimizing Neural Networks with Kronecker-factored Approximate Curvature", ICML 2015 (arXiv:1503.05671).
- V. Gupta, T. Koren, Y. Singer, "Shampoo: Preconditioned Stochastic Tensor Optimization", ICML 2018 (arXiv:1802.09568). MLCommons AlgoPerf 2024 results.
- K. Jordan et al., "Muon: An optimizer for hidden layers in neural networks" (2024), https://kellerjordan.github.io/posts/muon/. J. Bernstein, L. Newhouse, "Old Optimizer, New Norm: An Anthology", arXiv:2409.20325. J. Liu et al., "Muon is Scalable for LLM Training", arXiv:2502.16982.
- N. J. Higham, *Functions of Matrices: Theory and Computation* (SIAM, 2008), ch. 8 (polar decomposition, Newton–Schulz).

**Inspiration (not a source):** the SIAM Activity Group on Dynamical Systems' post on X sharing the Baggag–Saad survey, https://x.com/DynamicsSIAM/status/2107370387306651968. The survey itself is cited above as a secondary source; the claims here are checked against the primary papers and checkpoints.
