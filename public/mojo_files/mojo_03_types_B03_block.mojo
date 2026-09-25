# A vector of four Float32 values
var vec = SIMD[DType.float32, 4](3.0, 2.0, 2.0, 1.0)

# Math is applied elementwise
var vec1 = SIMD[DType.int8, 4](2, 3, 5, 7)
var vec2 = SIMD[DType.int8, 4](1, 2, 3, 4)
print(vec1 * vec2)   # [2, 6, 15, 28]
