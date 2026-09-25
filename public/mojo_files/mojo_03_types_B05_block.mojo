var simd1 = SIMD[DType.float32, 4](2.2, 3.3, 4.4, 5.5)
var simd2 = SIMD[DType.int16, 4](-1, 2, -3, 4)

# Convert with cast()
var simd3 = simd1 * simd2.cast[DType.float32]()
# Convert with the SIMD constructor
var simd4 = simd2 + SIMD[DType.int16, 4](simd1)

# Scalars: construct the target type
var my_int: Int16 = 12
var result = Float32(my_int) * 0.75   # 9.0
