# Extracted from tutorials on this site (source: praxis/drill_20.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_20.html

def fvifa(r: Float64, n: Int) -> Float64:
    if r == 0.0:
        return Float64(n)
    return ((1.0 + r) ** n - 1.0) / r

def pvifa(r: Float64, n: Int) -> Float64:
    if r == 0.0:
        return Float64(n)
    return (1.0 - (1.0 + r) ** -n) / r

def pv_annuity(pmt: Float64, r: Float64, n: Int, due: Bool = False) -> Float64:
    var pv = pmt * pvifa(r, n)
    if due:
        pv = pv * (1.0 + r)
    return pv

def payment_from_pv(pv: Float64, r: Float64, n: Int) -> Float64:
    return pv * r / (1.0 - (1.0 + r) ** -n)

def main():
    print(pvifa(0.05, 20))                 # ≈ 12.4622
    print(pv_annuity(50000.0, 0.05, 20))   # ≈ 623110
    print(payment_from_pv(100000.0, 0.06/12.0, 360))  # ≈ 599.55
