struct Point:
    var x: Float64
    var y: Float64

    def __init__(out self, x: Float64, y: Float64):
        self.x = x
        self.y = y

    def magnitude(self) -> Float64:
        return (self.x ** 2 + self.y ** 2).sqrt()

    def __add__(self, other: Point) -> Point:
        return Point(self.x + other.x, self.y + other.y)

var p = Point(3.0, 4.0)
print(p.magnitude())  # 5.0
