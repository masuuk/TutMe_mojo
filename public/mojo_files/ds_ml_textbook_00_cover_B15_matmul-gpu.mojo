// Mojo — GPU kernel for matrix multiplication
from gpu import cuda

@cuda
def matmul_gpu(A: Tensor[Float32], B: Tensor[Float32],
    C: Tensor[Float32]):
    var i = blockIdx.x * blockDim.x + threadIdx.x
    var j = blockIdx.y * blockDim.y + threadIdx.y
    var k = blockIdx.z * blockDim.z + threadIdx.z

    var sum: Float32 = 0.0
    for t in range(A.shape(1)):
        sum += A[i, t] * B[t, j]

    C[i, j] = sum
