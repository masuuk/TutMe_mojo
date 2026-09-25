# Mojo — matrix multiplication
var A = Tensor[DType.float32](
    [1.0, 2.0, 3.0, 4.0]
).reshape(2, 2)
var B = Tensor[DType.float32](
    [5.0, 6.0, 7.0, 8.0]
).reshape(2, 2)

# Using the matmul function
var C = matmul(A, B)
# [[19, 22],   1*5 + 3*7 = 19, 1*6 + 3*8 = 22
#  [43, 50]]   2*5 + 4*7 = 43, 2*6 + 4*8 = 50

# SIMD dot product for custom kernels
def simd_dot(
    a: Tensor[DType.float32],
    b: Tensor[DType.float32]
) -> Float32:
    comptime width = 8
    var accum = SIMD[DType.float32, width](0)
    for i in range(0, len(a), width):
        accum += a.simd_load[width](i) * b.simd_load[width](i)
    return accum.reduce_add()
