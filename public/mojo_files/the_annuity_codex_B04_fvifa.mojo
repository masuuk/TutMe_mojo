from std.math import pow

def fvifa(r: Float64, n: Int) -> Float64:
    """[ (1 + r)^n - 1 ] / r"""
    if r == 0.0:
        return Float64(n)
    return (pow(1.0 + r, Float64(n)) - 1.0) / r

def fv_annuity(pmt: Float64, r: Float64, n: Int, due: Bool = False) -> Float64:
    """FV = PMT × FVIFA(r, n), × (1 + r) if due"""
    var factor = fvifa(r, n)
    if due:
        factor *= (1.0 + r)
    return pmt * factor

def main():
    # $200 / month, 20 years, 7% compounded monthly
    var r = 0.07 / 12.0
    var n = 240
    print("FVIFA = ", fvifa(r, n))              # 520.9267...
    print("FV    = $", fv_annuity(200.0, r, n))  # 104185.34...
