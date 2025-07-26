# Matrices: Organizing and Transforming Linear Information

## Introduction to Matrices

A matrix is a rectangular array of numbers, symbols, or expressions arranged in rows and columns. Matrices provide a compact and powerful way to represent linear transformations, solve systems of equations, and organize multidimensional data.

```
Matrix Fundamentals
══════════════════

Definition: An m × n matrix has m rows and n columns

General Form:
A = [a₁₁  a₁₂  a₁₃  ...  a₁ₙ]
    [a₂₁  a₂₂  a₂₃  ...  a₂ₙ]
    [a₃₁  a₃₂  a₃₃  ...  a₃ₙ]
    [⋮    ⋮    ⋮    ⋱   ⋮  ]
    [aₘ₁  aₘ₂  aₘ₃  ...  aₘₙ]

Notation:
- Capital letters: A, B, C
- Entry notation: aᵢⱼ (row i, column j)
- Size notation: A ∈ ℝᵐˣⁿ

Examples:
2×3 matrix: A = [1   2  -1]
                [3  -1   4]

3×3 matrix: B = [2   0   1]
                [1  -3   2]
                [0   1  -1]

Column vector: v = [3]  (3×1 matrix)
                   [2]
                   [-1]

Row vector: w = [1  4  -2]  (1×3 matrix)
```

## Types of Matrices

### Special Matrix Categories

```
Important Matrix Types
═════════════════════

Square Matrix: m = n (same number of rows and columns)
Example: [1  2]
         [3  4]

Identity Matrix: Square matrix with 1's on diagonal, 0's elsewhere
I₂ = [1  0]    I₃ = [1  0  0]
     [0  1]         [0  1  0]
                    [0  0  1]

Zero Matrix: All entries are 0
O = [0  0  0]
    [0  0  0]

Diagonal Matrix: Non-zero entries only on main diagonal
D = [3  0  0]
    [0 -2  0]
    [0  0  5]

Upper Triangular: All entries below diagonal are 0
U = [2  3  1]
    [0 -1  4]
    [0  0  3]

Lower Triangular: All entries above diagonal are 0
L = [2  0  0]
    [1 -3  0]
    [4  2  1]

Symmetric Matrix: A = Aᵀ (equals its transpose)
S = [1  2  3]
    [2  4  5]
    [3  5  6]

Skew-Symmetric: A = -Aᵀ (diagonal entries are 0)
K = [ 0  2 -1]
    [-2  0  3]
    [ 1 -3  0]
```

### Matrix Dimensions and Indexing

```
Matrix Structure and Access
══════════════════════════

Dimension Rules:
- Matrix A has dimensions m × n
- Entry aᵢⱼ is in row i, column j
- Row index: 1 ≤ i ≤ m
- Column index: 1 ≤ j ≤ n

Row and Column Vectors:
Row i of matrix A: [aᵢ₁  aᵢ₂  ...  aᵢₙ]
Column j of matrix A: [a₁ⱼ]
                      [a₂ⱼ]
                      [⋮  ]
                      [aₘⱼ]

Example: A = [1  2  3]
             [4  5  6]

- A is 2×3 matrix
- a₁₂ = 2 (row 1, column 2)
- a₂₃ = 6 (row 2, column 3)
- Row 1: [1  2  3]
- Column 2: [2]
            [5]

Submatrices:
Extract rectangular portions of larger matrices
Useful for block operations and partitioning

Principal Submatrix:
Square submatrix formed by deleting same rows and columns
Important for eigenvalue analysis
```

## Matrix Operations

### Matrix Addition and Subtraction

Matrix addition and subtraction are performed element-wise and require matrices of the same dimensions.

```
Addition and Subtraction Rules
═════════════════════════════

Requirement: Matrices must have same dimensions

Definition: (A + B)ᵢⱼ = aᵢⱼ + bᵢⱼ
           (A - B)ᵢⱼ = aᵢⱼ - bᵢⱼ

Example:
A = [1  2]    B = [3  1]
    [3 -1]        [2  4]

A + B = [1+3  2+1] = [4  3]
        [3+2 -1+4]   [5  3]

A - B = [1-3  2-1] = [-2  1]
        [3-2 -1-4]   [ 1 -5]

Properties:
- Commutative: A + B = B + A
- Associative: (A + B) + C = A + (B + C)
- Zero matrix: A + O = A
- Additive inverse: A + (-A) = O

Scalar Multiplication:
(cA)ᵢⱼ = c·aᵢⱼ

Example:
3A = 3[1  2] = [3   6]
     [3 -1]   [9  -3]

Properties:
- Distributive: c(A + B) = cA + cB
- Distributive: (c + d)A = cA + dA
- Associative: c(dA) = (cd)A
- Identity: 1A = A
```

### Matrix Multiplication

Matrix multiplication is more complex than addition and follows specific rules about dimensions and computation.

```
Matrix Multiplication Rules
══════════════════════════

Dimension Requirement:
A(m×n) × B(n×p) = C(m×p)
Number of columns in A must equal number of rows in B

Definition:
cᵢⱼ = Σₖ₌₁ⁿ aᵢₖbₖⱼ = aᵢ₁b₁ⱼ + aᵢ₂b₂ⱼ + ... + aᵢₙbₙⱼ

Example:
A = [1  2]    B = [3  1]
    [3 -1]        [2  4]

AB = [1·3 + 2·2   1·1 + 2·4] = [7   9]
     [3·3 + (-1)·2  3·1 + (-1)·4]   [7  -1]

Step-by-step for c₁₁:
c₁₁ = a₁₁b₁₁ + a₁₂b₂₁ = (1)(3) + (2)(2) = 3 + 4 = 7

Matrix-Vector Multiplication:
Ax = b where A is m×n, x is n×1, b is m×1

Example:
[1  2  3][2]   [1·2 + 2·1 + 3·0]   [4]
[4  5  6][1] = [4·2 + 5·1 + 6·0] = [13]
         [0]

Geometric Interpretation:
Matrix multiplication represents composition of linear transformations
Ax transforms vector x according to transformation represented by A
```

### Properties of Matrix Multiplication

```
Matrix Multiplication Properties
══════════════════════════════

Non-Commutative: Generally AB ≠ BA
Example:
A = [1  2]    B = [0  1]
    [0  1]        [1  0]

AB = [2  1]    BA = [0  1]
     [1  0]         [1  2]

Clearly AB ≠ BA

Associative: (AB)C = A(BC)
When dimensions allow, grouping doesn't matter

Distributive:
- A(B + C) = AB + AC (right distributive)
- (A + B)C = AC + BC (left distributive)

Identity Property:
AI = IA = A (when dimensions allow)

Zero Property:
AO = OA = O (when dimensions allow)

Transpose Property:
(AB)ᵀ = BᵀAᵀ (order reverses!)

Block Multiplication:
Matrices can be partitioned into blocks and multiplied block-wise
Useful for large matrices and parallel computation

Example:
[A₁₁  A₁₂][B₁₁  B₁₂] = [A₁₁B₁₁ + A₁₂B₂₁  A₁₁B₁₂ + A₁₂B₂₂]
[A₂₁  A₂₂][B₂₁  B₂₂]   [A₂₁B₁₁ + A₂₂B₂₁  A₂₁B₁₂ + A₂₂B₂₂]
```

## Matrix Transpose

### Definition and Properties

The transpose of a matrix is formed by interchanging rows and columns.

```
Transpose Operation
══════════════════

Definition: (Aᵀ)ᵢⱼ = aⱼᵢ

Example:
A = [1  2  3]    Aᵀ = [1  4]
    [4  5  6]         [2  5]
                      [3  6]

For square matrix:
B = [1  2  3]    Bᵀ = [1  4  7]
    [4  5  6]         [2  5  8]
    [7  8  9]         [3  6  9]

Properties:
- (Aᵀ)ᵀ = A (transpose of transpose is original)
- (A + B)ᵀ = Aᵀ + Bᵀ
- (cA)ᵀ = cAᵀ
- (AB)ᵀ = BᵀAᵀ (order reverses!)

Special Cases:
- Row vector transpose = column vector
- Column vector transpose = row vector
- Symmetric matrix: A = Aᵀ
- Skew-symmetric matrix: A = -Aᵀ

Applications:
- Converting between row and column vectors
- Defining inner products: xᵀy
- Least squares problems: (AᵀA)x = Aᵀb
- Orthogonal matrices: QᵀQ = I
```

## Determinants

### Definition and Calculation

The determinant is a scalar value that provides important information about a square matrix.

```
Determinant Basics
═════════════════

2×2 Determinant:
det(A) = |a  b| = ad - bc
         |c  d|

Example:
A = [3  2]
    [1  4]
det(A) = (3)(4) - (2)(1) = 12 - 2 = 10

3×3 Determinant (Cofactor Expansion):
|a₁₁  a₁₂  a₁₃|
|a₂₁  a₂₂  a₂₃| = a₁₁|a₂₂  a₂₃| - a₁₂|a₂₁  a₂₃| + a₁₃|a₂₁  a₂₂|
|a₃₁  a₃₂  a₃₃|      |a₃₂  a₃₃|      |a₃₁  a₃₃|      |a₃₁  a₃₂|

Example:
A = [2  1  3]
    [1  4  2]
    [3  2  1]

det(A) = 2|4  2| - 1|1  2| + 3|1  4|
          |2  1|    |3  1|    |3  2|
       = 2(4-4) - 1(1-6) + 3(2-12)
       = 2(0) - 1(-5) + 3(-10)
       = 0 + 5 - 30 = -25

Properties:
- det(I) = 1 (identity matrix)
- det(AB) = det(A)det(B)
- det(Aᵀ) = det(A)
- det(cA) = cⁿdet(A) for n×n matrix
- If A has zero row/column, det(A) = 0
- Swapping rows changes sign of determinant
```

### Geometric Interpretation

```
Determinant Geometric Meaning
════════════════════════════

2D Interpretation:
det(A) = signed area of parallelogram formed by column vectors
- Positive: counterclockwise orientation
- Negative: clockwise orientation
- Zero: vectors are parallel (degenerate parallelogram)

3D Interpretation:
det(A) = signed volume of parallelepiped formed by column vectors
- Positive: right-handed orientation
- Negative: left-handed orientation
- Zero: vectors are coplanar (degenerate parallelepiped)

Linear Transformation:
If T is linear transformation with matrix A, then:
|det(A)| = factor by which T scales areas/volumes

Examples:
- det(A) = 2: transformation doubles all areas
- det(A) = 0.5: transformation halves all areas
- det(A) = -1: transformation preserves area but reverses orientation

Invertibility:
Matrix A is invertible if and only if det(A) ≠ 0
- det(A) = 0: matrix is singular (not invertible)
- det(A) ≠ 0: matrix is non-singular (invertible)

Applications:
- Testing linear independence of vectors
- Solving systems using Cramer's rule
- Computing cross products in higher dimensions
- Change of variables in integration
```

## Matrix Inverse

### Definition and Properties

The matrix inverse generalizes the concept of reciprocal to matrices.

```
Matrix Inverse Definition
════════════════════════

For square matrix A, inverse A⁻¹ satisfies:
AA⁻¹ = A⁻¹A = I

Existence Condition:
A⁻¹ exists if and only if det(A) ≠ 0

2×2 Inverse Formula:
A = [a  b]    A⁻¹ = 1/(ad-bc) [ d  -b]
    [c  d]                    [-c   a]

Example:
A = [3  2]
    [1  4]
det(A) = 12 - 2 = 10

A⁻¹ = 1/10 [ 4  -2] = [ 0.4  -0.2]
           [-1   3]   [-0.1   0.3]

Verification:
AA⁻¹ = [3  2][ 0.4  -0.2] = [1  0]
       [1  4][-0.1   0.3]   [0  1] = I

Properties:
- (A⁻¹)⁻¹ = A
- (AB)⁻¹ = B⁻¹A⁻¹ (order reverses!)
- (Aᵀ)⁻¹ = (A⁻¹)ᵀ
- det(A⁻¹) = 1/det(A)
- If A is invertible, then Ax = b has unique solution x = A⁻¹b
```

### Computing Matrix Inverse

```
Methods for Finding Inverse
══════════════════════════

Method 1: Gauss-Jordan Elimination
Set up augmented matrix [A|I] and reduce to [I|A⁻¹]

Example: Find inverse of A = [2  1]
                             [1  1]

[A|I] = [2  1 | 1  0]
        [1  1 | 0  1]

R₁ ↔ R₂: [1  1 | 0  1]
         [2  1 | 1  0]

R₂ - 2R₁: [1  1 | 0  1]
          [0 -1 | 1 -2]

-R₂:      [1  1 | 0  1]
          [0  1 |-1  2]

R₁ - R₂:  [1  0 | 1 -1]
          [0  1 |-1  2]

Therefore: A⁻¹ = [ 1 -1]
                 [-1  2]

Method 2: Adjugate Formula (for small matrices)
A⁻¹ = (1/det(A)) × adj(A)
where adj(A) is adjugate (transpose of cofactor matrix)

Method 3: LU Decomposition
For larger matrices, factor A = LU and solve:
- Ly = b (forward substitution)
- Ux = y (backward substitution)

Computational Considerations:
- Direct inversion is expensive: O(n³) operations
- Often better to solve Ax = b directly
- Numerical stability issues for ill-conditioned matrices
- Use specialized algorithms for structured matrices
```

## Systems of Linear Equations

### Matrix Representation

Systems of linear equations can be compactly represented using matrices.

```
System Representation
════════════════════

General System:
a₁₁x₁ + a₁₂x₂ + ... + a₁ₙxₙ = b₁
a₂₁x₁ + a₂₂x₂ + ... + a₂ₙxₙ = b₂
⋮
aₘ₁x₁ + aₘ₂x₂ + ... + aₘₙxₙ = bₘ

Matrix Form: Ax = b

where A = [a₁₁  a₁₂  ...  a₁ₙ]  (coefficient matrix)
          [a₂₁  a₂₂  ...  a₂ₙ]
          [⋮    ⋮    ⋱   ⋮  ]
          [aₘ₁  aₘ₂  ...  aₘₙ]

      x = [x₁]  (variable vector)
          [x₂]
          [⋮ ]
          [xₙ]

      b = [b₁]  (constant vector)
          [b₂]
          [⋮ ]
          [bₘ]

Augmented Matrix: [A|b]

Example:
2x + 3y = 7
x - y = 1

Matrix form: [2   3][x] = [7]
             [1  -1][y]   [1]

Augmented: [2   3 | 7]
           [1  -1 | 1]
```

### Solution Methods

```
Matrix Solution Techniques
═════════════════════════

Method 1: Matrix Inverse (when A is square and invertible)
If Ax = b and A⁻¹ exists, then x = A⁻¹b

Example:
[2   3][x] = [7]
[1  -1][y]   [1]

A⁻¹ = 1/(-5) [-1  -3] = [ 0.2   0.6]
              [-1   2]   [ 0.2  -0.4]

x = A⁻¹b = [ 0.2   0.6][7] = [2]
           [ 0.2  -0.4][1]   [1]

Solution: x = 2, y = 1

Method 2: Gaussian Elimination
Transform augmented matrix to row echelon form

[2   3 | 7]  R₁ ↔ R₂  [1  -1 | 1]
[1  -1 | 1]  ────────→ [2   3 | 7]

R₂ - 2R₁  [1  -1 | 1]
────────→ [0   5 | 5]

(1/5)R₂   [1  -1 | 1]
────────→ [0   1 | 1]

Back substitution:
From row 2: y = 1
From row 1: x - y = 1 → x = 2

Method 3: Cramer's Rule (for square systems with det(A) ≠ 0)
xᵢ = det(Aᵢ)/det(A)
where Aᵢ is A with column i replaced by b

Example:
A = [2   3]    A₁ = [7   3]    A₂ = [2   7]
    [1  -1]         [1  -1]         [1   1]

det(A) = -2 - 3 = -5
det(A₁) = -7 - 3 = -10
det(A₂) = 2 - 7 = -5

x = det(A₁)/det(A) = -10/(-5) = 2
y = det(A₂)/det(A) = -5/(-5) = 1
```

### Solution Types and Consistency

```
System Classification
════════════════════

Consistent System: Has at least one solution
Inconsistent System: Has no solution

For m×n system Ax = b:

Case 1: m = n (square system)
- If det(A) ≠ 0: unique solution x = A⁻¹b
- If det(A) = 0: either no solution or infinitely many

Case 2: m < n (underdetermined system)
- More variables than equations
- If consistent: infinitely many solutions
- Solution space has dimension n - rank(A)

Case 3: m > n (overdetermined system)
- More equations than variables
- Usually inconsistent (no exact solution)
- Can find least squares solution

Rank and Consistency:
System Ax = b is consistent if and only if:
rank(A) = rank([A|b])

Homogeneous Systems: Ax = 0
- Always consistent (x = 0 is always a solution)
- If det(A) ≠ 0: only trivial solution x = 0
- If det(A) = 0: infinitely many solutions

Example of Inconsistent System:
x + y = 1
x + y = 2

Augmented matrix: [1  1 | 1]
                  [1  1 | 2]

R₂ - R₁: [1  1 | 1]
         [0  0 | 1]

Last row represents 0 = 1, which is impossible.
System is inconsistent.
```

## Elementary Matrices and Row Operations

### Elementary Row Operations

```
Three Types of Row Operations
════════════════════════════

Type 1: Row Interchange
Rᵢ ↔ Rⱼ (swap rows i and j)

Type 2: Row Scaling
kRᵢ → Rᵢ (multiply row i by nonzero constant k)

Type 3: Row Addition
Rᵢ + kRⱼ → Rᵢ (add k times row j to row i)

Elementary Matrices:
Each row operation corresponds to multiplying by an elementary matrix

Type 1 Elementary Matrix (swap rows 1 and 2 in 3×3):
E₁ = [0  1  0]
     [1  0  0]
     [0  0  1]

Type 2 Elementary Matrix (multiply row 2 by k):
E₂ = [1  0  0]
     [0  k  0]
     [0  0  1]

Type 3 Elementary Matrix (add k times row 2 to row 1):
E₃ = [1  k  0]
     [0  1  0]
     [0  0  1]

Properties:
- All elementary matrices are invertible
- Elementary matrices are their own inverses (Type 1)
- Or have simple inverses (Types 2 and 3)
- Any invertible matrix is product of elementary matrices
```

### Row Echelon Forms

```
Row Echelon Form (REF)
═════════════════════

Properties:
1. All zero rows are at bottom
2. Leading entry (pivot) of each row is to right of pivot above
3. All entries below pivots are zero

Example:
[1  2  3  4]
[0  1  2  1]
[0  0  0  1]
[0  0  0  0]

Reduced Row Echelon Form (RREF):
Additional properties:
4. All pivots equal 1
5. All entries above and below pivots are zero

Example:
[1  0  1  0]
[0  1  2  0]
[0  0  0  1]
[0  0  0  0]

Uniqueness:
Every matrix has unique RREF
REF is not unique (depends on elimination choices)

Gauss-Jordan Elimination:
Process to transform matrix to RREF
1. Forward elimination (to REF)
2. Backward elimination (to RREF)

Applications:
- Solving systems of equations
- Finding matrix rank
- Determining linear independence
- Computing matrix inverse
```

## Matrix Rank

### Definition and Properties

```
Matrix Rank Definition
═════════════════════

Rank of matrix A = maximum number of linearly independent:
- Row vectors (row rank)
- Column vectors (column rank)

Fundamental Theorem: Row rank = Column rank

Alternative Definitions:
- Number of pivots in REF
- Dimension of column space
- Dimension of row space

Examples:
A = [1  2  3]  →  REF: [1  2  3]
    [2  4  6]           [0  0  0]
    [1  2  3]           [0  0  0]

rank(A) = 1 (one pivot)

B = [1  0  2]  →  REF: [1  0  2]
    [0  1  3]           [0  1  3]
    [2  1  7]           [0  0  0]

rank(B) = 2 (two pivots)

Properties:
- 0 ≤ rank(A) ≤ min(m,n) for m×n matrix
- rank(A) = rank(Aᵀ)
- rank(AB) ≤ min(rank(A), rank(B))
- rank(A + B) ≤ rank(A) + rank(B)
- If A is invertible, rank(A) = n

Full Rank:
- m×n matrix has full rank if rank(A) = min(m,n)
- Square matrix: full rank ⟺ invertible ⟺ det(A) ≠ 0
```

## Applications of Matrices

### Computer Graphics and Transformations

```
2D Transformations
═════════════════

Rotation by angle θ:
R(θ) = [cos θ  -sin θ]
       [sin θ   cos θ]

Example: Rotate point (1,0) by 90°
R(90°) = [0  -1][1] = [0]
         [1   0][0]   [1]

Scaling by factors sx, sy:
S = [sx  0 ]
    [0   sy]

Reflection across x-axis:
Rx = [1   0]
     [0  -1]

Shear transformation:
H = [1  k]  (horizontal shear by factor k)
    [0  1]

Composition of Transformations:
Combined transformation = product of matrices
Order matters: T₂T₁ means apply T₁ first, then T₂

3D Transformations:
Rotation about z-axis:
Rz(θ) = [cos θ  -sin θ  0]
        [sin θ   cos θ  0]
        [0       0      1]

Homogeneous Coordinates:
Represent 2D point (x,y) as 3D vector [x,y,1]
Allows translation as matrix multiplication:

Translation by (tx,ty):
T = [1  0  tx]
    [0  1  ty]
    [0  0  1 ]

Combined transformation pipeline:
Final = Projection × View × Model × vertex
```

### Data Analysis and Statistics

```
Matrix Applications in Data Science
══════════════════════════════════

Data Matrix:
Rows = observations/samples
Columns = features/variables

Example: Student grades
        [Math  Science  English]
Alice   [85    92      78     ]
Bob     [76    88      85     ]
Carol   [92    85      90     ]

Covariance Matrix:
C = (1/(n-1))XᵀX (for centered data)
Measures relationships between variables

Correlation Matrix:
Normalized covariance matrix
Entries between -1 and 1

Principal Component Analysis (PCA):
1. Center data (subtract means)
2. Compute covariance matrix C
3. Find eigenvalues and eigenvectors of C
4. Principal components = eigenvectors
5. Explained variance = eigenvalues

Linear Regression:
Model: y = Xβ + ε
Normal equation: β = (XᵀX)⁻¹Xᵀy

Example: Predict house prices
X = [1  1200]  (1 for intercept, 1200 sq ft)
    [1  1500]
    [1  1800]

y = [200000]  (prices)
    [250000]
    [300000]

Solve for β = [intercept, price per sq ft]
```

### Engineering Applications

```
Engineering Matrix Uses
══════════════════════

Structural Analysis:
Stiffness matrix K relates forces F to displacements u:
Ku = F

Example: Spring system
K = [k₁+k₂  -k₂  ]  u = [u₁]  F = [F₁]
    [-k₂    k₂+k₃]      [u₂]      [F₂]

Circuit Analysis:
Nodal analysis: YV = I
where Y is admittance matrix, V is voltage vector, I is current vector

Control Systems:
State-space representation:
ẋ = Ax + Bu  (state equation)
y = Cx + Du  (output equation)

A = system matrix
B = input matrix
C = output matrix
D = feedthrough matrix

Signal Processing:
Discrete Fourier Transform (DFT) as matrix multiplication:
X = Wx where W is DFT matrix

Finite Element Method:
Discretize continuous problems into matrix equations
[K]{u} = {F} where K is global stiffness matrix

Network Analysis:
Adjacency matrix represents graph connections
A[i,j] = 1 if edge from node i to node j, 0 otherwise

Markov Chains:
Transition matrix P where P[i,j] = probability of moving from state i to state j
Steady state: πP = π
```

## Advanced Matrix Concepts

### Matrix Norms

```
Matrix Norms
═══════════

Vector Norms Extended to Matrices:

Frobenius Norm:
‖A‖F = √(Σᵢⱼ aᵢⱼ²) = √(trace(AᵀA))

Example:
A = [1  2]
    [3  4]
‖A‖F = √(1² + 2² + 3² + 4²) = √30

Induced Norms:
‖A‖p = max{‖Ax‖p : ‖x‖p = 1}

Common Induced Norms:
- ‖A‖₁ = max column sum
- ‖A‖∞ = max row sum
- ‖A‖₂ = largest singular value

Properties:
- ‖A‖ ≥ 0, with equality iff A = 0
- ‖cA‖ = |c|‖A‖
- ‖A + B‖ ≤ ‖A‖ + ‖B‖
- ‖AB‖ ≤ ‖A‖‖B‖

Applications:
- Measuring matrix "size"
- Error analysis in numerical computations
- Convergence analysis of iterative methods
- Condition number: κ(A) = ‖A‖‖A⁻¹‖
```

### Matrix Decompositions Preview

```
Important Decompositions
══════════════════════

LU Decomposition:
A = LU (lower triangular × upper triangular)
Efficient for solving multiple systems with same A

QR Decomposition:
A = QR (orthogonal × upper triangular)
Used in least squares and eigenvalue algorithms

Singular Value Decomposition (SVD):
A = UΣVᵀ (orthogonal × diagonal × orthogonal)
Most general decomposition, works for any matrix

Eigenvalue Decomposition:
A = PDP⁻¹ (for diagonalizable matrices)
P contains eigenvectors, D contains eigenvalues

Cholesky Decomposition:
A = LLᵀ (for positive definite matrices)
Efficient for symmetric positive definite systems

Applications:
- Efficient equation solving
- Data compression and dimensionality reduction
- Principal component analysis
- Image processing and computer vision
- Numerical stability improvements
```

## Summary and Key Concepts

Matrices provide the computational framework for linear algebra, enabling efficient representation and manipulation of linear transformations and systems of equations.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Matrix notation, types, and basic operations
✓ Matrix multiplication and its properties
✓ Transpose operations and symmetric matrices
✓ Determinant calculation and geometric interpretation
✓ Matrix inverse computation and applications
✓ Systems of linear equations using matrices
✓ Row operations and echelon forms
✓ Matrix rank and its significance

Key Concepts:
• Matrices as rectangular arrays of numbers
• Matrix multiplication as composition of transformations
• Determinant as measure of scaling and invertibility
• Matrix inverse as generalization of reciprocal
• Row operations as elementary matrix multiplications
• Rank as measure of linear independence
• Applications in graphics, data analysis, and engineering

Fundamental Operations:
• Addition/subtraction: element-wise for same dimensions
• Multiplication: row-by-column with dimension matching
• Transpose: interchange rows and columns
• Determinant: scalar measure of matrix properties
• Inverse: multiplicative "reciprocal" when it exists

Problem-Solving Tools:
• Gaussian elimination for systems
• Matrix inverse for unique solutions
• Determinants for testing invertibility
• Rank for analyzing solution spaces
• Elementary matrices for understanding row operations

Applications Covered:
• Computer graphics transformations
• Data analysis and statistics
• Engineering systems and networks
• Circuit analysis and control systems
• Structural analysis and finite elements

Next Steps:
Matrix concepts prepare you for:
- Eigenvalues and eigenvectors
- Vector spaces and linear transformations
- Matrix decompositions and factorizations
- Numerical linear algebra methods
- Advanced applications in machine learning and data science
```

Matrices represent the computational heart of linear algebra, providing both theoretical foundations and practical tools for solving real-world problems. The skills developed in this chapter - matrix operations, system solving, and geometric interpretation - form essential building blocks for advanced topics in linear algebra and its applications across science, engineering, and data analysis. Understanding matrices opens the door to powerful computational methods and elegant mathematical insights that drive modern technology and scientific discovery.