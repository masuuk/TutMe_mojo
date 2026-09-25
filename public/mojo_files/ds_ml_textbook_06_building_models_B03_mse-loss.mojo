from tensor import Tensor
from math import exp, log

def mse_loss(
    predictions: Tensor[Float32],
    targets: Tensor[Float32],
) -> Float32:
    var n = Float32(predictions.num_elements())
    var total: Float32 = 0.0
    for i in range(predictions.num_elements()):
        var diff = predictions[i] - targets[i]
        total += diff * diff
    return total / n

def softmax(mut logits: Tensor[Float32]):
    var n = logits.num_elements()
    var max_val: Float32 = logits[0]
    for i in range(1, n):
        if logits[i] > max_val:
            max_val = logits[i]
    var exp_sum: Float32 = 0.0
    for i in range(n):
        logits[i] = exp(logits[i] - max_val)
        exp_sum += logits[i]
    for i in range(n):
        logits[i] /= exp_sum
