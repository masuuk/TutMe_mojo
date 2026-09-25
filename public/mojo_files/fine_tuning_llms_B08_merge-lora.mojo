from tensor import Tensor

# native merge: ΔW = (α/r)·B·A over Tensors — compiles to SIMD,
# dtype is a compile-time fact (float16 = the training dtype).
def merge_lora(W: Tensor[DType.float16],
                 A: Tensor[DType.float16],
                 B: Tensor[DType.float16], r: Int,
                 alpha: Float64) -> Tensor[DType.float16]:
    var n = W.shape()[0]
    var m = W.shape()[1]
    var scale = Float16(alpha / Float64(r))
    var out = Tensor[DType.float16](n, m)
    for i in range(n):
        for j in range(m):
            var delta: Float16 = 0.0
            for k in range(r):        # low-rank inner product
                delta += B[i, k] * A[k, j]
            out[i, j] = W[i, j] + scale * delta
    return out
