# SIMD: process 8 floats simultaneously
from math import sqrt

def simd_dot(a: Pointer[Float32],
             b: Pointer[Float32],
             n: Int) -> Float32:
    var sum = SIMD[DType.float32, 8](0)  # 8-wide SIMD register
    var i = 0

    # Process 8 elements per iteration
    while i + 8 <= n:
        var va = a.simd_load[8](i)
        var vb = b.simd_load[8](i)
        sum += va * vb  # 8 multiply-adds in one instruction
        i += 8

    # Horizontal sum
    var result = sum.reduce_add()

    # Handle remaining elements
    while i < n:
        result += a[i] * b[i]
        i += 1

    return result

# Vectorized ReLU — 16 floats at a time
def simd_relu(data: Pointer[Float32], n: Int):
    var zero = SIMD[DType.float32, 16](0)
    var i = 0
    while i + 16 <= n:
        var vals = data.simd_load[16](i)
        data.simd_store[16](i, vals.max(zero))
        i += 16
    while i < n:
        data[i] = max(data[i], 0)
        i += 1
