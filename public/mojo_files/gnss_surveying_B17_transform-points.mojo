from std.math import cos, sin, radians

def transform_points(points: List[Tuple[Float64, Float64]],
                    tx: Float64, ty: Float64,
                    s: Float64, theta_deg: Float64)
                    -> List[Tuple[Float64, Float64]]:
    var result = List[Tuple[Float64, Float64]]()
    var t = radians(theta_deg)

    for p in points:
        var E = p[0]
        var N = p[1]
        var x = tx + s*(E*cos(t) - N*sin(t))
        var y = ty + s*(E*sin(t) + N*cos(t))
        result.append((x, y))

    return result

def main():
    var pts: List[Tuple[Float64, Float64]] = [(100.0, 200.0), (120.0, 240.0), (150.0, 210.0)]
    print(transform_points(pts, 1000.0, 2000.0, 1.0001, 0.02))
