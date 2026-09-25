from tensor import Tensor
from random import normal_float64, seed

# the forward pass as pure arithmetic — dtype and shapes are
# compile-time facts, and the r-inner-product is a tight loop.
def lora_forward(X: Tensor[DType.float64], W: Tensor[DType.float64],
                  B: Tensor[DType.float64], A: Tensor[DType.float64],
                  r: Int, alpha: Float64) -> Tensor[DType.float64]:
    var n = X.shape()[0]
    var o = W.shape()[1]
    var s = alpha / Float64(r)
    var Y = Tensor[DType.float64](n, o)
    for i in range(n):
        for j in range(o):
            var base = dot_row(X, W, i, j)        # X[i,:]·W[:,j]
            var delta: Float64 = 0.0
            for k in range(r):               # the low-rank path
                delta += X[i, k] * B[k, 0] * A[0, j]  # (illustrative 1-r)
            Y[i, j] = base + s * delta
    return Y

# init rule, both languages: B = 0 exactly, A ~ N(0, 0.02²)
seed(42)
var a0 = normal_float64(0.0, 0.02)
