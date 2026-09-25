// Compute Mean Squared Error with parallel vectorization
from tensor import Tensor, Float32
from algorithm import ParallelFor

def mse(a: Tensor[Float32], b: Tensor[Float32]) -> Float32:
    assert a.shape == b.shape
    var diff = a - b
    var squared = diff ** 2.0

    // Parallel reduction across SIMD lanes
    var total = Float32(0.0)
    ParallelFor(squared.size, lambda i:
        atomic_add(total, squared[i])
    )

    return total / Float32(a.size)
