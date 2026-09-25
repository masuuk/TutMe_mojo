from std.math import sin, cos, radians

@fieldwise_init
struct Vec3:
    var x: Float64
    var y: Float64
    var z: Float64

@fieldwise_init
struct ENU:
    var e: Float64
    var n: Float64
    var u: Float64

def ecef_delta_to_enu(d: Vec3, lat0_deg: Float64, lon0_deg: Float64) -> ENU:
    """
    Rotate an ECEF difference vector into the local horizon frame
    at (lat0_deg, lon0_deg). Same rotation as the NumPy version,
    expanded component by component so no matrix library is needed.
    """
    var lat0 = radians(lat0_deg)
    var lon0 = radians(lon0_deg)
    var sin_lat = sin(lat0)
    var cos_lat = cos(lat0)
    var sin_lon = sin(lon0)
    var cos_lon = cos(lon0)

    # row 1 of R: east = -sin(lon)*dX + cos(lon)*dY
    var e = -sin_lon * d.x + cos_lon * d.y
    # row 2 of R: north = -sin(lat)cos(lon)*dX - sin(lat)sin(lon)*dY + cos(lat)*dZ
    var n = -sin_lat*cos_lon * d.x - sin_lat*sin_lon * d.y + cos_lat * d.z
    # row 3 of R: up = cos(lat)cos(lon)*dX + cos(lat)sin(lon)*dY + sin(lat)*dZ
    var u =  cos_lat*cos_lon * d.x + cos_lat*sin_lon * d.y + sin_lat * d.z
    return ENU(e, n, u)

def main():
    # a 100 m step along the ECEF X axis, seen from 45 N, 8 E:
    # mostly north with a small up component, as expected at mid-latitude
    var enu = ecef_delta_to_enu(Vec3(100.0, 0.0, 0.0), 45.0, 8.0)
    print("ENU (m):", enu.e, enu.n, enu.u)
