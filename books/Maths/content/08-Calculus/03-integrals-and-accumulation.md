# Integrals and Accumulation

## 1. Area and Accumulation

Definite integral accumulates infinitesimal contributions:

`integral_a^b f(x) dx`.

Geometrically: signed area under curve.

## 2. Riemann Sum View

Partition interval into small pieces:

`sum f(x_i^*) Delta x`.

Integral is limit as max interval width goes to zero.

## 3. Fundamental Theorem of Calculus

If `F'(x)=f(x)`, then:

`integral_a^b f(x) dx = F(b)-F(a)`.

This links differentiation and integration.

## 4. Improper Integrals

For infinite intervals or singularities, define integral by limits.
Convergence must be checked explicitly.

## 5. Numerical Integration

When antiderivative unavailable:
- Trapezoidal rule: `O(h^2)` global error
- Simpson's rule: `O(h^4)` global error
- Monte Carlo integration: dimension-friendly stochastic approach

## 6. Worked Example

Compute `integral_0^1 x^2 dx = 1/3`.

Trapezoid with two intervals gives approximation `0.375`, showing discretization error.

## 7. CS Applications

- probability from densities: `P(a<=X<=b)=integral_a^b f_X(x)dx`
- total energy or mass in simulation
- accumulated loss/utility over time

## Exercises

1. Derive trapezoid rule from linear interpolation.
2. Compare trapezoid vs Simpson on `sin(x)` over `[0,pi]`.
3. Use Monte Carlo to estimate area of unit circle.
4. Explain when Monte Carlo can beat grid methods.
