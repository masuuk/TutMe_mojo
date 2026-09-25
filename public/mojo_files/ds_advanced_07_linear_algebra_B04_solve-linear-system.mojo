from math.linalg import (
    lu_decomposition,
    solve_triangular,
    matrix_inverse
)

def solve_linear_system(A: Matrix[Float64], b: Vector[Float64]) -> Vector[Float64]:
    // LU factorization with partial pivoting
    var (L, U, P) = lu_decomposition(A)

    // Solve Ly = Pb (forward substitution)
    var y = solve_triangular(L, P @ b, lower=True)

    // Solve Ux = y (back substitution)
    return solve_triangular(U, y, lower=False)


def matrix_norm(A: Matrix[Float64]) -> Float64:
    // Frobenius norm — fully vectorized
    return sqrt((A ** 2.0).sum())
