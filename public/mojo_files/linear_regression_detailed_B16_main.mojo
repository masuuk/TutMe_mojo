from std.python import Python

def main():
    var np = Python.import_module("numpy")
    np.random.seed(42)
    var n = 200

    var TV = np.random.uniform(0, 300, n)
    var radio = np.random.uniform(0, 80, n)
    var newspaper = np.random.uniform(0, 60, n)
    var sales = 5.0 + 0.045 * TV + 0.18 * radio + 0.01 * newspaper + 2.0 * np.random.randn(n)

    var X = np.column_stack([TV, radio, newspaper])
    var y = sales

    # closed form: β = (XᵀX)⁻¹ Xᵀ y
    var beta = np.linalg.inv(X.T @ X) @ X.T @ y
    var y_pred = X @ beta
    var mae = np.mean(np.abs(y - y_pred))

    print("Coeffs:", beta)
    print("MAE:", mae)
