from std.math import sqrt

def main():
    var a = 6378137.0                # WGS84 semi-major axis (m)
    var f = 1.0 / 298.257223563      # flattening
    var e2 = 2.0 * f - f * f         # first eccentricity squared
    var ep2 = e2 / (1.0 - e2)        # second eccentricity squared
    var n = f / (2.0 - f)            # third flattening
    var b = a * (1.0 - f)            # semi-minor axis
    print("e²  =", e2)               # 0.006694380022903
    print("e'² =", ep2)              # 0.0820944737957
    print("n   =", n)                # 0.001679220386384
    print("b   =", b, "m")           # 6356752.314245 m
