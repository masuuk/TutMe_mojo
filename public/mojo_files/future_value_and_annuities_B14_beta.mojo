from collections import List

def beta(asset: List[Float64], market: List[Float64]) -> Float64:
    """Beta = Cov(asset, market) / Var(market)."""
    var n = len(asset)
    var mean_a: Float64 = 0.0
    var mean_m: Float64 = 0.0
    for i in range(n):
        mean_a += asset[i]
        mean_m += market[i]
    mean_a /= Float64(n)
    mean_m /= Float64(n)

    var cov: Float64 = 0.0
    var variance: Float64 = 0.0
    for i in range(n):
        var da = asset[i] - mean_a
        var dm = market[i] - mean_m
        cov += da * dm
        variance += dm * dm
    return cov / variance

def main():
    var asset = List[Float64](0.02, -0.01, 0.04, 0.03, -0.02, 0.05)
    var market = List[Float64](0.01, -0.02, 0.03, 0.02, -0.01, 0.04)
    print("beta = ", beta(asset, market))   # same ≈1.16 as Python
