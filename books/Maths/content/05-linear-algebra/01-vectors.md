# Vectors: The Foundation of Linear Algebra

## Introduction to Vectors

Vectors are mathematical objects that represent quantities having both magnitude and direction. They form the fundamental building blocks of linear algebra and provide a powerful way to describe and analyze multidimensional relationships.

```
Vector Concepts
══════════════

Physical Interpretation:
- Displacement: How far and in what direction
- Velocity: Speed and direction of motion
- Force: Magnitude and direction of push/pull
- Acceleration: Rate and direction of velocity change

Mathematical Representation:
- Geometric: Directed line segments (arrows)
- Algebraic: Ordered lists of numbers
- Abstract: Elements of vector spaces

Key Properties:
✓ Independent of starting position (free vectors)
✓ Defined by magnitude and direction only
✓ Can be added and scaled
✓ Form the basis for linear combinations
```

## Vector Notation and Representation

### Coordinate Representation

Vectors can be represented using coordinates in various dimensional spaces.

```
Vector Notation Systems
══════════════════════

2D Vectors:
Component form: v = ⟨3, 4⟩ or v = (3, 4)
Column vector: v = [3]
                   [4]
Row vector: v = [3  4]

3D Vectors:
Component form: w = ⟨1, -2, 5⟩
Column vector: w = [1]
                   [-2]
                   [5]

n-Dimensional Vectors:
General form: u = ⟨u₁, u₂, u₃, ..., uₙ⟩
Column form: u = [u₁]
                 [u₂]
                 [u₃]
                 [⋮]
                 [uₙ]

Standard Notation:
- Bold lowercase letters: v, w, u
- Arrow notation: v⃗, w⃗, u⃗
- Component notation: vᵢ (i-th component of v)
- Magnitude notation: |v| or ‖v‖
```

### Geometric Interpretation

```
Geometric Vector Properties
══════════════════════════

Position vs. Direction:
- Position vector: From origin to point
- Direction vector: Represents direction and magnitude only
- Free vector: Can be placed anywhere in space

Magnitude (Length):
2D: |v| = √(v₁² + v₂²)
3D: |w| = √(w₁² + w₂² + w₃²)
nD: |u| = √(u₁² + u₂² + ... + uₙ²)

Unit Vectors:
- Magnitude = 1
- Represent pure direction
- Standard unit vectors:
  2D: î = ⟨1, 0⟩, ĵ = ⟨0, 1⟩
  3D: î = ⟨1, 0, 0⟩, ĵ = ⟨0, 1, 0⟩, k̂ = ⟨0, 0, 1⟩

Direction Angles:
Angles that vector makes with coordinate axes
cos α = v₁/|v|, cos β = v₂/|v|, cos γ = v₃/|v|
where α, β, γ are angles with x, y, z axes respectively
```

## Vector Operations

### Vector Addition

Vector addition combines two vectors to produce a resultant vector.

```
Vector Addition Methods
══════════════════════

Algebraic Method:
Add corresponding components
u + v = ⟨u₁ + v₁, u₂ + v₂, u₃ + v₃⟩

Example:
u = ⟨2, 3, -1⟩
v = ⟨-1, 4, 2⟩
u + v = ⟨2 + (-1), 3 + 4, -1 + 2⟩ = ⟨1, 7, 1⟩

Geometric Methods:

1. Parallelogram Law:
   - Place vectors tail-to-tail
   - Complete parallelogram
   - Diagonal from common tail is sum

2. Triangle Law (Tip-to-Tail):
   - Place second vector's tail at first vector's tip
   - Sum vector goes from first tail to second tip

Properties of Vector Addition:
- Commutative: u + v = v + u
- Associative: (u + v) + w = u + (v + w)
- Identity: v + 0 = v (zero vector is additive identity)
- Inverse: v + (-v) = 0 (every vector has additive inverse)

Applications:
- Displacement: Total displacement = sum of individual displacements
- Forces: Resultant force = vector sum of individual forces
- Velocities: Relative velocity calculations
```

### Scalar Multiplication

Scalar multiplication scales a vector by a real number, changing its magnitude and possibly direction.

```
Scalar Multiplication Properties
══════════════════════════════

Algebraic Definition:
cv = ⟨cv₁, cv₂, cv₃⟩

Examples:
v = ⟨2, -3, 1⟩
2v = ⟨4, -6, 2⟩
-0.5v = ⟨-1, 1.5, -0.5⟩

Geometric Effects:
- c > 1: Stretches vector (increases magnitude)
- 0 < c < 1: Shrinks vector (decreases magnitude)
- c = 1: No change
- c = 0: Results in zero vector
- c < 0: Reverses direction and scales magnitude

Properties:
- Distributive over vector addition: c(u + v) = cu + cv
- Distributive over scalar addition: (a + b)v = av + bv
- Associative: a(bv) = (ab)v
- Identity: 1v = v

Unit Vector Formula:
For any non-zero vector v, the unit vector in same direction:
û = v/|v| = (1/|v|)v

Example:
v = ⟨3, 4⟩
|v| = √(3² + 4²) = 5
û = (1/5)⟨3, 4⟩ = ⟨3/5, 4/5⟩
```

### Linear Combinations

Linear combinations form the foundation of vector spaces and span concepts.

```
Linear Combination Definition
════════════════════════════

A linear combination of vectors v₁, v₂, ..., vₙ is:
c₁v₁ + c₂v₂ + ... + cₙvₙ

where c₁, c₂, ..., cₙ are scalars (coefficients)

Examples:
Given u = ⟨1, 2⟩ and v = ⟨3, -1⟩

3u + 2v = 3⟨1, 2⟩ + 2⟨3, -1⟩
        = ⟨3, 6⟩ + ⟨6, -2⟩
        = ⟨9, 4⟩

-u + 4v = -⟨1, 2⟩ + 4⟨3, -1⟩
        = ⟨-1, -2⟩ + ⟨12, -4⟩
        = ⟨11, -6⟩

Geometric Interpretation:
- Linear combinations create new vectors
- All possible linear combinations form a subspace
- Two non-parallel vectors span a plane
- Three non-coplanar vectors span 3D space

Standard Basis Representation:
Any vector in ℝⁿ can be written as linear combination of standard basis vectors

2D: v = ⟨v₁, v₂⟩ = v₁î + v₂ĵ
3D: w = ⟨w₁, w₂, w₃⟩ = w₁î + w₂ĵ + w₃k̂

Applications:
- Computer graphics: Interpolation between points
- Physics: Superposition of forces, fields
- Economics: Portfolio combinations
- Engineering: Signal processing, control systems
```

## Dot Product (Inner Product)

### Definition and Computation

The dot product is a fundamental operation that produces a scalar from two vectors.

```
Dot Product Definitions
══════════════════════

Algebraic Definition:
u · v = u₁v₁ + u₂v₂ + u₃v₃ + ... + uₙvₙ

Examples:
u = ⟨2, 3, -1⟩, v = ⟨1, -2, 4⟩
u · v = (2)(1) + (3)(-2) + (-1)(4) = 2 - 6 - 4 = -8

u = ⟨5, 0⟩, v = ⟨3, 4⟩
u · v = (5)(3) + (0)(4) = 15

Geometric Definition:
u · v = |u||v|cos θ

where θ is the angle between vectors u and v

Properties:
- Commutative: u · v = v · u
- Distributive: u · (v + w) = u · v + u · w
- Scalar associative: (cu) · v = c(u · v) = u · (cv)
- Positive definite: v · v ≥ 0, with equality iff v = 0

Self Dot Product:
v · v = |v|² = v₁² + v₂² + ... + vₙ²
This gives the squared magnitude of the vector
```

### Geometric Applications

```
Angle Between Vectors
════════════════════

Formula: cos θ = (u · v)/(|u||v|)

Example:
u = ⟨1, 2⟩, v = ⟨3, 1⟩
u · v = (1)(3) + (2)(1) = 5
|u| = √(1² + 2²) = √5
|v| = √(3² + 1²) = √10

cos θ = 5/(√5 · √10) = 5/√50 = 1/√2
θ = 45°

Special Cases:
- θ = 0°: Vectors point in same direction (cos θ = 1)
- θ = 90°: Vectors are perpendicular (cos θ = 0)
- θ = 180°: Vectors point in opposite directions (cos θ = -1)

Orthogonality:
Two vectors are orthogonal (perpendicular) if and only if u · v = 0

Examples of Orthogonal Vectors:
⟨1, 0⟩ and ⟨0, 1⟩ (standard basis vectors)
⟨3, 4⟩ and ⟨4, -3⟩
⟨1, 1, 1⟩ and ⟨1, -1, 0⟩

Orthogonal Complement:
For vector v = ⟨a, b⟩, orthogonal vectors have form ⟨-b, a⟩ or ⟨b, -a⟩
```

### Vector Projections

```
Projection Formulas
══════════════════

Scalar Projection (Component):
comp_u v = (v · u)/|u| = |v|cos θ

This gives the signed length of v in direction of u

Vector Projection:
proj_u v = ((v · u)/(u · u))u = ((v · u)/|u|²)u

This gives the vector component of v in direction of u

Example:
Project v = ⟨3, 4⟩ onto u = ⟨1, 0⟩

v · u = (3)(1) + (4)(0) = 3
u · u = 1² + 0² = 1

proj_u v = (3/1)⟨1, 0⟩ = ⟨3, 0⟩

Geometric Interpretation:
- Projection is the "shadow" of v onto line containing u
- Always lies along the direction of u
- Length equals |v|cos θ where θ is angle between vectors

Orthogonal Decomposition:
Any vector v can be decomposed as:
v = proj_u v + (v - proj_u v)

where proj_u v is parallel to u and (v - proj_u v) is orthogonal to u

Applications:
- Physics: Component of force in given direction
- Computer graphics: Lighting calculations
- Engineering: Stress analysis
- Statistics: Regression analysis
```

## Cross Product (3D Only)

### Definition and Properties

The cross product is defined only in 3D space and produces a vector perpendicular to both input vectors.

```
Cross Product Definition
═══════════════════════

Algebraic Formula:
u × v = ⟨u₂v₃ - u₃v₂, u₃v₁ - u₁v₃, u₁v₂ - u₂v₁⟩

Determinant Form:
u × v = |î  ĵ  k̂|
        |u₁ u₂ u₃|
        |v₁ v₂ v₃|

Example:
u = ⟨2, 1, -1⟩, v = ⟨1, 3, 2⟩

u × v = ⟨(1)(2) - (-1)(3), (-1)(1) - (2)(2), (2)(3) - (1)(1)⟩
      = ⟨2 + 3, -1 - 4, 6 - 1⟩
      = ⟨5, -5, 5⟩

Properties:
- Anti-commutative: u × v = -(v × u)
- Distributive: u × (v + w) = u × v + u × w
- Scalar associative: (cu) × v = c(u × v) = u × (cv)
- u × u = 0 (any vector crossed with itself is zero)
- u × v = 0 if and only if u and v are parallel

Geometric Properties:
- Result is perpendicular to both u and v
- Direction follows right-hand rule
- Magnitude: |u × v| = |u||v|sin θ
- Magnitude equals area of parallelogram formed by u and v
```

### Applications of Cross Product

```
Cross Product Applications
═════════════════════════

Area Calculations:
Area of parallelogram = |u × v|
Area of triangle = (1/2)|u × v|

Example:
Find area of triangle with vertices A(1,0,0), B(0,1,0), C(0,0,1)

AB⃗ = ⟨-1, 1, 0⟩
AC⃗ = ⟨-1, 0, 1⟩

AB⃗ × AC⃗ = ⟨1, 1, 1⟩
|AB⃗ × AC⃗| = √(1² + 1² + 1²) = √3

Area = (1/2)√3

Normal Vectors:
u × v gives normal vector to plane containing u and v
Used in computer graphics for surface normals

Torque in Physics:
τ = r × F
where r is position vector and F is force vector
Magnitude: |τ| = |r||F|sin θ

Angular Velocity:
v = ω × r
where ω is angular velocity vector and r is position vector

Right-Hand Rule:
Point fingers in direction of first vector
Curl toward second vector
Thumb points in direction of cross product
```

## Vector Spaces and Subspaces

### Vector Space Axioms

```
Formal Vector Space Definition
═════════════════════════════

A vector space V over field F satisfies:

Closure Properties:
1. u + v ∈ V for all u, v ∈ V
2. cu ∈ V for all c ∈ F, u ∈ V

Addition Properties:
3. u + v = v + u (commutative)
4. (u + v) + w = u + (v + w) (associative)
5. ∃ 0 ∈ V such that v + 0 = v for all v ∈ V
6. For each v ∈ V, ∃ (-v) ∈ V such that v + (-v) = 0

Scalar Multiplication Properties:
7. c(u + v) = cu + cv
8. (c + d)u = cu + du
9. c(du) = (cd)u
10. 1u = u

Examples of Vector Spaces:
- ℝⁿ: n-tuples of real numbers
- ℂⁿ: n-tuples of complex numbers
- Pₙ: polynomials of degree ≤ n
- C[a,b]: continuous functions on interval [a,b]
- Mₘₓₙ: m×n matrices with real entries

Non-Examples:
- Positive real numbers (no additive identity)
- Integers (not closed under scalar multiplication)
- Vectors in ℝ² with first component = 1 (no zero vector)
```

### Subspaces

```
Subspace Definition and Tests
════════════════════════════

A subset W of vector space V is a subspace if:
1. 0 ∈ W (contains zero vector)
2. Closed under addition: u, v ∈ W ⟹ u + v ∈ W
3. Closed under scalar multiplication: u ∈ W, c ∈ F ⟹ cu ∈ W

Equivalent Test:
W is a subspace if and only if:
au + bv ∈ W for all u, v ∈ W and scalars a, b

Examples in ℝ³:
- {0}: trivial subspace
- Lines through origin: {t⟨a, b, c⟩ : t ∈ ℝ}
- Planes through origin: {s⟨a₁, b₁, c₁⟩ + t⟨a₂, b₂, c₂⟩ : s, t ∈ ℝ}
- ℝ³ itself: improper subspace

Non-Examples:
- Line not through origin (no zero vector)
- First quadrant in ℝ² (not closed under scalar multiplication)
- Unit sphere (not closed under addition)

Important Subspaces:
- Span of vectors: span{v₁, v₂, ..., vₖ}
- Null space of matrix: {x : Ax = 0}
- Column space of matrix: span of column vectors
- Row space of matrix: span of row vectors
```

## Linear Independence and Basis

### Linear Independence

```
Linear Independence Definition
═════════════════════════════

Vectors v₁, v₂, ..., vₖ are linearly independent if:
c₁v₁ + c₂v₂ + ... + cₖvₖ = 0 ⟹ c₁ = c₂ = ... = cₖ = 0

Otherwise, they are linearly dependent.

Testing Linear Independence:
Set up equation c₁v₁ + c₂v₂ + ... + cₖvₖ = 0
Solve for coefficients c₁, c₂, ..., cₖ
If only solution is all cᵢ = 0, vectors are independent

Example:
Test independence of v₁ = ⟨1, 2, 0⟩, v₂ = ⟨0, 1, 1⟩, v₃ = ⟨1, 0, -1⟩

c₁⟨1, 2, 0⟩ + c₂⟨0, 1, 1⟩ + c₃⟨1, 0, -1⟩ = ⟨0, 0, 0⟩

This gives system:
c₁ + c₃ = 0
2c₁ + c₂ = 0
c₂ - c₃ = 0

Solving: c₁ = c₂ = c₃ = 0 (only solution)
Therefore, vectors are linearly independent.

Geometric Interpretation:
- 2 vectors: independent if not parallel
- 3 vectors in ℝ³: independent if not coplanar
- n vectors in ℝⁿ: independent if they span n-dimensional space

Key Facts:
- Any set containing zero vector is dependent
- More than n vectors in ℝⁿ must be dependent
- Subset of independent set is independent
- Superset of dependent set is dependent
```

### Basis and Dimension

```
Basis Definition
═══════════════

A basis for vector space V is a set of vectors that:
1. Spans V (every vector in V is a linear combination)
2. Is linearly independent

Properties of Bases:
- Every vector space has a basis
- All bases of a space have the same number of elements
- Basis provides unique representation for each vector

Standard Bases:
ℝ²: {⟨1, 0⟩, ⟨0, 1⟩}
ℝ³: {⟨1, 0, 0⟩, ⟨0, 1, 0⟩, ⟨0, 0, 1⟩}
ℝⁿ: {e₁, e₂, ..., eₙ} where eᵢ has 1 in position i, 0 elsewhere

Alternative Bases:
ℝ²: {⟨1, 1⟩, ⟨1, -1⟩}
ℝ³: {⟨1, 1, 0⟩, ⟨0, 1, 1⟩, ⟨1, 0, 1⟩}

Dimension:
The dimension of vector space V is the number of vectors in any basis for V

dim(ℝⁿ) = n
dim({0}) = 0
dim(line through origin) = 1
dim(plane through origin) = 2

Coordinate Representation:
If B = {v₁, v₂, ..., vₙ} is basis for V and v = c₁v₁ + c₂v₂ + ... + cₙvₙ,
then [v]ᵦ = ⟨c₁, c₂, ..., cₙ⟩ is the coordinate vector of v relative to B

Change of Basis:
Converting between different coordinate systems
Involves matrix transformations between bases
```

## Applications and Examples

### Computer Graphics

```
Graphics Applications
════════════════════

3D Transformations:
- Translation: v' = v + d (where d is displacement vector)
- Scaling: v' = sv (where s is scale factor)
- Rotation: v' = Rv (where R is rotation matrix)

Lighting Calculations:
- Surface normals using cross products
- Diffuse lighting: intensity ∝ n · l (normal dot light direction)
- Specular reflection using vector reflections

Camera Systems:
- View vectors: direction camera is pointing
- Up vectors: orientation of camera
- Right vectors: perpendicular to view and up

Animation:
- Interpolation between keyframes using linear combinations
- Velocity vectors for motion
- Acceleration vectors for realistic physics

Example: Rotating point (3, 4) by 90° counterclockwise
Rotation matrix: R = [0  -1]
                     [1   0]

v' = Rv = [0  -1][3] = [-4]
          [1   0][4]   [3]

Result: (3, 4) → (-4, 3)
```

### Physics Applications

```
Physics Vector Applications
══════════════════════════

Force Analysis:
- Resultant force: F_net = F₁ + F₂ + ... + Fₙ
- Equilibrium: ΣF = 0
- Components: F_x = |F|cos θ, F_y = |F|sin θ

Motion in 2D and 3D:
- Position: r(t) = ⟨x(t), y(t), z(t)⟩
- Velocity: v(t) = dr/dt
- Acceleration: a(t) = dv/dt

Electromagnetic Fields:
- Electric field: E = F/q (force per unit charge)
- Magnetic field: F = q(v × B) (Lorentz force)
- Electromagnetic waves: E ⊥ B ⊥ direction of propagation

Example: Projectile Motion
Initial velocity: v₀ = ⟨v₀cos θ, v₀sin θ⟩
Acceleration: a = ⟨0, -g⟩
Position: r(t) = r₀ + v₀t + (1/2)at²
        = ⟨x₀ + v₀cos θ · t, y₀ + v₀sin θ · t - (1/2)gt²⟩
```

### Engineering Applications

```
Engineering Vector Uses
══════════════════════

Structural Analysis:
- Force vectors in trusses and beams
- Moment vectors for rotational effects
- Stress and strain tensors (advanced)

Signal Processing:
- Signals as vectors in function space
- Fourier analysis using orthogonal basis functions
- Filtering as projection operations

Control Systems:
- State vectors representing system conditions
- Input and output vectors
- Feedback control using vector operations

Robotics:
- Position and orientation vectors
- Joint angles as configuration vectors
- Path planning in configuration space

Example: Truss Analysis
Forces at joint must sum to zero:
F₁ + F₂ + F₃ = 0

If F₁ = ⟨100, 0⟩ N and F₂ = ⟨-50, 86.6⟩ N,
then F₃ = -F₁ - F₂ = ⟨-50, -86.6⟩ N
```

## Summary and Key Concepts

Vectors provide the fundamental language for describing multidimensional quantities and relationships, forming the cornerstone of linear algebra and its applications.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Vector representation in multiple dimensions
✓ Vector operations (addition, scalar multiplication, dot product, cross product)
✓ Geometric interpretation of vector operations
✓ Linear combinations and their significance
✓ Understanding of vector spaces and subspaces
✓ Linear independence and basis concepts
✓ Applications in graphics, physics, and engineering

Key Concepts:
• Vectors as quantities with magnitude and direction
• Algebraic and geometric approaches to vector operations
• Dot product for angles, projections, and orthogonality
• Cross product for areas, normals, and rotations (3D)
• Vector spaces as abstract mathematical structures
• Basis as minimal spanning sets
• Dimension as measure of space "size"

Fundamental Operations:
• Addition: u + v (parallelogram law)
• Scalar multiplication: cv (scaling and direction)
• Dot product: u · v = |u||v|cos θ
• Cross product: u × v (perpendicular vector, 3D only)
• Linear combination: c₁v₁ + c₂v₂ + ... + cₙvₙ

Applications Covered:
• Computer graphics and 3D transformations
• Physics: forces, motion, electromagnetic fields
• Engineering: structural analysis, signal processing
• Geometric calculations: areas, angles, projections

Next Steps:
Vector concepts prepare you for:
- Matrix operations and linear transformations
- Systems of linear equations
- Eigenvalues and eigenvectors
- Advanced applications in data science and machine learning
```

Vectors represent one of the most intuitive yet powerful concepts in mathematics. By mastering vector operations and their geometric interpretations, you've built essential foundations for understanding linear transformations, solving systems of equations, and applying linear algebra to real-world problems. The skills developed in this chapter will serve as building blocks for all subsequent topics in linear algebra and its applications across science, engineering, and technology.