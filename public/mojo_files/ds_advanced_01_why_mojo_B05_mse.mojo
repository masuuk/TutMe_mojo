# Compute Mean Squared Error
from tensor import Tensor, Float32

def mse(a: Tensor[Float32], b: Tensor[Float32]) -> Float32:
    assert a.shape == b.shape
    var diff = a - b
    var squared = diff ** 2.0
    return squared.sum() / Float32(a.size)
