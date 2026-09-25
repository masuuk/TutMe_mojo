struct LinearEq:
    var a: Float64
    var b: Float64
    var c: Float64   # ax + by = c

    def __init__(out self, a: Float64, b: Float64, c: Float64):
        self.a = a
        self.b = b
        self.c = c

def solve(eq1: LinearEq, eq2: LinearEq) -> Tuple[Float64, Float64]:
    var det = eq1.a * eq2.b - eq2.a * eq1.b
    if det == 0.0:
        raise "No unique solution"
    var x = (eq1.c * eq2.b - eq2.c * eq1.b) / det
    var y = (eq1.a * eq2.c - eq2.a * eq1.c) / det
    return (x, y)

def main():
    var eq1 = LinearEq(2.0, 3.0, 8.0)
    var eq2 = LinearEq(1.0, -1.0, -1.0)
    var (x, y) = solve(eq1, eq2)
    print("x =", x, " y =", y)
    # x = 1.0  y = 2.0
