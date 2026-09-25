def clip(xs: List[Float64], lo: Float64,
         hi: Float64) -> List[Float64]:
    var out = List[Float64]()
    for x in xs:
        out.append(min(max(x, lo), hi))
    return out

def weighted_sum(xs: Tensor[Float64],
                 ws: Tensor[Float64]) -> Float64:
    var total: Float64 = 0.0
    @parameter
    for i in range(xs.num_elements()):
        total += ws[i] * xs[i]
    return total
