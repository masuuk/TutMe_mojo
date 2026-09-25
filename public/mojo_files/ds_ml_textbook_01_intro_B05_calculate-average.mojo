def calculate_average(temps: List[Float64]) raises -> Float64:
    if len(temps) == 0:
        raise Error("No temperature data")
    var total = 0.0
    for temp in temps:
        total += temp
    return total / Float64(len(temps))
