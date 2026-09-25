def train_step(X: Tensor[Float64],
               y: Tensor[Float64],
               W1: Tensor[Float64],
               b1: Tensor[Float64],
               W2: Tensor[Float64],
               b2: Tensor[Float64],
               eta: Float64):
    # forward: z1 = X·W1 + b1 → ReLU → z2
    var z1 = matvec_bias(X, W1, b1)
    var a1 = relu(z1)
    var z2 = matvec_bias(a1, W2, b2)
    # backward: d2 = ∇ of MSE at the output
    var d2 = z2
    @parameter
    for i in range(d2.num_elements()):
        d2[i] = 2.0 * (z2[i] - y[i]) / M
    var gW2 = outer(a1, d2)          # ∂L/∂W2 = d2·a1ᵀ
    # chain rule one layer down, masked by ReLU grad
    var d1 = matvec_T(W2, d2)
    @parameter
    for i in range(d1.num_elements()):
        d1[i] *= relu_grad(z1[i])    # z1[i] > 0
    var gW1 = outer(X, d1)           # ∂L/∂W1 = d1·Xᵀ
    # SGD step: θ ← θ − η·∇J
    axpy(-eta, gW1, W1)
    axpy(-eta, gW2, W2)
