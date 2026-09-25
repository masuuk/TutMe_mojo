from std.python import Python

def main() raises:
    var tm_mod = Python.import_module("geographiclib.transverse_mercator")
    var tm = tm_mod.TransverseMercator(6378137, 1 / 298.257223563, k0=0.9996)

    var res = tm.Forward(0, 40.0, 6.0)     # (lon0, lat, lon) -> x, y, k, conv
    var x = res[0]
    var y = res[1]
    var k = res[2]
    var conv = res[3]

    var back = tm.Reverse(0, x, y)         # round-trip check
    print("E:", x, "m  N:", y, "m  k:", k, "conv:", conv)
    print("reverse lat/lon:", back[1], back[2])
