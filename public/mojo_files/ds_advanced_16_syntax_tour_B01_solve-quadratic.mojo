from math import sqrt

def solve_quadratic(a: Float64, b: Float64, c: Float64):
    var discriminant = b * b - 4.0 * a * c

    if discriminant > 0:
        var x1 = (-b + sqrt(discriminant)) / (2.0 * a)
        var x2 = (-b - sqrt(discriminant)) / (2.0 * a)
        print("Two real roots:", x1, x2)
    elif discriminant == 0:
        var x = -b / (2.0 * a)
        print("One repeated root:", x)
    else:
        var real = -b / (2.0 * a)
        var imag = sqrt(abs(discriminant)) / (2.0 * a)
        print("Complex roots:", real, "±", imag, "i")

solve_quadratic(1.0, -5.0, 6.0)
