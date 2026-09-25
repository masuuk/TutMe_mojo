from math import sqrt, exp

def pi_mc(n: Int, seed: UInt64) -> Float64:
    var rng = Random(seed)
    var hits = 0
    # embarrassingly parallel: every sample is independent,
    # so each thread can own its own rng and counter
    for i in range(n):
        var u = rng.random_float64()   # uniform in [0,1)
        var v = rng.random_float64()
        if u*u + v*v <= 1.0:           # inside quarter circle?
            hits += 1
    return 4.0 * hits.to_float64() / n.to_float64()

def call_mc(S: Float64, K: Float64, r: Float64,
            sigma: Float64, T: Float64,
            n: Int) -> Float64:
    var rng = Random(42)
    var acc = 0.0
    for i in range(n):
        var z = rng.normal_float64()   # z ~ N(0,1)
        # risk-neutral terminal price S_T
        var ST = S * exp((r - sigma**2/2)*T
                         + sigma*sqrt(T)*z)
        acc += max(ST - K, 0.0)        # discounted later
    return exp(-r*T) * acc / n.to_float64()
