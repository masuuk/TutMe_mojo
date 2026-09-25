// Direct BLAS Level-3 call from Mojo
from math.linalg import matrix_multiply, Matrix
from sys.ffi import cblas_dgemm

var A = Matrix[Float64](64, 64)
var B = Matrix[Float64](64, 64)
var C = Matrix[Float64](64, 64)

// Fill A and B with values...
randomize(A)
randomize(B)

// C = alpha * A × B + beta * C
cblas_dgemm(
    CblasRowMajor, CblasNoTrans, CblasNoTrans,
    64, 64, 64,
    1.0, A.data(), 64,
    B.data(), 64,
    0.0, C.data(), 64
)
