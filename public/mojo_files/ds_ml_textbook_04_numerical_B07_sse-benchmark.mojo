from time import now
from random import random_float64

def sse_benchmark(n: Int) -> Float64:
    var a = Tensor[Float64](n)
    var b = Tensor[Float64](n)
    for i in range(n):
        a[i] = random_float64()
        b[i] = random_float64()

    var start = now()
    var sse: Float64 = 0.0
    for i in range(n):
        var diff = a[i] - b[i]
        sse += diff * diff
    var elapsed = now() - start
    print("Time:", elapsed, "ns")
    return sse

def main():
    sse_benchmark(1_000_000)
