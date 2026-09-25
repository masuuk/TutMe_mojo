def compound_interest(
    principal: Float64,
    annual_rate: Float64,
    compounds_per_year: Int,
    years: Int
) -> Float64:
    var r = annual_rate / 100.0
    var n = float(compounds_per_year)
    var t = float(years)
    return principal * (1.0 + r / n) ** (n * t)

def main():
    var amount = compound_interest(10000.0, 5.0, 12, 10)
    print("Future value: $", amount)
    # Future value: $16470.09
