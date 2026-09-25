def compound_interest(
    principal: Float64,
    rate: Float64,
    times_per_year: Int,
    years: Int
) -> Float64:
    var n = Float64(times_per_year)
    var t = Float64(years)
    var base = 1.0 + rate / n
    return principal * base ** (n * t)

def main():
    var amount = compound_interest(10000.0, 0.05, 12, 10)
    print("Accumulated:", amount)
