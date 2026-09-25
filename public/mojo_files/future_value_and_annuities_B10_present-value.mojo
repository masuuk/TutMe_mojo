from std.math import pow

def present_value(fv: Float64, rate: Float64, years: Int) -> Float64:
    """Present value (discounting)."""
    var r = rate / 100.0
    return fv / pow(1.0 + r, Float64(years))

def main():
    print("PV = $", present_value(50000.0, 7.0, 10))
