# Extracted from tutorials on this site (source: praxis/drill_19.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_19.html

def npv(rate: Float64, flows: List[Float64]) -> Float64:
    var total = 0.0
    var r = rate / 100.0
    for t in range(len(flows)):
        total = total + flows[t] / (1.0 + r) ** (t + 1)
    return total

def monthly_payment(principal: Float64, annual: Float64, years: Int) -> Float64:
    var r = annual / 100.0 / 12.0
    var n = Float64(years * 12)
    return principal * r / (1.0 - ((1.0 + r) ** -n))

def amortise(principal: Float64, annual: Float64, years: Int):
    var r = annual / 100.0 / 12.0
    var n = years * 12
    var pmt = monthly_payment(principal, annual, years)
    var balance = principal
    for month in range(n):
        var interest = balance * r
        var principal_part = pmt - interest
        balance = balance - principal_part
    print("payment", pmt)     # 599.55 for the 30y / 6% version

def main():
    var flows = List[Float64](-1000.0, 300.0, 400.0, 500.0, 600.0)
    print(npv(10.0, flows))    # ≈ 388.77
    amortise(100_000.0, 6.0, 30)
