# Mojo uses Python interop for matplotlib
from python import Python
from collections import List

def plot_decision_boundary(
    X: List[List[Float64]],
    y: List[Int],
    weights: List[Float64],
    bias: Float64
) raises:
    """Plot the decision boundary using matplotlib via Python interop."""
    var plt = Python.import_module("matplotlib.pyplot")
    var np = Python.import_module("numpy")

    # Convert Mojo lists to numpy arrays
    var X_np = np.array(X)
    var y_np = np.array(y)

    # Plot data points
    plt.scatter(X_np[:, 0], X_np[:, 1], c=y_np, cmap="viridis", edgecolors="k", s=100)
    plt.xlabel("x1")
    plt.ylabel("x2")

    # Compute decision boundary: w1*x1 + w2*x2 + b = 0
    var w1 = weights[0]
    var w2 = weights[1]
    var x1_vals = np.linspace(-0.5, 1.5, 100)
    var x2_vals = -(w1 * x1_vals + bias) / w2

    plt.plot(x1_vals, x2_vals, "r--", label="Decision boundary")
    plt.xlim(-0.5, 1.5)
    plt.ylim(-0.5, 1.5)
    plt.legend()
    plt.title("Perceptron Decision Boundary (AND Gate)")
    plt.show()

# Usage in main:
# plot_decision_boundary(X, y, p.weights, p.bias)
