# Statistical Foundations for Data Science

Statistics provides the mathematical framework for understanding data, quantifying uncertainty, and making data-driven decisions. This section covers fundamental statistical concepts essential for data science.

## Descriptive Statistics

### Measures of Central Tendency

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats

# Generate sample data
np.random.seed(42)
data = np.random.normal(100, 15, 1000)  # Normal distribution
skewed_data = np.random.exponential(2, 1000)  # Skewed distribution

def calculate_central_tendency(data, name):
    """Calculate and display measures of central tendency"""
    mean = np.mean(data)
    median = np.median(data)
    mode_result = stats.mode(data, keepdims=True)
    mode = mode_result.mode[0] if len(mode_result.mode) > 0 else np.nan

    print(f"\n{name}:")
    print(f"Mean: {mean:.2f}")
    print(f"Median: {median:.2f}")
    print(f"Mode: {mode:.2f}")

    return mean, median, mode

# Analyze both datasets
mean1, median1, mode1 = calculate_central_tendency(data, "Normal Distribution")
mean2, median2, mode2 = calculate_central_tendency(skewed_data, "Skewed Distribution")

# Visualize the differences
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# Normal distribution
ax1.hist(data, bins=50, alpha=0.7, density=True, color='skyblue')
ax1.axvline(mean1, color='red', linestyle='--', label=f'Mean: {mean1:.1f}')
ax1.axvline(median1, color='green', linestyle='--', label=f'Median: {median1:.1f}')
ax1.set_title('Normal Distribution')
ax1.legend()
ax1.grid(True, alpha=0.3)

# Skewed distribution
ax2.hist(skewed_data, bins=50, alpha=0.7, density=True, color='lightcoral')
ax2.axvline(mean2, color='red', linestyle='--', label=f'Mean: {mean2:.1f}')
ax2.axvline(median2, color='green', linestyle='--', label=f'Median: {median2:.1f}')
ax2.set_title('Skewed Distribution')
ax2.legend()
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()
```

### Measures of Variability

```python
def calculate_variability(data, name):
    """Calculate measures of variability"""
    variance = np.var(data, ddof=1)  # Sample variance
    std_dev = np.std(data, ddof=1)   # Sample standard deviation
    range_val = np.max(data) - np.min(data)
    iqr = np.percentile(data, 75) - np.percentile(data, 25)
    mad = np.median(np.abs(data - np.median(data)))  # Median Absolute Deviation

    print(f"\n{name} - Variability Measures:")
    print(f"Variance: {variance:.2f}")
    print(f"Standard Deviation: {std_dev:.2f}")
    print(f"Range: {range_val:.2f}")
    print(f"Interquartile Range (IQR): {iqr:.2f}")
    print(f"Median Absolute Deviation: {mad:.2f}")

    return variance, std_dev, range_val, iqr, mad

# Calculate variability for both datasets
calculate_variability(data, "Normal Distribution")
calculate_variability(skewed_data, "Skewed Distribution")

# Box plots to visualize variability
plt.figure(figsize=(12, 6))
plt.subplot(1, 2, 1)
plt.boxplot(data, labels=['Normal'])
plt.title('Normal Distribution')
plt.grid(True, alpha=0.3)

plt.subplot(1, 2, 2)
plt.boxplot(skewed_data, labels=['Skewed'])
plt.title('Skewed Distribution')
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()
```

### Distribution Shape

```python
def analyze_distribution_shape(data, name):
    """Analyze skewness and kurtosis"""
    skewness = stats.skew(data)
    kurt = stats.kurtosis(data)

    print(f"\n{name} - Shape Measures:")
    print(f"Skewness: {skewness:.3f}")
    if skewness > 0.5:
        print("  → Right-skewed (positive skew)")
    elif skewness < -0.5:
        print("  → Left-skewed (negative skew)")
    else:
        print("  → Approximately symmetric")

    print(f"Kurtosis: {kurt:.3f}")
    if kurt > 0:
        print("  → Leptokurtic (heavy tails)")
    elif kurt < 0:
        print("  → Platykurtic (light tails)")
    else:
        print("  → Mesokurtic (normal tails)")

    return skewness, kurt

analyze_distribution_shape(data, "Normal Distribution")
analyze_distribution_shape(skewed_data, "Skewed Distribution")
```

## Probability Fundamentals

### Basic Probability Rules

```python
def demonstrate_probability_rules():
    """Demonstrate basic probability rules with examples"""

    # Simulate coin flips
    n_flips = 10000
    coin_flips = np.random.choice(['H', 'T'], n_flips)

    # Calculate probabilities
    p_heads = np.sum(coin_flips == 'H') / n_flips
    p_tails = np.sum(coin_flips == 'T') / n_flips

    print("Basic Probability Rules:")
    print(f"P(Heads) = {p_heads:.3f}")
    print(f"P(Tails) = {p_tails:.3f}")
    print(f"P(Heads) + P(Tails) = {p_heads + p_tails:.3f}")
    print("Rule: Sum of all probabilities = 1")

    # Simulate dice rolls
    dice_rolls = np.random.randint(1, 7, n_flips)

    # Joint probability example
    even_rolls = dice_rolls % 2 == 0
    high_rolls = dice_rolls >= 4

    p_even = np.mean(even_rolls)
    p_high = np.mean(high_rolls)
    p_even_and_high = np.mean(even_rolls & high_rolls)
    p_even_or_high = np.mean(even_rolls | high_rolls)

    print(f"\nDice Roll Probabilities:")
    print(f"P(Even) = {p_even:.3f}")
    print(f"P(High ≥ 4) = {p_high:.3f}")
    print(f"P(Even AND High) = {p_even_and_high:.3f}")
    print(f"P(Even OR High) = {p_even_or_high:.3f}")

    # Verify addition rule: P(A ∪ B) = P(A) + P(B) - P(A ∩ B)
    calculated_or = p_even + p_high - p_even_and_high
    print(f"Calculated P(Even OR High) = {calculated_or:.3f}")
    print(f"Difference: {abs(p_even_or_high - calculated_or):.6f}")

demonstrate_probability_rules()
```

### Conditional Probability and Bayes' Theorem

```python
def bayes_theorem_example():
    """Medical diagnosis example using Bayes' theorem"""

    # Disease prevalence and test accuracy
    disease_prevalence = 0.01  # 1% of population has disease
    test_sensitivity = 0.95    # 95% true positive rate
    test_specificity = 0.90    # 90% true negative rate

    # Calculate probabilities
    p_disease = disease_prevalence
    p_no_disease = 1 - disease_prevalence
    p_positive_given_disease = test_sensitivity
    p_positive_given_no_disease = 1 - test_specificity

    # Total probability of positive test
    p_positive = (p_positive_given_disease * p_disease +
                  p_positive_given_no_disease * p_no_disease)

    # Bayes' theorem: P(Disease|Positive) = P(Positive|Disease) * P(Disease) / P(Positive)
    p_disease_given_positive = (p_positive_given_disease * p_disease) / p_positive

    print("Bayes' Theorem Example - Medical Diagnosis:")
    print(f"Disease prevalence: {disease_prevalence:.1%}")
    print(f"Test sensitivity: {test_sensitivity:.1%}")
    print(f"Test specificity: {test_specificity:.1%}")
    print(f"\nP(Positive test) = {p_positive:.3f}")
    print(f"P(Disease | Positive test) = {p_disease_given_positive:.3f} ({p_disease_given_positive:.1%})")

    print(f"\nInterpretation:")
    print(f"Even with a positive test, there's only a {p_disease_given_positive:.1%} chance of having the disease!")
    print(f"This is due to the low base rate (prevalence) of the disease.")

    return p_disease_given_positive

# Simulate the medical test scenario
def simulate_medical_test(n_people=100000):
    """Simulate medical testing scenario"""

    # Generate population
    has_disease = np.random.random(n_people) < 0.01  # 1% prevalence

    # Generate test results
    test_results = np.zeros(n_people, dtype=bool)

    # People with disease: 95% test positive
    disease_indices = np.where(has_disease)[0]
    test_results[disease_indices] = np.random.random(len(disease_indices)) < 0.95

    # People without disease: 10% test positive (false positives)
    no_disease_indices = np.where(~has_disease)[0]
    test_results[no_disease_indices] = np.random.random(len(no_disease_indices)) < 0.10

    # Calculate actual probabilities from simulation
    positive_tests = test_results
    true_positives = has_disease & positive_tests
    false_positives = (~has_disease) & positive_tests

    simulated_p_disease_given_positive = np.sum(true_positives) / np.sum(positive_tests)

    print(f"\nSimulation Results (n={n_people:,}):")
    print(f"People with disease: {np.sum(has_disease):,}")
    print(f"Positive tests: {np.sum(positive_tests):,}")
    print(f"True positives: {np.sum(true_positives):,}")
    print(f"False positives: {np.sum(false_positives):,}")
    print(f"Simulated P(Disease | Positive) = {simulated_p_disease_given_positive:.3f}")

theoretical_prob = bayes_theorem_example()
simulate_medical_test()
```

## Sampling and Sampling Distributions

### Central Limit Theorem

```python
def demonstrate_central_limit_theorem():
    """Demonstrate the Central Limit Theorem"""

    # Create different population distributions
    populations = {
        'Uniform': np.random.uniform(0, 10, 10000),
        'Exponential': np.random.exponential(2, 10000),
        'Bimodal': np.concatenate([np.random.normal(2, 1, 5000),
                                  np.random.normal(8, 1, 5000)])
    }

    sample_sizes = [5, 10, 30, 100]
    n_samples = 1000

    fig, axes = plt.subplots(len(populations), len(sample_sizes) + 1,
                            figsize=(20, 12))

    for i, (pop_name, population) in enumerate(populations.items()):
        # Plot original population
        axes[i, 0].hist(population, bins=50, alpha=0.7, density=True)
        axes[i, 0].set_title(f'{pop_name} Population')
        axes[i, 0].grid(True, alpha=0.3)

        # For each sample size, create sampling distribution
        for j, sample_size in enumerate(sample_sizes):
            sample_means = []

            for _ in range(n_samples):
                sample = np.random.choice(population, sample_size)
                sample_means.append(np.mean(sample))

            sample_means = np.array(sample_means)

            # Plot sampling distribution
            axes[i, j + 1].hist(sample_means, bins=30, alpha=0.7, density=True)
            axes[i, j + 1].set_title(f'Sample Means (n={sample_size})')
            axes[i, j + 1].grid(True, alpha=0.3)

            # Add normal curve overlay
            x = np.linspace(sample_means.min(), sample_means.max(), 100)
            normal_curve = stats.norm.pdf(x, np.mean(sample_means), np.std(sample_means))
            axes[i, j + 1].plot(x, normal_curve, 'r-', linewidth=2, alpha=0.8)

            # Calculate and display statistics
            mean_of_means = np.mean(sample_means)
            std_of_means = np.std(sample_means)
            theoretical_std = np.std(population) / np.sqrt(sample_size)

            axes[i, j + 1].text(0.02, 0.98,
                               f'Mean: {mean_of_means:.2f}\nStd: {std_of_means:.2f}\nTheoretical: {theoretical_std:.2f}',
                               transform=axes[i, j + 1].transAxes,
                               verticalalignment='top',
                               bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

    plt.tight_layout()
    plt.show()

    print("Central Limit Theorem Observations:")
    print("1. As sample size increases, sampling distribution becomes more normal")
    print("2. Mean of sampling distribution equals population mean")
    print("3. Standard error = population std / sqrt(sample size)")
    print("4. This holds regardless of the original population distribution!")

demonstrate_central_limit_theorem()
```

### Confidence Intervals

```python
def confidence_intervals_analysis():
    """Analyze confidence intervals and their interpretation"""

    # True population parameters
    true_mean = 100
    true_std = 15

    # Generate samples and calculate confidence intervals
    sample_sizes = [10, 30, 100, 500]
    confidence_levels = [0.90, 0.95, 0.99]
    n_simulations = 1000

    results = {}

    for sample_size in sample_sizes:
        for conf_level in confidence_levels:
            coverage_count = 0
            intervals = []

            for _ in range(n_simulations):
                # Generate sample
                sample = np.random.normal(true_mean, true_std, sample_size)
                sample_mean = np.mean(sample)
                sample_std = np.std(sample, ddof=1)

                # Calculate confidence interval
                alpha = 1 - conf_level
                t_critical = stats.t.ppf(1 - alpha/2, df=sample_size - 1)
                margin_error = t_critical * (sample_std / np.sqrt(sample_size))

                ci_lower = sample_mean - margin_error
                ci_upper = sample_mean + margin_error

                intervals.append((ci_lower, ci_upper))

                # Check if interval contains true mean
                if ci_lower <= true_mean <= ci_upper:
                    coverage_count += 1

            coverage_rate = coverage_count / n_simulations
            results[(sample_size, conf_level)] = {
                'coverage_rate': coverage_rate,
                'intervals': intervals
            }

    # Display results
    print("Confidence Interval Coverage Analysis:")
    print("=" * 60)
    print(f"{'Sample Size':>12} {'Conf Level':>12} {'Coverage Rate':>15} {'Expected':>10}")
    print("-" * 60)

    for (sample_size, conf_level), result in results.items():
        coverage_rate = result['coverage_rate']
        print(f"{sample_size:>12} {conf_level:>12.0%} {coverage_rate:>15.1%} {conf_level:>10.0%}")

    # Visualize confidence intervals for one case
    sample_size = 30
    conf_level = 0.95
    intervals = results[(sample_size, conf_level)]['intervals'][:50]  # Show first 50

    plt.figure(figsize=(12, 8))

    for i, (lower, upper) in enumerate(intervals):
        color = 'green' if lower <= true_mean <= upper else 'red'
        plt.plot([lower, upper], [i, i], color=color, linewidth=2, alpha=0.7)
        plt.plot([(lower + upper) / 2], [i], 'o', color=color, markersize=3)

    plt.axvline(true_mean, color='blue', linestyle='--', linewidth=2,
                label=f'True Mean = {true_mean}')
    plt.xlabel('Value')
    plt.ylabel('Sample Number')
    plt.title(f'{conf_level:.0%} Confidence Intervals (n={sample_size})')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.show()

    print(f"\nInterpretation:")
    print(f"- Green intervals contain the true mean ({true_mean})")
    print(f"- Red intervals do not contain the true mean")
    print(f"- About {conf_level:.0%} of intervals should be green")

confidence_intervals_analysis()
```

## Statistical Inference

### Hypothesis Testing Framework

```python
def hypothesis_testing_framework():
    """Demonstrate hypothesis testing concepts"""

    print("Hypothesis Testing Framework:")
    print("=" * 50)

    # Example: Testing if a coin is fair
    print("Example: Testing if a coin is fair")
    print("H₀: p = 0.5 (coin is fair)")
    print("H₁: p ≠ 0.5 (coin is biased)")
    print()

    # Simulate coin flips
    n_flips = 100
    true_p = 0.6  # Biased coin (unknown to us)
    observed_heads = np.random.binomial(n_flips, true_p)
    observed_p = observed_heads / n_flips

    print(f"Observed: {observed_heads} heads out of {n_flips} flips")
    print(f"Sample proportion: {observed_p:.3f}")

    # Calculate test statistic (z-test for proportion)
    null_p = 0.5
    standard_error = np.sqrt(null_p * (1 - null_p) / n_flips)
    z_statistic = (observed_p - null_p) / standard_error

    # Calculate p-value (two-tailed test)
    p_value = 2 * (1 - stats.norm.cdf(abs(z_statistic)))

    print(f"\nTest Results:")
    print(f"Z-statistic: {z_statistic:.3f}")
    print(f"P-value: {p_value:.4f}")

    # Decision
    alpha = 0.05
    if p_value < alpha:
        print(f"Decision: Reject H₀ (p-value < {alpha})")
        print("Conclusion: Evidence suggests the coin is biased")
    else:
        print(f"Decision: Fail to reject H₀ (p-value ≥ {alpha})")
        print("Conclusion: Insufficient evidence that the coin is biased")

    return z_statistic, p_value

z_stat, p_val = hypothesis_testing_framework()
```

### Type I and Type II Errors

```python
def error_types_analysis():
    """Analyze Type I and Type II errors"""

    # Simulation parameters
    null_mean = 100  # H₀: μ = 100
    sample_size = 30
    alpha = 0.05
    n_simulations = 10000

    # Test different true means to see error rates
    true_means = np.arange(95, 106, 0.5)

    type_i_errors = []
    type_ii_errors = []
    power_values = []

    for true_mean in true_means:
        reject_count = 0

        for _ in range(n_simulations):
            # Generate sample from true distribution
            sample = np.random.normal(true_mean, 15, sample_size)
            sample_mean = np.mean(sample)

            # Perform t-test
            t_statistic = (sample_mean - null_mean) / (15 / np.sqrt(sample_size))
            p_value = 2 * (1 - stats.t.cdf(abs(t_statistic), df=sample_size - 1))

            if p_value < alpha:
                reject_count += 1

        rejection_rate = reject_count / n_simulations

        if true_mean == null_mean:
            # Type I error rate (rejecting true null)
            type_i_error_rate = rejection_rate
            type_i_errors.append(type_i_error_rate)
        else:
            # Power (correctly rejecting false null)
            power = rejection_rate
            power_values.append(power)

            # Type II error rate (failing to reject false null)
            type_ii_error_rate = 1 - power
            type_ii_errors.append(type_ii_error_rate)

    # Plot power curve
    plt.figure(figsize=(12, 8))

    plt.subplot(2, 1, 1)
    plt.plot(true_means[true_means != null_mean], power_values, 'b-', linewidth=2, label='Power')
    plt.axhline(alpha, color='red', linestyle='--', label=f'α = {alpha}')
    plt.axvline(null_mean, color='gray', linestyle=':', alpha=0.7, label='H₀: μ = 100')
    plt.xlabel('True Mean')
    plt.ylabel('Power (1 - β)')
    plt.title('Statistical Power Curve')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.subplot(2, 1, 2)
    plt.plot(true_means[true_means != null_mean], type_ii_errors, 'r-', linewidth=2, label='Type II Error Rate (β)')
    plt.axhline(alpha, color='blue', linestyle='--', label=f'α = {alpha}')
    plt.axvline(null_mean, color='gray', linestyle=':', alpha=0.7, label='H₀: μ = 100')
    plt.xlabel('True Mean')
    plt.ylabel('Type II Error Rate (β)')
    plt.title('Type II Error Rate')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

    print("Error Types Analysis:")
    print(f"Type I Error Rate (α): {type_i_error_rate:.3f} (should be ≈ {alpha})")
    print(f"Type II Error Rate varies with effect size")
    print(f"Power increases as true mean moves away from null hypothesis")

    # Effect size and power relationship
    effect_sizes = np.abs(true_means[true_means != null_mean] - null_mean) / 15

    plt.figure(figsize=(10, 6))
    plt.plot(effect_sizes, power_values, 'go-', linewidth=2, markersize=6)
    plt.xlabel('Effect Size (Cohen\'s d)')
    plt.ylabel('Statistical Power')
    plt.title('Power vs Effect Size')
    plt.grid(True, alpha=0.3)
    plt.axhline(0.8, color='red', linestyle='--', label='Conventional Power = 0.8')
    plt.legend()
    plt.show()

error_types_analysis()
```

## Correlation and Causation

### Correlation Analysis

```python
def correlation_analysis():
    """Comprehensive correlation analysis"""

    # Generate different types of relationships
    n = 1000
    x = np.random.normal(0, 1, n)

    # Different correlation patterns
    relationships = {
        'Strong Positive': x + 0.2 * np.random.normal(0, 1, n),
        'Weak Positive': x + 2 * np.random.normal(0, 1, n),
        'No Correlation': np.random.normal(0, 1, n),
        'Strong Negative': -x + 0.2 * np.random.normal(0, 1, n),
        'Non-linear': x**2 + 0.5 * np.random.normal(0, 1, n)
    }

    fig, axes = plt.subplots(2, 3, figsize=(18, 12))
    axes = axes.flatten()

    correlations = {}

    for i, (name, y) in enumerate(relationships.items()):
        if i < len(axes):
            # Calculate correlations
            pearson_r, pearson_p = stats.pearsonr(x, y)
            spearman_r, spearman_p = stats.spearmanr(x, y)

            correlations[name] = {
                'pearson': pearson_r,
                'spearman': spearman_r,
                'pearson_p': pearson_p,
                'spearman_p': spearman_p
            }

            # Plot
            axes[i].scatter(x, y, alpha=0.6, s=20)
            axes[i].set_title(f'{name}\nPearson r = {pearson_r:.3f}\nSpearman ρ = {spearman_r:.3f}')
            axes[i].grid(True, alpha=0.3)

            # Add trend line for linear relationships
            if abs(pearson_r) > 0.3:
                z = np.polyfit(x, y, 1)
                p = np.poly1d(z)
                axes[i].plot(sorted(x), p(sorted(x)), "r--", alpha=0.8)

    # Remove empty subplot
    if len(relationships) < len(axes):
        fig.delaxes(axes[-1])

    plt.tight_layout()
    plt.show()

    # Display correlation summary
    print("Correlation Analysis Summary:")
    print("=" * 60)
    print(f"{'Relationship':>15} {'Pearson r':>12} {'p-value':>10} {'Spearman ρ':>12} {'p-value':>10}")
    print("-" * 60)

    for name, corr in correlations.items():
        print(f"{name:>15} {corr['pearson']:>12.3f} {corr['pearson_p']:>10.4f} "
              f"{corr['spearman']:>12.3f} {corr['spearman_p']:>10.4f}")

    print("\nInterpretation Guidelines:")
    print("Pearson correlation (r):")
    print("  |r| < 0.3: Weak relationship")
    print("  0.3 ≤ |r| < 0.7: Moderate relationship")
    print("  |r| ≥ 0.7: Strong relationship")
    print("\nSpearman correlation (ρ): Measures monotonic relationships")
    print("Use when relationship is not linear but monotonic")

correlation_analysis()
```

### Spurious Correlations and Confounding

```python
def spurious_correlation_example():
    """Demonstrate spurious correlations and confounding variables"""

    n = 1000

    # Example 1: Ice cream sales and drowning deaths
    # Both are caused by temperature (confounding variable)
    temperature = np.random.normal(75, 10, n)  # Temperature in Fahrenheit

    # Ice cream sales increase with temperature
    ice_cream_sales = 50 + 2 * (temperature - 70) + np.random.normal(0, 10, n)
    ice_cream_sales = np.maximum(ice_cream_sales, 0)  # Can't be negative

    # Drowning deaths also increase with temperature (more swimming)
    drowning_deaths = 2 + 0.1 * (temperature - 70) + np.random.poisson(1, n)
    drowning_deaths = np.maximum(drowning_deaths, 0)

    # Calculate correlations
    corr_ice_drowning = stats.pearsonr(ice_cream_sales, drowning_deaths)[0]
    corr_temp_ice = stats.pearsonr(temperature, ice_cream_sales)[0]
    corr_temp_drowning = stats.pearsonr(temperature, drowning_deaths)[0]

    # Partial correlation (controlling for temperature)
    from scipy.stats import pearsonr

    # Simple partial correlation calculation
    def partial_correlation(x, y, z):
        """Calculate partial correlation of x and y controlling for z"""
        rxy = pearsonr(x, y)[0]
        rxz = pearsonr(x, z)[0]
        ryz = pearsonr(y, z)[0]

        partial_r = (rxy - rxz * ryz) / (np.sqrt(1 - rxz**2) * np.sqrt(1 - ryz**2))
        return partial_r

    partial_corr = partial_correlation(ice_cream_sales, drowning_deaths, temperature)

    # Visualize
    fig, axes = plt.subplots(2, 2, figsize=(15, 12))

    # Ice cream vs drowning (spurious correlation)
    axes[0, 0].scatter(ice_cream_sales, drowning_deaths, alpha=0.6)
    axes[0, 0].set_xlabel('Ice Cream Sales')
    axes[0, 0].set_ylabel('Drowning Deaths')
    axes[0, 0].set_title(f'Spurious Correlation\nr = {corr_ice_drowning:.3f}')
    axes[0, 0].grid(True, alpha=0.3)

    # Temperature vs ice cream
    axes[0, 1].scatter(temperature, ice_cream_sales, alpha=0.6, color='orange')
    axes[0, 1].set_xlabel('Temperature (°F)')
    axes[0, 1].set_ylabel('Ice Cream Sales')
    axes[0, 1].set_title(f'Temperature → Ice Cream\nr = {corr_temp_ice:.3f}')
    axes[0, 1].grid(True, alpha=0.3)

    # Temperature vs drowning
    axes[1, 0].scatter(temperature, drowning_deaths, alpha=0.6, color='red')
    axes[1, 0].set_xlabel('Temperature (°F)')
    axes[1, 0].set_ylabel('Drowning Deaths')
    axes[1, 0].set_title(f'Temperature → Drowning\nr = {corr_temp_drowning:.3f}')
    axes[1, 0].grid(True, alpha=0.3)

    # Residual plot (controlling for temperature)
    ice_cream_residuals = ice_cream_sales - (np.mean(ice_cream_sales) +
                                           corr_temp_ice * (temperature - np.mean(temperature)))
    drowning_residuals = drowning_deaths - (np.mean(drowning_deaths) +
                                          corr_temp_drowning * (temperature - np.mean(temperature)))

    axes[1, 1].scatter(ice_cream_residuals, drowning_residuals, alpha=0.6, color='green')
    axes[1, 1].set_xlabel('Ice Cream Sales (residuals)')
    axes[1, 1].set_ylabel('Drowning Deaths (residuals)')
    axes[1, 1].set_title(f'Controlling for Temperature\nPartial r = {partial_corr:.3f}')
    axes[1, 1].grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

    print("Spurious Correlation Example:")
    print("=" * 50)
    print(f"Ice cream sales ↔ Drowning deaths: r = {corr_ice_drowning:.3f}")
    print(f"Temperature → Ice cream sales: r = {corr_temp_ice:.3f}")
    print(f"Temperature → Drowning deaths: r = {corr_temp_drowning:.3f}")
    print(f"Partial correlation (controlling for temperature): r = {partial_corr:.3f}")
    print()
    print("Key Insight:")
    print("The correlation between ice cream sales and drowning deaths")
    print("disappears when we control for the confounding variable (temperature).")
    print("This demonstrates that correlation ≠ causation!")

spurious_correlation_example()
```

## Summary

Statistical foundations provide the mathematical framework for:

1. **Data Description**: Summarizing and characterizing datasets
2. **Uncertainty Quantification**: Understanding variability and confidence
3. **Inference**: Making conclusions about populations from samples
4. **Hypothesis Testing**: Evaluating claims using statistical evidence
5. **Relationship Analysis**: Understanding associations between variables

Key principles:
- **Sampling variability** affects all statistical conclusions
- **Central Limit Theorem** enables many statistical procedures
- **Confidence intervals** quantify uncertainty in estimates
- **Hypothesis testing** provides a framework for decision-making
- **Correlation does not imply causation** - always consider confounding variables

These concepts form the foundation for more advanced data science techniques including machine learning, experimental design, and causal inference.