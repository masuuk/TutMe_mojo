def matmul(A: Tensor[Float64], B: Tensor[Float64])
           -> Tensor[Float64]:
    var n = A.dim(0)
    var C = Tensor[Float64](n, n)
    # tile rows/cols; for full machine utilization, take the
    # tiles to a GPU via max.gpu DeviceContext.enqueue_function
    for ti in range(0, n, 64):
        for tj in range(0, n, 64):
            var tile = heap_allocation_blocked  # 64×64 block
            for i in range(ti, ti+64):
                for k in range(n):
                    var a = A[i, k]
                    for j in range(tj, tj+64):
                        tile[i, j] += a * B[k, j]
            # write tile back to C
    return C
