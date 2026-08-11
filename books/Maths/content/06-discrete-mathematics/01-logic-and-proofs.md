# Logic and Proofs: The Foundation of Mathematical Reasoning

## Introduction to Mathematical Logic

Mathematical logic provides the rigorous foundation for all mathematical reasoning and proof. It gives us precise tools for expressing mathematical statements, analyzing their truth values, and constructing valid arguments.

Logic is essential not only for pure mathematics but also for computer science, where it forms the basis for programming languages, database queries, artificial intelligence, and digital circuit design.

```
Logic in Mathematics and Computing
═════════════════════════════════

Mathematical Applications:
• Expressing theorems and definitions precisely
• Constructing rigorous proofs
• Analyzing mathematical structures
• Developing axiomatic systems

Computer Science Applications:
• Programming language semantics
• Database query languages (SQL)
• Artificial intelligence and expert systems
• Digital circuit design and verification
• Software specification and verification

Everyday Reasoning:
• Analyzing arguments and detecting fallacies
• Making logical decisions
• Understanding conditional statements
• Reasoning about cause and effect

Key Benefits:
✓ Precision in mathematical communication
✓ Systematic approach to problem-solving
✓ Foundation for automated reasoning
✓ Bridge between mathematics and computation
```

## Propositional Logic

### Basic Concepts and Connectives

Propositional logic deals with statements that are either true or false, and ways to combine them using logical connectives.

```
Propositional Logic Fundamentals
══════════════════════════════

Proposition: A declarative statement that is either true or false

Examples of Propositions:
✓ "2 + 3 = 5" (True)
✓ "Paris is the capital of France" (True)
✓ "7 is an even number" (False)
✓ "It is raining" (True or False, depending on circumstances)

Not Propositions:
✗ "What time is it?" (Question)
✗ "Close the door" (Command)
✗ "x + 1 = 5" (Contains variable, truth depends on x)
✗ "This statement is false" (Paradox)

Propositional Variables:
Use letters p, q, r, s, ... to represent propositions
p: "It is sunny"
q: "I will go to the beach"

Logical Connectives:
Symbol | Name        | Meaning
-------|-------------|----------
¬      | Negation    | not
∧      | Conjunction | and
∨      | Disjunction | or
→      | Implication | if...then
↔      | Biconditional| if and only if
```

### Truth Tables

Truth tables systematically show the truth values of compound propositions for all possible combinations of their components.

```
Truth Tables for Basic Connectives
═════════════════════════════════

Negation (¬p):
p | ¬p
--|---
T | F
F | T

Conjunction (p ∧ q):
p | q | p ∧ q
--|---|------
T | T |   T
T | F |   F
F | T |   F
F | F |   F

Disjunction (p ∨ q):
p | q | p ∨ q
--|---|------
T | T |   T
T | F |   T
F | T |   T
F | F |   F

Implication (p → q):
p | q | p → q
--|---|------
T | T |   T
T | F |   F
F | T |   T
F | F |   T

Biconditional (p ↔ q):
p | q | p ↔ q
--|---|------
T | T |   T
T | F |   F
F | T |   F
F | F |   T

Key Insights:
• Conjunction is true only when both parts are true
• Disjunction is false only when both parts are false
• Implication is false only when antecedent is true and consequent is false
• Biconditional is true when both parts have same truth value
```

## Proof Techniques

### Direct Proof

Direct proof is the most straightforward method: assume the hypothesis and logically derive the conclusion.

```
Direct Proof Method
══════════════════

Structure:
To prove P → Q:
1. Assume P is true
2. Use logical reasoning, definitions, and known facts
3. Derive Q

Template:
Proof: Assume P. [reasoning steps] Therefore Q. ∎

Example 1: Prove "If n is even, then n² is even"
Proof:
Assume n is even. Then n = 2k for some integer k.
Therefore n² = (2k)² = 4k² = 2(2k²).
Since 2k² is an integer, n² is even. ∎

Example 2: Prove "If x and y are rational, then x + y is rational"
Proof:
Assume x and y are rational.
Then x = a/b and y = c/d where a, b, c, d are integers and b, d ≠ 0.
Therefore x + y = a/b + c/d = (ad + bc)/(bd).
Since ad + bc and bd are integers and bd ≠ 0, x + y is rational. ∎

Key Strategies:
• Start with definitions of terms in hypothesis
• Use algebraic manipulation when appropriate
• Apply known theorems and properties
• Work step-by-step toward conclusion
• Ensure each step follows logically from previous steps
```

### Proof by Contradiction

Proof by contradiction assumes the negation of what we want to prove and derives a logical contradiction.

```
Proof by Contradiction Method
════════════════════════════

Structure:
To prove P:
1. Assume ¬P (not P)
2. Use logical reasoning
3. Derive a contradiction (Q ∧ ¬Q)
4. Conclude P must be true

Example: Prove "√2 is irrational"
Proof:
Assume for the sake of contradiction that √2 is rational.
Then √2 = p/q where p, q are integers with gcd(p,q) = 1.
Squaring both sides: 2 = p²/q², so 2q² = p².
This means p² is even, so p is even. Let p = 2r.
Then 2q² = (2r)² = 4r², so q² = 2r².
This means q² is even, so q is even.
But if both p and q are even, then gcd(p,q) ≥ 2.
This contradicts gcd(p,q) = 1.
Therefore √2 is irrational. ∎
```

### Mathematical Induction

Mathematical induction is used to prove statements about all positive integers.

```
Mathematical Induction Method
════════════════════════════

Principle:
To prove ∀n ≥ n₀, P(n):
1. Base case: Prove P(n₀)
2. Inductive step: Prove ∀k ≥ n₀, P(k) → P(k+1)
3. Conclude ∀n ≥ n₀, P(n)

Example: Prove 1 + 2 + ... + n = n(n+1)/2 for all n ≥ 1
Proof:
Base case (n = 1): 1 = 1(2)/2 = 1 ✓

Inductive step: Assume 1 + 2 + ... + k = k(k+1)/2.
We need to prove 1 + 2 + ... + k + (k+1) = (k+1)(k+2)/2.

1 + 2 + ... + k + (k+1) = k(k+1)/2 + (k+1)    [by inductive hypothesis]
                        = (k+1)(k/2 + 1)
                        = (k+1)(k+2)/2

By mathematical induction, the formula holds for all n ≥ 1. ∎
```

## Applications in Computer Science

### Programming Logic

```
Logic in Programming
═══════════════════

Boolean Expressions:
if (age >= 18 && hasLicense) {
    // Can drive
}

Loop Invariants:
Property that remains true before and after each loop iteration

Example: Array sum algorithm
sum = 0
for i = 0 to n-1:
    sum = sum + array[i]

Invariant: sum = array[0] + array[1] + ... + array[i-1]

Software Verification:
Specify program behavior using logical formulas
Verify correctness using logical reasoning
```

### Database Queries

```
SQL and Logic
════════════

SQL WHERE clauses use propositional logic:

SELECT * FROM Students
WHERE (major = 'CS' OR major = 'Math')
  AND gpa > 3.5;

Quantifiers in SQL:
EXISTS (existential quantifier)
ALL (universal quantifier)

Query optimization uses logical equivalences
```

## Summary and Key Concepts

Logic and proofs form the rigorous foundation for all mathematical reasoning and provide essential tools for computer science applications.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Propositional logic: connectives, truth tables, equivalences
✓ Predicate logic: quantifiers and mathematical statements
✓ Direct proof techniques and logical reasoning
✓ Proof by contradiction and mathematical induction
✓ Applications in computer science and mathematics

Key Concepts:
• Logic as foundation for mathematical reasoning
• Truth tables and logical equivalences
• Systematic proof techniques for different problem types
• Rigorous argumentation and logical validity
• Applications in programming, databases, and AI

Proof Techniques:
• Direct proof: assume hypothesis, derive conclusion
• Contradiction: assume negation, derive contradiction
• Induction: base case + inductive step

Next Steps:
Logic and proof skills prepare you for:
- Advanced mathematics and theorem proving
- Computer science theory and algorithms
- Software engineering and formal methods
- Artificial intelligence and machine learning
```

Logic and proofs represent the intellectual foundation of mathematics and computer science, providing the tools for rigorous reasoning and systematic problem-solving. The skills developed in this chapter are essential for advanced mathematics, programming, software engineering, and any field requiring precise reasoning.