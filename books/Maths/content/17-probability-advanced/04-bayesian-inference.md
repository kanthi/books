# Bayesian Inference

Bayesian inference treats unknown parameters as random variables and updates beliefs with data via Bayes’ rule. It yields full posterior distributions, natural regularization through priors, and predictive distributions for new observations—central in modern ML and decision systems.

## 1. Bayes’ rule for parameters

Parameter $\theta$, data $D$:

$$
p(\theta\mid D)=\frac{p(D\mid\theta)\,p(\theta)}{p(D)},\qquad
p(D)=\int p(D\mid\theta)p(\theta)\,d\theta.
$$

| Name | Symbol | Role |
|------|--------|------|
| Prior | $p(\theta)$ | belief before data |
| Likelihood | $p(D\mid\theta)$ | sampling model |
| Evidence | $p(D)$ | marginal likelihood |
| Posterior | $p(\theta\mid D)$ | updated belief |

### Worked example 1 — discrete hypothesis

Two coins: fair $P(H)=1/2$ or two-headed. Prior $1/2$ each. Observe $H$: posterior on two-headed is $2/3$ by Bayes.

## 2. Conjugate priors

A prior is **conjugate** for a likelihood if the posterior stays in the same family—closed-form updates.

| Likelihood | Conjugate prior | Posterior update |
|------------|-----------------|------------------|
| Bernoulli/Binomial | Beta$(\alpha,\beta)$ | $\alpha'=\alpha+\#\mathrm{success}$, $\beta'=\beta+\#\mathrm{fail}$ |
| Poisson | Gamma | add counts to shape; expose to rate |
| Normal mean (known var) | Normal | precision-weighted average |
| Multinomial | Dirichlet | add category counts |

### Worked example 2 — Beta–Binomial

Prior $\mathrm{Beta}(2,2)$, data 8 successes, 2 failures $\Rightarrow$ posterior $\mathrm{Beta}(10,4)$.  
Mean $10/14\approx 0.714$. Prior mean was $0.5$; data pulled belief up.

### Worked example 3 — uniform prior

$\mathrm{Beta}(1,1)$ is Uniform$(0,1)$. After $s$ successes, $f$ failures: $\mathrm{Beta}(1+s,1+f)$.

### Worked example 4 — strong prior

$\mathrm{Beta}(100,100)$ after same 8/2 data barely moves—prior as “pseudo-counts.”

## 3. MAP vs MLE vs posterior mean

- **MLE:** $\hat\theta_{\mathrm{MLE}}=\arg\max_\theta p(D\mid\theta)$  
- **MAP:** $\hat\theta_{\mathrm{MAP}}=\arg\max_\theta p(\theta\mid D)=\arg\max_\theta [p(D\mid\theta)p(\theta)]$  
- **Posterior mean:** $\mathbb{E}[\theta\mid D]$ (optimal under squared error)

MAP with prior $p(\theta)\propto e^{-\lambda\Omega(\theta)}$ resembles regularized MLE.

### Worked example 5

Gaussian prior on regression weights $\Leftrightarrow$ ridge penalty in MAP.

### Worked example 6

Laplace prior $\Leftrightarrow$ lasso-like MAP (with caveats on geometric exactness).

## 4. Posterior predictive

For new observation $x_{\mathrm{new}}$:

$$
p(x_{\mathrm{new}}\mid D)=\int p(x_{\mathrm{new}}\mid\theta)\,p(\theta\mid D)\,d\theta.
$$

Averages likelihoods under posterior uncertainty—better for forecasting than plugging a point estimate only.

### Worked example 7 — Beta–Binomial predictive

Predictive success probability equals posterior mean of $p$ for exchangeable Bernoulli—intuitive.

## 5. Hierarchical models (sketch)

Priors on priors: $\theta_i\sim p(\theta_i\mid\phi)$, $\phi\sim p(\phi)$. Share statistical strength across groups (empirical Bayes / full Bayes). Used in multilevel A/B tests and recommendation.

### Worked example 8

Per-user conversion rates with global hyperprior—avoids wild estimates for users with 1 visit.

## 6. Computation when conjugates fail

| Method | Idea |
|--------|------|
| Grid / quadrature | low-dimensional $\theta$ |
| Laplace approximation | Gaussian around MAP |
| MCMC (MH, HMC, NUTS) | samples from posterior |
| Variational inference | optimize approx $q(\theta)\approx p(\theta\mid D)$ |

### Worked example 9 — MCMC intuition

Build Markov chain with stationary law $p(\theta\mid D)$; averages of samples estimate posterior expectations (ergodic theorem).

### Worked example 10 — VI

Minimize $\mathrm{KL}(q\|p(\cdot\mid D))$—connects to ELBO in VAEs.

## 7. Decision theory link

Loss $L(\theta,a)$; choose action $a$ minimizing posterior expected loss $\int L(\theta,a)p(\theta\mid D)\,d\theta$. Point estimates emerge from particular losses (0-1 $\to$ MAP for discrete; squared $\to$ mean).

## 8. CS/ML applications

- Spam filters / Naive Bayes  
- A/B tests with Beta-Binomial dashboards  
- Bayesian optimization priors on functions (GPs)  
- Uncertainty in deep learning (approx Bayesian)  
- Kalman filters as sequential Bayes for linear-Gaussian state space  

### Worked example 11 — online Bayes

Process arrivals one-by-one: conjugate update is $O(1)$ per observation—streaming inference.

### Worked example 12 — regularization interpretation

Without calling it Bayesian, weight decay is MAP under Gaussian prior—same math, different philosophy.

## 9. Pitfalls

1. Priors that put zero mass where truth lies (no recovery)  
2. Improper priors without checking posterior propriety  
3. Interpreting credible intervals as frequentist CIs without care  
4. Label-switching in mixture posteriors  
5. MCMC not converged (use diagnostics: R-hat, ESS)  
6. “Uninformative” priors still informative on transformed scales  

## 10. Checkpoint

- Write Bayes update and name all parts  
- Perform Beta-Binomial update numerically  
- Contrast MLE, MAP, posterior mean  
- Define posterior predictive  
- Name two computational approximate inference methods  

## Exercises

### Easy

1. Update $\mathrm{Beta}(1,1)$ after 3 successes, 1 failure; posterior mean.
2. Fair vs double-head coin: after two heads, posterior on double-head?
3. Why is MAP with flat prior equal to MLE (when flat allowed)?
4. Interpret $\alpha,\beta$ in Beta as pseudo-counts.
5. One sentence: what is the evidence $p(D)$ used for in model comparison?

### Medium

6. Derive Normal–Normal posterior for mean with known variance.
7. Show MAP for Bernoulli with $\mathrm{Beta}(\alpha,\beta)$ prior in closed form.
8. Explain how hierarchical model reduces variance of per-group estimates (qualitative).
9. Connect ridge regression to Gaussian prior MAP (write objective).
10. Predictive: for Beta-Binomial, $P(\text{next success}\mid D)$.

### Challenge

11. Prove conjugacy update for Beta-Binomial fully.
12. Laplace approximation: expand $\log p(\theta\mid D)$ to quadratic; identify covariance as inverse Hessian.
13. KL$(q\|p)$ vs KL$(p\|q)$ for VI vs expectation propagation intuition.
14. Design a Bayesian A/B test stopping rule sketch using posterior $P(p_A>p_B\mid D)$.
15. Discuss prior sensitivity: reanalyze Example 2 with $\mathrm{Beta}(0.5,0.5)$ vs $\mathrm{Beta}(5,5)$.

## Summary

Bayesian inference is coherent updating of beliefs with likelihoods. Conjugacy gives exact posteriors; computation extends the framework to rich models. MAP links to regularization; predictives support decisions under parameter uncertainty—the probabilistic counterpart to point-estimate ML.
