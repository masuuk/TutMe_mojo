from std.math import sqrt

def main():
    # Small, dependency-light residual calculation on three check points
    var ve1 = 0.010;  var vn1 = 0.020
    var ve2 = 0.030;  var vn2 = 0.010
    var ve3 = 0.000;  var vn3 = 0.040

    # per-point horizontal error = sqrt(vE^2 + vN^2)
    var e1 = sqrt(ve1*ve1 + vn1*vn1)
    var e2 = sqrt(ve2*ve2 + vn2*vn2)
    var e3 = sqrt(ve3*ve3 + vn3*vn3)

    # RMSE over the check set
    var rmse = sqrt((e1*e1 + e2*e2 + e3*e3) / 3.0)

    print("Errors:", e1, e2, e3)
    print("RMSE:", rmse)
