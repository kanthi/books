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

A set $V$ with $+$ and scalar mult is a vector space over $\mathbb{R}$ if:

- closed under $+$ and scalar mult
- $+$ associative, commutative; zero vector $0$; additive inverses
- $1v=v$, and distributive laws hold

**Examples:** $\mathbb{R}^n$, polynomials of degree $\le d$, continuous functions on $[0,1]$, solution set of homogeneous $Ax=0$.

**Non-example:** positive reals with usual $+$ (no zero / inverses in the set).

## 2. Subspaces

$W\subseteq V$ is a subspace if it contains $0$ and is closed under $+$ and scalar mult.

**Kernel** of linear map $T$: $\{v:T(v)=0\}$ is always a subspace.  
**Image** (column space of matrix) is a subspace.

## 3. Linear independence

$\{v_1,\ldots,v_k\}$ independent if

$$
c_1 v_1+\cdots+c_k v_k=0 \implies c_1=\cdots=c_k=0.
$$

Otherwise one vector is a combination of others (redundant).

```text
  independent: no one lies in span of the others
  dependent:   v3 sits in plane of v1,v2 (in R^3)
```

## 4. Span

$$
\mathrm{span}\{v_1,\ldots,v_k\}=\{c_1 v_1+\cdots+c_k v_k:c_i\in\mathbb{R}\}.
$$

## 5. Basis and dimension

A **basis** is a linearly independent spanning set.  
All bases of a finite-dimensional space have the same size = **dimension**.

| Space | Typical basis | dim |
|-------|---------------|-----|
| $\mathbb{R}^n$ | standard $e_i$ | $n$ |
| polynomials deg $\le 2$ | $1,x,x^2$ | $3$ |
| solutions to $x+y+z=0$ in $\mathbb{R}^3$ | e.g. $(1,-1,0),(1,0,-1)$ | $2$ |

## 6. Rank–nullity (preview)

For $A\in\mathbb{R}^{m\times n}$:

$$
\mathrm{rank}(A)+\mathrm{nullity}(A)=n.
$$

$\mathrm{rank}=$ dim column space; $\mathrm{nullity}=$ dim kernel.

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

## 7. Worked example

In $\mathbb{R}^3$, $v_1=(1,0,1)$, $v_2=(0,1,1)$, $v_3=(1,1,2)$.  
$v_3=v_1+v_2$ ⇒ dependent. $\{v_1,v_2\}$ independent and span a plane; not a basis of $\mathbb{R}^3$ (need 3 independent vectors).

## 8. CS / ML map

| Idea | Use |
|------|-----|
| Feature space | points as vectors in $\mathbb{R}^d$ |
| One-hot basis | standard basis for categories |
| Embeddings | coordinates in learned basis-like frames |
| Null space | degrees of freedom / non-identifiability |

## Exercises

1. Prove $\{0\}$ is a subspace of any $V$.
2. Are $\{(1,1),(2,2)\}$ independent in $\mathbb{R}^2$? Span?
3. Find a basis for $\{(x,y,z):x+y+z=0\}$.
4. Show that if more than $n$ vectors in $\mathbb{R}^n$, they are dependent.
5. For $A=\begin{bmatrix}1&2\\2&4\end{bmatrix}$, find rank and a basis for $\ker A$.
6. **Challenge:** Prove any independent set can be extended to a basis in finite dimensions (outline is enough).

## Checks

2. Dependent; span is the line $y=x$.  
5. Rank 1; $\ker$ spanned by $(2,-1)$.
