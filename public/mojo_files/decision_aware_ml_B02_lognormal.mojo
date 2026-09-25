from collections import List
from random import random_float64, seed
from math import sqrt, log, cos, exp, PI

def lognormal(mu: Float64, sigma: Float64, n: Int) -> List[Float64]:
    var xs = List[Float64]()
    for _ in range(n):                # Box–Muller
        var u1 = random_float64(1e-12, 1.0)
        var u2 = random_float64(0.0, 1.0)
        var z = sqrt(-2.0*log(u1)) * cos(2.0*PI*u2)
        xs.append(exp(mu + sigma*z))
    return xs

def quantile(xs: List[Float64], q: Float64) -> Float64:
    xs.sort()                          # empirical quantile = sorted index
    return xs[Int(q * Float64(len(xs)-1) + 0.5)]

def cost(q: Float64, d: Float64, c_u: Float64,
             c_o: Float64) -> Float64:
    return c_o*max(q-d, 0.0) + c_u*max(d-q, 0.0)

def main():
    seed(42)
    var c_u: Float64 = 8.0
    var c_o: Float64 = 1.0
    var fr = c_u / (c_u + c_o)
    var hist = lognormal(3.0, 0.6, 200)
    var q_da = quantile(hist, fr)         # cost-aware order
    var test = lognormal(3.0, 0.6, 1_000_000)
    var tot: Float64 = 0.0
    for d in test:
        tot += cost(q_da, d, c_u, c_o)
    print("expected cost:", tot / 1e6)
