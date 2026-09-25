from math import sqrt

def dot(a: Pointer[Float64],
        b: Pointer[Float64],
        n: Int) -> Float64:
    comptime LANES = simdwidthof[DType.float64]()
    var acc = SIMD[DType.float64, LANES](0)
    @parameter
    for i in range(n // LANES):
        acc += a.simd_load[LANES](i * LANES) \
             * b.simd_load[LANES](i * LANES)
    var total = acc.reduce_add()
    # scalar tail
    for i in range(n // LANES * LANES, n):
        total += a[i] * b[i]
    return total

def norm(a: Pointer[Float64], n: Int) -> Float64:
    return sqrt(dot(a, a, n))
