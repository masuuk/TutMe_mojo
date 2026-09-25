trait Squarable:
    def square(self) -> Self

struct Vec2[T: Squarable]:
    var x: T
    var y: T

    def norm2(self) -> T:
        return self.x.square() + self.y.square()

# comptime: computed during compilation, zero runtime cost
comptime N = 1024
comptime LANES = simdwidthof[DType.float64]()  # 4 or 8, per CPU

def main():
    var v = Vec2[Float64](3.0, 4.0)
    print(v.norm2())      # 25.0
    print(N, LANES)
