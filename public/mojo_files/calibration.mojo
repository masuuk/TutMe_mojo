# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/applications/geomatics/gnss_surveying.html
#  File:    calibration.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo calibration.mojo
# ============================================================================
from std.math import sqrt, atan2, abs

comptime PI: Float64 = 3.14159265358979323846

@fieldwise_init
struct Point2D:
    var e: Float64
    var n: Float64

@fieldwise_init
struct CalibResult:
    var a: Float64
    var b: Float64
    var tE: Float64
    var tN: Float64
    var scale: Float64
    var rot_deg: Float64

# Solve a 4x4 linear system (normal equations) by Gaussian elimination.
# A is 4x4, L is the right-hand side; returns the solution vector.
def solve4x4(A: List[List[Float64]], L: List[Float64]) -> List[Float64]:
    var n: Int = 4
    # build the augmented matrix [A | L]
    var M = List[List[Float64]]()
    for i in range(n):
        var row = List[Float64]()
        for j in range(n):
            row.append(A[i][j])
        row.append(L[i])
        M.append(row^)

    # forward elimination
    for k in range(n):
        # partial pivoting keeps the elimination stable
        var pivot = k
        for i in range(k + 1, n):
            if abs(M[i][k]) > abs(M[pivot][k]):
                pivot = i
        if pivot != k:
            var tmp = M[k].copy()
            M[k] = M[pivot].copy()
            M[pivot] = tmp^
        for i in range(k + 1, n):
            var factor = M[i][k] / M[k][k]
            for j in range(k, n + 1):
                M[i][j] = M[i][j] - factor * M[k][j]

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
    return x^

def calibrate_2d(local_pts: List[Point2D],
                global_pts: List[Point2D]) -> CalibResult:
    var n = len(local_pts)
    var ATA = List[List[Float64]]()
    var ATL = List[Float64]()
    for _ in range(4):
        var row = List[Float64]()
        for _ in range(4):
            row.append(0.0)
        ATA.append(row^)
    for _ in range(4):
        ATL.append(0.0)

    for i in range(n):
        var E = local_pts[i].e
        var N = local_pts[i].n
        var r1: List[Float64] = [E, -N, 1.0, 0.0]   # -> global E
        var r2: List[Float64] = [N,  E, 0.0, 1.0]   # -> global N
        var l1 = global_pts[i].e
        var l2 = global_pts[i].n

        # accumulate A^T A and A^T L from the two observation rows
        for p in range(4):
            for q in range(4):
                ATA[p][q] += r1[p]*r1[q] + r2[p]*r2[q]
            ATL[p] += r1[p]*l1 + r2[p]*l2

    var x = solve4x4(ATA, ATL)
    var a = x[0]
    var b = x[1]
    return CalibResult(
        a=a, b=b, tE=x[2], tN=x[3],
        scale=sqrt(a*a + b*b),
        rot_deg=atan2(b, a) * 180.0 / PI
    )

def main():
    var local_pts: List[Point2D] = [
        Point2D(100.000, 200.000),
        Point2D(1250.500, 180.200),
        Point2D(700.300, 1450.800)
    ]
    var global_pts: List[Point2D] = [
        Point2D(540123.456, 6234567.890),
        Point2D(541273.812, 6234542.104),
        Point2D(540719.331, 6235835.021)
    ]
    var r = calibrate_2d(local_pts, global_pts)
    print("a =", r.a, " b =", r.b)
    print("tE =", r.tE, " tN =", r.tN)
    print("Scale =", r.scale, " Rot (deg) =", r.rot_deg)
