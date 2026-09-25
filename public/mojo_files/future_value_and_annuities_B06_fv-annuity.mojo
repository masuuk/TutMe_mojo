from std.math import pow

def fv_annuity(pmt: Float64, rate: Float64, n: Int) -> Float64:
    """Future Value of Ordinary Annuity."""
    var r = rate / 100.0
    return pmt * (pow(1.0 + r, Float64(n)) - 1.0) / r

def main():
    print("FV = $", fv_annuity(500.0, 6.0, 20))
