def corrected_height(E: Float64, N: Float64,
                    a: Float64, b: Float64, c: Float64) -> Float64:
    # a + bE + cN: fitted tilt plane applied to a queried position.
    # a, b, c come from the plane fit above (intercept + two gradients).
    return a + b*E + c*N

def main():
    var h = corrected_height(200.0, 300.0, 499.86, 0.0010, 0.0008)
    print(h)
