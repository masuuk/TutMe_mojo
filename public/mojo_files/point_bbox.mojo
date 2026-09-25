# Extracted from tutorials on this site (source: praxis/drill_22.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_22.html

struct Point:
    var x: Float64
    var y: Float64

    def __init__(out self, x: Float64, y: Float64):
        self.x = x
        self.y = y

def distance(a: Point, b: Point) -> Float64:
    return ((a.x - b.x) ** 2 + (a.y - b.y) ** 2) ** 0.5

@fieldwise_init
struct BBox:
    var min_x: Float64
    var min_y: Float64
    var max_x: Float64
    var max_y: Float64

def bounding_box(pts: List[Point]) -> BBox:
    var b = BBox(pts[0].x, pts[0].y, pts[0].x, pts[0].y)
    for p in pts:
        if p.x < b.min_x: b.min_x = p.x
        if p.y < b.min_y: b.min_y = p.y
        if p.x > b.max_x: b.max_x = p.x
        if p.y > b.max_y: b.max_y = p.y
    return b

def main():
    var pts = List[Point](Point(0.0, 0.0), Point(3.0, 4.0), Point(-1.0, 2.0))
    var bb = bounding_box(pts)
    print(bb.min_x, bb.min_y, bb.max_x, bb.max_y)   # -1 0 3 4

    var origin = Point(0.0, 0.0)
    for p in pts:
        print("dist to (0,0):", distance(p, origin))

    # Attributes: wrap Point inside a Feature struct and add an id field.
