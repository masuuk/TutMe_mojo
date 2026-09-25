def capm_return(rf: Float64, beta: Float64, market_return: Float64) -> Float64:
    """Expected return: rf + beta × market risk premium."""
    return rf + beta * (market_return - rf)

def main():
    var expected = capm_return(0.03, 1.2, 0.10)
    print("E(R) = ", expected)   # 0.114 — 11.4%
