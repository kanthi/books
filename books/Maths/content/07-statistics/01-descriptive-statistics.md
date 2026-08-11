# Descriptive Statistics: Summarizing and Visualizing Data

## Introduction to Descriptive Statistics

Descriptive statistics provides the tools and techniques for summarizing, organizing, and presenting data in meaningful ways. Before we can make inferences or draw conclusions about populations, we must first understand what our data tells us through careful description and visualization.

Descriptive statistics transforms raw data into comprehensible information, revealing patterns, trends, and characteristics that might otherwise remain hidden in long lists of numbers.

```
Purpose of Descriptive Statistics
═══════════════════════════════

Primary Goals:
• Summarize large datasets with key measures
• Identify patterns and trends in data
• Detect outliers and unusual observations
• Communicate findings clearly and effectively
• Prepare data for further statistical analysis

Key Questions Answered:
• What is the typical or central value?
• How spread out or variable are the data?
• What is the shape of the data distribution?
• Are there any unusual or extreme values?
• How do different groups or variables compare?

Tools and Techniques:
• Measures of central tendency (mean, median, mode)
• Measures of variability (range, variance, standard deviation)
• Measures of position (percentiles, quartiles, z-scores)
• Data visualization (histograms, box plots, scatter plots)
• Summary tables and frequency distributions

Applications:
• Business reporting and dashboards
• Scientific data analysis and presentation
• Quality control and process monitoring
• Market research and consumer analysis
• Educational assessment and evaluation
```

## Organizing Data

### Frequency Distributions

Frequency distributions organize data by showing how often each value or range of values occurs.

```
Types of Frequency Distributions
══════════════════════════════

For Qualitative Data:
Simple frequency table showing categories and their counts

Example: Student Majors
Major          | Frequency | Relative Frequency | Percentage
---------------|-----------|-------------------|------------
Computer Sci   |    45     |       0.30        |    30%
Mathematics    |    30     |       0.20        |    20%
Engineering    |    38     |       0.25        |    25%
Business       |    22     |       0.15        |    15%
Other          |    15     |       0.10        |    10%
Total          |   150     |       1.00        |   100%

For Quantitative Data:
Grouped frequency distribution using class intervals

Example: Test Scores (0-100)
Class Interval | Frequency | Relative Frequency | Cumulative Frequency
---------------|-----------|-------------------|--------------------
60-69          |     5     |       0.10        |         5
70-79          |    12     |       0.24        |        17
80-89          |    18     |       0.36        |        35
90-99          |    15     |       0.30        |        50
Total          |    50     |       1.00        |        50

Key Concepts:
• Frequency: Number of observations in each category/class
• Relative frequency: Proportion of total (frequency ÷ total)
• Cumulative frequency: Running total of frequencies
• Class width: Size of each interval (should be equal)
• Class midpoint: Middle value of each interval

Guidelines for Creating Classes:
• Use 5-20 classes (typically 5-15)
• Make class widths equal when possible
• Avoid overlapping classes
• Include all data points
• Use convenient class boundaries
```

### Stem-and-Leaf Plots

```
Stem-and-Leaf Displays
═════════════════════

Purpose:
• Show distribution shape while preserving actual data values
• Quick way to organize and visualize small to moderate datasets
• Useful for identifying outliers and gaps

Construction:
1. Separate each number into stem (leading digits) and leaf (trailing digit)
2. List stems vertically in order
3. List leaves horizontally for each stem in order
4. Include key explaining the format

Example: Test Scores
Data: 67, 72, 73, 75, 78, 81, 83, 85, 87, 89, 91, 93, 95, 97

Stem | Leaf
-----|----------
6    | 7
7    | 2 3 5 8
8    | 1 3 5 7 9
9    | 1 3 5 7

Key: 6|7 = 67

Advantages:
• Preserves original data values
• Shows distribution shape
• Easy to construct by hand
• Identifies outliers clearly

Disadvantages:
• Limited to relatively small datasets
• Not suitable for very large or very small numbers
• Less flexible than histograms

Variations:
• Split stems: Use 6* for 60-64, 6• for 65-69
• Back-to-back: Compare two distributions
• Truncated: Drop decimal places for simplicity
```

## Measures of Central Tendency

### The Mean

The arithmetic mean is the most commonly used measure of central tendency.

```
Arithmetic Mean
══════════════

Population Mean: μ = (Σx)/N = (x₁ + x₂ + ... + xₙ)/N

Sample Mean: x̄ = (Σx)/n = (x₁ + x₂ + ... + xₙ)/n

Where:
• Σx = sum of all values
• N = population size
• n = sample size

Example: Test Scores
Data: 85, 92, 78, 88, 95, 82, 90
x̄ = (85 + 92 + 78 + 88 + 95 + 82 + 90)/7 = 610/7 = 87.14

Properties of the Mean:
• Uses all data values in calculation
• Unique value for any dataset
• Affected by extreme values (outliers)
• Sum of deviations from mean equals zero: Σ(x - x̄) = 0
• Minimizes sum of squared deviations: Σ(x - x̄)²

When to Use:
✓ Data is roughly symmetric
✓ No extreme outliers present
✓ Interval or ratio level data
✓ Further statistical analysis planned

When Not to Use:
✗ Highly skewed distributions
✗ Presence of extreme outliers
✗ Ordinal data
✗ Open-ended classes in grouped data

Weighted Mean:
When observations have different importance or frequency

x̄w = (Σwᵢxᵢ)/(Σwᵢ)

Example: Course Grade Calculation
Component    | Score | Weight | Weighted Score
-------------|-------|--------|---------------
Homework     |  85   |  0.20  |     17.0
Midterm      |  78   |  0.30  |     23.4
Final Exam   |  92   |  0.50  |     46.0
Total        |       |  1.00  |     86.4

Weighted mean = 86.4
```

### The Median

The median is the middle value when data is arranged in order.

```
Median Calculation
═════════════════

For Odd Number of Values:
Median = middle value when arranged in order

Example: 12, 15, 18, 22, 25, 28, 30
Median = 22 (4th value out of 7)

For Even Number of Values:
Median = average of two middle values

Example: 12, 15, 18, 22, 25, 28
Median = (18 + 22)/2 = 20

Position Formula:
Position of median = (n + 1)/2

For n = 7: Position = (7 + 1)/2 = 4th value
For n = 8: Position = (8 + 1)/2 = 4.5 (average of 4th and 5th values)

Properties of the Median:
• Not affected by extreme values (robust)
• Divides data into two equal halves
• Unique value for any dataset
• Can be used with ordinal data
• May not use all data values

When to Use:
✓ Skewed distributions
✓ Presence of outliers
✓ Ordinal level data
✓ Open-ended distributions
✓ Income and housing price data

Example: Income Data
$25,000, $28,000, $32,000, $35,000, $38,000, $42,000, $250,000

Mean = $64,286 (pulled up by high income)
Median = $35,000 (better represents typical income)

Quartiles and Percentiles:
• Q₁ (25th percentile): 25% of data below this value
• Q₂ (50th percentile): Median
• Q₃ (75th percentile): 75% of data below this value

Finding Quartiles:
1. Find median (Q₂)
2. Q₁ = median of lower half
3. Q₃ = median of upper half
```

### The Mode

The mode is the most frequently occurring value in a dataset.

```
Mode Identification
══════════════════

Definition:
Value that appears most frequently in the dataset

Examples:

Unimodal (One Mode):
Data: 2, 3, 4, 4, 4, 5, 6, 7
Mode = 4 (appears 3 times)

Bimodal (Two Modes):
Data: 1, 2, 2, 3, 4, 5, 5, 6
Modes = 2 and 5 (each appears twice)

Multimodal (Multiple Modes):
Data: 1, 1, 2, 2, 3, 3, 4
Modes = 1, 2, and 3 (each appears twice)

No Mode:
Data: 1, 2, 3, 4, 5, 6, 7
No mode (all values appear once)

For Grouped Data:
Modal class = class interval with highest frequency

Example: Test Scores
Class Interval | Frequency
---------------|----------
60-69          |     3
70-79          |     8
80-89          |    12  ← Modal class
90-99          |     7

Properties of the Mode:
• Can be used with any level of data
• Not affected by extreme values
• May not exist or may not be unique
• Doesn't use all data values
• Easy to identify in frequency distributions

When to Use:
✓ Nominal (categorical) data
✓ Finding most popular item
✓ Highly skewed distributions
✓ Quick rough estimate needed

Applications:
• Most popular product size
• Most common defect type
• Peak hours for service
• Most frequent customer complaint

Relationship Between Mean, Median, and Mode:

Symmetric Distribution:
Mean = Median = Mode

Right-Skewed (Positively Skewed):
Mode < Median < Mean

Left-Skewed (Negatively Skewed):
Mean < Median < Mode

This relationship helps identify distribution shape.
```

## Measures of Variability

### Range and Interquartile Range

Measures of variability describe how spread out the data values are.

```
Range Measures
═════════════

Range:
Difference between largest and smallest values
Range = Maximum - Minimum

Example: Test Scores
Data: 65, 72, 78, 85, 88, 92, 95
Range = 95 - 65 = 30

Properties:
• Simple to calculate and understand
• Uses only two values (extremes)
• Heavily influenced by outliers
• Doesn't describe internal variability

Interquartile Range (IQR):
Difference between third and first quartiles
IQR = Q₃ - Q₁

Advantages:
• Not affected by outliers
• Describes spread of middle 50% of data
• Useful for identifying outliers

Outlier Detection Rule:
• Lower outlier: Below Q₁ - 1.5(IQR)
• Upper outlier: Above Q₃ + 1.5(IQR)

Example: Calculating IQR
Data: 12, 15, 18, 22, 25, 28, 30, 35, 40, 45, 50

Step 1: Find quartiles
Q₁ = 18 (25th percentile)
Q₂ = 28 (median)
Q₃ = 40 (75th percentile)

Step 2: Calculate IQR
IQR = Q₃ - Q₁ = 40 - 18 = 22

Step 3: Check for outliers
Lower fence: 18 - 1.5(22) = 18 - 33 = -15
Upper fence: 40 + 1.5(22) = 40 + 33 = 73
No outliers in this dataset

Semi-Interquartile Range:
Also called quartile deviation
Semi-IQR = (Q₃ - Q₁)/2 = IQR/2

Used when median is reported as central tendency measure
```

### Variance and Standard Deviation

```
Variance and Standard Deviation
═════════════════════════════

Population Variance:
σ² = Σ(x - μ)²/N

Population Standard Deviation:
σ = √[Σ(x - μ)²/N]

Sample Variance:
s² = Σ(x - x̄)²/(n - 1)

Sample Standard Deviation:
s = √[Σ(x - x̄)²/(n - 1)]

Note: Sample formulas use (n-1) for unbiased estimation

Calculation Example:
Data: 2, 4, 6, 8, 10

Step 1: Calculate mean
x̄ = (2 + 4 + 6 + 8 + 10)/5 = 30/5 = 6

Step 2: Calculate deviations and squared deviations
x  | (x - x̄) | (x - x̄)²
---|---------|----------
2  |   -4    |    16
4  |   -2    |     4
6  |    0    |     0
8  |    2    |     4
10 |    4    |    16
   |    0    |    40

Step 3: Calculate variance
s² = 40/(5-1) = 40/4 = 10

Step 4: Calculate standard deviation
s = √10 = 3.16

Properties:
• Uses all data values
• Measures average distance from mean
• Same units as original data (for standard deviation)
• Larger values indicate more variability
• Always non-negative

Computational Formula (easier for hand calculation):
s² = [Σx² - (Σx)²/n]/(n - 1)

Using previous example:
Σx = 30, Σx² = 220, n = 5
s² = [220 - (30)²/5]/(5-1) = [220 - 180]/4 = 40/4 = 10

Interpretation:
• About 68% of data within 1 standard deviation of mean
• About 95% of data within 2 standard deviations of mean
• About 99.7% of data within 3 standard deviations of mean
(For approximately normal distributions)

When to Use:
✓ Interval or ratio level data
✓ Roughly symmetric distributions
✓ Further statistical analysis planned
✓ Comparing variability between groups
```

### Coefficient of Variation

```
Coefficient of Variation
══════════════════════

Definition:
Relative measure of variability expressed as percentage
CV = (s/x̄) × 100%

Purpose:
• Compare variability between datasets with different units
• Compare variability between datasets with different means
• Determine relative consistency

Example 1: Comparing Test Scores
Class A: x̄ = 85, s = 10
Class B: x̄ = 75, s = 8

CV_A = (10/85) × 100% = 11.8%
CV_B = (8/75) × 100% = 10.7%

Class B has less relative variability despite similar absolute variability.

Example 2: Comparing Different Measurements
Height: x̄ = 68 inches, s = 3 inches
Weight: x̄ = 150 pounds, s = 20 pounds

CV_height = (3/68) × 100% = 4.4%
CV_weight = (20/150) × 100% = 13.3%

Weight shows more relative variability than height.

Interpretation Guidelines:
• CV < 15%: Low variability
• 15% ≤ CV < 35%: Moderate variability
• CV ≥ 35%: High variability

When to Use:
✓ Comparing datasets with different units
✓ Comparing datasets with very different means
✓ Quality control applications
✓ Financial risk assessment

Limitations:
• Not meaningful when mean is close to zero
• Can be misleading with negative values
• Assumes ratio-level data
```

## Measures of Position

### Percentiles and Quartiles

```
Percentiles
══════════

Definition:
The kth percentile is the value below which k% of the data falls

Common Percentiles:
• 25th percentile (Q₁): First quartile
• 50th percentile (Q₂): Median
• 75th percentile (Q₃): Third quartile
• 90th percentile: Commonly used in testing
• 95th percentile: Often used as cutoff points

Calculating Percentiles:
1. Arrange data in ascending order
2. Find position: L = (k/100) × n
3. If L is whole number, percentile = average of values at positions L and L+1
4. If L is not whole number, round up to next integer position

Example: Finding 30th Percentile
Data: 12, 15, 18, 22, 25, 28, 30, 35, 40 (n = 9)

L = (30/100) × 9 = 2.7
Round up to position 3
30th percentile = 18

Five-Number Summary:
1. Minimum value
2. First quartile (Q₁)
3. Median (Q₂)
4. Third quartile (Q₃)
5. Maximum value

Example:
Data: 5, 8, 12, 15, 18, 22, 25, 28, 30, 35, 40

Five-number summary:
Min = 5
Q₁ = 12
Q₂ = 22
Q₃ = 30
Max = 40

Applications:
• Standardized test scores (SAT, GRE)
• Growth charts for children
• Income distribution analysis
• Performance benchmarking
• Quality control limits
```

### Z-Scores (Standard Scores)

```
Z-Scores
═══════

Definition:
Number of standard deviations a value is from the mean
z = (x - μ)/σ  (population)
z = (x - x̄)/s  (sample)

Interpretation:
• z = 0: Value equals the mean
• z > 0: Value is above the mean
• z < 0: Value is below the mean
• |z| = 1: Value is 1 standard deviation from mean

Example: Test Scores
Class average: x̄ = 75, standard deviation: s = 10
Student score: x = 85

z = (85 - 75)/10 = 1.0

The student scored 1 standard deviation above the mean.

Properties of Z-Scores:
• Mean of z-scores = 0
• Standard deviation of z-scores = 1
• Shape of distribution unchanged
• Unitless (standardized)

Uses:
• Compare scores from different distributions
• Identify outliers (|z| > 2 or 3)
• Calculate probabilities with normal distribution
• Standardize data for analysis

Example: Comparing Performance
Math test: x = 85, x̄ = 75, s = 10
z_math = (85 - 75)/10 = 1.0

English test: x = 92, x̄ = 88, s = 6
z_english = (92 - 88)/6 = 0.67

Better relative performance in math despite lower absolute score.

Outlier Detection:
• Mild outliers: 2 < |z| < 3
• Extreme outliers: |z| > 3

Modified Z-Score (using median):
More robust for skewed data
Modified z = 0.6745(x - median)/MAD
where MAD = median absolute deviation
```

## Data Visualization

### Histograms

```
Histogram Construction
════════════════════

Purpose:
• Show distribution shape
• Identify patterns and outliers
• Compare distributions
• Estimate probabilities

Construction Steps:
1. Determine number of classes (5-20, typically)
2. Calculate class width = (max - min)/number of classes
3. Create class boundaries
4. Count frequencies for each class
5. Draw bars with heights equal to frequencies

Example: Test Scores
Data: 65, 68, 72, 75, 78, 80, 82, 85, 88, 90, 92, 95

Classes:
60-69: 2 students
70-79: 3 students
80-89: 4 students
90-99: 3 students

Histogram Features:
• Bars touch each other (continuous data)
• Height represents frequency
• Area represents relative frequency
• No gaps between bars (unless no data)

Distribution Shapes:
• Normal (bell-shaped): Symmetric, single peak
• Right-skewed: Tail extends to right
• Left-skewed: Tail extends to left
• Uniform: All bars approximately same height
• Bimodal: Two distinct peaks

Guidelines:
• Use equal class widths when possible
• Avoid too few or too many classes
• Label axes clearly
• Include title and sample size
• Consider relative frequency for comparisons

Variations:
• Relative frequency histogram (proportions)
• Density histogram (area = 1)
• Cumulative frequency histogram
• Back-to-back histogram (comparing groups)
```

### Box Plots

```
Box Plot Construction
═══════════════════

Components:
• Box: Extends from Q₁ to Q₃ (contains middle 50%)
• Median line: Line inside box at Q₂
• Whiskers: Lines extending to furthest non-outlier points
• Outliers: Points beyond whiskers (circles or asterisks)

Construction Steps:
1. Calculate five-number summary
2. Identify outliers using IQR rule
3. Draw box from Q₁ to Q₃
4. Draw median line at Q₂
5. Extend whiskers to furthest non-outlier points
6. Plot outliers as individual points

Example:
Data: 12, 15, 18, 22, 25, 28, 30, 35, 40, 45, 60

Five-number summary:
Min = 12, Q₁ = 18, Q₂ = 28, Q₃ = 40, Max = 60

IQR = 40 - 18 = 22
Lower fence: 18 - 1.5(22) = -15
Upper fence: 40 + 1.5(22) = 73

No outliers, so whiskers extend to 12 and 60.

Advantages:
• Shows distribution shape
• Identifies outliers clearly
• Compact display
• Good for comparing groups
• Shows median and quartiles

Disadvantages:
• Less detail than histogram
• Doesn't show sample size
• May hide multimodal distributions
• Requires understanding of quartiles

Variations:
• Notched box plot: Shows confidence interval for median
• Variable width: Box width proportional to sample size
• Violin plot: Combines box plot with density curve

Interpretation:
• Symmetric: Median near center of box, equal whiskers
• Right-skewed: Median toward left side, longer right whisker
• Left-skewed: Median toward right side, longer left whisker
```

### Scatter Plots

```
Scatter Plot Analysis
═══════════════════

Purpose:
• Show relationship between two quantitative variables
• Identify correlation patterns
• Detect outliers and unusual points
• Assess linearity of relationships

Construction:
• x-axis: Independent (explanatory) variable
• y-axis: Dependent (response) variable
• Each point represents one observation
• Plot all (x, y) pairs

Relationship Patterns:

Positive Linear:
• Points form upward-sloping pattern
• As x increases, y tends to increase
• Example: Height vs. weight

Negative Linear:
• Points form downward-sloping pattern
• As x increases, y tends to decrease
• Example: Price vs. demand

No Relationship:
• Points scattered randomly
• No clear pattern
• Example: Shoe size vs. GPA

Nonlinear:
• Points form curved pattern
• May be exponential, quadratic, etc.
• Example: Age vs. reaction time

Strength Assessment:
• Strong: Points close to pattern line
• Moderate: Points somewhat scattered around pattern
• Weak: Points widely scattered, pattern unclear

Outliers:
• Points that don't fit the general pattern
• May indicate data errors or special cases
• Can strongly influence correlation

Example Analysis:
Study time (hours) vs. Test score

Observations:
• Positive relationship: More study time → higher scores
• Moderately strong: Points fairly close to line
• One outlier: Student with high study time but low score
• Generally linear relationship

Enhancements:
• Add trend line to show relationship
• Use different colors/symbols for groups
• Add marginal histograms
• Include correlation coefficient
• Size points by third variable (bubble plot)
```

## Summary Statistics and Reports

### Creating Effective Summaries

```
Statistical Summary Reports
═════════════════════════

Essential Components:
• Sample size (n)
• Measures of central tendency
• Measures of variability
• Distribution shape indicators
• Outlier identification
• Confidence intervals (when appropriate)

Standard Summary Format:
Variable: Test Scores
n = 50
Mean = 82.4
Median = 84.0
Mode = 85
Standard Deviation = 8.2
Range = 35 (65 to 100)
IQR = 12 (Q₁ = 78, Q₃ = 90)
Outliers: 2 (scores of 65 and 67)

Choosing Appropriate Statistics:

For Symmetric Distributions:
• Central tendency: Mean
• Variability: Standard deviation
• Position: Z-scores

For Skewed Distributions:
• Central tendency: Median
• Variability: IQR
• Position: Percentiles

For Categorical Data:
• Central tendency: Mode
• Variability: Not applicable
• Position: Frequencies and percentages

Comparative Summaries:
When comparing groups, include:
• Side-by-side statistics
• Relative measures (CV, percentages)
• Visual comparisons (box plots)
• Effect size measures

Example: Comparing Two Classes
                Class A    Class B
n                 25         30
Mean            85.2       78.6
Median          86.0       80.0
Std Dev          6.8        9.2
Range           28         35
IQR             10         14

Interpretation: Class A performed better on average with less variability.

Report Writing Guidelines:
• Start with context and data source
• Present statistics in logical order
• Use appropriate precision (2-3 significant digits)
• Include units of measurement
• Highlight key findings
• Discuss limitations and assumptions
• Use tables and graphs effectively
```

## Summary and Key Concepts

Descriptive statistics provides the foundation for understanding and communicating what data reveals, serving as the essential first step in any statistical analysis.

```
Chapter Summary
══════════════

Essential Skills Mastered:
✓ Organizing data with frequency distributions and displays
✓ Calculating measures of central tendency (mean, median, mode)
✓ Computing measures of variability (range, variance, standard deviation)
✓ Finding measures of position (percentiles, quartiles, z-scores)
✓ Creating and interpreting data visualizations
✓ Writing effective statistical summaries

Key Concepts:
• Central tendency describes typical values
• Variability measures spread of data
• Position measures locate individual values
• Distribution shape affects choice of statistics
• Outliers can significantly impact results
• Visualization reveals patterns not apparent in numbers

Fundamental Measures:
• Mean: Arithmetic average, sensitive to outliers
• Median: Middle value, robust to outliers
• Mode: Most frequent value, useful for categories
• Standard deviation: Average distance from mean
• IQR: Spread of middle 50% of data
• Percentiles: Position relative to other values

Problem-Solving Framework:
• Examine data type and distribution shape
• Choose appropriate measures of center and spread
• Identify and investigate outliers
• Create meaningful visualizations
• Summarize findings clearly and accurately

Visualization Tools:
• Histograms: Show distribution shape and frequency
• Box plots: Display five-number summary and outliers
• Scatter plots: Reveal relationships between variables
• Stem-and-leaf: Preserve actual data values
• Frequency tables: Organize categorical data

Next Steps:
Descriptive statistics skills prepare you for:
- Probability theory and distributions
- Inferential statistics and hypothesis testing
- Regression analysis and correlation
- Quality control and process improvement
- Data analysis in research and business
```

Descriptive statistics represents the essential foundation of statistical analysis, providing the tools to transform raw data into meaningful information. The techniques covered in this chapter—from basic measures of center and spread to sophisticated visualization methods—enable you to explore data systematically, identify important patterns, and communicate findings effectively.

Understanding descriptive statistics is crucial not only for further statistical study but also for making informed decisions in any field that involves data. Whether you're analyzing business performance, evaluating research results, or simply trying to make sense of information in daily life, these descriptive tools provide the framework for clear, accurate, and insightful data analysis.

The skills developed in this chapter form the building blocks for more advanced statistical methods. As you progress to inferential statistics, you'll use these descriptive techniques to understand sample data before making generalizations about populations. The visualization and summary skills you've learned will remain essential throughout your statistical journey, helping you communicate results and validate assumptions in more complex analyses.