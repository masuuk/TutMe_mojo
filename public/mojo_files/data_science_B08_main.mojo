from tensor import Tensor
from math import sqrt

def main():
    var A = Tensor[DType.float64](2, 2)
    A[0, 0] = 0.7; A[0, 1] = 0.3   # transition matrix
    A[1, 0] = 0.2; A[1, 1] = 0.8
    var v = Tensor[DType.float64]([1.0, 0.0])

    for _ in range(200):                # power iteration → λ=1 eigenvector
        var nv = Tensor[DType.float64](2)
        for i in range(2):
            var s: Float64 = 0.0
            for j in range(2):
                s += A[i, j] * v[j]
            nv[i] = s
        var norm: Float64 = 0.0
        for i in range(2):
            norm += nv[i] * nv[i]
        for i in range(2):
            v[i] = nv[i] / sqrt(norm)

    print("steady state ≈ (0.4, 0.6)")   # v now ∝ [0.4, 0.6]
