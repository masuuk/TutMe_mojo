# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/applications/geomatics/gnss_surveying.html
#  File:    coordinate_transform.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo coordinate_transform.mojo
# ============================================================================
from std.math import sqrt, sin, cos, atan2, hypot, abs

comptime PI: Float64 = 3.14159265358979323846

def radians(deg: Float64) -> Float64:
    return deg * PI / 180.0

def degrees(rad: Float64) -> Float64:
    return rad * 180.0 / PI

comptime A: Float64 = 6378137.0
comptime F: Float64 = 1.0 / 298.257223563
comptime E2: Float64 = 2.0 * F - F * F

def geodetic_to_ecef(lat_deg: Float64, lon_deg: Float64, h: Float64)
        -> Tuple[Float64, Float64, Float64]:
    var lat = radians(lat_deg)
    var lon = radians(lon_deg)
    var sin_lat = sin(lat)
    var cos_lat = cos(lat)
    var sin_lon = sin(lon)
    var cos_lon = cos(lon)

    # prime-vertical radius of curvature
    var N = A / sqrt(1.0 - E2 * sin_lat * sin_lat)

    var x = (N + h) * cos_lat * cos_lon
    var y = (N + h) * cos_lat * sin_lon
    var z = (N * (1.0 - E2) + h) * sin_lat
    return (x, y, z)

def ecef_to_geodetic(x: Float64, y: Float64, z: Float64)
        -> Tuple[Float64, Float64, Float64]:
    var lon = atan2(y, x)
    var p = hypot(x, y)
    var lat = atan2(z, p * (1.0 - E2))
    var h: Float64 = 0.0
    for _ in range(10):
        var sin_lat = sin(lat)
        var N = A / sqrt(1.0 - E2 * sin_lat * sin_lat)
        h = p / cos(lat) - N
        var lat_new = atan2(z, p * (1.0 - E2 * N / (N + h)))
        if abs(lat_new - lat) < 1e-12:
            break
        lat = lat_new
    return (degrees(lat), degrees(lon), h)

def main():
    var x, y, z = geodetic_to_ecef(45.9764, 7.6586, 4478.0)
    print("ECEF:", x, y, z)
    var lat2, lon2, h2 = ecef_to_geodetic(x, y, z)
    print("Back:", lat2, "deg", lon2, "deg", h2, "m")
