from python import Python

def transform_to_zimbabwe_lo31(lat: Float64, lon: Float64) raises:
    var tm_mod = Python.import_module("geographiclib.transverse_mercator")
    # Clarke 1880 (Modified) for Arc 1950: a=6378249.145, f=1/293.465
    var tm = tm_mod.TransverseMercator(6378249.145, 1 / 293.465, k0=1.0)
    var res = tm.Forward(31.0, lat, lon)
    return (res[0], res[1], res[2])   # (southings, westings, k) — LO flips to S/W

def main() raises:
    var (s, w, k) = transform_to_zimbabwe_lo31(-17.829, 31.027)   # Harare
    print("Harare LO31 -> South:", s, "m  West:", w, "m")
