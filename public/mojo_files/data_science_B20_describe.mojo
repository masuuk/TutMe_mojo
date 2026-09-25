from math import sqrt
from algorithm import sort

def describe(s: List[Float64]):
    var n = float64(s.size)
    var mean: Float64 = 0.0
    for v in s:
        mean += v
    mean /= n
    var var_: Float64 = 0.0
    for v in s:
        var_ += (v - mean) * (v - mean)
    var_ /= (n - 1)                 # ddof = 1 → sample variance
    var sorted_s = s.copy()
    sort(sorted_s)
    var mid = sorted_s.size // 2
    var median: Float64
    if sorted_s.size % 2 == 1:
        median = sorted_s[mid]
    else:
        median = (sorted_s[mid - 1] + sorted_s[mid]) / 2.0
    print("mean", mean, "median", median, "sd", sqrt(var))

def main():
    var control = List[Float64](50.0, 52.0, 48.0, 61.0, 45.0, 55.0, 49.0, 51.0)
    describe(control)
