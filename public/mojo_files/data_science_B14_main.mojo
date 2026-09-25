from math import exp, sqrt

def main():
    var scores = [72.0, 85.0, 90.0, 61.0]
    var mu: Float64 = 0.0                      # mean
    for s in scores:
        mu += s
    mu /= float64(scores.size)
    var var_: Float64 = 0.0
    for s in scores:
        var_ += (s - mu) * (s - mu)
    var_ /= float64(scores.size)
    var sd = sqrt(var_)
    for s in scores:
        print((s - mu) / sd)                   # z-scores: -1.18 0.47 1.1 -0.39

    print(exp(0.0), exp(1.0))        # ufunc ↦ 1.0  2.718

    # solve [[3,1],[1,2]]·[x0,x1] = [9,8]  via Cramer's rule → [2,3]
    var det: Float64 = 3.0 * 2.0 - 1.0 * 1.0
    var x0 = (9.0 * 2.0 - 1.0 * 8.0) / det   # → 2
    var x1 = (3.0 * 8.0 - 9.0 * 1.0) / det   # → 3
    print(x0, x1)
