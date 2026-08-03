# Dimensionality, Features, and the Curse

High-dimensional data is normal in text, images, and logs. Geometry changes: distances concentrate, nearest neighbors weaken, and **feature design** dominates.

## Diagram: curse sketch

```text
  d=1     points spread on a line
  d=2     square
  d=3     cube
  d large volume concentrates near the "shell"
            most mass far from center
```

## 1. Distance concentration (intuition)

In high $d$, pairwise distances between random points become similar — **nearest** and **farthest** neighbors are hard to distinguish. k-NN and distance-based outliers need care (metric learning, dimensionality reduction, different similarities).

## 2. Feature types

| Type | Examples | Encoding notes |
|------|----------|----------------|
| Numeric | age, latency | scale/normalize |
| Categorical | country | one-hot / embeddings |
| Ordinal | rating 1–5 | careful: not always linear |
| Text | tokens | bag-of-words, TF-IDF, embeddings |
| Time | timestamps | cyclic features, lags |

## 3. Scaling

Standardize: $(x-\mu)/\sigma$.  
Min-max to $[0,1]$.  

Tree models often less sensitive; linear models, k-NN, k-means, neural nets **care**.

## 4. Dimensionality reduction map

```text
  raw features R^d
       │
       ├── PCA / SVD (linear subspace)
       ├── projections / random projections
       └── learned embeddings (nonlinear)
              │
              v
         R^k  k ≪ d   for viz / speed / denoise
```

PCA: maximize variance directions (see advanced LA chapters).

## 5. Feature crosses and interactions

Linear model on $[x_1,x_2]$ cannot represent $x_1 x_2$ gate without an explicit product feature or nonlinear model.

## 6. Sparsity

One-hot and n-grams ⇒ sparse high-$d$ vectors. Algorithms should exploit sparsity; regularization ($L_1$) selects features.

## Exercises

1. Why cosine similarity is common for text bags-of-words?  
2. If all features are one-hot countries (200 levels), what is $d$ roughly?  
3. Give one reason to standardize before PCA.  
4. Explain train-only fitting of scalers (no leakage).  
5. **Thought:** In high $d$, why might “average distance to 10-NN” stop being a good novelty score?  
6. Sketch when embeddings beat one-hot for high-cardinality IDs.

## Checks

1. Direction matters more than length; normalizes document length.  
3. PCA is not scale-invariant; big-scale features dominate variance.
