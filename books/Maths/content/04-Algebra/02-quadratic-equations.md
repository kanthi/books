# Quadratic Equations: Exploring Parabolic Relationships

## Introduction to Quadratic Equations

A quadratic equation is a polynomial equation of degree 2, meaning the highest power of the variable is 2. These equations model many real-world phenomena involving acceleration, optimization, and curved relationships.

```
Quadratic Equation Forms
═══════════════════════

Standard Form: ax² + bx + c = 0 (a ≠ 0)
- a, b, c are constants (coefficients)
- a ≠ 0 (otherwise it's linear, not quadratic)
- x is the variable

Examples:
x² - 5x + 6 = 0     (a=1, b=-5, c=6)
2x² + 3x - 1 = 0    (a=2, b=3, c=-1)
x² - 9 = 0          (a=1, b=0, c=-9)
3x² + 12x = 0       (a=3, b=12, c=0)

Other Forms:
Vertex Form: y = a(x - h)² + k
Factored Form: y = a(x - r₁)(x - r₂)
```

## The Parabola: Graph of Quadratic Functions

### Understanding Parabolic Shape

Quadratic functions graph as parabolas - U-shaped curves that open upward or downward.

```
Parabola Characteristics
══════════════════════

Direction of Opening:
a > 0: Opens upward (∪)
a < 0: Opens downward (∩)

Key Features:
• Vertex: Highest or lowest point
• Axis of symmetry: Vertical line through vertex
• y-intercept: Point where graph crosses y-axis
• x-intercepts: Points where graph crosses x-axis (roots)

Vertex Location:
For y = ax² + bx + c:
x-coordinate of vertex: x = -b/(2a)
y-coordinate: substitute x-value back into equation

Example: y = x² - 4x + 3
Vertex x-coordinate: x = -(-4)/(2·1) = 2
Vertex y-coordinate: y = (2)² - 4(2) + 3 = -1
Vertex: (2, -1)
```

### Graphing Quadratic Functions

```
Graphing Process
═══════════════

Method 1: Using Vertex and Additional Points
1. Find vertex using x = -b/(2a)
2. Find y-intercept (set x = 0)
3. Find x-intercepts if they exist (set y = 0)
4. Plot additional points for accuracy
5. Draw smooth parabola

Method 2: Using Transformations
For y = a(x - h)² + k:
- Start with parent function y = x²
- Horizontal shift: h units (right if +, left if -)
- Vertical shift: k units (up if +, down if -)
- Vertical stretch/compression: factor of |a|
- Reflection: if a < 0, flip over x-axis

Example: y = -2(x + 1)² + 3
- Start with y = x²
- Shift left 1 unit: y = (x + 1)²
- Stretch by factor 2: y = 2(x + 1)²
- Reflect over x-axis: y = -2(x + 1)²
- Shift up 3 units: y = -2(x + 1)² + 3
```

## Solving Quadratic Equations

### Method 1: Factoring

When a quadratic can be written as a product of linear factors, we can use the zero product property.

```
Factoring Strategies
═══════════════════

Zero Product Property:
If ab = 0, then a = 0 or b = 0

Common Factoring Patterns:
1. Greatest Common Factor (GCF)
   3x² + 6x = 3x(x + 2) = 0
   Solutions: x = 0 or x = -2

2. Difference of Squares
   x² - 9 = (x + 3)(x - 3) = 0
   Solutions: x = -3 or x = 3

3. Perfect Square Trinomials
   x² + 6x + 9 = (x + 3)² = 0
   Solution: x = -3 (double root)

4. General Trinomials (ax² + bx + c)
   x² - 5x + 6 = (x - 2)(x - 3) = 0
   Solutions: x = 2 or x = 3

Factoring Process for x² + bx + c:
Find two numbers that:
- Multiply to give c
- Add to give b

Example: x² - 7x + 12
Need two numbers that multiply to 12 and add to -7
-3 and -4: (-3)(-4) = 12, (-3) + (-4) = -7 ✓
So: x² - 7x + 12 = (x - 3)(x - 4) = 0
Solutions: x = 3 or x = 4
```

### Method 2: Quadratic Formula

The quadratic formula provides a systematic way to solve any quadratic equation.

```
The Quadratic Formula
════════════════════

For ax² + bx + c = 0:

x = (-b ± √(b² - 4ac))/(2a)

Components:
- Discriminant: Δ = b² - 4ac
- ± means two solutions (usually)

Discriminant Analysis:
Δ > 0: Two distinct real solutions
Δ = 0: One repeated real solution
Δ < 0: No real solutions (two complex solutions)

Example: 2x² + 3x - 1 = 0
a = 2, b = 3, c = -1
Δ = 3² - 4(2)(-1) = 9 + 8 = 17 > 0 (two real solutions)

x = (-3 ± √17)/(2·2) = (-3 ± √17)/4

Solutions: x = (-3 + √17)/4 ≈ 0.28 or x = (-3 - √17)/4 ≈ -1.28
```

### Method 3: Completing the Square

This method transforms a quadratic into perfect square form, useful for finding vertex form and solving equations.

```
Completing the Square Process
════════════════════════════

For ax² + bx + c = 0:

1. If a ≠ 1, divide entire equation by a
2. Move constant to right side
3. Add (b/2)² to both sides
4. Factor left side as perfect square
5. Solve by taking square root

Example: x² + 6x + 5 = 0

Step 1: x² + 6x = -5
Step 2: Add (6/2)² = 9 to both sides
        x² + 6x + 9 = -5 + 9
        x² + 6x + 9 = 4
Step 3: Factor: (x + 3)² = 4
Step 4: Take square root: x + 3 = ±2
Step 5: Solve: x = -3 ± 2
        x = -1 or x = -5

Converting to Vertex Form:
x² + 6x + 5 = (x + 3)² - 9 + 5 = (x + 3)² - 4
Vertex: (-3, -4)
```

### Method 4: Graphing

Graphical solutions involve finding where the parabola crosses the x-axis.

```
Graphical Solution Method
════════════════════════

Steps:
1. Graph the quadratic function y = ax² + bx + c
2. Find x-intercepts (where y = 0)
3. These x-values are the solutions

Advantages:
✓ Visual understanding of solutions
✓ Shows relationship between equation and graph
✓ Useful for approximate solutions

Limitations:
⚠ May not give exact values
⚠ Requires accurate graphing
⚠ Some solutions may not be visible on standard viewing window

Technology Tools:
- Graphing calculators
- Computer algebra systems
- Online graphing tools
- Spreadsheet programs
```

## Applications of Quadratic Equations

### Projectile Motion

Quadratic equations naturally model objects moving under the influence of gravity.

```
Projectile Motion Models
══════════════════════

Height Equation: h(t) = -16t² + v₀t + h₀
- h(t) = height at time t
- -16 = acceleration due to gravity (ft/s²)
- v₀ = initial velocity
- h₀ = initial height

Key Questions:
1. When does object hit ground? (h = 0)
2. What is maximum height? (vertex)
3. When is object at specific height?

Example: Ball thrown upward
"A ball is thrown upward from a 6-foot platform with initial velocity 32 ft/s."

Equation: h(t) = -16t² + 32t + 6

Maximum height:
t = -32/(2(-16)) = 1 second
h(1) = -16(1)² + 32(1) + 6 = 22 feet

Time to hit ground:
-16t² + 32t + 6 = 0
Using quadratic formula: t ≈ 2.18 seconds
```

### Area and Optimization Problems

```
Optimization Applications
═══════════════════════

Maximum/Minimum Problems:
Since parabolas have vertex as extreme point, quadratics are perfect for optimization.

Example: Rectangular Enclosure
"A farmer has 100 feet of fencing to enclose a rectangular area against a barn. What dimensions maximize the area?"

Setup:
Let x = width of rectangle
Then 100 - 2x = length (since one side is the barn)
Area: A(x) = x(100 - 2x) = 100x - 2x²

This is quadratic with a = -2 < 0 (maximum exists)
Maximum at x = -100/(2(-2)) = 25 feet
Maximum area: A(25) = 25(50) = 1250 square feet

Business Applications:
Revenue: R(x) = px (price × quantity)
If price affects demand: p = a - bx
Then: R(x) = x(a - bx) = ax - bx²
Maximum revenue occurs at vertex
```

### Geometric Applications

```
Geometric Problem Types
═════════════════════

Pythagorean Theorem Applications:
a² + b² = c² often leads to quadratic equations

Example: "A ladder leans against a wall. The ladder is 13 feet long, and its base is 5 feet from the wall. How high up the wall does it reach?"

Setup: 5² + h² = 13²
       25 + h² = 169
       h² = 144
       h = 12 feet

Area Problems:
Often involve quadratic relationships

Example: "A square has the same area as a rectangle with length 12 and width 3. What is the side length of the square?"

Setup: s² = 12 × 3 = 36
       s = 6

Number Problems:
"Find two consecutive integers whose product is 132."
Let n = first integer, n+1 = second
n(n+1) = 132
n² + n - 132 = 0
(n + 12)(n - 11) = 0
n = 11 or n = -12
Positive solution: 11 and 12
```

## Complex Solutions and the Discriminant

### Understanding the Discriminant

The discriminant Δ = b² - 4ac provides crucial information about quadratic solutions.

```
Discriminant Analysis
════════════════════

Δ > 0: Two distinct real solutions
- Parabola crosses x-axis at two points
- Factoring possible (usually)
- Example: x² - 5x + 6 = 0, Δ = 25 - 24 = 1

Δ = 0: One repeated real solution
- Parabola touches x-axis at vertex
- Perfect square trinomial
- Example: x² - 6x + 9 = 0, Δ = 36 - 36 = 0

Δ < 0: No real solutions (two complex solutions)
- Parabola doesn't cross x-axis
- Solutions involve imaginary numbers
- Example: x² + x + 1 = 0, Δ = 1 - 4 = -3

Applications:
- Determine solution type before solving
- Analyze when problems have real solutions
- Understand graphical behavior
```

### Introduction to Complex Numbers

When the discriminant is negative, solutions involve the imaginary unit i = √(-1).

```
Complex Number Basics
════════════════════

Imaginary Unit: i = √(-1)
Properties: i² = -1, i³ = -i, i⁴ = 1

Complex Number Form: a + bi
- a = real part
- b = imaginary part

Example: x² + 2x + 5 = 0
Δ = 4 - 20 = -16 < 0

x = (-2 ± √(-16))/2 = (-2 ± 4i)/2 = -1 ± 2i

Solutions: x = -1 + 2i and x = -1 - 2i
(These are complex conjugates)

Verification:
(-1 + 2i)² + 2(-1 + 2i) + 5
= 1 - 4i - 4 - 2 + 4i + 5 = 0 ✓
```

## Systems of Quadratic Equations

### Linear-Quadratic Systems

Systems involving one linear and one quadratic equation.

```
Solution Methods
═══════════════

Substitution Method:
1. Solve linear equation for one variable
2. Substitute into quadratic equation
3. Solve resulting quadratic
4. Back-substitute to find other variable

Example:
{y = x + 1
{x² + y² = 25

Substitute: x² + (x + 1)² = 25
           x² + x² + 2x + 1 = 25
           2x² + 2x - 24 = 0
           x² + x - 12 = 0
           (x + 4)(x - 3) = 0
           x = -4 or x = 3

When x = -4: y = -4 + 1 = -3
When x = 3: y = 3 + 1 = 4

Solutions: (-4, -3) and (3, 4)

Graphical Interpretation:
Solutions are intersection points of line and parabola
Can have 0, 1, or 2 solutions
```

## Quadratic Inequalities

### Solving Quadratic Inequalities

Quadratic inequalities involve finding where a quadratic expression is positive or negative.

```
Solution Process
═══════════════

1. Write in standard form: ax² + bx + c > 0 (or <, ≥, ≤)
2. Find zeros of corresponding equation ax² + bx + c = 0
3. Plot zeros on number line
4. Test sign in each interval
5. Choose intervals that satisfy inequality

Example: x² - 5x + 6 > 0

Step 1: Factor: (x - 2)(x - 3) > 0
Step 2: Zeros: x = 2 and x = 3
Step 3: Number line intervals: (-∞, 2), (2, 3), (3, ∞)
Step 4: Test points:
        x = 0: (0-2)(0-3) = 6 > 0 ✓
        x = 2.5: (2.5-2)(2.5-3) = -0.25 < 0 ✗
        x = 4: (4-2)(4-3) = 2 > 0 ✓
Step 5: Solution: x < 2 or x > 3
        Interval notation: (-∞, 2) ∪ (3, ∞)

Sign Chart Method:
     - - - - - + + + + + + + + + +
     -------|-------|-------
           2       3
```

## Advanced Topics and Extensions

### Quadratic Functions in Vertex Form

```
Vertex Form Applications
══════════════════════

Form: f(x) = a(x - h)² + k
- (h, k) is the vertex
- a determines opening direction and width
- Useful for transformations and optimization

Converting Standard to Vertex Form:
Complete the square process

Example: f(x) = 2x² - 8x + 3
Factor out coefficient of x²: f(x) = 2(x² - 4x) + 3
Complete square inside: x² - 4x + 4 = (x - 2)²
Adjust: f(x) = 2(x² - 4x + 4 - 4) + 3
       = 2((x - 2)² - 4) + 3
       = 2(x - 2)² - 8 + 3
       = 2(x - 2)² - 5

Vertex: (2, -5)
```

### Quadratic Modeling

```
Real-World Modeling
══════════════════

Revenue and Profit Models:
Often quadratic due to price-demand relationships

Population Models:
P(t) = at² + bt + c (when growth rate changes)

Physics Applications:
- Projectile motion: h(t) = -½gt² + v₀t + h₀
- Kinetic energy: KE = ½mv²
- Electrical power: P = I²R

Engineering Applications:
- Beam deflection
- Signal processing
- Optimization problems

Data Analysis:
Quadratic regression for curved data patterns
```

## Summary and Key Concepts

Quadratic equations extend algebraic problem-solving to curved relationships and optimization problems, providing essential tools for modeling real-world phenomena.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Solving quadratic equations by multiple methods
✓ Graphing parabolas and identifying key features
✓ Applying quadratics to real-world problems
✓ Understanding the discriminant and solution types
✓ Working with quadratic inequalities
✓ Converting between different forms

Key Formulas:
• Standard form: ax² + bx + c = 0
• Quadratic formula: x = (-b ± √(b² - 4ac))/(2a)
• Vertex formula: x = -b/(2a)
• Discriminant: Δ = b² - 4ac
• Vertex form: y = a(x - h)² + k

Solution Methods:
• Factoring (when possible)
• Quadratic formula (always works)
• Completing the square (useful for vertex form)
• Graphing (visual understanding)

Applications Covered:
• Projectile motion and physics
• Area and optimization problems
• Business and economics models
• Geometric relationships

Next Steps:
Quadratic concepts prepare you for:
- Higher-degree polynomials
- Exponential and logarithmic functions
- Conic sections
- Calculus applications
```

Quadratic equations represent a significant step forward in algebraic sophistication, introducing curved relationships, optimization concepts, and complex number systems. The problem-solving strategies and mathematical reasoning developed through quadratic equations form essential foundations for advanced mathematics and real-world applications across science, engineering, and business.