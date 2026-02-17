# Floating-Point Arithmetic, Error, and Stability

## 1. Machine Numbers

Real numbers are approximated by finite binary encodings.
IEEE-754 double precision stores sign, exponent, and mantissa.

Not all decimals are exactly representable (`0.1` is classic example).

## 2. Rounding Model

A computed operation can be idealized as:

`fl(x op y) = (x op y)(1 + delta)` with `|delta| <= u`,

where `u` is machine precision.

## 3. Error Types

- Absolute error: `|x - xhat|`
- Relative error: `|x - xhat| / |x|`
- Forward error: error in final answer
- Backward error: smallest perturbation to input making output exact

## 4. Catastrophic Cancellation

Subtracting nearly equal numbers destroys significant digits.

Example:
`f(x)=sqrt(x+1)-sqrt(x)` for large x.
Direct formula is unstable; rationalized form is better:

`f(x)=1/(sqrt(x+1)+sqrt(x))`.

## 5. Conditioning vs Stability

- Conditioning: property of problem sensitivity.
- Stability: property of algorithm.

A well-conditioned problem can still yield bad answers with unstable algorithm.

## 6. Theorem (Error Amplification Intuition)

If condition number `kappa` is large, relative input error `eps` may produce output error roughly `kappa*eps`.

Proof idea: first-order perturbation analysis.

## 7. Practical Guidelines

- Avoid direct subtraction of close values.
- Normalize/scaled data before solving.
- Use robust library routines (`solve`, `lstsq`, `svd`).
- Check residuals and condition numbers.

## 8. Worked Example (Python)

```python
import math

x = 1e16
naive = math.sqrt(x+1) - math.sqrt(x)
stable = 1.0 / (math.sqrt(x+1) + math.sqrt(x))
print(naive, stable)
```

## Exercises

1. Show with computation that `(1e16 + 1) - 1e16` loses precision.
2. Compare naive vs stable form for `log(1+x)` near `x=0`.
3. Explain when relative error is preferred over absolute error.
4. Define backward stability in your own words.
