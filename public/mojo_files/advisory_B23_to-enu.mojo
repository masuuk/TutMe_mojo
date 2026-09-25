# WGS84 → local ENU, millions of points:
#   x = (λ − λ₀)·cos(φ₀)·R
#   y = (φ − φ₀)·R
#   z = h
def to_enu(lat: Tensor[Float64],
           lon: Tensor[Float64],
           h: Tensor[Float64], phi0: Float64,
           lam0: Float64, R: Float64)
           -> Tensor[Float64]:
    var n = lat.num_elements()
    var out = Tensor[Float64](n, 3)   # ENU triples
    comptime LANES = simdwidthof[DType.float64]()
    # pure arithmetic per point — no branches, no objects,
    # ideal for SIMD lanes and GPU dispatch (max.gpu)
    @parameter
    for i in range(n):
        var dphi = (lat[i] - phi0) * R       # north
        var dlam = (lon[i] - lam0) \
                   * cos(phi0) * R            # east
        out[i, 0] = dlam
        out[i, 1] = dphi
        out[i, 2] = h[i]                      # up
    return out
