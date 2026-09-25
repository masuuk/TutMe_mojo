# Mojo — backward pass with manual gradient computation
def backward(mut self, x: List[Float64], y: Float64,
             output: Float64, a1: List[Float64],
             z1: List[Float64]):
    var m = 1  # batch size (single sample)

    # Output layer gradients (binary cross-entropy + sigmoid)
    var dz2 = output - y  # (1,) shape
    var dW2 = List[Float64]()
    for i in range(self.n_hidden):
        dW2.append(dz2 * a1[i] / Float64(m))
    var db2 = [dz2 / Float64(m)]

    # Hidden layer gradients
    var da1 = List[Float64]()
    for i in range(self.n_hidden):
        da1.append(self.W2[i] * dz2)
    var dz1 = List[Float64]()
    for i in range(self.n_hidden):
        # ReLU derivative: 1 if z1 > 0, else 0
        var relu_grad = 1.0 if z1[i] > 0.0 else 0.0
        dz1.append(da1[i] * relu_grad)

    var dW1 = List[Float64]()
    for i in range(self.n_hidden):
        for j in range(self.n_features):
            dW1.append(dz1[i] * x[j] / Float64(m))
    var db1 = List[Float64]()
    for i in range(self.n_hidden):
        db1.append(dz1[i] / Float64(m))

    # Gradient descent update
    for i in range(len(self.W1)):
        self.W1[i] -= self.lr * dW1[i]
    for i in range(self.n_hidden):
        self.b1[i] -= self.lr * db1[i]
    for i in range(self.n_hidden):
        self.W2[i] -= self.lr * dW2[i]
    self.b2[0] -= self.lr * db2[0]
