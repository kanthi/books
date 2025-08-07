# Linear Algebra for Machine Learning

Linear algebra is the backbone of machine learning. Most ML algorithms can be expressed as operations on vectors and matrices, making linear algebra essential for understanding and implementing these algorithms.

## Vectors in Machine Learning

### Vector Representation of Data

In ML, data points are typically represented as vectors:

```python
import numpy as np
import matplotlib.pyplot as plt

# Example: House price prediction
# Features: [square_feet, bedrooms, bathrooms, age]
house1 = np.array([2000, 3, 2, 5])    # House 1
house2 = np.array([1500, 2, 1, 10])   # House 2
house3 = np.array([2500, 4, 3, 2])    # House 3

# Dataset as matrix (each row is a data point)
X = np.array([house1, house2, house3])
print("Dataset shape:", X.shape)
print("Dataset:\n", X)
```

### Vector Operations in ML

#### Dot Product and Similarity

```python
def cosine_similarity(v1, v2):
    """Compute cosine similarity between two vectors"""
    dot_product = np.dot(v1, v2)
    norms = np.linalg.norm(v1) * np.linalg.norm(v2)
    return dot_product / norms

# Example: Document similarity
doc1 = np.array([1, 2, 0, 1])  # Word frequencies
doc2 = np.array([2, 1, 1, 0])  # Word frequencies
doc3 = np.array([0, 0, 1, 2])  # Word frequencies

similarity_12 = cosine_similarity(doc1, doc2)
similarity_13 = cosine_similarity(doc1, doc3)

print(f"Similarity between doc1 and doc2: {similarity_12:.3f}")
print(f"Similarity between doc1 and doc3: {similarity_13:.3f}")
```

#### Distance Metrics

```python
def euclidean_distance(v1, v2):
    """Euclidean distance between vectors"""
    return np.linalg.norm(v1 - v2)

def manhattan_distance(v1, v2):
    """Manhattan distance between vectors"""
    return np.sum(np.abs(v1 - v2))

# Example: K-Nearest Neighbors
def knn_classify(X_train, y_train, x_test, k=3):
    """Simple KNN classifier"""
    distances = [euclidean_distance(x_test, x_train) for x_train in X_train]
    k_indices = np.argsort(distances)[:k]
    k_labels = y_train[k_indices]
    return np.bincount(k_labels).argmax()

# Sample data
X_train = np.array([[1, 2], [2, 3], [3, 1], [6, 5], [7, 7], [8, 6]])
y_train = np.array([0, 0, 0, 1, 1, 1])  # Class labels
x_test = np.array([4, 4])

predicted_class = knn_classify(X_train, y_train, x_test, k=3)
print(f"Predicted class for {x_test}: {predicted_class}")

# Visualize
plt.figure(figsize=(8, 6))
colors = ['red', 'blue']
for i in range(2):
    mask = y_train == i
    plt.scatter(X_train[mask, 0], X_train[mask, 1],
                c=colors[i], label=f'Class {i}', s=100)

plt.scatter(x_test[0], x_test[1], c='green', marker='x', s=200, label='Test point')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.legend()
plt.title('K-Nearest Neighbors Classification')
plt.grid(True)
plt.show()
```

## Matrices in Machine Learning

### Data Representation

```python
# Dataset matrix: rows = samples, columns = features
n_samples, n_features = 1000, 4
X = np.random.randn(n_samples, n_features)
y = np.random.randint(0, 2, n_samples)

print(f"Data matrix shape: {X.shape}")
print(f"Labels shape: {y.shape}")

# Feature statistics
print(f"Feature means: {np.mean(X, axis=0)}")
print(f"Feature std: {np.std(X, axis=0)}")
```

### Matrix Operations in Linear Regression

```python
class LinearRegression:
    def __init__(self):
        self.weights = None
        self.bias = None

    def fit(self, X, y):
        """Fit linear regression using normal equation"""
        # Add bias term (intercept)
        X_with_bias = np.column_stack([np.ones(X.shape[0]), X])

        # Normal equation: θ = (X^T X)^(-1) X^T y
        XtX = X_with_bias.T @ X_with_bias
        Xty = X_with_bias.T @ y
        theta = np.linalg.solve(XtX, Xty)

        self.bias = theta[0]
        self.weights = theta[1:]

    def predict(self, X):
        """Make predictions"""
        return X @ self.weights + self.bias

    def score(self, X, y):
        """R-squared score"""
        y_pred = self.predict(X)
        ss_res = np.sum((y - y_pred) ** 2)
        ss_tot = np.sum((y - np.mean(y)) ** 2)
        return 1 - (ss_res / ss_tot)

# Generate sample data
np.random.seed(42)
X = np.random.randn(100, 2)
true_weights = np.array([3, -2])
true_bias = 1
y = X @ true_weights + true_bias + 0.1 * np.random.randn(100)

# Fit model
model = LinearRegression()
model.fit(X, y)

print(f"True weights: {true_weights}")
print(f"Estimated weights: {model.weights}")
print(f"True bias: {true_bias}")
print(f"Estimated bias: {model.bias:.3f}")
print(f"R-squared: {model.score(X, y):.3f}")
```

### Matrix Factorization

#### Principal Component Analysis (PCA)

```python
class PCA:
    def __init__(self, n_components):
        self.n_components = n_components
        self.components = None
        self.mean = None
        self.explained_variance_ratio = None

    def fit(self, X):
        """Fit PCA using eigendecomposition"""
        # Center the data
        self.mean = np.mean(X, axis=0)
        X_centered = X - self.mean

        # Compute covariance matrix
        cov_matrix = np.cov(X_centered.T)

        # Eigendecomposition
        eigenvalues, eigenvectors = np.linalg.eigh(cov_matrix)

        # Sort by eigenvalues (descending)
        idx = np.argsort(eigenvalues)[::-1]
        eigenvalues = eigenvalues[idx]
        eigenvectors = eigenvectors[:, idx]

        # Select top components
        self.components = eigenvectors[:, :self.n_components].T
        self.explained_variance_ratio = eigenvalues[:self.n_components] / np.sum(eigenvalues)

    def transform(self, X):
        """Transform data to lower dimension"""
        X_centered = X - self.mean
        return X_centered @ self.components.T

    def fit_transform(self, X):
        """Fit and transform in one step"""
        self.fit(X)
        return self.transform(X)

# Generate 2D data with correlation
np.random.seed(42)
mean = [0, 0]
cov = [[1, 0.8], [0.8, 1]]
X = np.random.multivariate_normal(mean, cov, 300)

# Apply PCA
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)

# Visualize
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

# Original data
ax1.scatter(X[:, 0], X[:, 1], alpha=0.6)
ax1.set_title('Original Data')
ax1.set_xlabel('Feature 1')
ax1.set_ylabel('Feature 2')
ax1.grid(True)
ax1.axis('equal')

# PCA transformed data
ax2.scatter(X_pca[:, 0], X_pca[:, 1], alpha=0.6)
ax2.set_title('PCA Transformed Data')
ax2.set_xlabel('First Principal Component')
ax2.set_ylabel('Second Principal Component')
ax2.grid(True)
ax2.axis('equal')

plt.tight_layout()
plt.show()

print(f"Explained variance ratio: {pca.explained_variance_ratio}")
print(f"Total variance explained: {np.sum(pca.explained_variance_ratio):.3f}")
```

## Eigenvalues and Eigenvectors

### Understanding Eigendecomposition

```python
def visualize_eigenvectors(A):
    """Visualize how matrix A transforms eigenvectors"""
    # Compute eigenvalues and eigenvectors
    eigenvalues, eigenvectors = np.linalg.eig(A)

    # Create unit circle
    theta = np.linspace(0, 2*np.pi, 100)
    unit_circle = np.array([np.cos(theta), np.sin(theta)])

    # Transform unit circle
    transformed_circle = A @ unit_circle

    plt.figure(figsize=(12, 5))

    # Original space
    plt.subplot(1, 2, 1)
    plt.plot(unit_circle[0], unit_circle[1], 'b-', label='Unit circle')

    # Plot eigenvectors
    for i, (val, vec) in enumerate(zip(eigenvalues, eigenvectors.T)):
        plt.arrow(0, 0, vec[0], vec[1], head_width=0.1, head_length=0.1,
                 fc=f'C{i}', ec=f'C{i}', label=f'Eigenvector {i+1} (λ={val:.2f})')

    plt.axis('equal')
    plt.grid(True)
    plt.legend()
    plt.title('Original Space')

    # Transformed space
    plt.subplot(1, 2, 2)
    plt.plot(transformed_circle[0], transformed_circle[1], 'r-', label='Transformed circle')

    # Plot transformed eigenvectors
    for i, (val, vec) in enumerate(zip(eigenvalues, eigenvectors.T)):
        transformed_vec = A @ vec
        plt.arrow(0, 0, transformed_vec[0], transformed_vec[1],
                 head_width=0.1, head_length=0.1,
                 fc=f'C{i}', ec=f'C{i}', label=f'Transformed eigenvector {i+1}')

    plt.axis('equal')
    plt.grid(True)
    plt.legend()
    plt.title('Transformed Space')

    plt.tight_layout()
    plt.show()

# Example matrix
A = np.array([[2, 1], [1, 2]])
visualize_eigenvectors(A)
```

### Spectral Clustering

```python
def spectral_clustering(X, n_clusters=2, sigma=1.0):
    """Simple spectral clustering implementation"""
    n_samples = X.shape[0]

    # Compute similarity matrix (RBF kernel)
    distances = np.sum(X**2, axis=1, keepdims=True) + np.sum(X**2, axis=1) - 2 * X @ X.T
    similarity = np.exp(-distances / (2 * sigma**2))

    # Compute degree matrix
    degree = np.diag(np.sum(similarity, axis=1))

    # Compute normalized Laplacian
    D_inv_sqrt = np.diag(1.0 / np.sqrt(np.sum(similarity, axis=1)))
    L_norm = np.eye(n_samples) - D_inv_sqrt @ similarity @ D_inv_sqrt

    # Eigendecomposition
    eigenvalues, eigenvectors = np.linalg.eigh(L_norm)

    # Use smallest eigenvectors for clustering
    embedding = eigenvectors[:, :n_clusters]

    # K-means on embedding
    from sklearn.cluster import KMeans
    kmeans = KMeans(n_clusters=n_clusters, random_state=42)
    labels = kmeans.fit_predict(embedding)

    return labels, embedding

# Generate two moons dataset
from sklearn.datasets import make_moons
X, y_true = make_moons(n_samples=200, noise=0.1, random_state=42)

# Apply spectral clustering
labels_spectral, embedding = spectral_clustering(X, n_clusters=2, sigma=0.3)

# Visualize results
fig, axes = plt.subplots(1, 3, figsize=(15, 5))

# Original data
axes[0].scatter(X[:, 0], X[:, 1], c=y_true, cmap='viridis')
axes[0].set_title('True Clusters')
axes[0].grid(True)

# Spectral embedding
axes[1].scatter(embedding[:, 0], embedding[:, 1], c=y_true, cmap='viridis')
axes[1].set_title('Spectral Embedding')
axes[1].grid(True)

# Spectral clustering result
axes[2].scatter(X[:, 0], X[:, 1], c=labels_spectral, cmap='viridis')
axes[2].set_title('Spectral Clustering Result')
axes[2].grid(True)

plt.tight_layout()
plt.show()
```

## Matrix Calculus for Neural Networks

### Gradient Computation

```python
class SimpleNeuralNetwork:
    def __init__(self, input_size, hidden_size, output_size):
        # Initialize weights
        self.W1 = np.random.randn(input_size, hidden_size) * 0.1
        self.b1 = np.zeros((1, hidden_size))
        self.W2 = np.random.randn(hidden_size, output_size) * 0.1
        self.b2 = np.zeros((1, output_size))

    def sigmoid(self, x):
        return 1 / (1 + np.exp(-np.clip(x, -250, 250)))

    def sigmoid_derivative(self, x):
        s = self.sigmoid(x)
        return s * (1 - s)

    def forward(self, X):
        """Forward pass"""
        self.z1 = X @ self.W1 + self.b1
        self.a1 = self.sigmoid(self.z1)
        self.z2 = self.a1 @ self.W2 + self.b2
        self.a2 = self.sigmoid(self.z2)
        return self.a2

    def backward(self, X, y, output):
        """Backward pass using matrix calculus"""
        m = X.shape[0]

        # Output layer gradients
        dz2 = output - y
        dW2 = (1/m) * self.a1.T @ dz2
        db2 = (1/m) * np.sum(dz2, axis=0, keepdims=True)

        # Hidden layer gradients
        da1 = dz2 @ self.W2.T
        dz1 = da1 * self.sigmoid_derivative(self.z1)
        dW1 = (1/m) * X.T @ dz1
        db1 = (1/m) * np.sum(dz1, axis=0, keepdims=True)

        return dW1, db1, dW2, db2

    def train(self, X, y, epochs=1000, learning_rate=0.1):
        """Train the network"""
        losses = []

        for epoch in range(epochs):
            # Forward pass
            output = self.forward(X)

            # Compute loss
            loss = np.mean((output - y)**2)
            losses.append(loss)

            # Backward pass
            dW1, db1, dW2, db2 = self.backward(X, y, output)

            # Update weights
            self.W1 -= learning_rate * dW1
            self.b1 -= learning_rate * db1
            self.W2 -= learning_rate * dW2
            self.b2 -= learning_rate * db2

            if epoch % 100 == 0:
                print(f"Epoch {epoch}, Loss: {loss:.4f}")

        return losses

# Generate XOR dataset
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])

# Create and train network
nn = SimpleNeuralNetwork(2, 4, 1)
losses = nn.train(X, y, epochs=5000, learning_rate=1.0)

# Test the network
predictions = nn.forward(X)
print("\nFinal predictions:")
for i in range(len(X)):
    print(f"Input: {X[i]}, Target: {y[i][0]}, Prediction: {predictions[i][0]:.3f}")

# Plot training loss
plt.figure(figsize=(10, 6))
plt.plot(losses)
plt.title('Training Loss')
plt.xlabel('Epoch')
plt.ylabel('Mean Squared Error')
plt.grid(True)
plt.show()
```

## Singular Value Decomposition (SVD)

### Recommender Systems

```python
def matrix_factorization_svd(R, k=10):
    """Matrix factorization using SVD for recommender systems"""
    # R is user-item rating matrix
    # Fill missing values with mean
    R_filled = R.copy()
    mask = ~np.isnan(R)
    R_filled[~mask] = np.nanmean(R)

    # Center the data
    user_means = np.nanmean(R, axis=1, keepdims=True)
    R_centered = R_filled - user_means

    # SVD decomposition
    U, s, Vt = np.linalg.svd(R_centered, full_matrices=False)

    # Keep only top k components
    U_k = U[:, :k]
    s_k = s[:k]
    Vt_k = Vt[:k, :]

    # Reconstruct matrix
    R_reconstructed = U_k @ np.diag(s_k) @ Vt_k + user_means

    return R_reconstructed, U_k, s_k, Vt_k

# Create sample user-item rating matrix
np.random.seed(42)
n_users, n_items = 100, 50
R = np.random.rand(n_users, n_items) * 5

# Introduce missing values (80% sparsity)
mask = np.random.rand(n_users, n_items) < 0.8
R[mask] = np.nan

print(f"Original matrix shape: {R.shape}")
print(f"Sparsity: {np.sum(mask) / (n_users * n_items):.2%}")

# Apply matrix factorization
R_pred, U, s, Vt = matrix_factorization_svd(R, k=10)

# Compute RMSE on observed entries
observed_mask = ~np.isnan(R)
rmse = np.sqrt(np.mean((R[observed_mask] - R_pred[observed_mask])**2))
print(f"RMSE on observed entries: {rmse:.3f}")

# Visualize singular values
plt.figure(figsize=(10, 6))
plt.plot(s, 'bo-')
plt.title('Singular Values')
plt.xlabel('Component')
plt.ylabel('Singular Value')
plt.grid(True)
plt.show()
```

## Practical Applications

### Image Compression using SVD

```python
def compress_image_svd(image, k):
    """Compress image using SVD"""
    if len(image.shape) == 3:
        # Color image - compress each channel
        compressed = np.zeros_like(image)
        for i in range(3):
            U, s, Vt = np.linalg.svd(image[:, :, i], full_matrices=False)
            compressed[:, :, i] = U[:, :k] @ np.diag(s[:k]) @ Vt[:k, :]
    else:
        # Grayscale image
        U, s, Vt = np.linalg.svd(image, full_matrices=False)
        compressed = U[:, :k] @ np.diag(s[:k]) @ Vt[:k, :]

    return np.clip(compressed, 0, 255).astype(np.uint8)

# Create a simple synthetic image
def create_test_image():
    x = np.linspace(0, 4*np.pi, 100)
    y = np.linspace(0, 4*np.pi, 100)
    X, Y = np.meshgrid(x, y)
    image = 128 + 127 * np.sin(X) * np.cos(Y)
    return image.astype(np.uint8)

# Test image compression
original_image = create_test_image()
compression_ratios = [5, 10, 20, 50]

fig, axes = plt.subplots(1, len(compression_ratios) + 1, figsize=(15, 3))

# Original image
axes[0].imshow(original_image, cmap='gray')
axes[0].set_title('Original')
axes[0].axis('off')

# Compressed images
for i, k in enumerate(compression_ratios):
    compressed = compress_image_svd(original_image, k)
    axes[i+1].imshow(compressed, cmap='gray')

    # Calculate compression ratio
    original_size = original_image.size
    compressed_size = k * (original_image.shape[0] + original_image.shape[1] + 1)
    ratio = compressed_size / original_size

    axes[i+1].set_title(f'k={k}\n({ratio:.1%} of original)')
    axes[i+1].axis('off')

plt.tight_layout()
plt.show()
```

## Summary

Linear algebra is fundamental to machine learning because:

1. **Data Representation**: Data is naturally represented as vectors and matrices
2. **Efficient Computation**: Matrix operations enable vectorized computations
3. **Dimensionality Reduction**: Techniques like PCA use eigendecomposition
4. **Neural Networks**: Forward and backward passes are matrix multiplications
5. **Optimization**: Gradient-based methods rely on matrix calculus
6. **Similarity and Distance**: Vector operations measure data relationships

Understanding these concepts enables you to:
- Implement ML algorithms from scratch
- Debug and optimize existing implementations
- Understand the mathematical foundations of modern AI systems
- Design new algorithms and approaches