from std.math import pow

def compound_interest(
    principal: Float64,
    rate: Float64,
    times_per_year: Int,
    years: Int
) -> Float64:
    var n = Float64(times_per_year)
    var t = Float64(years)
    return principal * pow(1.0 + rate / n, n * t)

def show_growth(principal: Float64, rate: Float64, years: Int):
    for y in range(1, years + 1):
        var amount = compound_interest(principal, rate, 12, y)
        print("Year ", y, ": $", amount)

def main():
    show_growth(10000.0, 0.05, 5)
