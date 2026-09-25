from std.math import sin

def sinc_squeeze(x: Float64) -> Float64:
    if x == 0.0:
        return 1.0            # limit, not a division by zero
    return sin(x) / x

def main():
    var xs = [1e-1, 1e-2, 1e-3, 1e-4, 1e-5]
    for x in xs:
        print(sinc_squeeze(x))   # 0.998 → 0.9999998, creeping toward 1.0
