# 6-parameter affine from GCPs via 6x6 normal equations
@fieldwise_init
struct GCP:
    var col: Float64
    var row: Float64
    var X:   Float64
    var Y:   Float64

@fieldwise_init
struct Affine6:
    var A: Float64   # pixel width
    var B: Float64   # row rotation
    var C: Float64   # X of upper-left centre
    var D: Float64   # col rotation
    var E: Float64   # pixel height (negative)
    var F: Float64   # Y of upper-left centre

# Solve an augmented 6x7 system M by Gauss elimination (last col = RHS).
# `mut` marks the argument as mutated in place — Mojo arguments are
# immutable by default in 1.0.
def solve6x6(mut M: List[List[Float64]]) -> List[Float64]:
    var n: Int = 6
    # forward elimination
    for k in range(n):
        for i in range(k + 1, n):
            var f = M[i][k] / M[k][k]
            for j in range(k, n + 1):
                M[i][j] = M[i][j] - f * M[k][j]
    # back substitution
    var x = List[Float64]()
    for _ in range(n):
        x.append(0.0)
    for ii in range(n):
        var i = n - 1 - ii
        var s: Float64 = M[i][n]
        for j in range(i + 1, n):
            s = s - M[i][j] * x[j]
        x[i] = s / M[i][i]
    return x

def fit_affine(gcps: List[GCP]) -> Affine6:
    # Build normal equations for 6 unknowns (augmented 6x7)
    var M = List[List[Float64]]()
    for _ in range(6):
        var row = List[Float64]()
        for _ in range(7):
            row.append(0.0)
        M.append(row)

    for g in gcps:
        # X equation: [c, r, 1, 0, 0, 0 | X]
        # one row per coordinate equation, augmented with the RHS value
        var r1: List[Float64] = [g.col, g.row, 1.0, 0.0, 0.0, 0.0, g.X]
        # Y equation: [0, 0, 0, c, r, 1 | Y]
        var r2: List[Float64] = [0.0, 0.0, 0.0, g.col, g.row, 1.0, g.Y]
        for p in range(6):
            for q in range(6):
                M[p][q] += r1[p]*r1[q] + r2[p]*r2[q]
            M[p][6] += r1[p]*r1[6] + r2[p]*r2[6]

    var x = solve6x6(M)
    return Affine6(A=x[0], B=x[1], C=x[2], D=x[3], E=x[4], F=x[5])

def main():
    var gcps: List[GCP] = [
        GCP(    0.0,    0.0, 540000.0, 6235000.0),
        GCP(10000.0,    0.0, 540100.0, 6235000.0),
        GCP(    0.0, 8000.0, 540000.0, 6234920.0),
        GCP(10000.0, 8000.0, 540100.0, 6234920.0)
    ]
    var a = fit_affine(gcps)
    print("Affine params:", a.A, a.B, a.C, a.D, a.E, a.F)
