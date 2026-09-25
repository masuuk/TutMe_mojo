from std.math import pow

def fv_single(pv: Float64, r: Float64, n: Int) -> Float64:
    """FV = PV · (1 + r)^n"""
    return pv * pow(1.0 + r, Float64(n))

def main():
    # $1,000 at 6% for 10 years
    print("FV = $", fv_single(1000.0, 0.06, 10))  # 1790.847...
