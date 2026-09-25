def mean(values: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for v in values:
        total += v
    return total / Float64(len(values))

def main():
    var data = List[Float64](2.0, 4.0, 6.0, 8.0)
    print("mean =", mean(data))  # mean = 5.0
