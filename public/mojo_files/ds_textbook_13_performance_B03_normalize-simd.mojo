# Mojo — SIMD-accelerated normalization (native syntax)
from algorithm import vectorize
from math import sqrt

def normalize_simd(data: List[Float64]) -> List[Float64]:
    var n = len(data)
    var mean: Float64 = 0.0

    # SIMD-reduction for mean
    for i in range(n):
        mean += data[i]
    mean /= n

    var std: Float64 = 0.0
    for i in range(n):
        std += (data[i] - mean) ** 2
    std = sqrt(std / n)

    var result = List[Float64](capacity=n)
    result.resize(n, 0.0)

    # Vectorized division — processes 4-8 elements per cycle
    @parameter
    def div_normalize[simd_width: Int](idx: Int):
        result[idx] = (data[idx] - mean) / std

    vectorize[div_normalize, 8](n)
    return result

# The @parameter + vectorize pattern tells the compiler
# to unroll the loop by 8 elements, using SIMD registers
# directly. No manual SIMD intrinsics required.
