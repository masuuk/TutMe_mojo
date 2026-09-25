def num_diff[f: def(Float64) -> Float64](x: Float64, h: Float64 = 1e-6) -> Float64:
    return (f(x + h) - f(x - h)) / (2.0 * h)

def square(x: Float64) -> Float64:
    return x * x   # x²

def main():
    print(num_diff[square](3.0))   # → 6.0  (true answer: f'(3) = 2·3)
