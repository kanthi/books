# Derivatives and Applications in Computer Science

Derivatives are crucial in computer science for optimization, machine learning, and algorithm analysis. This section covers derivatives with practical CS applications.

## What is a Derivative?

A derivative measures the rate of change of a function. In CS contexts:
- **Gradient descent**: Uses derivatives to find optimal parameters
- **Backpropagation**: Computes derivatives to train neural networks
- **Algorithm analysis**: Derivatives help analyze growth rates

## Basic Derivative Rules

### Power Rule
If f(x) = x^n, then f'(x) = nx^(n-1)

```python
import numpy as np
import matplotlib.pyplot as plt

# Example: f(x) = x^2, f'(x) = 2x
x = np.linspace(-3, 3, 100)
f = x**2
f_prime = 2*x

plt.figure(figsize=(10, 6))
plt.subplot(1, 2, 1)
plt.plot(x, f, 'b-', label='f(x) = x²')
plt.title('Original Function')
plt.grid(True)
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(x, f_prime, 'r-', label="f'(x) = 2x")
plt.title('Derivative')
plt.grid(True)
plt.legend()
plt.show()
```

### Chain Rule
If f(x) = g(h(x)), then f'(x) = g'(h(x)) × h'(x)

This is fundamental in neural networks for backpropagation.

## Applications in Machine Learning

### 1. Gradient Descent

Gradient descent uses derivatives to minimize cost functions:

```python
import numpy as np

def gradient_descent(f, df, x0, learning_rate=0.01, iterations=1000):
    """
    Minimize function f using gradient descent
    f: function to minimize
    df: derivative of f
    x0: starting point
    """
    x = x0
    history = [x]

    for i in range(iterations):
        gradient = df(x)
        x = x - learning_rate * gradient
        history.append(x)

    return x, history

# Example: minimize f(x) = x^2 + 2x + 1
def f(x):
    return x**2 + 2*x + 1

def df(x):
    return 2*x + 2

# Find minimum
minimum, path = gradient_descent(f, df, x0=5.0)
print(f"Minimum found at x = {minimum:.4f}")
print(f"Function value: {f(minimum):.4f}")
```

### 2. Neural Network Backpropagation

```python
import numpy as np

class SimpleNeuron:
    def __init__(self, weights, bias):
        self.weights = np.array(weights)
        self.bias = bias

    def sigmoid(self, x):
        return 1 / (1 + np.exp(-x))

    def sigmoid_derivative(self, x):
        s = self.sigmoid(x)
        return s * (1 - s)

    def forward(self, inputs):
        self.inputs = np.array(inputs)
        self.z = np.dot(self.weights, self.inputs) + self.bias
        self.output = self.sigmoid(self.z)
        return self.output

    def backward(self, error):
        # Compute gradients using chain rule
        d_output = error
        d_z = d_output * self.sigmoid_derivative(self.z)
        d_weights = d_z * self.inputs
        d_bias = d_z
        d_inputs = d_z * self.weights

        return d_weights, d_bias, d_inputs

# Example usage
neuron = SimpleNeuron([0.5, -0.3], 0.1)
output = neuron.forward([1.0, 2.0])
gradients = neuron.backward(0.1)  # Small error
print(f"Output: {output:.4f}")
print(f"Weight gradients: {gradients[0]}")
```

## Applications in Computer Graphics

### 1. Parametric Curves

Derivatives help create smooth curves in graphics:

```python
import numpy as np
import matplotlib.pyplot as plt

def bezier_curve(t, P0, P1, P2, P3):
    """Cubic Bezier curve"""
    return (1-t)**3 * P0 + 3*(1-t)**2*t * P1 + 3*(1-t)*t**2 * P2 + t**3 * P3

def bezier_derivative(t, P0, P1, P2, P3):
    """Derivative of cubic Bezier curve (tangent vector)"""
    return 3*(1-t)**2 * (P1-P0) + 6*(1-t)*t * (P2-P1) + 3*t**2 * (P3-P2)

# Control points
P0, P1, P2, P3 = np.array([0,0]), np.array([1,2]), np.array([3,2]), np.array([4,0])

t = np.linspace(0, 1, 100)
curve = np.array([bezier_curve(ti, P0, P1, P2, P3) for ti in t])
tangents = np.array([bezier_derivative(ti, P0, P1, P2, P3) for ti in t])

plt.figure(figsize=(10, 6))
plt.plot(curve[:, 0], curve[:, 1], 'b-', linewidth=2, label='Bezier Curve')
plt.plot([P0[0], P1[0], P2[0], P3[0]], [P0[1], P1[1], P2[1], P3[1]], 'ro--', alpha=0.5, label='Control Points')

# Show tangent vectors at a few points
for i in range(0, len(t), 20):
    start = curve[i]
    direction = tangents[i] * 0.1  # Scale for visibility
    plt.arrow(start[0], start[1], direction[0], direction[1],
              head_width=0.05, head_length=0.05, fc='red', ec='red')

plt.axis('equal')
plt.grid(True)
plt.legend()
plt.title('Bezier Curve with Tangent Vectors')
plt.show()
```

### 2. Surface Normals

In 3D graphics, derivatives help compute surface normals:

```python
import numpy as np
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt

def surface_function(x, y):
    """Example surface: z = x^2 + y^2"""
    return x**2 + y**2

def surface_normal(x, y):
    """Compute normal vector using partial derivatives"""
    # ∂z/∂x = 2x, ∂z/∂y = 2y
    dz_dx = 2*x
    dz_dy = 2*y

    # Normal vector is (-∂z/∂x, -∂z/∂y, 1)
    normal = np.array([-dz_dx, -dz_dy, 1])
    # Normalize
    return normal / np.linalg.norm(normal)

# Create surface
x = np.linspace(-2, 2, 20)
y = np.linspace(-2, 2, 20)
X, Y = np.meshgrid(x, y)
Z = surface_function(X, Y)

# Compute normals
normals = np.array([[surface_normal(xi, yi) for xi, yi in zip(row_x, row_y)]
                   for row_x, row_y in zip(X, Y)])

fig = plt.figure(figsize=(12, 5))

# Plot surface
ax1 = fig.add_subplot(121, projection='3d')
ax1.plot_surface(X, Y, Z, alpha=0.7, cmap='viridis')
ax1.set_title('Surface: z = x² + y²')

# Plot surface with normals
ax2 = fig.add_subplot(122, projection='3d')
ax2.plot_surface(X, Y, Z, alpha=0.3, cmap='viridis')

# Show normal vectors at selected points
step = 3
for i in range(0, X.shape[0], step):
    for j in range(0, X.shape[1], step):
        start = [X[i,j], Y[i,j], Z[i,j]]
        direction = normals[i,j] * 0.5
        ax2.quiver(start[0], start[1], start[2],
                  direction[0], direction[1], direction[2],
                  color='red', arrow_length_ratio=0.1)

ax2.set_title('Surface with Normal Vectors')
plt.show()
```

## Applications in Algorithm Analysis

### Growth Rate Analysis

Derivatives help analyze algorithm complexity:

```python
import numpy as np
import matplotlib.pyplot as plt

def analyze_growth_rate(f, df, x_range):
    """Analyze how fast a function grows"""
    x = np.linspace(x_range[0], x_range[1], 1000)
    y = f(x)
    dy = df(x)

    plt.figure(figsize=(12, 4))

    plt.subplot(1, 3, 1)
    plt.plot(x, y, 'b-', linewidth=2)
    plt.title('Function f(x)')
    plt.grid(True)

    plt.subplot(1, 3, 2)
    plt.plot(x, dy, 'r-', linewidth=2)
    plt.title("Growth Rate f'(x)")
    plt.grid(True)

    plt.subplot(1, 3, 3)
    plt.loglog(x[x>0], y[x>0], 'b-', linewidth=2, label='f(x)')
    plt.loglog(x[x>0], dy[x>0], 'r-', linewidth=2, label="f'(x)")
    plt.title('Log-Log Plot')
    plt.legend()
    plt.grid(True)

    plt.tight_layout()
    plt.show()

# Compare different complexity functions
functions = [
    (lambda x: x, lambda x: np.ones_like(x), "O(n)"),
    (lambda x: x*np.log(x), lambda x: np.log(x) + 1, "O(n log n)"),
    (lambda x: x**2, lambda x: 2*x, "O(n²)"),
    (lambda x: x**3, lambda x: 3*x**2, "O(n³)")
]

x = np.linspace(1, 100, 1000)
plt.figure(figsize=(12, 8))

for i, (f, df, label) in enumerate(functions):
    plt.subplot(2, 2, i+1)
    y = f(x)
    dy = df(x)

    plt.plot(x, y, 'b-', linewidth=2, label=f'f(x) = {label}')
    plt.plot(x, dy, 'r--', linewidth=2, label="f'(x)")
    plt.title(f'Growth Analysis: {label}')
    plt.legend()
    plt.grid(True)

plt.tight_layout()
plt.show()
```

## Optimization Problems

### Finding Critical Points

```python
import numpy as np
from scipy.optimize import minimize_scalar
import matplotlib.pyplot as plt

def find_critical_points(f, df, x_range):
    """Find critical points where f'(x) = 0"""
    x = np.linspace(x_range[0], x_range[1], 1000)
    y = f(x)
    dy = df(x)

    # Find where derivative is approximately zero
    critical_points = []
    for i in range(1, len(dy)-1):
        if dy[i-1] * dy[i+1] < 0:  # Sign change
            # Use more precise method
            result = minimize_scalar(lambda x: abs(df(x)),
                                   bounds=(x[i-1], x[i+1]),
                                   method='bounded')
            critical_points.append(result.x)

    plt.figure(figsize=(12, 4))

    plt.subplot(1, 2, 1)
    plt.plot(x, y, 'b-', linewidth=2, label='f(x)')
    for cp in critical_points:
        plt.plot(cp, f(cp), 'ro', markersize=8, label=f'Critical point: x={cp:.2f}')
    plt.title('Function with Critical Points')
    plt.legend()
    plt.grid(True)

    plt.subplot(1, 2, 2)
    plt.plot(x, dy, 'r-', linewidth=2, label="f'(x)")
    plt.axhline(y=0, color='k', linestyle='--', alpha=0.5)
    for cp in critical_points:
        plt.plot(cp, df(cp), 'ro', markersize=8)
    plt.title('Derivative (zeros are critical points)')
    plt.legend()
    plt.grid(True)

    plt.tight_layout()
    plt.show()

    return critical_points

# Example: f(x) = x^3 - 3x^2 + 2x + 1
def f(x):
    return x**3 - 3*x**2 + 2*x + 1

def df(x):
    return 3*x**2 - 6*x + 2

critical_points = find_critical_points(f, df, (-1, 3))
print("Critical points found at:", critical_points)
```

## Practical Exercises

### Exercise 1: Implement Gradient Descent for Linear Regression

```python
import numpy as np
import matplotlib.pyplot as plt

def linear_regression_gradient_descent():
    # Generate sample data
    np.random.seed(42)
    X = np.random.randn(100, 1)
    y = 2 * X.flatten() + 1 + 0.1 * np.random.randn(100)

    # Initialize parameters
    w = 0.0  # weight
    b = 0.0  # bias
    learning_rate = 0.01
    iterations = 1000

    # Cost function: MSE
    def cost_function(w, b, X, y):
        predictions = w * X.flatten() + b
        return np.mean((predictions - y)**2)

    # Gradients
    def compute_gradients(w, b, X, y):
        m = len(y)
        predictions = w * X.flatten() + b
        dw = (2/m) * np.sum((predictions - y) * X.flatten())
        db = (2/m) * np.sum(predictions - y)
        return dw, db

    # Training loop
    costs = []
    for i in range(iterations):
        cost = cost_function(w, b, X, y)
        costs.append(cost)

        dw, db = compute_gradients(w, b, X, y)
        w -= learning_rate * dw
        b -= learning_rate * db

    # Plot results
    plt.figure(figsize=(12, 4))

    plt.subplot(1, 2, 1)
    plt.scatter(X, y, alpha=0.5, label='Data')
    plt.plot(X, w * X.flatten() + b, 'r-', linewidth=2, label=f'Fitted line: y = {w:.2f}x + {b:.2f}')
    plt.xlabel('X')
    plt.ylabel('y')
    plt.legend()
    plt.title('Linear Regression Result')

    plt.subplot(1, 2, 2)
    plt.plot(costs)
    plt.xlabel('Iteration')
    plt.ylabel('Cost')
    plt.title('Cost Function During Training')
    plt.grid(True)

    plt.tight_layout()
    plt.show()

    print(f"Final parameters: w = {w:.4f}, b = {b:.4f}")
    print(f"True parameters: w = 2.0, b = 1.0")

linear_regression_gradient_descent()
```

### Exercise 2: Numerical Differentiation

```python
def numerical_derivative(f, x, h=1e-7):
    """Compute numerical derivative using central difference"""
    return (f(x + h) - f(x - h)) / (2 * h)

def compare_derivatives():
    """Compare analytical and numerical derivatives"""

    # Test function: f(x) = x^3 + 2x^2 - x + 1
    def f(x):
        return x**3 + 2*x**2 - x + 1

    def analytical_derivative(x):
        return 3*x**2 + 4*x - 1

    x_values = np.linspace(-3, 3, 100)
    analytical = [analytical_derivative(x) for x in x_values]
    numerical = [numerical_derivative(f, x) for x in x_values]

    plt.figure(figsize=(10, 6))
    plt.plot(x_values, analytical, 'b-', linewidth=2, label='Analytical')
    plt.plot(x_values, numerical, 'r--', linewidth=2, label='Numerical')
    plt.xlabel('x')
    plt.ylabel("f'(x)")
    plt.title('Analytical vs Numerical Derivatives')
    plt.legend()
    plt.grid(True)
    plt.show()

    # Compute error
    error = np.abs(np.array(analytical) - np.array(numerical))
    print(f"Maximum error: {np.max(error):.2e}")
    print(f"Average error: {np.mean(error):.2e}")

compare_derivatives()
```

## Summary

Derivatives are essential in computer science for:

1. **Optimization**: Finding optimal solutions using gradient-based methods
2. **Machine Learning**: Training neural networks through backpropagation
3. **Computer Graphics**: Creating smooth curves and computing surface properties
4. **Algorithm Analysis**: Understanding growth rates and complexity
5. **Numerical Methods**: Approximating solutions to complex problems

The key insight is that derivatives measure rates of change, which is fundamental to optimization and learning algorithms that form the backbone of modern AI and machine learning systems.