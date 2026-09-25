from math import sqrt

def solve_quadratic(a: Float64, b: Float64, c: Float64) -> String:
    var discriminant = b * b - 4.0 * a * c
    if discriminant < 0.0:
        return "No real roots"
    var sqrt_disc = sqrt(discriminant)
    var r1 = (-b + sqrt_disc) / (2.0 * a)
    var r2 = (-b - sqrt_disc) / (2.0 * a)
    return "x1 = " + str(r1) + ", x2 = " + str(r2)

def main():
    print(solve_quadratic(1.0, -5.0, 6.0))   # x1 = 3.0, x2 = 2.0
    print(solve_quadratic(1.0, 2.0, 5.0))   # No real roots
