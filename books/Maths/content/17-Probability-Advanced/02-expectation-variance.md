# Expectation, Variance, Covariance

## 1. Expectation

- Discrete: `E[X]=sum_x x p(x)`
- Continuous: `E[X]=integral x f(x) dx`

Linearity:
`E[aX+bY+c]=aE[X]+bE[Y]+c`.

## 2. Variance

`Var(X)=E[(X-E[X])^2]=E[X^2]-E[X]^2`.

Scaling:
`Var(aX+b)=a^2 Var(X)`.

## 3. Covariance and Correlation

`Cov(X,Y)=E[(X-E[X])(Y-E[Y])]`.

`Corr(X,Y)=Cov(X,Y)/(sigma_X sigma_Y)`.

Uncorrelated does not always mean independent.

## 4. Conditional Expectation

`E[X|Y]` is a random variable measurable w.r.t. Y.

### Law of Total Expectation

`E[X]=E[E[X|Y]]`.

### Law of Total Variance

`Var(X)=E[Var(X|Y)] + Var(E[X|Y])`.

These identities are fundamental in probabilistic ML and hierarchical modeling.

## 5. Worked Example

Suppose machine chooses mode `Y in {A,B}` with probabilities `0.7,0.3`.
If `E[X|Y=A]=10`, `E[X|Y=B]=20`, then
`E[X]=0.7*10+0.3*20=13`.

## 6. Theorem (Variance of Sum)

`Var(X+Y)=Var(X)+Var(Y)+2Cov(X,Y)`.

For independent variables, covariance is zero.

## Exercises

1. Compute covariance and correlation for two short sample vectors.
2. Prove linearity of expectation without independence assumptions.
3. Derive variance of average of i.i.d variables.
4. Use total expectation in a two-stage random process.
