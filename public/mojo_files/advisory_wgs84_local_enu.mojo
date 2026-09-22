# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/mojo_v1/advisory.html
#  File:    advisory_wgs84_local_enu.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo advisory_wgs84_local_enu.mojo
# ============================================================================
from std.math import cos

# WGS84 → local ENU, millions of points:
#   x = (λ − λ₀)·cos(φ₀)·R
#   y = (φ − φ₀)·R
#   z = h
def to_enu(lat: List[Float64],
           lon: List[Float64],
           h: List[Float64], phi0: Float64,
           lam0: Float64, R: Float64)
           -> List[List[Float64]]:
    var n = len(lat)
    var out = List[List[Float64]]()
    # pure arithmetic per point — no branches, no objects,
    # ideal for SIMD lanes and GPU dispatch (max.gpu)
    for i in range(n):
        var dphi = (lat[i] - phi0) * R       # north
        var dlam = (lon[i] - lam0) \
                   * cos(phi0) * R            # east
        var row = List[Float64]()
        row.append(dlam)
        row.append(dphi)
        row.append(h[i])                      # up
        out.append(row^)
    return out^

def main():
    var lat: List[Float64] = [40.0]; var lon: List[Float64] = [-105.0]
    var hh: List[Float64] = [1600.0]
    print(to_enu(lat, lon, hh, 40.0, -105.0, 6378137.0))
