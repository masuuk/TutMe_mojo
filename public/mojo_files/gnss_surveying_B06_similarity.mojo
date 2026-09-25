from std.math import cos, sin, radians

def similarity(E: Float64, N: Float64,
              tx: Float64, ty: Float64,
              scale: Float64, theta_deg: Float64)
              -> Tuple[Float64, Float64]:
    var t = radians(theta_deg)
    var Ep = tx + scale * (E*cos(t) - N*sin(t))
    var Np = ty + scale * (E*sin(t) + N*cos(t))
    return (Ep, Np)

def main():
    var p = similarity(1000.0, 500.0, 250.0, -100.0, 1.0002, 0.15)
    print(p)
