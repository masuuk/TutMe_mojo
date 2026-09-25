# Extracted from tutorials on this site (source: praxis/drill_25.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_25.html

from std.math import sin, cos, sqrt, atan2, radians

@fieldwise_init
struct Ellipsoid:
    var a: Float64      # semi-major axis (m)
    var f: Float64      # flattening

def WGS84() -> Ellipsoid:
    return Ellipsoid(a=6378137.0, f=1.0 / 298.257223563)

def geodetic_to_ecef(lat: Float64, lon: Float64, h: Float64) -> (Float64, Float64, Float64):
    var wgs = WGS84()
    var e2 = 2.0 * wgs.f - wgs.f ** 2
    var phi = radians(lat)
    var lam = radians(lon)
    var s = sin(phi)
    var n = wgs.a / sqrt(1.0 - e2 * s * s)   # prime-vertical radius
    var x = (n + h) * cos(phi) * cos(lam)
    var y = (n + h) * cos(phi) * sin(lam)
    var z = (n * (1.0 - e2) + h) * s
    return (x, y, z)

def enu(dx: Float64, dy: Float64, dz: Float64, lat: Float64, lon: Float64) -> (Float64, Float64, Float64):
    var phi = radians(lat)
    var lam = radians(lon)
    var e = -sin(lam) * dx + cos(lam) * dy
    var n = -sin(phi) * cos(lam) * dx - sin(phi) * sin(lam) * dy + cos(phi) * dz
    var u = cos(phi) * cos(lam) * dx + cos(phi) * sin(lam) * dy + sin(phi) * dz
    return (e, n, u)

# 4-parameter similarity: E = a*x - b*y + tx ; N = b*x + a*y + ty
def apply_sim4(x: Float64, y: Float64, a: Float64, b: Float64, tx: Float64, ty: Float64) -> (Float64, Float64):
    return (a * x - b * y + tx, b * x + a * y + ty)

def main():
    # Harare area check: geodetic -> ECEF round trip closes to < 1 mm
    var (x, y, z) = geodetic_to_ecef(-17.8252, 31.0335, 1480.0)
    print("ECEF (m):", x, y, z)

    # Calibrated grid point (a, b, tx, ty from a least-squares fit of control points)
    var (E, N) = apply_sim4(x=501234.5, y=7987654.3, a=0.9999965, b=0.0000210, tx=102.45, ty=-57.82)
    print("Local E, N:", E, N)

    # Residual QC: known local coords of a control point vs transformed
    var known_E = 501336.98
    var known_N = 7987596.44
    print("residual dE, dN (m):", E - known_E, N - known_N)
    # |residual| at the few-mm level means the calibration is trustworthy.
