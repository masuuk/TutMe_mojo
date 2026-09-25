# Extracted from tutorials on this site (source: praxis/drill_21.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_21.html

from std.math import cos

def clenshaw_cos(c: List[Float64], theta: Float64) -> Float64:
    var b0 = 0.0
    var b1 = 0.0
    var two_cos = 2.0 * cos(theta)
    for j in range(len(c) - 1, 0, -1):
        var t = two_cos * b0 - b1 + c[j]
        b1 = b0
        b0 = t
    return b0 * cos(theta) - b1 + c[0]

def naive_cos_sum(c: List[Float64], theta: Float64) -> Float64:
    var s = 0.0
    for j in range(len(c)):
        s += c[j] * cos(Float64(j) * theta)
    return s

def main():
    var c = List[Float64](1.0, 0.5, 0.2, 0.1)
    var th = 0.3
    print(clenshaw_cos(c, th))
    print(naive_cos_sum(c, th))     # agree to ~1e-15

    # Forward alpha then inverse beta series (Karney-Krueger):
    #   x, y = kruger_forward(Phi, Lambda, alpha, ellipsoid)
    #   Phi', Lambda' = kruger_inverse(x, y, beta, ellipsoid)
    # Round trip on a point near Harare closes to ~3e-17.
