from sys.intrinsics import (
    simd_load, simd_store, simd_add, simd_mul
)

// SIMD vectorized element-wise add kernel
def simd_add_kernel(
    a: Pointer[Float32],
    b: Pointer[Float32],
    result: Pointer[Float32],
    n: Int
):
    var i = 0
    var simd_width = 8

    // Vectorized loop
    while i + simd_width <= n:
        var va = simd_load[DType.float32, 8](a + i)
        var vb = simd_load[DType.float32, 8](b + i)
        simd_store(result + i, simd_add(va, vb))
        i += simd_width

    // Scalar tail
    while i < n:
        result[i] = a[i] + b[i]
        i += 1


// ReLU kernel with SIMD
def simd_relu_kernel(
    input: Pointer[Float32],
    output: Pointer[Float32],
    n: Int
):
    var zero = SIMD[DType.float32, 8](0.0)
    var i = 0

    while i + 8 <= n:
        var v = simd_load[DType.float32, 8](input + i)
        simd_store(output + i, v.max(zero))
        i += 8

    while i < n:
        output[i] = max(input[i], 0.0)
        i += 1
