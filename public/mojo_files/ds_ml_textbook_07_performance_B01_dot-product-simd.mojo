from math import sqrt

def dot_product_simd(
    a: Tensor[Float32], b: Tensor[Float32]
) -> Float32:
    var n = a.num_elements()
    var total: Float32 = 0.0
    var i = 0
    # Process 8 elements at a time with SIMD
    comptime S = simdwidthof[Float32]()  # typically 8
    var simd_acc = SIMD[Float32, S](0.0)
    while i + S <= n:
        simd_acc += a.load[0](i) * b.load[0](i)
        i += S
    # Horizontal reduction
    for k in range(S):
        total += simd_acc[k]
    # Handle remainder
    while i < n:
        total += a[i] * b[i]
        i += 1
    return total
