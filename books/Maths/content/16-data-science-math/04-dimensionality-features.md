# Dimensionality, Features, and the Curse

High-dimensional data is normal in text, images, and logs. Geometry changes: distances concentrate, nearest neighbors weaken, and **feature design** often matters more than the choice among similar models.

## Diagram: curse sketch

```text
  d=1     points spread on a line
  d=2     square
  d=3     cube
  d large volume concentrates near the "shell"
            most mass far from center
```

## 1. The curse of dimensionality (geometry)

In high $d$, several effects appear for “typical” random data:

1. **Volume concentration:** most of a high-$d$ ball’s volume is near the surface  
2. **Distance concentration:** pairwise distances between random points become relatively similar  
3. **Sparsity:** fixed $n$ samples cover $[0,1]^d$ vanishingly; local neighborhoods empty  

Consequence: k-NN, distance-based density, and some clustering methods degrade unless structure (manifold, sparsity, metric learning) is exploited.

### Worked example 1 — intuition

In high $d$, ratio of max to min distance among random pairs often approaches $1$ — “nearest” and “farthest” neighbors hard to distinguish.

### When the curse is milder

- Data lie near a low-dimensional **manifold**  
- Features are sparse (few nonzeros per row)  
- Strong signal in few coordinates  
- Task uses inner products / learned metrics, not raw Euclidean distance  

## 2. Feature types and encodings

| Type | Examples | Encoding notes |
|------|----------|----------------|
| Numeric | age, latency | scale / normalize; watch outliers |
| Categorical | country | one-hot / target / embeddings |
| Ordinal | rating 1–5 | not always linear spacing |
| Text | tokens | BoW, TF-IDF, embeddings |
| Time | timestamps | cyclic (sin/cos), lags, calendars |
| IDs | user_id | embeddings; rare IDs → unk |
| Multi-hot | tags | sparse binary vector |

### Worked example 2 — one-hot countries

$200$ countries ⇒ $d\approx 200$ binary features (or $199$ with a reference level in regression). High cardinality (millions of IDs) makes one-hot impractical — prefer embeddings or hashing.

## 3. Scaling and leakage

**Standardize:** $(x-\mu)/\sigma$ per feature.  
**Min-max:** map to $[0,1]$.  
**Robust:** median / IQR for heavy tails.

| Models sensitive to scale | Often less sensitive |
|---------------------------|----------------------|
| Linear / logistic / SVM / k-NN / k-means / neural nets / PCA | Tree ensembles (axis-aligned splits) |

**Leakage rule:** fit scalers, imputers, PCA, target encoders on **train only**, then apply to val/test. Using full-data $\mu,\sigma$ leaks future information into training transforms.

### Worked example 3 — PCA scaling

PCA maximizes variance. A feature measured in milliseconds (large numbers) dominates one in kilometers if unscaled — not because it is more informative.

## 4. Dimensionality reduction map

```text
  raw features R^d
       │
       ├── PCA / SVD (linear subspace)
       ├── random projections (JL lemma)
       ├── feature selection (filter / wrapper)
       └── learned embeddings (nonlinear)
              │
              v
         R^k  k ≪ d   for viz / speed / denoise
```

**PCA:** directions of maximum variance (see advanced LA / SVD chapters).  
**Johnson–Lindenstrauss:** random projections can preserve pairwise distances approximately with $k=\mathcal{O}(\varepsilon^{-2}\log n)$.  
**Feature selection:** drop coordinates; MI / regularization / tree importances (careful with interpretation).

## 5. Feature crosses and interactions

A linear model on $[x_1,x_2]$ cannot represent an AND-like interaction $x_1 x_2$ without an explicit product feature or a nonlinear model (trees, nets, kernels).

### Worked example 4

Spam: “free” and “money” each mild; co-occurrence strong. Cross feature $\mathbf{1}_{\mathrm{free}}\cdot\mathbf{1}_{\mathrm{money}}$ or use a model that builds interactions.

## 6. Sparsity

One-hot, n-grams, multi-hot tags ⇒ sparse high-$d$ vectors.

- Algorithms: sparse matrix formats, sparse-aware linear models  
- Regularization: $L_1$ selects features; elastic net for correlated groups  
- Hashing trick: map tokens to $2^b$ bins with collisions — controlled approximation  

## 7. Metrics: when Euclidean fails

| Similarity | Use when |
|------------|----------|
| Euclidean | dense, scaled numeric |
| Cosine | text BoW / TF-IDF (direction > length) |
| Manhattan | some sparse / robust settings |
| Learned (Mahalanobis, metric learning) | task-specific distances |

### Worked example 5 — cosine for documents

Long documents have larger BoW counts; cosine normalizes length so similarity is about relative word composition.

## 8. The “average distance to k-NN” trap

In high $d$, novelty scores based on distance to neighbors can become uninformative as distances concentrate. Prefer:

- Domain features  
- Dimensionality reduction first  
- One-class models with appropriate kernels  
- Reconstruction error of autoencoders / PCA (with caveats)  

## 9. Embeddings vs one-hot

| One-hot | Embedding |
|---------|-----------|
| No notion of similarity between levels | Learned similarity |
| $d=\#$ levels | $d=$ embedding dim (small) |
| Interpretable coefficients | Dense geometry |
| Great for low cardinality | High-cardinality IDs, words, items |

### Worked example 6

User IDs: millions of levels. Embedding dim $32$–$128$ common in recommenders; cold-start needs defaults / content features.

## 10. Pipeline checklist

1. Define label and unit of analysis  
2. Split train/val/test **before** heavy featurization that needs fit  
3. Encode categoricals; handle unknowns  
4. Scale if model requires  
5. Optional: select / reduce dimensions on train  
6. Fit model; evaluate on held-out with same transforms  
7. Inspect errors; iterate features  

## 11. Pitfalls

1. Scaling with full-data statistics  
2. Target encoding without CV (leakage)  
3. Huge one-hots into dense neural nets without embeddings  
4. Interpreting PCA components as causal factors  
5. k-NN in raw high-$d$ Euclidean space  
6. Dropping rare categories inconsistently between train and serve  

## 12. Checkpoint

- Explain distance concentration  
- Choose encodings for numeric / categorical / text  
- Scale with train-only fit  
- Sketch PCA vs embeddings vs selection  
- Know when cosine beats Euclidean  
- State leakage risks in feature pipelines  

## Exercises

### Easy

1. Why is cosine similarity common for text bags-of-words?  
2. If all features are one-hot countries (200 levels), what is $d$ roughly?  
3. Give one reason to standardize before PCA.  
4. Explain train-only fitting of scalers (no leakage).  
5. Sketch when embeddings beat one-hot for high-cardinality IDs.  

### Medium

6. **Thought:** In high $d$, why might “average distance to 10-NN” stop being a good novelty score?  
7. Feature cross: write a linear model that includes $x_1,x_2,x_1 x_2$.  
8. Hashing trick: what happens when two tokens collide?  
9. Compare $L_1$ vs $L_2$ regularization for sparse one-hot features.  
10. Time feature: encode hour of day with sin/cos; why not integer $0..23$ alone for linear models?  

### Challenge

11. JL lemma idea: why random projections preserve distances with high probability (statement-level).  
12. Show that for i.i.d. standard Gaussian coordinates, $\|x\|_2/\sqrt{d}\to 1$ in probability — concentration sketch.  
13. Design a leakage-safe target encoding with $K$-fold scheme.  
14. Manifold assumption: how does it reconcile high ambient $d$ with successful k-NN on images?  
15. End-to-end: propose features for churn prediction; mark which need fit-on-train only.  

## Checks

1. Direction matters more than length; normalizes document length.  
2. $\approx 200$ (or $199$ with reference level).  
3. PCA is not scale-invariant; large-scale features dominate variance.  

## Summary

High dimension changes geometry and stress-tests naive distance methods. Strong pipelines encode features carefully, scale without leakage, reduce or embed when needed, and pick metrics that match the data type. Feature design remains a primary lever in data science math — models only see the representation you build.
