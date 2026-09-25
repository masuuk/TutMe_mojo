def assign(X: Tensor[Float64], mu: Tensor[Float64])
          -> List[Int]:
    var n = X.dim(0)   # points
    var k = mu.dim(0)  # centroids
    var c = List[Int](capacity=n)
    # each point is independent — parallel-friendly
    for i in range(n):
        var best = 0
        var bd = inf
        for j in range(k):
            # squared distance ‖xᵢ − μⱼ‖² —
            # the SIMD dot-product kernel lives in here
            var d = sqdist(X, i, mu, j)
            if d < bd:
                bd = d; best = j
        c[i] = best     # nearest centroid wins
    return c
