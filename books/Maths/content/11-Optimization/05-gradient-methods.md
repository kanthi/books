# Gradient-Based Optimization Methods

Gradient-based methods are the backbone of modern machine learning and optimization. They use derivative information to iteratively find optimal solutions, making them essential for training neural networks and solving large-scale optimization problems.

## Gradient Descent Fundamentals

### Basic Gradient Descent

The gradient descent algorithm updates parameters in the direction of steepest descent:

**x_{k+1} = x_k - α ∇f(x_k)**

Where:
- α is the learning rate (step size)
- ∇f(x_k) is the gradient at point x_k

```python
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

def gradient_descent_basic(f, grad_f, x0, learning_rate=0.01, max_iterations=1000, tolerance=1e-6):
    """Basic gradient descent implementation"""
    x = x0.copy()
    history = [x.copy()]

    for i in range(max_iterations):
        gradient = grad_f(x)
        x_new = x - learning_rate * gradient

        # Check convergence
        if np.linalg.norm(x_new - x) < tolerance:
            print(f"Converged after {i+1} iterations")
            break

        x = x_new
        history.append(x.copy())

    return x, np.array(history)

# Example: Minimize f(x,y) = x² + 2y²
def quadratic_function(x):
    return x[0]**2 + 2*x[1]**2

def quadratic_gradient(x):
    return np.array([2*x[0], 4*x[1]])

# Optimize
x0 = np.array([3.0, 2.0])
optimal_x, history = gradient_descent_basic(quadratic_function, quadratic_gradient, x0, learning_rate=0.1)

print(f"Starting point: {x0}")
print(f"Optimal point: {optimal_x}")
print(f"Function value: {quadratic_function(optimal_x):.6f}")

# Visualize optimization path
x = np.linspace(-4, 4, 100)
y = np.linspace(-3, 3, 100)
X, Y = np.meshgrid(x, y)
Z = X**2 + 2*Y**2

plt.figure(figsize=(12, 5))

# 2D contour plot
plt.subplot(1, 2, 1)
contours = plt.contour(X, Y, Z, levels=20)
plt.plot(history[:, 0], history[:, 1], 'ro-', markersize=4, linewidth=2, label='Optimization path')
plt.plot(optimal_x[0], optimal_x[1], 'g*', markersize=15, label='Optimum')
plt.xlabel('x')
plt.ylabel('y')
plt.title('Gradient Descent Path')
plt.legend()
plt.grid(True, alpha=0.3)

# 3D surface plot
ax = plt.subplot(1, 2, 2, projection='3d')
ax.plot_surface(X, Y, Z, alpha=0.6, cmap='viridis')
ax.plot(history[:, 0], history[:, 1], [quadratic_function(h) for h in history],
        'ro-', markersize=4, linewidth=2, label='Optimization path')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('f(x,y)')
ax.set_title('3D Optimization Path')

plt.tight_layout()
plt.show()
```

### Learning Rate Analysis

```python
def analyze_learning_rates():
    """Analyze the effect of different learning rates"""

    learning_rates = [0.01, 0.1, 0.5, 0.9]
    x0 = np.array([3.0, 2.0])

    plt.figure(figsize=(15, 10))

    for i, lr in enumerate(learning_rates):
        optimal_x, history = gradient_descent_basic(
            quadratic_function, quadratic_gradient, x0,
            learning_rate=lr, max_iterations=50
        )

        plt.subplot(2, 2, i+1)

        # Plot contours
        x = np.linspace(-4, 4, 100)
        y = np.linspace(-3, 3, 100)
        X, Y = np.meshgrid(x, y)
        Z = X**2 + 2*Y**2
        plt.contour(X, Y, Z, levels=15, alpha=0.6)

        # Plot optimization path
        plt.plot(history[:, 0], history[:, 1], 'ro-', markersize=3, linewidth=1.5)
        plt.plot(0, 0, 'g*', markersize=15, label='True optimum')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.title(f'Learning Rate = {lr}')
        plt.grid(True, alpha=0.3)
        plt.legend()

        # Print convergence info
        final_error = np.linalg.norm(optimal_x)
        print(f"LR = {lr}: Final error = {final_error:.6f}, Iterations = {len(history)}")

    plt.tight_layout()
    plt.show()

analyze_learning_rates()
```

## Advanced Gradient Methods

### Momentum

Momentum helps accelerate convergence and reduces oscillations:

**v_{k+1} = β v_k + α ∇f(x_k)**
**x_{k+1} = x_k - v_{k+1}**

```python
def gradient_descent_momentum(f, grad_f, x0, learning_rate=0.01, momentum=0.9,
                             max_iterations=1000, tolerance=1e-6):
    """Gradient descent with momentum"""
    x = x0.copy()
    velocity = np.zeros_like(x)
    history = [x.copy()]

    for i in range(max_iterations):
        gradient = grad_f(x)
        velocity = momentum * velocity + learning_rate * gradient
        x_new = x - velocity

        if np.linalg.norm(x_new - x) < tolerance:
            print(f"Momentum GD converged after {i+1} iterations")
            break

        x = x_new
        history.append(x.copy())

    return x, np.array(history)

# Compare standard GD vs momentum
def compare_momentum():
    """Compare gradient descent with and without momentum"""

    # Ill-conditioned quadratic: f(x,y) = 10x² + y²
    def ill_conditioned_f(x):
        return 10*x[0]**2 + x[1]**2

    def ill_conditioned_grad(x):
        return np.array([20*x[0], 2*x[1]])

    x0 = np.array([2.0, 2.0])

    # Standard gradient descent
    opt_std, hist_std = gradient_descent_basic(
        ill_conditioned_f, ill_conditioned_grad, x0,
        learning_rate=0.05, max_iterations=100
    )

    # Gradient descent with momentum
    opt_mom, hist_mom = gradient_descent_momentum(
        ill_conditioned_f, ill_conditioned_grad, x0,
        learning_rate=0.05, momentum=0.9, max_iterations=100
    )

    # Visualize comparison
    plt.figure(figsize=(15, 5))

    # Create contour plot
    x = np.linspace(-3, 3, 100)
    y = np.linspace(-3, 3, 100)
    X, Y = np.meshgrid(x, y)
    Z = 10*X**2 + Y**2

    # Standard GD
    plt.subplot(1, 3, 1)
    plt.contour(X, Y, Z, levels=20)
    plt.plot(hist_std[:, 0], hist_std[:, 1], 'ro-', markersize=3, label='Standard GD')
    plt.plot(0, 0, 'g*', markersize=15, label='Optimum')
    plt.title('Standard Gradient Descent')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Momentum GD
    plt.subplot(1, 3, 2)
    plt.contour(X, Y, Z, levels=20)
    plt.plot(hist_mom[:, 0], hist_mom[:, 1], 'bo-', markersize=3, label='Momentum GD')
    plt.plot(0, 0, 'g*', markersize=15, label='Optimum')
    plt.title('Gradient Descent with Momentum')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Convergence comparison
    plt.subplot(1, 3, 3)
    std_errors = [np.linalg.norm(h) for h in hist_std]
    mom_errors = [np.linalg.norm(h) for h in hist_mom]

    plt.semilogy(std_errors, 'r-', label='Standard GD', linewidth=2)
    plt.semilogy(mom_errors, 'b-', label='Momentum GD', linewidth=2)
    plt.xlabel('Iteration')
    plt.ylabel('Distance to Optimum (log scale)')
    plt.title('Convergence Comparison')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

    print(f"Standard GD: {len(hist_std)} iterations, final error: {np.linalg.norm(opt_std):.6f}")
    print(f"Momentum GD: {len(hist_mom)} iterations, final error: {np.linalg.norm(opt_mom):.6f}")

compare_momentum()
```

### Adaptive Learning Rates

#### AdaGrad

AdaGrad adapts the learning rate based on historical gradients:

```python
def adagrad(f, grad_f, x0, learning_rate=0.1, epsilon=1e-8, max_iterations=1000, tolerance=1e-6):
    """AdaGrad optimizer"""
    x = x0.copy()
    G = np.zeros_like(x)  # Accumulated squared gradients
    history = [x.copy()]

    for i in range(max_iterations):
        gradient = grad_f(x)
        G += gradient**2

        # Adaptive learning rate
        adapted_lr = learning_rate / (np.sqrt(G) + epsilon)
        x_new = x - adapted_lr * gradient

        if np.linalg.norm(x_new - x) < tolerance:
            print(f"AdaGrad converged after {i+1} iterations")
            break

        x = x_new
        history.append(x.copy())

    return x, np.array(history)
```

#### Adam (Adaptive Moment Estimation)

Adam combines momentum with adaptive learning rates:

```python
def adam(f, grad_f, x0, learning_rate=0.001, beta1=0.9, beta2=0.999,
         epsilon=1e-8, max_iterations=1000, tolerance=1e-6):
    """Adam optimizer"""
    x = x0.copy()
    m = np.zeros_like(x)  # First moment estimate
    v = np.zeros_like(x)  # Second moment estimate
    history = [x.copy()]

    for i in range(max_iterations):
        gradient = grad_f(x)

        # Update biased first moment estimate
        m = beta1 * m + (1 - beta1) * gradient

        # Update biased second raw moment estimate
        v = beta2 * v + (1 - beta2) * gradient**2

        # Compute bias-corrected first moment estimate
        m_hat = m / (1 - beta1**(i + 1))

        # Compute bias-corrected second raw moment estimate
        v_hat = v / (1 - beta2**(i + 1))

        # Update parameters
        x_new = x - learning_rate * m_hat / (np.sqrt(v_hat) + epsilon)

        if np.linalg.norm(x_new - x) < tolerance:
            print(f"Adam converged after {i+1} iterations")
            break

        x = x_new
        history.append(x.copy())

    return x, np.array(history)

def compare_optimizers():
    """Compare different optimization algorithms"""

    # Rosenbrock function: f(x,y) = (a-x)² + b(y-x²)²
    def rosenbrock(x, a=1, b=100):
        return (a - x[0])**2 + b * (x[1] - x[0]**2)**2

    def rosenbrock_grad(x, a=1, b=100):
        dx = -2*(a - x[0]) - 4*b*x[0]*(x[1] - x[0]**2)
        dy = 2*b*(x[1] - x[0]**2)
        return np.array([dx, dy])

    x0 = np.array([-1.0, 1.0])

    # Run different optimizers
    optimizers = {
        'GD': lambda: gradient_descent_basic(rosenbrock, rosenbrock_grad, x0, 0.001, 2000),
        'Momentum': lambda: gradient_descent_momentum(rosenbrock, rosenbrock_grad, x0, 0.001, 0.9, 2000),
        'AdaGrad': lambda: adagrad(rosenbrock, rosenbrock_grad, x0, 0.1, max_iterations=2000),
        'Adam': lambda: adam(rosenbrock, rosenbrock_grad, x0, 0.01, max_iterations=2000)
    }

    results = {}
    for name, optimizer in optimizers.items():
        opt_x, history = optimizer()
        results[name] = {
            'optimum': opt_x,
            'history': history,
            'final_value': rosenbrock(opt_x)
        }

    # Visualize results
    plt.figure(figsize=(15, 10))

    # Create Rosenbrock function contour
    x = np.linspace(-2, 2, 100)
    y = np.linspace(-1, 3, 100)
    X, Y = np.meshgrid(x, y)
    Z = (1 - X)**2 + 100 * (Y - X**2)**2

    colors = ['red', 'blue', 'green', 'orange']

    for i, (name, result) in enumerate(results.items()):
        plt.subplot(2, 2, i+1)
        plt.contour(X, Y, Z, levels=np.logspace(-1, 3, 20))

        history = result['history']
        plt.plot(history[:, 0], history[:, 1], 'o-', color=colors[i],
                markersize=2, linewidth=1, alpha=0.7, label=name)
        plt.plot(1, 1, 'r*', markersize=15, label='Global minimum')

        plt.xlabel('x')
        plt.ylabel('y')
        plt.title(f'{name} Optimizer')
        plt.legend()
        plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

    # Print results summary
    print("Optimizer Comparison Results:")
    print("=" * 50)
    print(f"{'Optimizer':>10} {'Iterations':>12} {'Final Value':>15} {'Distance to Opt':>15}")
    print("-" * 50)

    for name, result in results.items():
        iterations = len(result['history'])
        final_value = result['final_value']
        distance = np.linalg.norm(result['optimum'] - np.array([1, 1]))
        print(f"{name:>10} {iterations:>12} {final_value:>15.6f} {distance:>15.6f}")

compare_optimizers()
```

## Stochastic Gradient Descent

### Mini-batch SGD

For large datasets, we use mini-batch stochastic gradient descent:

```python
def stochastic_gradient_descent(X, y, loss_fn, grad_fn, theta0,
                               learning_rate=0.01, batch_size=32,
                               epochs=100, shuffle=True):
    """Mini-batch stochastic gradient descent"""
    theta = theta0.copy()
    n_samples = X.shape[0]
    history = {'loss': [], 'theta': []}

    for epoch in range(epochs):
        # Shuffle data
        if shuffle:
            indices = np.random.permutation(n_samples)
            X_shuffled = X[indices]
            y_shuffled = y[indices]
        else:
            X_shuffled, y_shuffled = X, y

        epoch_loss = 0
        n_batches = 0

        # Process mini-batches
        for i in range(0, n_samples, batch_size):
            batch_X = X_shuffled[i:i+batch_size]
            batch_y = y_shuffled[i:i+batch_size]

            # Compute gradient on mini-batch
            gradient = grad_fn(theta, batch_X, batch_y)

            # Update parameters
            theta = theta - learning_rate * gradient

            # Track loss
            batch_loss = loss_fn(theta, batch_X, batch_y)
            epoch_loss += batch_loss
            n_batches += 1

        # Record history
        avg_loss = epoch_loss / n_batches
        history['loss'].append(avg_loss)
        history['theta'].append(theta.copy())

        if epoch % 10 == 0:
            print(f"Epoch {epoch}: Loss = {avg_loss:.6f}")

    return theta, history

# Example: Linear regression with SGD
def linear_regression_sgd_example():
    """Linear regression using SGD"""

    # Generate synthetic data
    np.random.seed(42)
    n_samples, n_features = 1000, 5
    X = np.random.randn(n_samples, n_features)
    true_theta = np.random.randn(n_features)
    y = X @ true_theta + 0.1 * np.random.randn(n_samples)

    # Add bias term
    X = np.column_stack([np.ones(n_samples), X])
    true_theta = np.concatenate([[0], true_theta])

    # Define loss and gradient functions
    def mse_loss(theta, X, y):
        predictions = X @ theta
        return np.mean((predictions - y)**2)

    def mse_gradient(theta, X, y):
        predictions = X @ theta
        return 2 * X.T @ (predictions - y) / len(y)

    # Initialize parameters
    theta0 = np.random.randn(X.shape[1]) * 0.1

    # Run SGD
    theta_sgd, history = stochastic_gradient_descent(
        X, y, mse_loss, mse_gradient, theta0,
        learning_rate=0.01, batch_size=32, epochs=100
    )

    # Compare with analytical solution
    theta_analytical = np.linalg.solve(X.T @ X, X.T @ y)

    print(f"\nResults Comparison:")
    print(f"True parameters: {true_theta}")
    print(f"SGD parameters: {theta_sgd}")
    print(f"Analytical solution: {theta_analytical}")
    print(f"SGD error: {np.linalg.norm(theta_sgd - true_theta):.6f}")
    print(f"Analytical error: {np.linalg.norm(theta_analytical - true_theta):.6f}")

    # Plot convergence
    plt.figure(figsize=(12, 5))

    plt.subplot(1, 2, 1)
    plt.plot(history['loss'])
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title('SGD Convergence')
    plt.grid(True, alpha=0.3)

    plt.subplot(1, 2, 2)
    theta_history = np.array(history['theta'])
    for i in range(len(true_theta)):
        plt.plot(theta_history[:, i], label=f'θ_{i}')
        plt.axhline(true_theta[i], color=f'C{i}', linestyle='--', alpha=0.7)

    plt.xlabel('Epoch')
    plt.ylabel('Parameter Value')
    plt.title('Parameter Evolution')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

linear_regression_sgd_example()
```

## Second-Order Methods

### Newton's Method

Newton's method uses second-order information (Hessian matrix):

**x_{k+1} = x_k - H^{-1}(x_k) ∇f(x_k)**

```python
def newtons_method(f, grad_f, hessian_f, x0, max_iterations=100, tolerance=1e-6):
    """Newton's method for optimization"""
    x = x0.copy()
    history = [x.copy()]

    for i in range(max_iterations):
        gradient = grad_f(x)
        hessian = hessian_f(x)

        # Check if Hessian is positive definite
        eigenvals = np.linalg.eigvals(hessian)
        if np.any(eigenvals <= 0):
            print(f"Warning: Hessian not positive definite at iteration {i}")

        # Newton step
        try:
            newton_step = np.linalg.solve(hessian, gradient)
            x_new = x - newton_step
        except np.linalg.LinAlgError:
            print(f"Singular Hessian at iteration {i}")
            break

        if np.linalg.norm(x_new - x) < tolerance:
            print(f"Newton's method converged after {i+1} iterations")
            break

        x = x_new
        history.append(x.copy())

    return x, np.array(history)

# Example: Compare Newton's method with gradient descent
def compare_newton_gd():
    """Compare Newton's method with gradient descent"""

    # Quadratic function with Hessian
    def quad_hessian(x):
        return np.array([[2, 0], [0, 4]])

    x0 = np.array([3.0, 2.0])

    # Newton's method
    opt_newton, hist_newton = newtons_method(
        quadratic_function, quadratic_gradient, quad_hessian, x0
    )

    # Gradient descent
    opt_gd, hist_gd = gradient_descent_basic(
        quadratic_function, quadratic_gradient, x0, learning_rate=0.1
    )

    # Visualize comparison
    plt.figure(figsize=(15, 5))

    # Create contour plot
    x = np.linspace(-4, 4, 100)
    y = np.linspace(-3, 3, 100)
    X, Y = np.meshgrid(x, y)
    Z = X**2 + 2*Y**2

    # Newton's method
    plt.subplot(1, 3, 1)
    plt.contour(X, Y, Z, levels=20)
    plt.plot(hist_newton[:, 0], hist_newton[:, 1], 'ro-', markersize=6, linewidth=2, label="Newton's Method")
    plt.plot(0, 0, 'g*', markersize=15, label='Optimum')
    plt.title("Newton's Method")
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Gradient descent
    plt.subplot(1, 3, 2)
    plt.contour(X, Y, Z, levels=20)
    plt.plot(hist_gd[:, 0], hist_gd[:, 1], 'bo-', markersize=3, linewidth=1, label='Gradient Descent')
    plt.plot(0, 0, 'g*', markersize=15, label='Optimum')
    plt.title('Gradient Descent')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Convergence comparison
    plt.subplot(1, 3, 3)
    newton_errors = [np.linalg.norm(h) for h in hist_newton]
    gd_errors = [np.linalg.norm(h) for h in hist_gd]

    plt.semilogy(newton_errors, 'ro-', label="Newton's Method", linewidth=2)
    plt.semilogy(gd_errors, 'bo-', label='Gradient Descent', linewidth=2)
    plt.xlabel('Iteration')
    plt.ylabel('Distance to Optimum (log scale)')
    plt.title('Convergence Comparison')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

    print(f"Newton's method: {len(hist_newton)} iterations")
    print(f"Gradient descent: {len(hist_gd)} iterations")
    print(f"Newton's method final error: {np.linalg.norm(opt_newton):.10f}")
    print(f"Gradient descent final error: {np.linalg.norm(opt_gd):.10f}")

compare_newton_gd()
```

### Quasi-Newton Methods (BFGS)

BFGS approximates the Hessian using gradient information:

```python
def bfgs(f, grad_f, x0, max_iterations=100, tolerance=1e-6):
    """BFGS quasi-Newton method"""
    x = x0.copy()
    n = len(x)
    B = np.eye(n)  # Initial Hessian approximation
    history = [x.copy()]

    gradient = grad_f(x)

    for i in range(max_iterations):
        # Solve B * p = -gradient for search direction p
        p = -np.linalg.solve(B, gradient)

        # Line search (simplified - use fixed step size)
        alpha = 1.0
        x_new = x + alpha * p
        gradient_new = grad_f(x_new)

        # Check convergence
        if np.linalg.norm(gradient_new) < tolerance:
            print(f"BFGS converged after {i+1} iterations")
            break

        # BFGS update
        s = x_new - x
        y = gradient_new - gradient

        # Avoid division by zero
        if np.dot(s, y) > 1e-10:
            rho = 1.0 / np.dot(s, y)
            I = np.eye(n)
            B = (I - rho * np.outer(s, y)) @ B @ (I - rho * np.outer(y, s)) + rho * np.outer(s, s)

        x = x_new
        gradient = gradient_new
        history.append(x.copy())

    return x, np.array(history)

# Compare BFGS with other methods
def compare_all_methods():
    """Compare all optimization methods"""

    x0 = np.array([3.0, 2.0])

    methods = {
        'Gradient Descent': lambda: gradient_descent_basic(quadratic_function, quadratic_gradient, x0, 0.1),
        'Newton': lambda: newtons_method(quadratic_function, quadratic_gradient,
                                       lambda x: np.array([[2, 0], [0, 4]]), x0),
        'BFGS': lambda: bfgs(quadratic_function, quadratic_gradient, x0),
        'Adam': lambda: adam(quadratic_function, quadratic_gradient, x0, 0.1)
    }

    plt.figure(figsize=(12, 8))
    colors = ['red', 'blue', 'green', 'orange']

    # Create contour plot
    x = np.linspace(-4, 4, 100)
    y = np.linspace(-3, 3, 100)
    X, Y = np.meshgrid(x, y)
    Z = X**2 + 2*Y**2
    plt.contour(X, Y, Z, levels=15, alpha=0.6)

    for i, (name, method) in enumerate(methods.items()):
        opt_x, history = method()
        plt.plot(history[:, 0], history[:, 1], 'o-', color=colors[i],
                markersize=4, linewidth=2, label=f'{name} ({len(history)} iter)')

    plt.plot(0, 0, 'k*', markersize=15, label='Optimum')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('Optimization Methods Comparison')
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.show()

compare_all_methods()
```

## Applications in Machine Learning

### Logistic Regression

```python
def logistic_regression_optimization():
    """Optimize logistic regression using different methods"""

    # Generate binary classification data
    np.random.seed(42)
    n_samples, n_features = 1000, 2
    X = np.random.randn(n_samples, n_features)
    true_w = np.array([1.5, -2.0])
    true_b = 0.5

    # Generate labels
    logits = X @ true_w + true_b
    probabilities = 1 / (1 + np.exp(-logits))
    y = np.random.binomial(1, probabilities)

    # Add bias term
    X_with_bias = np.column_stack([np.ones(n_samples), X])
    true_params = np.array([true_b, true_w[0], true_w[1]])

    # Logistic regression loss and gradient
    def logistic_loss(params, X, y):
        logits = X @ params
        return np.mean(np.log(1 + np.exp(logits)) - y * logits)

    def logistic_gradient(params, X, y):
        logits = X @ params
        probabilities = 1 / (1 + np.exp(-logits))
        return X.T @ (probabilities - y) / len(y)

    # Initialize parameters
    params0 = np.random.randn(X_with_bias.shape[1]) * 0.1

    # Optimize using different methods
    methods = {
        'SGD': lambda: stochastic_gradient_descent(
            X_with_bias, y, logistic_loss, logistic_gradient, params0,
            learning_rate=0.1, batch_size=64, epochs=100
        ),
        'Adam': lambda: adam(
            lambda p: logistic_loss(p, X_with_bias, y),
            lambda p: logistic_gradient(p, X_with_bias, y),
            params0, learning_rate=0.01, max_iterations=1000
        )
    }

    results = {}
    for name, method in methods.items():
        if name == 'SGD':
            params_opt, history = method()
            loss_history = history['loss']
        else:
            params_opt, param_history = method()
            loss_history = [logistic_loss(p, X_with_bias, y) for p in param_history]

        results[name] = {
            'params': params_opt,
            'loss_history': loss_history,
            'final_loss': logistic_loss(params_opt, X_with_bias, y)
        }

    # Visualize results
    plt.figure(figsize=(15, 5))

    # Decision boundary visualization
    plt.subplot(1, 3, 1)

    # Plot data points
    plt.scatter(X[y==0, 0], X[y==0, 1], c='red', marker='o', alpha=0.6, label='Class 0')
    plt.scatter(X[y==1, 0], X[y==1, 1], c='blue', marker='s', alpha=0.6, label='Class 1')

    # Plot true decision boundary
    x_boundary = np.linspace(-3, 3, 100)
    y_boundary = -(true_params[0] + true_params[1] * x_boundary) / true_params[2]
    plt.plot(x_boundary, y_boundary, 'g--', linewidth=2, label='True boundary')

    # Plot learned decision boundary (using Adam result)
    adam_params = results['Adam']['params']
    y_learned = -(adam_params[0] + adam_params[1] * x_boundary) / adam_params[2]
    plt.plot(x_boundary, y_learned, 'k-', linewidth=2, label='Learned boundary')

    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.title('Logistic Regression Decision Boundary')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Loss convergence
    plt.subplot(1, 3, 2)
    for name, result in results.items():
        plt.plot(result['loss_history'], label=f'{name}', linewidth=2)

    plt.xlabel('Iteration/Epoch')
    plt.ylabel('Logistic Loss')
    plt.title('Loss Convergence')
    plt.legend()
    plt.grid(True, alpha=0.3)

    # Parameter convergence
    plt.subplot(1, 3, 3)
    print("Parameter Comparison:")
    print(f"True parameters: {true_params}")
    for name, result in results.items():
        params = result['params']
        error = np.linalg.norm(params - true_params)
        print(f"{name} parameters: {params}")
        print(f"{name} error: {error:.6f}")

        plt.bar(range(len(params)), params, alpha=0.7, label=f'{name}')

    plt.bar(range(len(true_params)), true_params, alpha=0.7,
            color='black', label='True', width=0.3)
    plt.xlabel('Parameter Index')
    plt.ylabel('Parameter Value')
    plt.title('Parameter Comparison')
    plt.legend()
    plt.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.show()

logistic_regression_optimization()
```

## Summary

Gradient-based optimization methods are essential for:

1. **Machine Learning**: Training neural networks and other models
2. **Parameter Estimation**: Finding optimal model parameters
3. **Function Minimization**: Solving continuous optimization problems
4. **Large-Scale Optimization**: Handling high-dimensional problems

Key insights:
- **Learning rate** is crucial for convergence
- **Momentum** helps accelerate convergence and reduce oscillations
- **Adaptive methods** (Adam, AdaGrad) automatically adjust learning rates
- **Second-order methods** converge faster but require more computation
- **Stochastic methods** are essential for large datasets

The choice of optimization method depends on:
- Problem size and computational budget
- Gradient availability and computational cost
- Convergence requirements
- Noise in the objective function

Understanding these methods enables you to select appropriate optimizers for different machine learning and optimization tasks.