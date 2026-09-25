from math import sqrt, sin, cos, sinh, cosh

def complex_sin(x: Float64, y: Float64) -> (Float64, Float64):
    # sin(x + iy) = sin(x)cosh(y) + i·cos(x)sinh(y)
    return (sin(x) * cosh(y), cos(x) * sinh(y))

def roundtrip_error(xp: Float64, yp: Float64, n: Float64) -> Float64:
    var al = krueger_alpha(n)
    var be = krueger_beta(n)          # same shape as krueger_alpha, β coefficients
    # forward: z = zp + Σ αⱼ·sin(2j·zp)
    var zx = xp
    var zy = yp
    var coefs = [al.a1, al.a2, al.a3, al.a4, al.a5, al.a6]
    for j in range(6):
        var s = complex_sin(2.0 * Float64(j + 1) * xp, 2.0 * Float64(j + 1) * yp)
        zx += coefs[j] * s[0]
        zy += coefs[j] * s[1]
    # inverse: zp' = z − Σ βⱼ·sin(2j·z)
    var bx = zx
    var by = zy
    var bcoefs = [be.a1, be.a2, be.a3, be.a4, be.a5, be.a6]
    for j in range(6):
        var s = complex_sin(2.0 * Float64(j + 1) * zx, 2.0 * Float64(j + 1) * zy)
        bx -= bcoefs[j] * s[0]
        by -= bcoefs[j] * s[1]
    return sqrt((bx - xp) ** 2 + (by - yp) ** 2)   # ~3e-17
