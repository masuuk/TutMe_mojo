# Mojo — SIMD is a built-in type
from math import sqrt

# SIMD[T, width] — vector of `width` elements of type T
var a = SIMD[Float32, 8](1.0, 2.0, 3.0, 4.0,
                       5.0, 6.0, 7.0, 8.0)
var b = SIMD[Float32, 8](8.0, 7.0, 6.0, 5.0,
                       4.0, 3.0, 2.0, 1.0)

# Element-wise operations — single CPU instruction
var c = a + b     # [9, 9, 9, 9, 9, 9, 9, 9]
var d = a * b     # [8, 14, 18, 20, 20, 18, 14, 8]
var e = a / b     # element-wise division

# Reductions — sum all elements
var total = a.reduce_add()  # 36.0
var product = a.reduce_mul()

# Fused multiply-add: a * b + c in one instruction
var fma = a.fma(b, c)  # (a * b) + c, single instruction

# The width is a comptime parameter
comptime width = 8
comptime dt = DType.float32
comptime vec_t = SIMD[dt, width]

def dot_product(a: vec_t, b: vec_t) -> Float32:
    return (a * b).reduce_add()

var v1 = vec_t(1, 2, 3, 4, 5, 6, 7, 8)
var v2 = vec_t(8, 7, 6, 5, 4, 3, 2, 1)
print(dot_product(v1, v2))  # 120
