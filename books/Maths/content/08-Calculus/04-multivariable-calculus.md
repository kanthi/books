# Multivariable Calculus for ML

## 1. Partial Derivatives

For `f(x1,...,xn)`, partial derivative wrt `xi` treats others fixed.

## 2. Gradient

`nabla f = [df/dx1,...,df/dxn]^T`.

Interpretation:
- direction of steepest ascent
- magnitude gives local steepness

## 3. Directional Derivative

Along unit vector `u`:

`D_u f = nabla f · u`.

Maximum value equals `||nabla f||` at `u` parallel to gradient.

## 4. Hessian Matrix

`H_ij = d^2f/(dxi dxj)`.

Second-order structure:
- positive definite -> local minimum
- negative definite -> local maximum
- indefinite -> saddle

## 5. Jacobian Matrix

For vector function `F: R^n -> R^m`, Jacobian stores first partial derivatives of each output component.

Backpropagation in neural nets is repeated Jacobian-chain multiplication.

## 6. Taylor Approximation (Multivariate)

`f(x+Delta) ~= f(x) + nabla f(x)^T Delta + 1/2 Delta^T H(x) Delta`.

This underlies Newton and quasi-Newton methods.

## 7. Worked Example

For `f(x,y)=x^2 + 3xy + y^2`:
- gradient: `[2x+3y, 3x+2y]`
- Hessian: `[[2,3],[3,2]]`.
Hessian eigenvalues indicate saddle/convex behavior.

## Exercises

1. Compute gradient/Hessian for logistic regression loss.
2. Show chain rule for composition `f(g(x))` in vector form.
3. Classify critical points for a two-variable quadratic.
4. Explain role of Hessian conditioning in optimization speed.
