from math import sqrt, sin, cos, atan2, atanh, sinh, cosh, radians

def conformal_latitude(phi: Float64, f: Float64) -> Float64:
    var e2 = 2.0 * f - f * f
    var e = sqrt(e2)
    var sin_phi = sin(phi)
    return atan2(sqrt(1.0 - e2) * sin_phi, cos(phi)) - e * atanh(e * sin_phi)

def forward_tm(phi: Float64, lambda_: Float64, lambda0: Float64,
               f: Float64, k0: Float64 = 0.9996) -> (Float64, Float64):
    var a = 6378137.0                       # WGS84
    var e2 = 2.0 * f - f * f
    var dlambda = lambda_ - lambda0
    var chi = conformal_latitude(phi, f)
    var n = f / (2.0 - f)
    var N0 = a / sqrt(1.0 - e2)
    var sin_chi = sin(chi)
    var cos_chi = cos(chi)
    var sinh_xi = sinh(dlambda * cos_chi)
    var cosh_xi = cosh(dlambda * cos_chi)
    var x = k0 * N0 * ((n / 2.0) * sin_chi * cosh_xi
                     + (n * n / 8.0) * sin(2.0 * chi) * sinh_xi
                     + (n * n * n / 48.0) * sin(3.0 * chi) * cosh_xi)
    var y = k0 * N0 * ((n / 2.0) * cos_chi * sinh_xi
                     + (n * n / 8.0) * cos(2.0 * chi) * cosh_xi)
    return (x, y)

def main():
    var phi = radians(-17.8252)             # Harare -> UTM 36S (CM 33E)
    var lon = radians(31.0335)
    var lambda0 = radians(33.0)
    var (E, N) = forward_tm(phi, lon, lambda0, 1.0 / 298.257223563)
    print("Easting:", E, "m  Northing:", N, "m")
