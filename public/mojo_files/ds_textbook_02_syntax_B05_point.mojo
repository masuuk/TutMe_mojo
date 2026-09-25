# Mojo — struct with fieldwise init
@fieldwise_init
struct Point:
    var x: Float64
    var y: Float64

    def distance_to(self, other: Point) -> Float64:
        return ((self.x - other.x)**2 + (self.y - other.y)**2)

# Usage
var p1 = Point(x=3.0, y=4.0)
var p2 = Point(x=0.0, y=0.0)
var d = p1.distance_to(p2)
print(d)  # 5.0
