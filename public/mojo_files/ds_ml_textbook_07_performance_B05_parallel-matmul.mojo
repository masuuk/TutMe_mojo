from algorithm import parallelize

def parallel_matmul(
    A: Tensor[Float32],
    B: Tensor[Float32],
    C: Tensor[Float32],
):
    var M = A.shape()[0]
    var N = B.shape()[1]
    var K = A.shape()[1]

    # Parallelize over rows
    def compute_row(row: Int):
        for j in range(N):
            var acc: Float32 = 0.0
            for k in range(K):
                acc += A[row, k] * B[k, j]
            C[row, j] = acc

    parallelize[compute_row](M, num_cores=logical_cores())
