# Systems of Linear Equations: Solving Multiple Relationships Simultaneously

## Introduction to Linear Systems

A system of linear equations consists of multiple linear equations involving the same set of variables. These systems arise naturally when modeling real-world situations with multiple constraints and relationships.

```
System Structure
═══════════════

General Form:
a₁₁x₁ + a₁₂x₂ + ... + a₁ₙxₙ = b₁
a₂₁x₁ + a₂₂x₂ + ... + a₂ₙxₙ = b₂
⋮
aₘ₁x₁ + aₘ₂x₂ + ... + aₘₙxₙ = bₘ

Matrix Representation: Ax = b
where:
A = coefficient matrix (m×n)
x = variable vector (n×1)
b = constant vector (m×1)

System Classifications:
• m = n: Square system (same number of equations and variables)
• m < n: Underdetermined (fewer equations than variables)
• m > n: Overdetermined (more equations than variables)

Examples:
2×2 System:    3×2 System:      2×3 System:
2x + 3y = 7    x + y = 3        x + 2y + z = 4
x - y = 1      2x - y = 1       2x - y + 3z = 1
               x + 2y = 5

Homogeneous vs. Nonhomogeneous:
• Homogeneous: Ax = 0 (all constants are zero)
• Nonhomogeneous: Ax = b (at least one constant is nonzero)
```

## Solution Types and Geometric Interpretation

### Understanding Solution Behavior

```
Solution Classifications
══════════════════════

Three Possibilities:
1. Unique Solution: Exactly one solution vector
2. No Solution: System is inconsistent
3. Infinite Solutions: System has infinitely many solutions

2D Geometric Interpretation:
Each equation represents a line in the plane

Unique Solution:
Two lines intersect at exactly one point
Example: x + y = 3, x - y = 1
Solution: (2, 1)

No Solution:
Lines are parallel (never intersect)
Example: x + y = 3, x + y = 5
Contradiction: same slope, different intercepts

Infinite Solutions:
Lines are identical (same line)
Example: x + y = 3, 2x + 2y = 6
Second equation is multiple of first

3D Geometric Interpretation:
Each equation represents a plane in 3D space

Unique Solution:
Three planes intersect at exactly one point
Common intersection point

No Solution:
Planes have no common intersection
Example: parallel planes or triangular prism configuration

Infinite Solutions:
Planes intersect along a line or are identical
Line of intersection or coincident planes

Higher Dimensions:
Each equation represents a hyperplane in n-dimensional space
Solution is intersection of all hyperplanes
```

### Consistency and Rank

```
Consistency Conditions
═════════════════════

Fundamental Theorem:
System Ax = b is consistent if and only if:
rank(A) = rank([A|b])

where [A|b] is the augmented matrix

Rank Analysis:
Let r = rank(A), n = number of variables

Case 1: rank(A) = rank([A|b]) = r
System is consistent

- If r = n: Unique solution
- If r < n: Infinite solutions (n - r free variables)

Case 2: rank(A) < rank([A|b])
System is inconsistent (no solution)

Examples:
Consistent with unique solution:
[1  2 | 3]  rank(A) = rank([A|b]) = 2 = n
[3  1 | 4]

Consistent with infinite solutions:
[1  2  1 | 3]  rank(A) = rank([A|b]) = 2 < n = 3
[2  4  3 | 7]

Inconsistent:
[1  2 | 3]  rank(A) = 1, rank([A|b]) = 2
[2  4 | 7]

Rouché-Capelli Theorem:
Provides complete characterization of solution existence
Essential for theoretical analysis
```

## Gaussian Elimination

### The Elimination Process

Gaussian elimination systematically transforms a system into an equivalent system that's easier to solve.

```
Gaussian Elimination Steps
═════════════════════════

Goal: Transform augmented matrix to row echelon form

Elementary Row Operations:
1. Rᵢ ↔ Rⱼ: Swap rows i and j
2. kRᵢ → Rᵢ: Multiply row i by nonzero constant k
3. Rᵢ + kRⱼ → Rᵢ: Add k times row j to row i

Forward Elimination Process:
1. Choose pivot (leftmost nonzero entry in current row)
2. Use row swaps to move pivot to diagonal position
3. Use row operations to make all entries below pivot zero
4. Move to next row and repeat

Example: Solve system
x + 2y + 3z = 14
2x + 3y + z = 11
3x + y + 2z = 13

Augmented matrix:
[1  2  3 | 14]
[2  3  1 | 11]
[3  1  2 | 13]

Step 1: Eliminate below first pivot
R₂ - 2R₁: [1  2  3 | 14]
          [0 -1 -5 |-17]
          [3  1  2 | 13]

R₃ - 3R₁: [1  2  3 | 14]
          [0 -1 -5 |-17]
          [0 -5 -7 |-29]

Step 2: Eliminate below second pivot
-R₂:      [1  2  3 | 14]
          [0  1  5 | 17]
          [0 -5 -7 |-29]

R₃ + 5R₂: [1  2  3 | 14]
          [0  1  5 | 17]
          [0  0 18 | 56]

Row Echelon Form achieved!
```

### Back Substitution

```
Back Substitution Process
════════════════════════

After forward elimination, solve from bottom up:

From our example:
[1  2  3 | 14]
[0  1  5 | 17]
[0  0 18 | 56]

Step 1: Solve for z from last equation
18z = 56
z = 56/18 = 28/9

Step 2: Substitute into second equation
y + 5z = 17
y + 5(28/9) = 17
y = 17 - 140/9 = 153/9 - 140/9 = 13/9

Step 3: Substitute into first equation
x + 2y + 3z = 14
x + 2(13/9) + 3(28/9) = 14
x + 26/9 + 84/9 = 14
x = 14 - 110/9 = 126/9 - 110/9 = 16/9

Solution: x = 16/9, y = 13/9, z = 28/9

Verification:
Substitute back into original equations to check
```

## Gauss-Jordan Elimination

### Reduced Row Echelon Form

Gauss-Jordan elimination extends Gaussian elimination to produce the reduced row echelon form (RREF).

```
RREF Properties
══════════════

Reduced Row Echelon Form has:
1. All properties of row echelon form
2. All pivot entries equal 1 (leading 1's)
3. All entries above and below pivots are 0

RREF Process:
1. Perform forward elimination (Gaussian)
2. Make all pivots equal to 1
3. Eliminate above pivots (backward elimination)

Example: Continue from previous REF
[1  2  3 | 14]
[0  1  5 | 17]
[0  0 18 | 56]

Step 1: Make pivots equal to 1
(1/18)R₃: [1  2  3 | 14]
          [0  1  5 | 17]
          [0  0  1 | 28/9]

Step 2: Eliminate above third pivot
R₂ - 5R₃: [1  2  3 | 14]
          [0  1  0 | 13/9]
          [0  0  1 | 28/9]

R₁ - 3R₃: [1  2  0 | 16/9]
          [0  1  0 | 13/9]
          [0  0  1 | 28/9]

Step 3: Eliminate above second pivot
R₁ - 2R₂: [1  0  0 | 16/9]
          [0  1  0 | 13/9]
          [0  0  1 | 28/9]

Solution directly readable: x = 16/9, y = 13/9, z = 28/9

Advantages of RREF:
- Solution immediately visible
- Easier to identify free variables
- Systematic approach for all cases
- Useful for finding matrix inverse
```

### Parametric Solutions

```
Systems with Infinite Solutions
══════════════════════════════

When system has infinite solutions, RREF reveals the structure:

Example: Solve system
x + 2y + z = 3
2x + 4y + 3z = 7
x + 2y + 2z = 4

Augmented matrix:
[1  2  1 | 3]
[2  4  3 | 7]
[1  2  2 | 4]

Forward elimination:
R₂ - 2R₁: [1  2  1 | 3]
          [0  0  1 | 1]
          [1  2  2 | 4]

R₃ - R₁:  [1  2  1 | 3]
          [0  0  1 | 1]
          [0  0  1 | 1]

R₃ - R₂:  [1  2  1 | 3]
          [0  0  1 | 1]
          [0  0  0 | 0]

RREF:
R₁ - R₂:  [1  2  0 | 2]
          [0  0  1 | 1]
          [0  0  0 | 0]

Interpretation:
x + 2y = 2  →  x = 2 - 2y
z = 1

y is a free variable (can be any real number)

Parametric Solution:
Let y = t (parameter)
x = 2 - 2t
y = t
z = 1

Vector Form:
[x]   [2]     [-2]
[y] = [0] + t [1]
[z]   [1]     [0]

General solution = particular solution + homogeneous solution
```

## Special Cases and Applications

### Homogeneous Systems

```
Homogeneous Systems: Ax = 0
═════════════════════════

Properties:
- Always consistent (x = 0 is always a solution)
- Either unique solution (x = 0) or infinite solutions
- Solution set forms a subspace (null space of A)

Trivial vs. Nontrivial Solutions:
- Trivial solution: x = 0
- Nontrivial solutions: x ≠ 0

Existence of Nontrivial Solutions:
For square matrix A (n×n):
- det(A) ≠ 0: Only trivial solution
- det(A) = 0: Infinite nontrivial solutions

For general matrix A (m×n):
- rank(A) = n: Only trivial solution
- rank(A) < n: Infinite nontrivial solutions

Example: Find nontrivial solutions
x + 2y - z = 0
2x + 3y + z = 0
x + y + 2z = 0

Augmented matrix (b = 0, so we work with A only):
[1  2 -1]
[2  3  1]
[1  1  2]

Row reduction:
[1  2 -1]
[0 -1  3]
[0 -1  3]

[1  2 -1]
[0  1 -3]
[0  0  0]

[1  0  5]
[0  1 -3]
[0  0  0]

Solution:
x + 5z = 0  →  x = -5z
y - 3z = 0  →  y = 3z
z is free

Parametric solution: x = -5t, y = 3t, z = t
Vector form: t[-5, 3, 1]ᵀ

Null space is line through origin in direction [-5, 3, 1]ᵀ
```

### Underdetermined Systems

```
More Variables Than Equations
════════════════════════════

Characteristics:
- m < n (fewer equations than variables)
- If consistent, always has infinite solutions
- At least n - m free variables

Example: 2 equations, 3 variables
x + 2y + z = 5
2x - y + 3z = 1

Augmented matrix:
[1  2  1 | 5]
[2 -1  3 | 1]

Row reduction:
[1  2  1 | 5]
[0 -5  1 |-9]

[1  2  1 | 5]
[0  1 -1/5| 9/5]

[1  0  7/5 | 7/5]
[0  1 -1/5 | 9/5]

Solution:
x + (7/5)z = 7/5  →  x = 7/5 - (7/5)z
y - (1/5)z = 9/5  →  y = 9/5 + (1/5)z
z is free

Parametric solution:
x = 7/5 - (7/5)t
y = 9/5 + (1/5)t
z = t

Applications:
- Optimization problems with constraints
- Curve fitting with fewer data points than parameters
- Control systems with multiple actuators
```

### Overdetermined Systems

```
More Equations Than Variables
════════════════════════════

Characteristics:
- m > n (more equations than variables)
- Usually inconsistent (no exact solution)
- When consistent, typically unique solution

Example: 3 equations, 2 variables
x + y = 3
2x - y = 0
x + 2y = 5

Augmented matrix:
[1  1 | 3]
[2 -1 | 0]
[1  2 | 5]

Row reduction:
[1  1 | 3]
[0 -3 |-6]
[0  1 | 2]

[1  1 | 3]
[0  1 | 2]
[0  1 | 2]

[1  0 | 1]
[0  1 | 2]
[0  0 | 0]

This system is consistent!
Solution: x = 1, y = 2

Verification:
1 + 2 = 3 ✓
2(1) - 2 = 0 ✓
1 + 2(2) = 5 ✓

Inconsistent Example:
x + y = 3
2x - y = 0
x + 2y = 6

Row reduction leads to:
[1  0 | 1]
[0  1 | 2]
[0  0 | 1]  ← Inconsistent row!

Last row represents 0 = 1, which is impossible.

Least Squares Solution:
When overdetermined system is inconsistent, find x that minimizes ‖Ax - b‖²
Solution: x = (AᵀA)⁻¹Aᵀb (normal equation)
```

## Matrix Methods for Linear Systems

### Using Matrix Inverse

```
Inverse Method for Square Systems
═══════════════════════════════

For square system Ax = b where A is invertible:
Solution: x = A⁻¹b

Example:
[2  1][x] = [7]
[1  3][y]   [8]

Find A⁻¹:
det(A) = 2(3) - 1(1) = 5

A⁻¹ = (1/5)[3  -1] = [3/5  -1/5]
           [-1   2]   [-1/5  2/5]

Solution:
x = A⁻¹b = [3/5  -1/5][7] = [21/5 - 8/5] = [13/5]
           [-1/5  2/5][8]   [-7/5 + 16/5]   [9/5]

Therefore: x = 13/5, y = 9/5

Computational Considerations:
- Computing A⁻¹ is expensive: O(n³) operations
- Numerically unstable for ill-conditioned matrices
- Usually better to solve Ax = b directly
- Useful when solving multiple systems with same A

When to Use Inverse Method:
✓ Multiple right-hand sides with same coefficient matrix
✓ Theoretical analysis and derivations
✓ Small systems where inverse has simple form
✗ Large systems (use elimination instead)
✗ Ill-conditioned systems (numerical instability)
```

### Cramer's Rule

```
Cramer's Rule for Square Systems
══════════════════════════════

For n×n system Ax = b with det(A) ≠ 0:

xᵢ = det(Aᵢ)/det(A)

where Aᵢ is matrix A with column i replaced by vector b

Example:
2x + 3y = 7
x - y = 1

A = [2   3]    b = [7]
    [1  -1]        [1]

det(A) = 2(-1) - 3(1) = -5

For x (replace column 1):
A₁ = [7   3]    det(A₁) = 7(-1) - 3(1) = -10
     [1  -1]

x = det(A₁)/det(A) = -10/(-5) = 2

For y (replace column 2):
A₂ = [2  7]     det(A₂) = 2(1) - 7(1) = -5
     [1  1]

y = det(A₂)/det(A) = -5/(-5) = 1

Solution: x = 2, y = 1

3×3 Example:
x + 2y + z = 6
2x + y + 2z = 8
x + y + 3z = 9

A = [1  2  1]    det(A) = 1(3-2) - 2(6-2) + 1(2-1) = -6
    [2  1  2]
    [1  1  3]

A₁ = [6  2  1]   det(A₁) = 6(3-2) - 2(24-18) + 1(8-9) = -11
     [8  1  2]
     [9  1  3]

x = -11/(-6) = 11/6

Limitations:
- Only works for square systems with det(A) ≠ 0
- Computationally expensive for large systems
- Requires n+1 determinant calculations
- Less efficient than elimination for n > 3
```

## Applications and Real-World Examples

### Economic Models

```
Economic System Example
══════════════════════

Supply and Demand Model:
Market 1: S₁ = 2P₁ - P₂ + 10, D₁ = -P₁ + 20
Market 2: S₂ = -P₁ + 3P₂ + 5,  D₂ = -2P₂ + 25

Equilibrium conditions: S₁ = D₁, S₂ = D₂

System:
2P₁ - P₂ + 10 = -P₁ + 20  →  3P₁ - P₂ = 10
-P₁ + 3P₂ + 5 = -2P₂ + 25  →  -P₁ + 5P₂ = 20

Matrix form:
[3  -1][P₁] = [10]
[-1  5][P₂]   [20]

Solution using elimination:
[3  -1 | 10]
[-1  5 | 20]

R₂ + (1/3)R₁: [3  -1 | 10]
              [0  14/3 | 70/3]

P₂ = (70/3)/(14/3) = 5
P₁ = (10 + 5)/3 = 5

Equilibrium prices: P₁ = $5, P₂ = $5

Input-Output Model (Leontief):
x = Ax + d
where x = output vector, A = technology matrix, d = final demand

Rearranging: (I - A)x = d
Solution: x = (I - A)⁻¹d

Example: Two-sector economy
Sector 1 uses 0.2 of its output and 0.3 from sector 2
Sector 2 uses 0.4 from sector 1 and 0.1 of its output
Final demands: d₁ = 100, d₂ = 200

A = [0.2  0.3]    I - A = [0.8  -0.3]
    [0.4  0.1]            [-0.4  0.9]

Solve: (I - A)x = d
```

### Engineering Applications

```
Circuit Analysis Example
═══════════════════════

Kirchhoff's Laws lead to linear systems:

Circuit with 3 loops:
Loop 1: 10I₁ - 5I₂ = 12
Loop 2: -5I₁ + 15I₂ - 8I₃ = 0
Loop 3: -8I₂ + 20I₃ = -8

Matrix form:
[10  -5   0][I₁]   [12]
[-5  15  -8][I₂] = [0]
[0   -8  20][I₃]   [-8]

Structural Analysis:
Force equilibrium at joints creates linear systems

Truss with 3 joints:
Joint 1: F₁cos(30°) + F₂ = P₁
         F₁sin(30°) = P₂
Joint 2: -F₁cos(30°) + F₃cos(45°) = P₃
         -F₁sin(30°) - F₃sin(45°) = P₄

Chemical Engineering:
Material balance equations

Reactor system:
Input₁ + Input₂ = Output₁ + Output₂ + Accumulation
Component A: 0.3F₁ + 0.1F₂ = 0.2F₃ + 0.4F₄
Component B: 0.7F₁ + 0.9F₂ = 0.8F₃ + 0.6F₄
Total: F₁ + F₂ = F₃ + F₄

Traffic Flow:
Conservation of vehicles at intersections

Intersection analysis:
Inflow = Outflow at each node
x₁ + x₂ = x₃ + x₄ (node 1)
x₃ + x₅ = x₆ + x₇ (node 2)
...
```

### Data Fitting and Regression

```
Linear Regression as System Solution
══════════════════════════════════

Problem: Fit line y = mx + b to data points
(x₁,y₁), (x₂,y₂), ..., (xₙ,yₙ)

Overdetermined system:
mx₁ + b = y₁
mx₂ + b = y₂
⋮
mxₙ + b = yₙ

Matrix form: Aβ = y
where A = [x₁  1]    β = [m]    y = [y₁]
          [x₂  1]        [b]        [y₂]
          [⋮   ⋮]                   [⋮]
          [xₙ  1]                   [yₙ]

Normal equation solution:
β = (AᵀA)⁻¹Aᵀy

Example: Fit line to points (1,2), (2,3), (3,5), (4,4)

A = [1  1]    y = [2]
    [2  1]        [3]
    [3  1]        [5]
    [4  1]        [4]

AᵀA = [1 2 3 4][1  1] = [30  10]
      [1 1 1 1][2  1]   [10   4]
                [3  1]
                [4  1]

Aᵀy = [1 2 3 4][2] = [40]
      [1 1 1 1][3]   [14]
                [5]
                [4]

Solve: [30  10][m] = [40]
       [10   4][b]   [14]

Solution: m = 0.7, b = 1.25
Best-fit line: y = 0.7x + 1.25

Polynomial Fitting:
For polynomial y = a₀ + a₁x + a₂x² + ... + aₙxⁿ

Vandermonde matrix:
A = [1  x₁  x₁²  ...  x₁ⁿ]
    [1  x₂  x₂²  ...  x₂ⁿ]
    [⋮  ⋮   ⋮    ⋱   ⋮  ]
    [1  xₘ  xₘ²  ...  xₘⁿ]

Same normal equation approach applies
```

## Computational Considerations

### Numerical Stability

```
Numerical Issues in Linear Systems
═════════════════════════════════

Ill-Conditioned Systems:
Small changes in coefficients cause large changes in solution

Example: Nearly singular system
[1.0000  1.0000][x] = [2.0000]
[1.0000  1.0001][y]   [2.0001]

Exact solution: x = 1, y = 1

Perturbed system:
[1.0000  1.0000][x] = [2.0000]
[1.0000  1.0001][y]   [2.0002]

Solution: x = 0, y = 2 (completely different!)

Condition Number:
κ(A) = ‖A‖‖A⁻¹‖
- κ(A) ≈ 1: well-conditioned
- κ(A) >> 1: ill-conditioned

Pivoting Strategies:
Partial pivoting: Choose largest element in column as pivot
Complete pivoting: Choose largest element in remaining submatrix

Benefits:
- Reduces round-off error accumulation
- Improves numerical stability
- Essential for practical implementations

Example with pivoting:
Original:     [0.001  1][x] = [1]
              [1      1][y]   [2]

Without pivoting: x ≈ 1000, y ≈ -999 (inaccurate)

With row swap:  [1      1][x] = [2]
                [0.001  1][y]   [1]

Accurate solution: x = 1, y = 1

Iterative Methods:
For large sparse systems, iterative methods may be preferred:
- Jacobi method
- Gauss-Seidel method
- Conjugate gradient method
- GMRES method

Advantages:
- Lower memory requirements
- Better for sparse matrices
- Can be stopped when desired accuracy reached
```

### Computational Complexity

```
Algorithm Efficiency Analysis
════════════════════════════

Gaussian Elimination:
Time complexity: O(n³) for n×n system
Space complexity: O(n²)

Operations count:
- Forward elimination: ~n³/3 multiplications
- Back substitution: ~n²/2 multiplications
- Total: ~n³/3 operations

Matrix Inverse:
Time complexity: O(n³)
Generally more expensive than direct solving

Cramer's Rule:
Time complexity: O(n! × n) (factorial growth!)
Impractical for n > 4

LU Decomposition:
One-time cost: O(n³)
Each solve: O(n²)
Efficient for multiple right-hand sides

Sparse Matrices:
Special techniques for matrices with many zeros:
- Store only nonzero elements
- Specialized algorithms (sparse Gaussian elimination)
- Iterative methods often preferred
- Complexity depends on sparsity pattern

Parallel Computing:
Matrix operations can be parallelized:
- Block algorithms
- Distributed memory systems
- GPU acceleration
- Significant speedup possible for large systems

Memory Considerations:
- In-place algorithms to reduce memory usage
- Block algorithms for cache efficiency
- Out-of-core methods for very large systems
- Numerical libraries (LAPACK, BLAS) for optimized implementations
```

## Summary and Key Concepts

Systems of linear equations provide the computational foundation for solving real-world problems involving multiple constraints and relationships simultaneously.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Classifying systems by solution type and geometry
✓ Gaussian elimination and back substitution
✓ Gauss-Jordan elimination and RREF
✓ Handling homogeneous and parametric solutions
✓ Matrix methods (inverse, Cramer's rule)
✓ Applications in economics, engineering, and data analysis
✓ Understanding numerical stability and computational complexity

Key Concepts:
• Systems as intersections of hyperplanes
• Consistency determined by rank conditions
• Three solution types: unique, none, infinite
• Elementary row operations preserve solutions
• RREF provides systematic solution method
• Parametric solutions for underdetermined systems
• Least squares for overdetermined systems

Solution Methods:
• Gaussian elimination: systematic and reliable
• Gauss-Jordan: produces RREF directly
• Matrix inverse: efficient for multiple right-hand sides
• Cramer's rule: theoretical importance, limited practical use
• Iterative methods: for large sparse systems

Problem-Solving Framework:
• Set up coefficient matrix and constant vector
• Analyze system type and expected solution behavior
• Choose appropriate solution method
• Interpret results in original problem context
• Verify solutions and check reasonableness

Applications Covered:
• Economic equilibrium and input-output models
• Circuit analysis and structural engineering
• Traffic flow and network problems
• Data fitting and regression analysis
• Chemical process balancing

Next Steps:
Linear systems concepts prepare you for:
- Vector spaces and linear transformations
- Eigenvalue problems and matrix diagonalization
- Numerical linear algebra methods
- Optimization and linear programming
- Advanced applications in machine learning and data science
```

Systems of linear equations represent the practical heart of linear algebra, providing essential tools for modeling and solving real-world problems across science, engineering, and economics. The systematic methods developed in this chapter - elimination techniques, matrix approaches, and solution analysis - form the computational foundation for advanced topics in linear algebra and its applications. Understanding how to set up, solve, and interpret linear systems opens doors to powerful problem-solving capabilities that drive modern technology and scientific discovery.