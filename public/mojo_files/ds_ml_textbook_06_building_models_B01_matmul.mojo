from tensor import Tensor
from math import sqrt

def matmul(
    A: Tensor[Float32], B: Tensor[Float32]
) -> Tensor[Float32]:
    var rows = A.shape()[0]
    var cols = B.shape()[1]
    var K = A.shape()[1]
    var C = Tensor[Float32](rows, cols)
    for i in range(rows):
        for j in range(cols):
            var acc: Float32 = 0.0
            for k in range(K):
                acc += A[i, k] * B[k, j]
            C[i, j] = acc
    return C

def relu(mut T: Tensor[Float32]):
    for i in range(T.num_elements()):
        if T[i] < 0.0:
            T[i] = 0.0
