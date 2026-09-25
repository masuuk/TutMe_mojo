from std.math import sqrt

def gradient_step(
    mut w: Float64,
    mut b: Float64,
    lr: Float64,
    grad_w: Float64,
    grad_b: Float64
):
    w -= lr * grad_w
    b -= lr * grad_b

def compute_gradient(
    x: List[Float64],
    y: List[Float64],
    w: Float64,
    b: Float64
) -> Tuple[Float64, Float64]:
    var n = Float64(len(x))
    var grad_w: Float64 = 0.0
    var grad_b: Float64 = 0.0
    for i in range(len(x)):
        var pred = w * x[i] + b
        var err = pred - y[i]
        grad_w += 2.0 * err * x[i]
        grad_b += 2.0 * err
    return (grad_w / n, grad_b / n)
