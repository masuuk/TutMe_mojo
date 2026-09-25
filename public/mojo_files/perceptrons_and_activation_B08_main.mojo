from std.math import exp, tanh, max
from std.collections import List

def main():
    var z = List[Float64]([-6.0, -2.0, -0.5, 0.0, 0.5, 2.0, 6.0])
    print("    z  |  sigmoid     σ′   |   tanh      t′   |  relu  r′  |  leaky")
    for i in range(len(z)):
        var v = z[i]
        var s = 1.0 / (1.0 + exp(-v))          # sigmoid
        var t = tanh(v)
        var leaky = max(0.01 * v, v)
        print(v, " |", s, s * (1.0 - s),
              "|", t, 1.0 - t * t,
              "|", max(0.0, v), "|", leaky)
    # σ′(±6) ≈ 0.0025: saturated.  t′(0) = 1 vs σ′(0) = 0.25.
    # ReLU: gradient exactly 1 for z > 0 — never decays.
