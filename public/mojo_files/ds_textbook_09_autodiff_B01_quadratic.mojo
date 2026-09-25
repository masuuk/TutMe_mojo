# Mojo — built-in autodiff
from math import exp, log

@differentiable
def quadratic(x: Float64) -> Float64:
    return x * x + 2.0 * x + 1.0

# Compute the derivative at x = 3.0
var df = grad(quadratic)
var slope = df(3.0)   # 2*3 + 2 = 8.0
print(slope)            # 8.0

# Multi-variable differentiation
@differentiable
def loss_fn(w: Float64, b: Float64) -> Float64:
    var pred = w * 3.0 + b
    return (pred - 5.0) ** 2

var grad_fn = grad(loss_fn)
var (dw, db) = grad_fn(1.0, 0.0)
print(f"dW = {dw}, db = {db}")
# dW = -12.0, db = -4.0

# Composing differentiable functions
@differentiable
def sigmoid(x: Float64) -> Float64:
    return 1.0 / (1.0 + exp(-x))

@differentiable
def bce(pred: Float64, target: Float64) -> Float64:
    var p = sigmoid(pred)
    return -(target * log(p) + (1.0 - target) * log(1.0 - p))

var grad_bce = grad(bce)
var gradient = grad_bce(0.5, 1.0)
