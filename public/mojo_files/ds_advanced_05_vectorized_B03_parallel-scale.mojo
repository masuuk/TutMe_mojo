# Parallel element-wise operations
def parallel_scale(
    src: Pointer[Float32],
    dst: Pointer[Float32],
    n: Int,
    scale: Float32
):
    # Distribute across all CPU cores
    for i in parallelize(n):
        dst[i] = src[i] * scale

# Parallel matrix multiplication (simple version)
def parallel_matmul(
    A: Tensor[Float32],
    B: Tensor[Float32],
    C: Tensor[Float32],
    M: Int, N: Int, K: Int
):
    # Parallelize over rows of output
    for i in parallelize(M):
        for j in range(N):
            var acc = SIMD[DType.float32, 8](0)
            var k = 0
            while k + 8 <= K:
                var a = A[i, k:k+8]
                var b = B[k:k+8, j]
                acc += a * b.simd_broadcast[8]()
                k += 8
            C[i, j] = acc.reduce_add()

# Parallel reduction — sum an array
def parallel_sum(data: Tensor[Float32]) -> Float32:
    var n = data.size()
    var num_tasks = 8
    var partial = Tensor[Float32](num_tasks)

    # Each thread sums its chunk
    for t in parallelize(num_tasks):
        var start = t * (n // num_tasks)
        var end = (t + 1) * (n // num_tasks)
        var local_sum = 0
        for i in range(start, end):
            local_sum += data[i]
        partial[t] = local_sum

    # Final reduction (single-threaded)
    var total: Float32 = 0
    for t in range(num_tasks):
        total += partial[t]
    return total
