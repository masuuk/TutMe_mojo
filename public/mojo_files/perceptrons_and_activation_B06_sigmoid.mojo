from math import exp, min, max
from collections import List

# --- 1. Sigmoid ---
def sigmoid(z: Float64) -> Float64:
    """Sigmoid activation function."""
    var clamped = min(max(z, -500.0), 500.0)  # Prevent overflow
    return 1.0 / (1.0 + exp(-clamped))

def sigmoid_derivative(z: Float64) -> Float64:
    """Derivative of sigmoid: s * (1 - s)."""
    var s = sigmoid(z)
    return s * (1.0 - s)

# --- 2. Tanh ---
def tanh_act(z: Float64) -> Float64:
    """Hyperbolic tangent activation."""
    return (exp(z) - exp(-z)) / (exp(z) + exp(-z))

def tanh_derivative(z: Float64) -> Float64:
    """Derivative of tanh: 1 - tanh^2(z)."""
    var t = tanh_act(z)
    return 1.0 - t * t

# --- 3. ReLU ---
def relu(z: Float64) -> Float64:
    """Rectified Linear Unit."""
    return max(0.0, z)

def relu_derivative(z: Float64) -> Float64:
    """Derivative of ReLU."""
    if z > 0.0:
        return 1.0
    return 0.0

# --- 4. Leaky ReLU ---
def leaky_relu(z: Float64, alpha: Float64 = 0.01) -> Float64:
    """Leaky ReLU activation."""
    if z > 0.0:
        return z
    return alpha * z

def leaky_relu_derivative(z: Float64, alpha: Float64 = 0.01) -> Float64:
    """Derivative of Leaky ReLU."""
    if z > 0.0:
        return 1.0
    return alpha

# --- 5. Softmax ---
def softmax(z: List[Float64]) -> List[Float64]:
    """Softmax function - converts logits to probabilities."""
    var result = List[Float64]()

    # Find max for numerical stability
    var max_val = z[0]
    for val in z:
        if val > max_val:
            max_val = val

    # Compute exp(z - max) and sum
    var exp_sum = 0.0
    for val in z:
        var exp_val = exp(val - max_val)
        result.append(exp_val)
        exp_sum += exp_val

    # Normalize
    for i in range(result.size):
        result[i] = result[i] / exp_sum

    return result

# --- Testing the Functions ---
def main():
    var test_input = List[Float64]()
    test_input.append(-2.0)
    test_input.append(-1.0)
    test_input.append(0.0)
    test_input.append(1.0)
    test_input.append(2.0)

    print("Input:       ", test_input)

    # Test each function
    var sig_results = List[Float64]()
    var tanh_results = List[Float64]()
    var relu_results = List[Float64]()
    var leaky_results = List[Float64]()

    for val in test_input:
        sig_results.append(sigmoid(val))
        tanh_results.append(tanh_act(val))
        relu_results.append(relu(val))
        leaky_results.append(leaky_relu(val))

    print("Sigmoid:     ", sig_results)
    print("Tanh:        ", tanh_results)
    print("ReLU:        ", relu_results)
    print("Leaky ReLU:  ", leaky_results)
    print("Softmax:     ", softmax(test_input))
