struct Grid:
    var a: Float64;  var f: Float64      # ellipsoid
    var k0: Float64; var fe: Float64     # scale at CM, false easting

def main():
    var utm36s = Grid(a=6378137.0,  f=1.0/298.257223563,
                      k0=0.9996, fe=500000.0)   # WGS84, N+/E+
    var lo31 = Grid(a=6378249.145, f=1.0/293.465,
                    k0=1.0, fe=0.0)             # Clarke 1880, S+/W+
    print("UTM 36S CM:", (36 - 1) * 6 + 3, "°E")   # 33°E
    print("LO 31 CM: 31°E — true origin, south/west positive")
