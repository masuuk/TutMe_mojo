from std.math import cos

def clenshaw_cos(c: List[Float64], theta: Float64) -> Float64:
    var y2 = 0.0
    var y1 = 0.0
    var two_cos = 2.0 * cos(theta)
    for k in range(len(c) - 1, -1, -1):
        var t = two_cos * y1 - y2 + c[k]
        y2 = y1
        y1 = t
    return c[0] + y1 * cos(theta) - y2

# swap cos -> sin for the sine series; GeographicLib's TransverseMercator
# evaluates the Krüger α/β sums with exactly this recurrence.
