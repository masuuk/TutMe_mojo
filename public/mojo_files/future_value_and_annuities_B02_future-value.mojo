from std.math import pow

def future_value(pv: Float64, rate: Float64, years: Int) -> Float64:
    """Calculate future value with compound interest."""
    var r = rate / 100.0
    return pv * pow(1.0 + r, Float64(years))

# Example usage
def main():
    var result = future_value(10000.0, 7.0, 10)
    print("FV = $", result)   # 19671.51…
