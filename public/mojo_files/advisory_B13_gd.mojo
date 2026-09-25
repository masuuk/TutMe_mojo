def gd(X: Tensor[Float64], y: Tensor[Float64])
       -> Tensor[Float64]:
    var m = X.dim(0).to_float64()   # samples
    var n = X.dim(1)                # features
    var theta = Tensor[Float64](n)  # starts at 0
    var resid = Tensor[Float64](X.dim(0))
    for it in range(1000):
        # resid = X·theta − y  (prediction error)
        matvec(X, theta, resid)
        @parameter
        for i in range(resid.num_elements()):
            resid[i] -= y[i]
        # grad = Xᵀ·resid / m ; theta −= η·grad
        vecmat(X, resid, theta, 0.01 / m)
    return theta
