def convolve(img: Tensor[Float64],
             w: Tensor[Float64])  # K×K, K odd
             -> Tensor[Float64]:
    var H = img.dim(0); var W = img.dim(1)
    var K = w.dim(0); var r = K // 2
    var out = Tensor[Float64](H, W)
    # rows are independent — parallelize across y on a GPU
    # (max.gpu) or with multiple threads
    for y in range(H):
        @parameter
        for x in range(W):
            var acc = 0.0
            for i in range(K):
                for j in range(K):
                    var yy = min(max(y+i-r, 0), H-1)
                    var xx = min(max(x+j-r, 0), W-1)
                    acc += w[i, j] * img[yy, xx]
            out[y, x] = acc
    return out
