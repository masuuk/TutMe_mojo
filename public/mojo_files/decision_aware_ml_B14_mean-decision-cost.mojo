def mean_decision_cost(C: Tensor[DType.float64],
                          y: List[Int],
                          d: List[Int]) -> Float64:
    var total: Float64 = 0.0
    for i in range(len(y)):
        total += C[y[i], d[i]]
    return total / Float64(len(y))

# worst-group: same loop over per-group index lists, keep the max.
# One compiled pass = mean + components + equity for a million rows.
