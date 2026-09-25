from std.math import sqrt

def mse_loss(pred: List[Float64], target: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for i in range(len(pred)):
        var diff = pred[i] - target[i]
        total += diff * diff
    return total / Float64(len(pred))

def mae_loss(pred: List[Float64], target: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for i in range(len(pred)):
        var diff = pred[i] - target[i]
        total += abs(diff)
    return total / Float64(len(pred))

def rmse_loss(pred: List[Float64], target: List[Float64]) -> Float64:
    return sqrt(mse_loss(pred, target))
