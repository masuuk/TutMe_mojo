# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/applications/geomatics/gnss_surveying.html
#  File:    gps.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo gps.mojo
# ============================================================================
from std.math import sqrt

@fieldwise_init
struct Sat:
    var x: Float64
    var y: Float64
    var z: Float64

@fieldwise_init
struct Fix:
    var x: Float64
    var y: Float64
    var z: Float64
    var clock_bias_m: Float64

# Solve 4x4 augmented normal equations by Gauss elimination (in place)
def solve4x4(mut M: List[List[Float64]]) -> List[Float64]:
    var n: Int = 4
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
    return x^

def gps_fix(sats: List[Sat], pr: List[Float64],
           tol: Float64 = 1e-4, max_iter: Int = 10) -> Fix:
    var n = len(sats)
    var x: Float64 = 0.0
    var y: Float64 = 0.0
    var z: Float64 = 0.0
    var dt: Float64 = 0.0

    for _ in range(max_iter):
        # Geometric ranges & Jacobian rows
        var H = List[List[Float64]]()
        var b = List[Float64]()
        for i in range(n):
            var dx = sats[i].x - x
            var dy = sats[i].y - y
            var dz = sats[i].z - z
            var r  = sqrt(dx*dx + dy*dy + dz*dz)
            var row: List[Float64] = [-dx/r, -dy/r, -dz/r, 1.0]
            H.append(row^)
            b.append(pr[i] - (r + dt))

        # Normal equations: H^T H dx = H^T b (augmented 4x5)
        var M = List[List[Float64]]()
        for _ in range(4):
            var mrow = List[Float64]()
            for _ in range(5):
                mrow.append(0.0)
            M.append(mrow^)
        for i in range(n):
            for p in range(4):
                for q in range(4):
                    M[p][q] += H[i][p] * H[i][q]
                M[p][4] += H[i][p] * b[i]

        # Newton-style update: linearise, solve, apply correction
        var delta = solve4x4(M)
        x  += delta[0]
        y  += delta[1]
        z  += delta[2]
        dt += delta[3]

        # convergence check on the positional part of the correction
        var step = sqrt(delta[0]*delta[0] + delta[1]*delta[1] + delta[2]*delta[2])
        if step < tol:
            break

    return Fix(x=x, y=y, z=z, clock_bias_m=dt)

def main():
    var sats: List[Sat] = [
        Sat( 1.5e7,  0.0,    2.0e7),
        Sat( 0.0,    1.5e7,  2.0e7),
        Sat(-1.5e7,  0.0,    2.0e7),
        Sat( 0.0,   -1.5e7,  2.0e7)
    ]
    var tx: Float64 = 1000.0
    var ty: Float64 = 2000.0
    var tz: Float64 = 6370000.0
    var true_bias: Float64 = 50.0

    # simulate consistent pseudoranges from the true position
    var pr = List[Float64]()
    for i in range(4):
        var dx = sats[i].x - tx
        var dy = sats[i].y - ty
        var dz = sats[i].z - tz
        pr.append(sqrt(dx*dx + dy*dy + dz*dz) + true_bias)

    var sol = gps_fix(sats, pr)
    print("ECEF fix:", sol.x, sol.y, sol.z, "dt =", sol.clock_bias_m, "m")
