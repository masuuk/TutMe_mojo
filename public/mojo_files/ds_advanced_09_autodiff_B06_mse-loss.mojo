from std.math import log, exp, abs

def mse_loss(pred: List[Float64], target: List[Float64]) -> Float64:
    var total = 0.0
    for i in range(len(pred)):
        var diff = pred[i] - target[i]
        total += diff * diff
    return total / Float64(len(pred))


def binary_cross_entropy(pred: List[Float64], target: List[Float64]) -> Float64:
    var total = 0.0
    var eps = 1e-7
    for i in range(len(pred)):
        var p = max(eps, min(1.0 - eps, pred[i]))
        total -= target[i] * log(p) + (1.0 - target[i]) * log(1.0 - p)
    return total / Float64(len(pred))


def huber_loss(pred: List[Float64], target: List[Float64], delta: Float64 = 1.0) -> Float64:
    var total = 0.0
    for i in range(len(pred)):
        var a = abs(pred[i] - target[i])
        if a <= delta:
            total += 0.5 * a * a
        else:
            total += delta * (a - 0.5 * delta)
    return total / Float64(len(pred))
