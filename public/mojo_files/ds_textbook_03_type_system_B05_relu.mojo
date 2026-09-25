# Write ONCE, works with any numeric type
def relu[dtype: DType](x: SIMD[dtype, 1]) -> SIMD[dtype, 1]:
    return max(x, 0)

# Instantiate for different precisions
var r1 = relu[DType.float32](-1.5)
var r2 = relu[DType.float64](-1.5)
var r3 = relu[DType.bfloat16](-1.5)

# SIMD-aware version — processes 8 values at once
def relu_vec[dtype: DType, width: Int](x: SIMD[dtype, width]) -> SIMD[dtype, width]:
    return max(x, 0)

var batch = SIMD[DType.float32, 8](
    -1.0, 2.0, -3.0, 4.0, -5.0, 6.0, -7.0, 8.0
)
print(relu_vec[DType.float32, 8](batch))
# [0, 2, 0, 4, 0, 6, 0, 8]
