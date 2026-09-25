from tensor import Tensor

def decision_weights(hist: Tensor[DType.float64],
                     stock: Tensor[DType.float64],
                     c_u: Float64) -> Tensor[DType.float64]:
    var n = hist.num_elements()
    var impact = Tensor[DType.float64](n)
    for i in range(n):
        var cover = stock[i] / (hist[i] + 1e-9)
        cover = min(max(cover, 0.0), 1.0)   # clip to [0,1]
        impact[i] = c_u * (1.0 - cover)
    return impact / impact.reduce_add()   # weights sum to 1

# weights computed in Mojo, consumed in Python:
#   model.fit(x, y, sample_weight=weights.to_numpy())
