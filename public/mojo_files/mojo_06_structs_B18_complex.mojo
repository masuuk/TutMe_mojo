from std.math import sqrt

@fieldwise_init
struct Complex(Boolable, Equatable, Writable,
              TrivialRegisterPassable):
    var re: Float64
    var im: Float64

    # Convenience init: real part only
    def __init__(out self, re: Float64):
        self.re = re
        self.im = 0.0

def main():
    var c1 = Complex(-1.2, 6.5)
    var c2 = Complex(-1.2, 6.5)
    print(c1 == c2)          # True  (Equatable default)
