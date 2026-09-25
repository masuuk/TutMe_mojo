# Helmert 7-parameter in pure Mojo — the small-angle rotation is
# expanded explicitly, so no matrix library is required.
comptime PI: Float64 = 3.14159265358979323846

@fieldwise_init
struct Vec3:
    var x: Float64
    var y: Float64
    var z: Float64

@fieldwise_init
struct HelmertParams:
    var tx: Float64
    var ty: Float64
    var tz: Float64
    var rx: Float64   # radians
    var ry: Float64
    var rz: Float64
    var s_ppm: Float64

def arcsec_to_rad(a: Float64) -> Float64:
    return a / 3600.0 * PI / 180.0

def helmert_forward(p: Vec3, h: HelmertParams) -> Vec3:
    # Small-angle rotation + scale + translation
    var s = 1.0 + h.s_ppm * 1e-6
    var X = p.x
    var Y = p.y
    var Z = p.z

    # small-angle rotation R applied to (X, Y, Z), component by component
    var xr = X - h.rz * Y + h.ry * Z
    var yr = h.rz * X + Y - h.rx * Z
    var zr = -h.ry * X + h.rx * Y + Z

    return Vec3(h.tx + s * xr, h.ty + s * yr, h.tz + s * zr)

def main():
    var h = HelmertParams(
        tx=-117.763, ty=-51.510, tz=139.061,
        rx=arcsec_to_rad(-0.1917),
        ry=arcsec_to_rad(-0.2220),
        rz=arcsec_to_rad(-0.2470),
        s_ppm=-0.191,
    )
    var src = Vec3(-4852421.0, 2560578.0, -3336862.0)
    var dst = helmert_forward(src, h)
    print("Transformed XYZ:", dst.x, dst.y, dst.z)
