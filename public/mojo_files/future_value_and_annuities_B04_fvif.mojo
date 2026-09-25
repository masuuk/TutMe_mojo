from std.math import pow

def fvif(rate: Float64, n: Int) -> Float64:
    """Future Value Interest Factor."""
    var r = rate / 100.0
    return pow(1.0 + r, Float64(n))

def main():
    print("FVIF =", fvif(7.0, 10))   # 1.96715…
