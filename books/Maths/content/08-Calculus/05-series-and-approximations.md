# Taylor Series and Approximation

## 1. Taylor Polynomial

At point `a`:

`f(x)=sum_{k=0}^n f^(k)(a)/k! * (x-a)^k + R_n(x)`.

`R_n` is remainder (error term).

## 2. Common Expansions at 0

- `e^x = 1 + x + x^2/2! + x^3/3! + ...`
- `sin x = x - x^3/3! + x^5/5! - ...`
- `cos x = 1 - x^2/2! + x^4/4! - ...`
- `ln(1+x) = x - x^2/2 + x^3/3 - ...` for `|x|<1`

## 3. Error Bounds

Lagrange remainder provides bound using `(n+1)`-st derivative.

## 4. Why CS Uses This Constantly

- local model in optimization
- numerical function implementations
- complexity approximations for log/exp near operating point
- control and robotics linearization

## 5. Worked Example

Approximate `e^0.1` with quadratic polynomial:
`1 + 0.1 + 0.1^2/2 = 1.105`.
True value `~1.10517`, very close.

## 6. Asymptotic Approximation Idea

Keep dominant terms when variable is small/large.
This supports both numerical and algorithmic reasoning.

## Exercises

1. Approximate `sin(0.2)` using 3rd-order polynomial.
2. Bound approximation error using next derivative term.
3. Use series to derive `lim_{x->0} (e^x-1)/x`.
4. Explain relation of second-order Taylor model to Newton updates.
