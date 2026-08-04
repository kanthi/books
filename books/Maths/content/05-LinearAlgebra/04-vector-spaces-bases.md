# Vector Spaces, Spans, and Bases

Beyond arrows in the plane: a **vector space** is any set where addition and scalar multiplication behave like vectors. **Bases** give coordinates; **dimension** is the size of a basis. This is the language of solutions to linear systems, signal spaces, and feature spaces in ML.

## Diagram: span and basis

```text
  two vectors in R^2 that are not collinear:

           ^ b
          /
         /
        +------→ a

  span{a,b} = whole plane

  basis = linearly independent spanning set
  dim = number of vectors in any basis
```

## 1. Vector space axioms (intuition)

A set $V$ with addition $+$ and scalar multiplication by $\mathbb{R}$ (or $\mathbb{C}$) is a **vector space** if:

1. **Closure:** $u,v\in V$, $\alpha\in\mathbb{R}$ ⇒ $u+v\in V$ and $\alpha u\in V$  
2. **Associativity / commutativity** of $+$  
3. **Zero vector** $0\in V$ with $u+0=u$  
4. **Additive inverses** $-u$ with $u+(-u)=0$  
5. **Scalar rules:** $1\cdot u=u$, $(\alpha\beta)u=\alpha(\beta u)$  
6. **Distributivity:** $\alpha(u+v)=\alpha u+\alpha v$, $(\alpha+\beta)u=\alpha u+\beta u$

You do not need to memorize a theatrical list every time — check closure, zero, and inverses first; the rest usually follow for standard constructions.

### Standard examples

| Space | Vectors | Operations |
|-------|---------|------------|
| $\mathbb{R}^n$ | $n$-tuples | componentwise |
| $M_{m\times n}$ | matrices | entrywise $+$ / scalar |
| $P_d$ | polynomials degree $\le d$ | usual $+$ / scalar |
| $C[0,1]$ | continuous functions | $(f+g)(x)=f(x)+g(x)$ |
| $\ker A$ | solutions of $Ax=0$ | same as ambient |

### Non-examples

- Positive reals $\mathbb{R}_{>0}$ with ordinary $+$ (no zero, no inverses in the set)  
- Unit circle with ordinary vector addition (not closed)  
- $\{(x,y):xy=1\}$ (hyperbola; not closed under $+$)

### Worked example 1 — function space

$f(x)=x^2$ and $g(x)=\sin x$ live in a huge vector space of functions; $3f-2g$ is another function. Coordinates need a basis (e.g. monomials, Fourier) — infinite-dimensional territory.

## 2. Subspaces

$W\subseteq V$ is a **subspace** if $W$ itself is a vector space under the same operations. Practical test:

1. $0\in W$  
2. Closed under $+$ and scalar multiplication  

**Equivalent:** closed under all linear combinations $\alpha u+\beta v$.

### Fundamental subspaces of a matrix $A\in\mathbb{R}^{m\times n}$

| Name | Definition | Ambient |
|------|------------|---------|
| Column space $\mathrm{col}(A)$ | span of columns | $\mathbb{R}^m$ |
| Row space $\mathrm{row}(A)$ | span of rows | $\mathbb{R}^n$ |
| Nullspace / kernel $\ker(A)$ | $\{x:Ax=0\}$ | $\mathbb{R}^n$ |
| Left nullspace $\ker(A^\top)$ | $\{y:A^\top y=0\}$ | $\mathbb{R}^m$ |

### Worked example 2 — plane through origin

$W=\{(x,y,z):x+y+z=0\}$ is a subspace of $\mathbb{R}^3$.  
$W'=\{(x,y,z):x+y+z=1\}$ is **not** (misses $0$; affine plane).

## 3. Linear combinations and span

$$
\mathrm{span}\{v_1,\ldots,v_k\}=\{c_1 v_1+\cdots+c_k v_k:c_i\in\mathbb{R}\}.
$$

Span is always a subspace (the smallest subspace containing the set).

```text
  span of one nonzero vector: a line through 0
  span of two independent vectors in R^3: a plane through 0
  span of three independent vectors in R^3: all of R^3
```

### Worked example 3

$\mathrm{span}\{(1,0),(0,1)\}=\mathbb{R}^2$.  
$\mathrm{span}\{(1,1),(2,2)\}=$ the line $y=x$.

## 4. Linear independence

$\{v_1,\ldots,v_k\}$ is **linearly independent** if

$$
c_1 v_1+\cdots+c_k v_k=0 \implies c_1=\cdots=c_k=0.
$$

Otherwise the set is **dependent**: some vector is a linear combination of the others (redundant for spanning).

### Tests

- Form matrix $V$ with those columns; independent iff $Vx=0$ has only $x=0$ iff columns have pivot in every column (full column rank).  
- In $\mathbb{R}^n$, more than $n$ vectors ⇒ always dependent.  
- Orthogonal nonzero vectors are independent.

### Worked example 4

$v_1=(1,0,1)$, $v_2=(0,1,1)$, $v_3=(1,1,2)$ in $\mathbb{R}^3$.  
$v_3=v_1+v_2$ ⇒ dependent. $\{v_1,v_2\}$ independent (not scalar multiples).

### Worked example 5

$\{(1,1),(2,2)\}$ in $\mathbb{R}^2$: $2\cdot(1,1)+(-1)\cdot(2,2)=0$ ⇒ dependent. Span is still the line $y=x$.

## 5. Basis and dimension

A **basis** of $V$ is a linearly independent spanning set.

**Theorem (finite dimension).** If $V$ has a finite spanning set, then:

- Every basis has the same number of vectors, called $\dim V$  
- Any independent set of size $\dim V$ is a basis  
- Any spanning set of size $\dim V$ is a basis  
- Independent sets extend to bases; spanning sets can be thinned to bases  

| Space | Typical basis | $\dim$ |
|-------|---------------|--------|
| $\mathbb{R}^n$ | standard $e_i$ | $n$ |
| $P_2$ | $\{1,x,x^2\}$ | $3$ |
| $\{x+y+z=0\}$ in $\mathbb{R}^3$ | e.g. $(1,-1,0),(1,0,-1)$ | $2$ |
| $\mathrm{col}\begin{bmatrix}1&2\\2&4\end{bmatrix}$ | e.g. $(1,2)$ | $1$ |

### Coordinates

If $\mathcal{B}=\{b_1,\ldots,b_n\}$ is a basis, every $v$ has **unique** coordinates $c$ with $v=\sum c_i b_i$. Changing basis multiplies coordinates by a transition matrix — core of “change of coordinates” in graphics and spectral methods.

### Worked example 6 — basis of a plane

For $x+y+z=0$: free variables $y=s$, $z=t$, then $x=-s-t$:

$$
\begin{bmatrix}x\\y\\z\end{bmatrix}
=s\begin{bmatrix}-1\\1\\0\end{bmatrix}
+t\begin{bmatrix}-1\\0\\1\end{bmatrix}.
$$

Those two vectors form a basis; $\dim=2$.

## 6. Rank–nullity theorem

For $A\in\mathbb{R}^{m\times n}$ (linear map $x\mapsto Ax$):

$$
\mathrm{rank}(A)+\mathrm{nullity}(A)=n,
$$

where $\mathrm{rank}(A)=\dim\mathrm{col}(A)$ and $\mathrm{nullity}(A)=\dim\ker(A)$.

```text
  domain R^n
     │
     │  A
     v
  R^m
  ker A ──dim──► nullity
  col A ──dim──► rank
  rank + nullity = n
```

**Also:** $\mathrm{rank}(A)=\dim\mathrm{row}(A)=\dim\mathrm{col}(A)$.

### Worked example 7

$A=\begin{bmatrix}1&2\\2&4\end{bmatrix}$: columns multiples ⇒ rank $1$.  
$\ker A$: $x+2y=0$, basis $(2,-1)$, nullity $1$.  
$1+1=2=n$. ✓

### Worked example 8 — underdetermined systems

If $A$ is $3\times 5$ with rank $3$, nullity $2$: solution space to $Ax=b$ (if nonempty) is an affine translate of a 2D nullspace — two free parameters.

## 7. Four fundamental subspaces (preview of structure)

For $A\in\mathbb{R}^{m\times n}$:

$$
\begin{aligned}
\mathbb{R}^n &= \mathrm{row}(A)\oplus \ker(A),\\
\mathbb{R}^m &= \mathrm{col}(A)\oplus \ker(A^\top),
\end{aligned}
$$

with orthogonal complements under the standard dot product. This is Strang’s diagram and underlies least squares: $b$ splits into $\mathrm{col}(A)$ part (fit) and left-null part (residual).

## 8. Linear maps and matrices

A map $T:V\to W$ is **linear** if $T(\alpha u+\beta v)=\alpha T(u)+\beta T(v)$.

Choosing bases of $V$ and $W$ represents $T$ by a matrix $A$. Changing bases conjugates $A$ (similarity when $V=W$). Dimension theorems above are coordinate-free facts about $T$.

## 9. CS / ML map

| Idea | Linear algebra view |
|------|---------------------|
| Feature space | points as vectors in $\mathbb{R}^d$ |
| One-hot categories | standard basis vectors |
| Embeddings | coordinates in a learned frame |
| Null space | non-identifiability / gauge freedom |
| Column space | reachable predictions of a linear model $Xw$ |
| Rank of data matrix | effective dimensionality before noise |
| Word co-occurrence | rows as vectors; rank reduction ≈ PCA/SVD |

### Worked example 9 — collinear features

If two feature columns of $X$ are multiples, $\mathrm{rank}(X)<\#\text{features}$, $\ker(X)$ nontrivial: infinitely many $w$ give the same predictions $Xw$ — regularization picks one.

## 10. Infinite dimensions (awareness)

Function spaces, $\ell^2$ sequences, RKHS in kernel methods: bases can be infinite (Hilbert bases). Finite-dimensional intuition (rank–nullity as stated) needs care; still, “span,” “independence,” and “coordinates in a dictionary” remain the right vocabulary.

## 11. Pitfalls

1. Calling any spanning set a basis (must also be independent)  
2. Forgetting subspaces must contain $0$  
3. Confusing affine spaces (solutions to $Ax=b$) with subspaces ($Ax=0$)  
4. Thinking dimension is the ambient $n$ rather than $\dim W$  
5. More vectors ⇒ “more independent” — false beyond ambient dimension  

## 12. Checkpoint

- Test subspace membership  
- Decide independence via $Vx=0$  
- Find a basis for a simple nullspace  
- Apply rank–nullity  
- Connect column space to what a linear model can represent  

## Exercises

### Easy

1. Prove $\{0\}$ is a subspace of any $V$.  
2. Are $\{(1,1),(2,2)\}$ independent in $\mathbb{R}^2$? What is their span?  
3. Find a basis for $\{(x,y,z):x+y+z=0\}$.  
4. Show that if more than $n$ vectors sit in $\mathbb{R}^n$, they are dependent.  
5. For $A=\begin{bmatrix}1&2\\2&4\end{bmatrix}$, find rank and a basis for $\ker A$.  

### Medium

6. Prove that the intersection of two subspaces is a subspace. Is the union?  
7. Show $\mathrm{col}(A)=\mathrm{col}(AE)$ if $E$ is invertible (same column space after right-multiplication by invertible).  
8. Find bases for all four fundamental subspaces of $A=\begin{bmatrix}1&1&0\\0&0&1\end{bmatrix}$.  
9. Prove that any independent set in a finite-dimensional space can be extended to a basis (outline).  
10. If $T:\mathbb{R}^n\to\mathbb{R}^m$ is linear and injective, what is $\dim\ker T$?  

### Challenge

11. Prove $\dim(U+W)=\dim U+\dim W-\dim(U\cap W)$ for subspaces of a finite-dimensional space.  
12. Show row rank equals column rank without quoting the theorem name (use RREF structure).  
13. Polynomials: show $\{1,x,x^2,\ldots\}$ is independent in the space of all polynomials.  
14. Connect rank–nullity to “number of free variables after elimination.”  
15. Data matrix $X\in\mathbb{R}^{n\times d}$ with $n<d$ and full row rank: describe $\ker(X)$ dimension and implication for overparameterized least squares.  

## Checks

2. Dependent; span is the line $y=x$.  
5. Rank $1$; $\ker$ spanned by $(2,-1)$.  

## Summary

Vector spaces abstract the algebra of linear combinations. Spans describe reachable sets; independence removes redundancy; bases provide coordinates; dimension is basis size. Rank–nullity balances degrees of freedom in domain against constraints. For CS readers: features, kernels, and linear models are subspace stories — identify the ambient space, the subspace of interest, and a basis when you need coordinates.
