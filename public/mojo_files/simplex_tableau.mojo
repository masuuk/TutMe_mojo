# Extracted from tutorials on this site (source: simplex_algorithm.html #8)
# https://github.com/masuuk/TutMe/blob/main/tui/public/applications/operations_research/simplex_algorithm.html

# simplex.mojo -- tableau-form primal simplex for standard-form LPs:
#   maximize c^T x  subject to  A x <= b,  x >= 0,  b >= 0
# Mojo 1.x (Modular 26.5) -- def functions, `var` bindings, List[Float64].

def solve(c: List[Float64], A: List[List[Float64]], b: List[Float64]) raises -> Tuple[List[Float64], Float64, Int]:
    var m = len(A)                       # constraint rows
    var n = len(c)                       # structural variables
    var ncols = n + m + 1                # tableau columns, RHS included

    # ---- build the tableau: [ A | I | b ], one row at a time ----
    var T = List[List[Float64]]()
    for i in range(m):
        var row = A[i].copy()            # List isn't implicitly copyable
        for k in range(m):
            row.append(1.0 if k == i else 0.0)   # slack identity block
        row.append(b[i])                 # RHS
        T.append(row^)                   # ^ hands ownership of row to T

    var obj: List[Float64] = [-v for v in c]     # comprehension: negated objective
    for _ in range(m + 1):
        obj.append(0.0)                  # slack columns + RHS start at zero
    T.append(obj^)

    var basis = List[Int]()
    for i in range(m):
        basis.append(n + i)              # slacks are the starting basis

    # ---- pivot loop: Dantzig entering, ratio test + Bland tie-break leaving ----
    var iteration = 0
    while True:
        var col = -1                     # entering column: most negative
        var best = -1e-10                # ... objective-row coefficient
        for j in range(n + m):
            if T[m][j] < best:
                best = T[m][j]
                col = j
        if col == -1:
            break                        # optimal: no negative reduced cost remains

        var row = -1                     # leaving row: minimum ratio
        var best_ratio = 1e30
        for i in range(m):
            if T[i][col] > 1e-10:        # only positive entries can block
                var ratio = T[i][ncols - 1] / T[i][col]
                if ratio < best_ratio - 1e-12 or (
                    ratio < best_ratio + 1e-12 and (row == -1 or basis[i] < basis[row])
                ):
                    best_ratio = ratio   # strict improvement, or a tie won
                    row = i              # ... by the smaller basis index (Bland)
        if row == -1:
            raise Error("Problem is unbounded")

        var pivot = T[row][col]          # normalize the pivot row...
        for k in range(ncols):
            T[row][k] = T[row][k] / pivot
        for i in range(m + 1):           # ...and Gauss-Jordan the column
            if i != row:
                var factor = T[i][col]
                if abs(factor) > 1e-12:
                    for k in range(ncols):
                        T[i][k] = T[i][k] - factor * T[row][k]
        basis[row] = col
        iteration += 1

    # ---- read the solution off the final tableau ----
    var solution: List[Float64] = [0.0 for _ in range(n)]   # nonbasic vars stay 0
    for i in range(m):
        if basis[i] < n:                 # a structural variable in the basis
            solution[basis[i]] = T[i][ncols - 1]    # ... takes the row's RHS

    return (solution^, T[m][ncols - 1], iteration)  # x, Z, pivots


def main() raises:
    # Example A -- Wyndor Glass Co. (section 4): list literals keep it short
    var c1: List[Float64] = [3.0, 5.0]
    var A1: List[List[Float64]] = [[1.0, 0.0], [0.0, 2.0], [3.0, 2.0]]
    var b1: List[Float64] = [4.0, 12.0, 18.0]
    var (x1, z1, k1) = solve(c1, A1, b1)
    print("Example A: x =", x1[0], x1[1], " Z =", z1, " pivots =", k1)

    # Example B -- three-variable production problem (section 4)
    var c2: List[Float64] = [5.0, 4.0, 3.0]
    var A2: List[List[Float64]] = [[2.0, 3.0, 1.0], [4.0, 1.0, 2.0], [3.0, 4.0, 2.0]]
    var b2: List[Float64] = [5.0, 11.0, 8.0]
    var (x2, z2, k2) = solve(c2, A2, b2)
    print("Example B: x =", x2[0], x2[1], x2[2], " Z =", z2, " pivots =", k2)
