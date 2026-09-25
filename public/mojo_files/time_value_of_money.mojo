# Extracted from tutorials on this site (source: praxis/drill_18.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_18.html

def future_value(pv: Float64, rate: Float64, years: Int) -> Float64:
    return pv * (1.0 + rate / 100.0) ** years

def present_value(fv: Float64, rate: Float64, years: Int) -> Float64:
    return fv / (1.0 + rate / 100.0) ** years

def fvifa(rate: Float64, n: Int) -> Float64:
    if rate == 0.0:
        return Float64(n)
    var r = rate / 100.0
    return ((1.0 + r) ** n - 1.0) / r

def fv_annuity(pmt: Float64, rate: Float64, n: Int, due: Bool = False) -> Float64:
    var f = pmt * fvifa(rate, n)
    if due:
        f = f * (1.0 + rate / 100.0)      # annuity-due boost
    return f

def main():
    print(future_value(1000.0, 7.0, 10))  # ≈ 1967.15
    print(present_value(50000.0, 7.0, 10))# ≈ 25415.0
    print(fv_annuity(1000.0, 7.0, 10))    # ordinary annuity
    print(fv_annuity(1000.0, 7.0, 10, due=True))  # due version
