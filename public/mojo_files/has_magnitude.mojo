# Extracted from tutorials on this site (source: praxis/drill_08.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_08.html

trait HasMagnitude:
    def magnitude(self) -> Float64: ...

def report[T: HasMagnitude](v: T) -> Float64:
    return v.magnitude()

struct Point(Copyable, HasMagnitude):
    var x: Int
    var y: Int

    def __init__(out self):
        self.x = 0
        self.y = 0

    def __init__(out self, x: Int, y: Int):
        self.x = x
        self.y = y

    def magnitude(self) -> Float64:
        return Float64(self.x * self.x + self.y * self.y) ** 0.5

    @staticmethod
    def from_origin() -> Point:
        return Point(0, 0)

@fieldwise_init
struct Complex:
    var re: Float64
    var im: Float64

    def __add__(self, other: Complex) -> Complex:
        return Complex(self.re + other.re, self.im + other.im)

def main():
    var p = Point(3, 4)
    print(report(p))          # 5.0 via the trait
    var c = Complex(1.0, 2.0) + Complex(3.0, 4.0)
    print(c.re, c.im)         # 4.0 6.0
