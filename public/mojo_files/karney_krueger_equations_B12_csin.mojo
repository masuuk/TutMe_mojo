from math import sin, cos, sqrt, sinh, cosh

def csin(x: Float64, y: Float64) -> (Float64, Float64):
    # sin(x + iy) = sin(x)cosh(y) + i·cos(x)sinh(y)
    return (sin(x) * cosh(y), cos(x) * sinh(y))

def ccos(x: Float64, y: Float64) -> (Float64, Float64):
    # cos(x + iy) = cos(x)cosh(y) − i·sin(x)sinh(y)
    return (cos(x) * cosh(y), -sin(x) * sinh(y))

def invert_z_newton(zx: Float64, zy: Float64,
                   alpha: List[Float64]) raises -> (Float64, Float64):
    var px = zx; var py = zy          # first guess = z (β correction omitted)
    for i in range(10):
        # F = forward(px) − z ; dF/dp = 1 + Σ 2j·αⱼ·cos(2j·p)
        var fx = px - zx; var fy = py - zy
        var dx = 1.0; var dy = 0.0
        for j in range(6):
            var w = 2.0 * Float64(j + 1)
            var s = csin(w * px, w * py)
            fx += alpha[j] * s[0];  fy += alpha[j] * s[1]
            var c = ccos(w * px, w * py)
            dx += w * alpha[j] * c[0]
            dy += w * alpha[j] * c[1]
        # complex Newton step: p −= F / dF   (one complex division)
        var den = dx * dx + dy * dy
        var qx = (fx * dx + fy * dy) / den
        var qy = (fy * dx - fx * dy) / den
        px -= qx; py -= qy
        if sqrt(qx * qx + qy * qy) < 1e-15:
            break                    # quadratic: error² each pass
    return (px, py)
