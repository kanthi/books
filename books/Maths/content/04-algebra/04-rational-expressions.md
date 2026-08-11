# Rational Expressions: Working with Algebraic Fractions

## Introduction to Rational Expressions

A rational expression is a fraction where both the numerator and denominator are polynomials. Just as rational numbers are ratios of integers, rational expressions are ratios of polynomials.

```
Rational Expression Structure
════════════════════════════

General Form: P(x)/Q(x) where P(x) and Q(x) are polynomials and Q(x) ≠ 0

Examples:
Simple: 3/x, (x+1)/(x-2), 5/(x²+1)

Complex: (x²-4)/(x²+3x+2), (2x³-x+1)/(x⁴-16)

Mixed: 3 + 2/x = (3x+2)/x

Domain Restrictions:
The denominator cannot equal zero
Find values that make Q(x) = 0 and exclude them

Example: f(x) = (x+3)/(x²-9)
Domain restriction: x² - 9 ≠ 0
x² ≠ 9
x ≠ ±3
Domain: all real numbers except x = 3 and x = -3
```

## Simplifying Rational Expressions

### Finding Common Factors

The key to simplifying rational expressions is factoring both numerator and denominator, then canceling common factors.

```
Simplification Process
═════════════════════

Steps:
1. Factor numerator completely
2. Factor denominator completely
3. Cancel common factors
4. State domain restrictions

Example 1: (x²-9)/(x²+3x)

Step 1: Factor numerator: x² - 9 = (x+3)(x-3)
Step 2: Factor denominator: x² + 3x = x(x+3)
Step 3: Cancel common factor (x+3):
        (x+3)(x-3)/(x(x+3)) = (x-3)/x
Step 4: Domain: x ≠ 0, x ≠ -3

Example 2: (x²+5x+6)/(x²+2x-3)

Step 1: Factor numerator: x² + 5x + 6 = (x+2)(x+3)
Step 2: Factor denominator: x² + 2x - 3 = (x+3)(x-1)
Step 3: Cancel (x+3): (x+2)(x+3)/((x+3)(x-1)) = (x+2)/(x-1)
Step 4: Domain: x ≠ -3, x ≠ 1

Important: Even after canceling, original domain restrictions remain!
```

### Complex Rational Expressions

```
Simplifying Complex Fractions
════════════════════════════

Complex fraction: Fraction containing fractions in numerator or denominator

Method 1: Multiply by LCD of all fractions

Example: (1/x + 1/y)/(1/x - 1/y)

LCD of all fractions = xy

Multiply numerator and denominator by xy:
= (xy(1/x + 1/y))/(xy(1/x - 1/y))
= (y + x)/(y - x)

Method 2: Simplify numerator and denominator separately, then divide

Example: (2 + 3/x)/(1 - 1/x²)

Numerator: 2 + 3/x = (2x + 3)/x
Denominator: 1 - 1/x² = (x² - 1)/x²

Result: (2x + 3)/x ÷ (x² - 1)/x² = (2x + 3)/x · x²/(x² - 1) = x(2x + 3)/(x² - 1)

Factor further: = x(2x + 3)/((x + 1)(x - 1))
```

## Operations with Rational Expressions

### Addition and Subtraction

Like numerical fractions, rational expressions need common denominators for addition and subtraction.

```
Addition and Subtraction Process
══════════════════════════════

Steps:
1. Find LCD (Least Common Denominator)
2. Rewrite each fraction with LCD
3. Add/subtract numerators
4. Simplify if possible

Example 1: 3/x + 2/(x+1)

LCD = x(x+1)

3/x = 3(x+1)/(x(x+1)) = (3x+3)/(x(x+1))
2/(x+1) = 2x/(x(x+1))

Sum: (3x+3)/(x(x+1)) + 2x/(x(x+1)) = (3x+3+2x)/(x(x+1)) = (5x+3)/(x(x+1))

Example 2: (x+2)/(x²-4) - 1/(x+2)

Factor: x² - 4 = (x+2)(x-2)
LCD = (x+2)(x-2)

(x+2)/(x²-4) = (x+2)/((x+2)(x-2))
1/(x+2) = (x-2)/((x+2)(x-2))

Difference: (x+2)/((x+2)(x-2)) - (x-2)/((x+2)(x-2)) = ((x+2)-(x-2))/((x+2)(x-2)) = 4/((x+2)(x-2))

Simplified: 4/(x²-4)
```

### Multiplication and Division

```
Multiplication and Division Rules
═══════════════════════════════

Multiplication: (A/B) · (C/D) = (AC)/(BD)
Division: (A/B) ÷ (C/D) = (A/B) · (D/C) = (AD)/(BC)

Process:
1. Factor all polynomials
2. Cancel common factors before multiplying
3. Multiply remaining factors
4. State domain restrictions

Example 1: (x²-1)/(x+2) · (x+2)/(x²+x)

Factor: x² - 1 = (x+1)(x-1), x² + x = x(x+1)

= ((x+1)(x-1))/(x+2) · (x+2)/(x(x+1))
= ((x+1)(x-1)(x+2))/((x+2)x(x+1))

Cancel (x+1) and (x+2):
= (x-1)/x

Domain: x ≠ 0, x ≠ -1, x ≠ -2

Example 2: (x²+3x+2)/(x²-4) ÷ (x+1)/(x-2)

= (x²+3x+2)/(x²-4) · (x-2)/(x+1)

Factor: x² + 3x + 2 = (x+1)(x+2), x² - 4 = (x+2)(x-2)

= ((x+1)(x+2))/((x+2)(x-2)) · (x-2)/(x+1)
= ((x+1)(x+2)(x-2))/((x+2)(x-2)(x+1))
= 1

Domain: x ≠ ±2, x ≠ -1
```

## Solving Rational Equations

### Basic Solution Techniques

A rational equation contains one or more rational expressions. To solve, clear the denominators by multiplying by the LCD.

```
Solution Process
═══════════════

Steps:
1. Find LCD of all denominators
2. Multiply entire equation by LCD
3. Solve resulting polynomial equation
4. Check solutions in original equation
5. Reject any extraneous solutions

Example 1: 3/x + 2 = 7/x

LCD = x
Multiply by x: x(3/x + 2) = x(7/x)
3 + 2x = 7
2x = 4
x = 2

Check: 3/2 + 2 = 1.5 + 2 = 3.5, 7/2 = 3.5 ✓

Example 2: 1/(x-1) + 2/(x+1) = 4/(x²-1)

Factor: x² - 1 = (x-1)(x+1)
LCD = (x-1)(x+1)

Multiply by LCD:
(x+1) + 2(x-1) = 4
x + 1 + 2x - 2 = 4
3x - 1 = 4
3x = 5
x = 5/3

Check: Substitute x = 5/3 into original equation
Domain check: x ≠ ±1, and 5/3 ≠ ±1 ✓
```

### Extraneous Solutions

```
Why Extraneous Solutions Occur
═════════════════════════════

When we multiply by LCD, we may introduce solutions that make the original denominators zero.

Example: 1/(x-2) + 1/(x+2) = 4/(x²-4)

LCD = x² - 4 = (x-2)(x+2)
Multiply by LCD:
(x+2) + (x-2) = 4
2x = 4
x = 2

Check: x = 2 makes denominators zero in original equation!
This is an extraneous solution.

The equation has no solution.

Always check solutions:
1. Substitute back into original equation
2. Verify denominators are not zero
3. Reject any extraneous solutions

Example with valid solution:
2/(x-1) = 3/(x+2)

Cross multiply: 2(x+2) = 3(x-1)
2x + 4 = 3x - 3
7 = x

Check: x = 7 doesn't make any denominator zero ✓
2/(7-1) = 2/6 = 1/3
3/(7+2) = 3/9 = 1/3 ✓
```

## Applications of Rational Expressions

### Work Rate Problems

```
Work Rate Formula
════════════════

If person A can complete a job in a hours and person B can complete it in b hours, then:
- A's rate: 1/a jobs per hour
- B's rate: 1/b jobs per hour
- Combined rate: 1/a + 1/b jobs per hour

Example: "John can paint a fence in 6 hours. Mary can paint the same fence in 4 hours. How long will it take them working together?"

John's rate: 1/6 fence per hour
Mary's rate: 1/4 fence per hour
Combined rate: 1/6 + 1/4 = 2/12 + 3/12 = 5/12 fence per hour

Time together: 1 ÷ (5/12) = 12/5 = 2.4 hours

Verification: In 2.4 hours:
John completes: 2.4 × (1/6) = 0.4 of fence
Mary completes: 2.4 × (1/4) = 0.6 of fence
Total: 0.4 + 0.6 = 1.0 fence ✓
```

### Distance-Rate-Time Problems

```
Motion Problems with Rational Expressions
═══════════════════════════════════════

Basic formula: Distance = Rate × Time, so Time = Distance/Rate

Example: "A boat travels 60 miles upstream in the same time it takes to travel 80 miles downstream. If the current is 2 mph, find the boat's speed in still water."

Let x = boat's speed in still water
Upstream speed: x - 2 mph
Downstream speed: x + 2 mph

Time upstream = 60/(x-2)
Time downstream = 80/(x+2)

Since times are equal:
60/(x-2) = 80/(x+2)

Cross multiply: 60(x+2) = 80(x-2)
60x + 120 = 80x - 160
280 = 20x
x = 14 mph

Check: Upstream time = 60/12 = 5 hours
       Downstream time = 80/16 = 5 hours ✓
```

### Mixture and Concentration Problems

```
Concentration Problems
═════════════════════

Amount of pure substance = Concentration × Total volume

Example: "How many gallons of a 20% salt solution must be mixed with 5 gallons of a 60% salt solution to get a 40% salt solution?"

Let x = gallons of 20% solution needed

Salt from 20% solution: 0.20x
Salt from 60% solution: 0.60(5) = 3
Total salt: 0.20x + 3

Total volume: x + 5
Final concentration: 40% = 0.40

Equation: (0.20x + 3)/(x + 5) = 0.40

Solve: 0.20x + 3 = 0.40(x + 5)
       0.20x + 3 = 0.40x + 2
       1 = 0.20x
       x = 5 gallons

Check: Salt: 0.20(5) + 3 = 4 gallons
       Total: 5 + 5 = 10 gallons
       Concentration: 4/10 = 0.40 = 40% ✓
```

## Rational Functions and Their Graphs

### Domain and Range

```
Analyzing Rational Functions
══════════════════════════

For f(x) = P(x)/Q(x):

Domain: All real numbers except where Q(x) = 0
Range: Depends on function behavior and asymptotes

Example: f(x) = (x+1)/(x-2)

Domain: x ≠ 2 (since x - 2 = 0 when x = 2)

To find range, solve for x in terms of y:
y = (x+1)/(x-2)
y(x-2) = x+1
yx - 2y = x + 1
yx - x = 2y + 1
x(y-1) = 2y + 1
x = (2y+1)/(y-1)

For x to be real, y - 1 ≠ 0, so y ≠ 1
Range: all real numbers except y = 1
```

### Vertical and Horizontal Asymptotes

```
Asymptote Analysis
═════════════════

Vertical Asymptotes:
Occur where denominator = 0 but numerator ≠ 0
Lines: x = a where Q(a) = 0 and P(a) ≠ 0

Horizontal Asymptotes:
Depend on degrees of numerator and denominator

Let n = degree of numerator, d = degree of denominator:
- If n < d: horizontal asymptote at y = 0
- If n = d: horizontal asymptote at y = (leading coefficient of P)/(leading coefficient of Q)
- If n > d: no horizontal asymptote (oblique asymptote may exist)

Example: f(x) = (2x²+1)/(x²-4)

Vertical asymptotes: x² - 4 = 0 → x = ±2
Horizontal asymptote: degrees equal, so y = 2/1 = 2

Behavior near asymptotes:
As x → 2⁺: f(x) → +∞ or -∞ (check sign)
As x → 2⁻: f(x) → +∞ or -∞ (check sign)
As x → ±∞: f(x) → 2
```

### Graphing Rational Functions

```
Graphing Process
═══════════════

Steps:
1. Find domain (vertical asymptotes)
2. Find horizontal/oblique asymptotes
3. Find x-intercepts (numerator = 0)
4. Find y-intercept (f(0))
5. Analyze behavior near asymptotes
6. Plot additional points as needed
7. Sketch graph

Example: f(x) = (x-1)/(x+2)

1. Domain: x ≠ -2 (vertical asymptote at x = -2)
2. Horizontal asymptote: y = 1 (degrees equal, coefficients both 1)
3. x-intercept: x - 1 = 0 → x = 1, point (1, 0)
4. y-intercept: f(0) = -1/2, point (0, -1/2)
5. Behavior near x = -2:
   As x → -2⁺: f(x) → +∞
   As x → -2⁻: f(x) → -∞
6. Additional points: f(-1) = -2, f(2) = 1/4
7. Sketch showing asymptotes and key points

Graph characteristics:
- Vertical asymptote at x = -2
- Horizontal asymptote at y = 1
- Passes through (1, 0) and (0, -1/2)
- Two separate branches
```

## Advanced Topics

### Partial Fraction Decomposition

```
Decomposing Rational Expressions
══════════════════════════════

Used to break complex rational expressions into simpler parts.

For proper fractions (degree of numerator < degree of denominator):

Case 1: Distinct Linear Factors
(3x+1)/((x-1)(x+2)) = A/(x-1) + B/(x+2)

Solve for A and B:
3x + 1 = A(x+2) + B(x-1)

Method 1 - Substitution:
x = 1: 3(1) + 1 = A(3) + B(0) → 4 = 3A → A = 4/3
x = -2: 3(-2) + 1 = A(0) + B(-3) → -5 = -3B → B = 5/3

Result: (3x+1)/((x-1)(x+2)) = (4/3)/(x-1) + (5/3)/(x+2)

Case 2: Repeated Linear Factors
(2x+3)/((x-1)²(x+2)) = A/(x-1) + B/(x-1)² + C/(x+2)

Case 3: Irreducible Quadratic Factors
(x+1)/((x²+1)(x-2)) = (Ax+B)/(x²+1) + C/(x-2)
```

### Rational Inequalities

```
Solving Rational Inequalities
════════════════════════════

Process:
1. Move all terms to one side
2. Find common denominator
3. Factor numerator and denominator
4. Find critical points (zeros and undefined points)
5. Create sign chart
6. Test intervals
7. Select appropriate intervals

Example: (x+1)/(x-2) > 0

Critical points: x = -1 (zero), x = 2 (undefined)

Sign chart:
Interval: (-∞,-1) | (-1,2) | (2,∞)
(x+1):       -    |   +    |   +
(x-2):       -    |   -    |   +
Quotient:    +    |   -    |   +

Solution: x ∈ (-∞,-1) ∪ (2,∞)

Note: x = 2 is excluded from domain
      x = -1 makes expression equal 0, not > 0
```

## Summary and Key Concepts

Rational expressions extend fraction arithmetic to algebraic expressions, providing tools for modeling complex relationships and solving advanced problems.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Simplifying rational expressions by factoring and canceling
✓ Performing operations (add, subtract, multiply, divide)
✓ Solving rational equations and checking for extraneous solutions
✓ Analyzing rational functions and their graphs
✓ Finding asymptotes and key features
✓ Applying rational expressions to real-world problems
✓ Working with complex rational expressions

Key Concepts:
• Domain restrictions and their importance
• Relationship between zeros, factors, and asymptotes
• Proper vs. improper rational expressions
• Vertical, horizontal, and oblique asymptotes
• Extraneous solutions in rational equations

Problem-Solving Applications:
• Work rate problems
• Distance-rate-time problems
• Mixture and concentration problems
• Optimization problems involving ratios

Advanced Topics:
• Partial fraction decomposition
• Rational inequalities
• Complex rational expressions
• Graphing techniques for rational functions

Next Steps:
Rational expression skills prepare you for:
- Limits and continuity in calculus
- Integration techniques (partial fractions)
- Differential equations
- Advanced function analysis
- Engineering and physics applications
```

Rational expressions represent a sophisticated extension of algebraic thinking, combining polynomial operations with fraction arithmetic. The skills developed in this chapter - domain analysis, asymptote identification, equation solving, and function graphing - form essential foundations for calculus and advanced mathematical applications. Understanding rational expressions provides insight into the behavior of complex functions and their real-world applications in science, engineering, and economics.