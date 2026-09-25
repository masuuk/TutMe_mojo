from std.math import exp


def step(x: Float64) -> Float64:
    return 1.0 if x >= 0.0 else 0.0


def relu(x: Float64) -> Float64:
    return x if x > 0.0 else 0.0


def sigmoid(x: Float64) -> Float64:
    return 1.0 / (1.0 + exp(-x))


def sigmoid_derivative(a: Float64) -> Float64:
    return a * (1.0 - a)


def mse_loss(predicted: Float64, target: Float64) -> Float64:
    var diff = predicted - target
    return diff * diff
