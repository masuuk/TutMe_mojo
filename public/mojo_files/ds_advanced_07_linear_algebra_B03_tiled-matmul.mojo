def tiled_matmul[
    TILE: Int = 64
](A: Matrix[Float64], B: Matrix[Float64]) -> Matrix[Float64]:
    var n = A.rows
    var C = Matrix[Float64](n, n)

    for i in range(0, n, TILE):
        for j in range(0, n, TILE):
            for k in range(0, n, TILE):
                // Multiply tile block (i:k) × (k:j)
                for ti in range(i, min(i + TILE, n)):
                    for tj in range(j, min(j + TILE, n)):
                        var sum = 0.0
                        for tk in range(k, min(k + TILE, n)):
                            sum += A[ti, tk] * B[tk, tj]
                        C[ti, tj] += sum
    return C
