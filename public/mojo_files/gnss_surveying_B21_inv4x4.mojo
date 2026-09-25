from std.math import sqrt, abs

# Invert a 4x4 matrix by Gauss-Jordan elimination with partial pivoting.
# The matrix is extended with the identity to the right; after full
# reduction the right half holds the inverse.
def inv4x4(mut M: List[List[Float64]]) -> List[List[Float64]]:
    var n: Int = 4
    var A = List[List[Float64]]()
    for i in range(n):
        var row = List[Float64]()
        for j in range(n):
            row.append(M[i][j])
        for j in range(n):
            row.append(1.0 if i == j else 0.0)
        A.append(row)

    for col in range(n):
        # partial pivoting: strongest pivot keeps the division stable
        var pivot = col
        for r in range(col + 1, n):
            if abs(A[r][col]) > abs(A[pivot][col]):
                pivot = r
        var tmp = A[col]
        A[col] = A[pivot]
        A[pivot] = tmp

        # normalise the pivot row
        var pval = A[col][col]
        for j in range(col, 2 * n):
            A[col][j] = A[col][j] / pval

        # eliminate this column from every other row
        for r in range(n):
            if r != col:
                var factor = A[r][col]
                for j in range(col, 2 * n):
                    A[r][j] = A[r][j] - factor * A[col][j]

    # extract the right half — the inverse
    var inv = List[List[Float64]]()
    for i in range(n):
        var row = List[Float64]()
        for j in range(n, 2 * n):
            row.append(A[i][j])
        inv.append(row)
    return inv

def main():
    # Same geometry matrix as the Python example: unit line-of-sight
    # vectors, each extended with a receiver-clock column of 1.0.
    var G: List[List[Float64]] = [
        [ 0.7,  0.2, 0.68, 1.0],
        [-0.4,  0.8, 0.45, 1.0],
        [ 0.1, -0.9, 0.42, 1.0],
        [-0.8, -0.2, 0.56, 1.0],
    ]

    # Cofactor matrix Q = (G^T G)^-1, formed explicitly (4x4)
    var GtG = List[List[Float64]]()
    for p in range(4):
        var row = List[Float64]()
        for q in range(4):
            var acc: Float64 = 0.0
            for i in range(4):
                acc += G[i][p] * G[i][q]
            row.append(acc)
        GtG.append(row)

    var Q = inv4x4(GtG)
    var pdop = sqrt(Q[0][0] + Q[1][1] + Q[2][2])
    var tdop = sqrt(Q[3][3])
    var gdop = sqrt(Q[0][0] + Q[1][1] + Q[2][2] + Q[3][3])

    print("PDOP =", pdop)
    print("TDOP =", tdop)
    print("GDOP =", gdop)
