from math import sqrt

def standardize(values: List[Float64]) -> List[Float64]:
    var n = Float64(len(values))
    var mean: Float64 = 0.0
    for v in values:
        mean += v
    mean /= n

    var variance: Float64 = 0.0
    for v in values:
        variance += (v - mean) * (v - mean)
    var std = sqrt(variance / n)

    var out = List[Float64]()
    for v in values:
        out.append((v - mean) / std)
    return out
