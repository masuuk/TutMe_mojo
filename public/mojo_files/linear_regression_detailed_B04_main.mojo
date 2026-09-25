from std.python import Python

def main():
    var np = Python.import_module("numpy")

    var X = np.array([[1, 2], [2, 3], [3, 4], [4, 5]])
    var y = np.array([3, 5, 7, 9])

    # add ones column
    var X_b = np.column_stack([np.ones(X.shape[0]), X])

    # closed form: β = (XᵀX)⁻¹ Xᵀ y
    var beta = np.linalg.inv(X_b.T @ X_b) @ X_b.T @ y

    print("β =", beta)  # [1. 0. 2.] → y = 1 + 0·x₁ + 2·x₂

    # numerically stable alternative
    var beta2 = np.linalg.lstsq(X_b, y, rcond=None)[0]
