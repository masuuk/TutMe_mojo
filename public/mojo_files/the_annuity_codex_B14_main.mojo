# No dependency needed — the factors are two lines each (see above).
# mojoproject.toml has no [dependencies] section at all.

def main():
    var pmt = 200.0
    var r = 0.07 / 12.0
    var n = 240

    print("FV = $", fv_annuity(pmt, r, n))
    print("PV = $", pv_annuity(pmt, r, n))
