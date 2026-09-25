from std.math import pow

def pvifa(r: Float64, n: Int) -> Float64:
    """[ 1 - (1 + r)^-n ] / r"""
    if r == 0.0:
        return Float64(n)
    return (1.0 - pow(1.0 + r, -Float64(n))) / r

def pv_annuity(pmt: Float64, r: Float64, n: Int, due: Bool = False) -> Float64:
    """PV = PMT × PVIFA(r, n), × (1 + r) if due"""
    var factor = pvifa(r, n)
    if due:
        factor *= (1.0 + r)
    return pmt * factor

def main():
    # $50,000 a year for 20 years, discounted at 5%
    print("PVIFA = ", pvifa(0.05, 20))              # 12.4622...
    print("PV    = $", pv_annuity(50000.0, 0.05, 20))  # 623110.50...
