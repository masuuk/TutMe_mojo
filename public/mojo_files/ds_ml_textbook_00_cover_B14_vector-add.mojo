// Mojo — explicit SIMD with vector types
from simd import vector

def vector_add(a: Tensor[Float32], b: Tensor[Float32]) -> Tensor[Float32]:
    var n = a.size()
    var result = Tensor[Float32](zeros([n]))

    // Vectorized loop with 8-wide SIMD
    for i in range(0, n, 8):
        var va = load[vector[Float32, 8]](a, i)
        var vb = load[vector[Float32, 8]](b, i)
        var vc = va + vb
        store(result, i, vc)

    return result
