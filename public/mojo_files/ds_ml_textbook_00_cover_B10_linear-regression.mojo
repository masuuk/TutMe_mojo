// Mojo — linear regression with gradient descent
def linear_regression(X: Tensor[Float32], y: Tensor[Float32],
    lr: Float32, epochs: Int) -> Tensor[Float32]:
    var n = X.shape(0)
    var p = X.shape(1)

    // Initialize weights to zero
    var w = Tensor[Float32](zeros([p, 1]))

    for epoch in range(epochs):
        // Forward pass: y_pred = X @ w
        var y_pred = matmul(X, w)

        // Gradient: (2/n) * X^T @ (y_pred - y)
        var grad = (2.0 / Float32(n)) *
            matmul(transpose(X), y_pred - y)

        // Update weights
        w = w - lr * grad

    return w
