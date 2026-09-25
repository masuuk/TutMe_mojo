@fieldwise_init
struct System2x2:
    var a1: Float64
    var b1: Float64
    var c1: Float64
    var a2: Float64
    var b2: Float64
    var c2: Float64

    def solve(self) raises -> (Float64, Float64):
        var det = self.a1 * self.b2 - self.a2 * self.b1
        if det == 0.0:
            raise "No unique solution"
        var x = (self.c1 * self.b2 - self.c2 * self.b1) / det
        var y = (self.a1 * self.c2 - self.a2 * self.c1) / det
        return (x, y)

def main():
    # 2x + 3y = 8,  4x - y = 2
    var sys = System2x2(2.0, 3.0, 8.0, 4.0, -1.0, 2.0)
    var x, y = sys.solve()
    print("x =", x, "y =", y)
