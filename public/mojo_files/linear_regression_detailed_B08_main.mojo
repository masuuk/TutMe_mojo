from std.python import Python

def main():
    var np = Python.import_module("numpy")

    # synthetic 50×5 data
    var X = np.random.randn(50, 5)
    var y = 2.0 * X[:, 0] - 1.5 * X[:, 1] + 0.5 * np.random.randn(50)

    # Ridge closed form: β = (XᵀX + αI)⁻¹ Xᵀ y
    var alpha = 1.0
    var XtX = X.T @ X
    var XtX_reg = XtX + alpha * np.eye(X.shape[1])
    var beta = np.linalg.inv(XtX_reg) @ X.T @ y
    print("Ridge coeff:", beta)
