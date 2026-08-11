# Entropy and Information Content

Entropy is the fundamental measure of information content and uncertainty in information theory. It quantifies how much information is contained in a message or how uncertain we are about the outcome of a random variable.

## Information Content

### Self-Information

The information content of an event is inversely related to its probability:

**I(x) = -log₂(P(x))**

```python
import numpy as np
import matplotlib.pyplot as plt

def information_content(probability):
    """Calculate information content in bits"""
    return -np.log2(probability)

# Example: Information content of different events
events = [
    ("Coin flip (heads)", 0.5),
    ("Rolling a 6", 1/6),
    ("Drawing ace of spades", 1/52),
    ("Winning lottery", 1e-8)
]

print("Information Content Examples:")
for event, prob in events:
    info = information_content(prob)
    print(f"{event}: P = {prob:.2e}, I = {info:.2f} bits")

# Visualize information content vs probability
probs = np.logspace(-6, 0, 1000)  # From 10^-6 to 1
info_content = information_content(probs)

plt.figure(figsize=(10, 6))
plt.semilogx(probs, info_content, 'b-', linewidth=2)
plt.xlabel('Probability')
plt.ylabel('Information Content (bits)')
plt.title('Information Content vs Probability')
plt.grid(True)
plt.show()
```

## Shannon Entropy

### Definition

For a discrete random variable X with possible values {x₁, x₂, ..., xₙ}:

**H(X) = -Σ P(xᵢ) log₂ P(xᵢ)**

```python
def shannon_entropy(probabilities):
    """Calculate Shannon entropy in bits"""
    # Remove zero probabilities to avoid log(0)
    probs = np.array(probabilities)
    probs = probs[probs > 0]
    return -np.sum(probs * np.log2(probs))

# Example 1: Fair coin
fair_coin = [0.5, 0.5]
print(f"Fair coin entropy: {shannon_entropy(fair_coin):.3f} bits")

# Example 2: Biased coin
biased_coin = [0.9, 0.1]
print(f"Biased coin entropy: {shannon_entropy(biased_coin):.3f} bits")

# Example 3: Fair die
fair_die = [1/6] * 6
print(f"Fair die entropy: {shannon_entropy(fair_die):.3f} bits")

# Example 4: Loaded die
loaded_die = [0.5, 0.1, 0.1, 0.1, 0.1, 0.1]
print(f"Loaded die entropy: {shannon_entropy(loaded_die):.3f} bits")
```

### Properties of Entropy

```python
def plot_binary_entropy():
    """Plot entropy of binary random variable"""
    p = np.linspace(0.001, 0.999, 1000)
    entropy = -p * np.log2(p) - (1-p) * np.log2(1-p)

    plt.figure(figsize=(10, 6))
    plt.plot(p, entropy, 'b-', linewidth=2)
    plt.axhline(y=1, color='r', linestyle='--', alpha=0.7, label='Maximum entropy')
    plt.axvline(x=0.5, color='r', linestyle='--', alpha=0.7)
    plt.xlabel('Probability p')
    plt.ylabel('Entropy H(X) (bits)')
    plt.title('Binary Entropy Function')
    plt.grid(True)
    plt.legend()
    plt.show()

    print(f"Maximum entropy occurs at p = 0.5: {shannon_entropy([0.5, 0.5]):.3f} bits")

plot_binary_entropy()
```

## Entropy in Data Analysis

### Text Analysis

```python
from collections import Counter
import string

def text_entropy(text):
    """Calculate entropy of text based on character frequencies"""
    # Convert to lowercase and remove punctuation
    text = text.lower().translate(str.maketrans('', '', string.punctuation))
    text = text.replace(' ', '')  # Remove spaces for character-level analysis

    # Count character frequencies
    char_counts = Counter(text)
    total_chars = len(text)

    # Calculate probabilities
    probabilities = [count / total_chars for count in char_counts.values()]

    return shannon_entropy(probabilities), char_counts

# Example texts
texts = [
    ("English text", "The quick brown fox jumps over the lazy dog"),
    ("Repetitive text", "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
    ("Random text", "xqzjkwpvmcnbghytrueioadslf"),
    ("Structured text", "abcabcabcabcabcabcabcabcabcabc")
]

print("Text Entropy Analysis:")
for name, text in texts:
    entropy, char_counts = text_entropy(text)
    print(f"{name}: {entropy:.3f} bits per character")
    print(f"  Unique characters: {len(char_counts)}")
    print(f"  Most common: {char_counts.most_common(3)}")
    print()
```

### Image Entropy

```python
def image_entropy(image):
    """Calculate entropy of image pixel values"""
    # Flatten image and get pixel value counts
    pixels = image.flatten()
    pixel_counts = np.bincount(pixels)

    # Calculate probabilities (excluding zero counts)
    probabilities = pixel_counts[pixel_counts > 0] / len(pixels)

    return shannon_entropy(probabilities)

# Create sample images with different entropy levels
def create_sample_images():
    # Low entropy: mostly uniform
    low_entropy = np.full((100, 100), 128, dtype=np.uint8)
    low_entropy += np.random.randint(-10, 10, (100, 100))

    # Medium entropy: gradient
    x, y = np.meshgrid(np.linspace(0, 255, 100), np.linspace(0, 255, 100))
    medium_entropy = ((x + y) / 2).astype(np.uint8)

    # High entropy: random noise
    high_entropy = np.random.randint(0, 256, (100, 100), dtype=np.uint8)

    return low_entropy, medium_entropy, high_entropy

low_ent_img, med_ent_img, high_ent_img = create_sample_images()

# Calculate entropies
entropies = [
    ("Low entropy", low_ent_img),
    ("Medium entropy", med_ent_img),
    ("High entropy", high_ent_img)
]

fig, axes = plt.subplots(1, 3, figsize=(15, 5))

for i, (name, img) in enumerate(entropies):
    entropy = image_entropy(img)
    axes[i].imshow(img, cmap='gray')
    axes[i].set_title(f'{name}\nH = {entropy:.2f} bits')
    axes[i].axis('off')

plt.tight_layout()
plt.show()
```

## Cross-Entropy and KL Divergence

### Cross-Entropy

Cross-entropy measures the average number of bits needed to encode events from distribution P using a code optimized for distribution Q:

**H(P,Q) = -Σ P(x) log₂ Q(x)**

```python
def cross_entropy(p, q):
    """Calculate cross-entropy between distributions p and q"""
    p, q = np.array(p), np.array(q)
    # Avoid log(0) by adding small epsilon
    epsilon = 1e-15
    q = np.clip(q, epsilon, 1)
    return -np.sum(p * np.log2(q))

# Example: True vs predicted distributions
true_dist = [0.7, 0.2, 0.1]
pred_dist1 = [0.6, 0.3, 0.1]  # Close to true
pred_dist2 = [0.1, 0.1, 0.8]  # Far from true

print(f"True distribution entropy: {shannon_entropy(true_dist):.3f} bits")
print(f"Cross-entropy (close prediction): {cross_entropy(true_dist, pred_dist1):.3f} bits")
print(f"Cross-entropy (poor prediction): {cross_entropy(true_dist, pred_dist2):.3f} bits")
```

### Kullback-Leibler (KL) Divergence

KL divergence measures how different two probability distributions are:

**D_KL(P||Q) = Σ P(x) log₂(P(x)/Q(x))**

```python
def kl_divergence(p, q):
    """Calculate KL divergence from q to p"""
    p, q = np.array(p), np.array(q)
    epsilon = 1e-15
    p = np.clip(p, epsilon, 1)
    q = np.clip(q, epsilon, 1)
    return np.sum(p * np.log2(p / q))

# Properties of KL divergence
print("KL Divergence Properties:")
print(f"D_KL(P||P) = {kl_divergence(true_dist, true_dist):.6f} (always 0)")
print(f"D_KL(P||Q1) = {kl_divergence(true_dist, pred_dist1):.3f}")
print(f"D_KL(P||Q2) = {kl_divergence(true_dist, pred_dist2):.3f}")
print(f"D_KL(Q1||P) = {kl_divergence(pred_dist1, true_dist):.3f} (asymmetric)")

# Relationship: H(P,Q) = H(P) + D_KL(P||Q)
h_p = shannon_entropy(true_dist)
h_pq1 = cross_entropy(true_dist, pred_dist1)
kl_pq1 = kl_divergence(true_dist, pred_dist1)

print(f"\nRelationship verification:")
print(f"H(P) = {h_p:.3f}")
print(f"H(P,Q) = {h_pq1:.3f}")
print(f"D_KL(P||Q) = {kl_pq1:.3f}")
print(f"H(P) + D_KL(P||Q) = {h_p + kl_pq1:.3f}")
```

## Applications in Machine Learning

### Decision Trees and Information Gain

```python
def information_gain(parent, children):
    """Calculate information gain for a split"""
    parent_entropy = shannon_entropy(parent)

    # Weighted average of children entropies
    total_samples = sum(len(child) for child in children)
    weighted_entropy = sum(
        (len(child) / total_samples) * shannon_entropy(child)
        for child in children
    )

    return parent_entropy - weighted_entropy

# Example: Binary classification dataset
# Class distribution before split
parent_classes = [0.6, 0.4]  # 60% class 0, 40% class 1

# After split on feature
left_child = [0.9, 0.1]   # 90% class 0, 10% class 1
right_child = [0.2, 0.8]  # 20% class 0, 80% class 1

# Assume equal-sized children for simplicity
children = [left_child, right_child]

gain = information_gain(parent_classes, children)
print(f"Information gain from split: {gain:.3f} bits")

# Compare with different splits
print("\nComparing different splits:")
splits = [
    ("Good split", [[0.9, 0.1], [0.2, 0.8]]),
    ("Poor split", [[0.55, 0.45], [0.65, 0.35]]),
    ("Perfect split", [[1.0, 0.0], [0.0, 1.0]])
]

for name, children in splits:
    gain = information_gain(parent_classes, children)
    print(f"{name}: {gain:.3f} bits")
```

### Feature Selection using Mutual Information

```python
from sklearn.feature_selection import mutual_info_classif
from sklearn.datasets import make_classification

# Generate sample dataset
X, y = make_classification(n_samples=1000, n_features=10, n_informative=5,
                          n_redundant=2, n_clusters_per_class=1, random_state=42)

# Calculate mutual information between features and target
mi_scores = mutual_info_classif(X, y, random_state=42)

# Visualize feature importance
plt.figure(figsize=(10, 6))
feature_names = [f'Feature {i}' for i in range(X.shape[1])]
plt.bar(feature_names, mi_scores)
plt.xlabel('Features')
plt.ylabel('Mutual Information')
plt.title('Feature Importance using Mutual Information')
plt.xticks(rotation=45)
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()

print("Feature ranking by mutual information:")
for i, score in sorted(enumerate(mi_scores), key=lambda x: x[1], reverse=True):
    print(f"Feature {i}: {score:.3f}")
```

## Entropy in Compression

### Huffman Coding Efficiency

```python
import heapq
from collections import defaultdict, Counter

class HuffmanNode:
    def __init__(self, char=None, freq=0, left=None, right=None):
        self.char = char
        self.freq = freq
        self.left = left
        self.right = right

    def __lt__(self, other):
        return self.freq < other.freq

def build_huffman_tree(text):
    """Build Huffman tree from text"""
    # Count character frequencies
    freq = Counter(text)

    # Create priority queue
    heap = [HuffmanNode(char, freq) for char, freq in freq.items()]
    heapq.heapify(heap)

    # Build tree
    while len(heap) > 1:
        left = heapq.heappop(heap)
        right = heapq.heappop(heap)
        merged = HuffmanNode(freq=left.freq + right.freq, left=left, right=right)
        heapq.heappush(heap, merged)

    return heap[0] if heap else None

def get_huffman_codes(root):
    """Get Huffman codes from tree"""
    if not root:
        return {}

    codes = {}

    def traverse(node, code=""):
        if node.char is not None:  # Leaf node
            codes[node.char] = code or "0"  # Handle single character case
        else:
            traverse(node.left, code + "0")
            traverse(node.right, code + "1")

    traverse(root)
    return codes

def analyze_compression_efficiency(text):
    """Analyze Huffman coding efficiency"""
    # Calculate entropy
    char_counts = Counter(text)
    total_chars = len(text)
    probabilities = [count / total_chars for count in char_counts.values()]
    entropy = shannon_entropy(probabilities)

    # Build Huffman tree and get codes
    root = build_huffman_tree(text)
    codes = get_huffman_codes(root)

    # Calculate average code length
    avg_length = sum(char_counts[char] * len(code) for char, code in codes.items()) / total_chars

    # Calculate compression ratio
    original_bits = len(text) * 8  # ASCII encoding
    compressed_bits = sum(char_counts[char] * len(codes[char]) for char in char_counts)
    compression_ratio = compressed_bits / original_bits

    print(f"Text: '{text[:50]}{'...' if len(text) > 50 else ''}'")
    print(f"Entropy: {entropy:.3f} bits per symbol")
    print(f"Average Huffman code length: {avg_length:.3f} bits per symbol")
    print(f"Efficiency: {entropy / avg_length:.3f} ({entropy / avg_length * 100:.1f}%)")
    print(f"Compression ratio: {compression_ratio:.3f} ({compression_ratio * 100:.1f}%)")
    print(f"Space saved: {(1 - compression_ratio) * 100:.1f}%")
    print()

    return entropy, avg_length, codes

# Test with different types of text
test_texts = [
    "AAAAAAAAAA",  # Low entropy
    "ABABABAB",    # Medium entropy
    "ABCDEFGHIJ",  # High entropy
    "The quick brown fox jumps over the lazy dog"  # Natural text
]

for text in test_texts:
    analyze_compression_efficiency(text)
```

## Practical Applications

### Password Strength Analysis

```python
import string
import math

def password_entropy(password):
    """Estimate password entropy"""
    # Determine character set size
    charset_size = 0
    if any(c.islower() for c in password):
        charset_size += 26  # lowercase
    if any(c.isupper() for c in password):
        charset_size += 26  # uppercase
    if any(c.isdigit() for c in password):
        charset_size += 10  # digits
    if any(c in string.punctuation for c in password):
        charset_size += len(string.punctuation)  # special characters

    # Calculate entropy assuming uniform distribution
    entropy = len(password) * math.log2(charset_size)

    return entropy, charset_size

def analyze_password_strength(passwords):
    """Analyze strength of different passwords"""
    print("Password Strength Analysis:")
    print("-" * 60)

    for pwd in passwords:
        entropy, charset = password_entropy(pwd)

        # Strength categories
        if entropy < 30:
            strength = "Very Weak"
        elif entropy < 50:
            strength = "Weak"
        elif entropy < 70:
            strength = "Moderate"
        elif entropy < 90:
            strength = "Strong"
        else:
            strength = "Very Strong"

        print(f"Password: {'*' * len(pwd)} (length: {len(pwd)})")
        print(f"Charset size: {charset}")
        print(f"Entropy: {entropy:.1f} bits")
        print(f"Strength: {strength}")
        print(f"Time to crack (1B guesses/sec): {2**(entropy-1) / 1e9:.2e} seconds")
        print()

# Test passwords
test_passwords = [
    "123456",
    "password",
    "Password1",
    "P@ssw0rd!",
    "MyVeryLongAndComplexPassword123!@#"
]

analyze_password_strength(test_passwords)
```

### Network Protocol Efficiency

```python
def protocol_efficiency_analysis():
    """Analyze efficiency of different encoding schemes"""

    # Simulate message types and their frequencies
    message_types = {
        'ACK': 0.4,      # Acknowledgment
        'DATA': 0.3,     # Data packet
        'NACK': 0.1,     # Negative acknowledgment
        'PING': 0.1,     # Ping
        'CLOSE': 0.05,   # Close connection
        'ERROR': 0.05    # Error message
    }

    # Fixed-length encoding (3 bits per message type)
    fixed_length = 3

    # Calculate optimal variable-length encoding
    probabilities = list(message_types.values())
    entropy = shannon_entropy(probabilities)

    # Huffman-like optimal encoding lengths
    # Sort by probability (descending)
    sorted_types = sorted(message_types.items(), key=lambda x: x[1], reverse=True)

    # Assign code lengths (simplified Huffman)
    optimal_codes = {
        sorted_types[0][0]: 1,  # Most frequent: 1 bit
        sorted_types[1][0]: 2,  # Second: 2 bits
        sorted_types[2][0]: 3,  # Third: 3 bits
        sorted_types[3][0]: 3,  # Fourth: 3 bits
        sorted_types[4][0]: 4,  # Fifth: 4 bits
        sorted_types[5][0]: 4   # Sixth: 4 bits
    }

    # Calculate average lengths
    avg_fixed = fixed_length
    avg_optimal = sum(message_types[msg] * length for msg, length in optimal_codes.items())

    print("Network Protocol Encoding Analysis:")
    print("-" * 50)
    print(f"Message entropy: {entropy:.3f} bits")
    print(f"Fixed-length encoding: {avg_fixed} bits per message")
    print(f"Optimal variable-length: {avg_optimal:.3f} bits per message")
    print(f"Efficiency gain: {(avg_fixed - avg_optimal) / avg_fixed * 100:.1f}%")
    print()

    print("Message type frequencies and optimal codes:")
    for msg, prob in sorted_types:
        print(f"{msg}: {prob:.2%} -> {optimal_codes[msg]} bits")

protocol_efficiency_analysis()
```

## Summary

Entropy and information content are fundamental concepts that:

1. **Quantify Information**: Measure how much information is contained in data
2. **Guide Compression**: Determine theoretical limits of data compression
3. **Optimize Communication**: Design efficient encoding schemes
4. **Analyze Uncertainty**: Measure randomness and predictability
5. **Feature Selection**: Identify informative features in machine learning
6. **Security Analysis**: Evaluate password strength and cryptographic systems

Understanding these concepts enables you to:
- Design efficient data compression algorithms
- Analyze the information content of datasets
- Optimize communication protocols
- Build better machine learning models
- Evaluate security systems
## Source Coding Sketch (Huffman Intuition)

Given symbol frequencies, assign shorter codes to frequent symbols and longer codes to rare symbols.

Example frequencies:
- A: 0.4, B: 0.3, C: 0.2, D: 0.1

One valid prefix code:
- A -> 0
- B -> 10
- C -> 110
- D -> 111

Average length:
`L = 0.4*1 + 0.3*2 + 0.2*3 + 0.1*3 = 1.9 bits/symbol`

This is close to entropy lower bound for efficient lossless coding.
