from std.math import pow

def fv_annuity_due(pmt: Float64, rate: Float64, n: Int) -> Float64:
    """FV of Annuity Due (payments at period start)."""
    var r = rate / 100.0
    var ordinary = pmt * (pow(1.0 + r, Float64(n)) - 1.0) / r
    return ordinary * (1.0 + r)

def main():
    print("FV Due = $", fv_annuity_due(500.0, 6.0, 20))
