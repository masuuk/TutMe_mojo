from math import sqrt
from python import Python

def pearson(x: List[Float64], y: List[Float64]) -> Float64:
    var n = float64(x.size)
    var mx = 0.0; var my = 0.0
    for i in range(x.size):
        mx += x[i]; my += y[i]
    mx /= n; my /= n
    var num = 0.0; var dx = 0.0; var dy = 0.0
    for i in range(x.size):
        var a = x[i] - mx; var b = y[i] - my
        num += a * b; dx += a * a; dy += b * b
    return num / sqrt(dx * dy)          # r ≈ 0.95

def main() raises:
    var hours = List[Float64](1,2,3,4,5,6,7)
    var score = List[Float64](38,55,49,71,82,79,95)
    print("r =", pearson(hours, score))   # ≈ 0.95

    var stats = Python.import_module("scipy.stats")
    # ttest_ind(control, treated) rides the bridge for its p-value.
