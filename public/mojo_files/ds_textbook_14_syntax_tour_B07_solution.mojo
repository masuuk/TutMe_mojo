struct Solution:
    var x: Float64
    var y: Float64

def solve_2x2(
    a: Float64, b: Float64, e: Float64,
    c: Float64, d: Float64, f: Float64
) -> Solution:
    var det = a * d - b * c
    if abs(det) < 1e-12:
        print("Degenerate — no unique solution")
        return Solution(0.0, 0.0)
    var x = (e * d - b * f) / det
    var y = (a * f - e * c) / det
    return Solution(x, y)

def main():
    var s = solve_2x2(2.0, 3.0, 8.0, 5.0, -2.0, 7.0)
    print("x =", s.x, "y =", s.y)
