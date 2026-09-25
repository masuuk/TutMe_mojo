def solve_quadratic(a: Float64, b: Float64, c: Float64) raises -> (Float64, Float64):
    var discriminant = b * b - 4.0 * a * c
    if discriminant < 0.0:
        raise "No real roots"
    var root1 = (-b + discriminant ** 0.5) / (2.0 * a)
    var root2 = (-b - discriminant ** 0.5) / (2.0 * a)
    return (root1, root2)

def main():
    var r1, r2 = solve_quadratic(1.0, -5.0, 6.0)
    print("x1 =", r1, "x2 =", r2)
