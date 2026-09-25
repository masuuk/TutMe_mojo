from std.math import pow

def monthly_payment(principal: Float64, annual_rate: Float64, years: Int) -> Float64:
    var r = annual_rate / 12.0
    var n = Float64(years * 12)
    return principal * (r * pow(1.0 + r, n)) / (pow(1.0 + r, n) - 1.0)

def combined_npv(loan: Float64, apy: Float64, years: Int, inflow: Float64, discount: Float64) -> Float64:
    var m = monthly_payment(loan, apy, years)
    var net = inflow - 12.0 * m
    var npv = 0.0
    for t in range(1, years + 1):
        npv += net / pow(1.0 + discount, Float64(t))          # skip t=0: nothing invested today
    return npv

def main():
    print("Project NPV = ", combined_npv(50000.0, 0.05, 5, 15000.0, 0.10))  # 13,939.71
