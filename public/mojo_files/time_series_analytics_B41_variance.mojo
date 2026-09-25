# Population variance implemented directly
def variance(data: List[Float64]) -> Float64:
    var total = 0.0
    for x in data:
        total += x
    var mean = total / Float64(len(data))
    var ss = 0.0
    for x in data:
        ss += (x - mean) * (x - mean)
    return ss / Float64(len(data))
