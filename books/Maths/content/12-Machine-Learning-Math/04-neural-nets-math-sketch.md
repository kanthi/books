# Neural Networks: A Mathematical Sketch

A neural net is a **composition of affine maps and nonlinearities**. Depth creates hierarchical features; training uses gradients of a scalar loss.

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

- **Affine:** $z=Wx+b$
- **Activation $\sigma$:** ReLU $\max(0,z)$, sigmoid, tanh, GELU, …
- **Layers:** stack; residual links $x+F(x)$ ease deep training

**Universal approximation (intuition):** shallow nets with enough width can approximate continuous functions on compact sets; deep nets often need fewer parameters for structured tasks.

## 2. Parameter count

Dense layer $d\to h$: $dh+h$ parameters (weights + biases).  
Stacking multiplies capacity and cost.

## 3. Jacobian / local linearization

Near a point, $f(x+\delta)\approx f(x)+J_f(x)\delta$.  
Backprop multiplies Jacobians efficiently without forming full matrices when the output is scalar loss.

## 4. Vanishing / exploding gradients

Products of many Jacobians can shrink/grow exponentially with depth.

Mitigations (conceptual): residual connections, normalization layers, careful init, gated architectures.

```text
  ∂ℓ/∂ early layer  ≈  (many matrices) × ∂ℓ/∂ late
                       │
            singular values <1 ──► vanish
            singular values >1 ──► explode
```

## 5. Overfitting and capacity

More parameters + flexible $\sigma$ ⇒ can interpolate noise.  
Control with data, weight decay, dropout (as noise), early stopping, architecture constraints.

## 6. What math to study next

| Topic | Why |
|-------|-----|
| Matrix calc | gradients w.r.t. $W$ |
| Probability | losses as likelihoods |
| Optimization | SGD, momentum, Adam |
| Linear algebra | attention as similarity, PCA of activations |

## Exercises

1. Count parameters of MLP: $10\to 32\to 32\to 1$ with biases.  
2. Compute ReLU derivative almost everywhere.  
3. Why is identity activation stacked still just one affine map?  
4. Sketch how residual $y=x+F(x)$ changes the “multiply many Jacobians” story.  
5. Name two reasons mini-batch SGD is used instead of full-batch GD on big data.

## Checks

1. $10\cdot32+32 + 32\cdot32+32 + 32\cdot1+1=32\cdot(10+32+1)+32+32+1=1473$.  
3. Composition of affines is affine.
