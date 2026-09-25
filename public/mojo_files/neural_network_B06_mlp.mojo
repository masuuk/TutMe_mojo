struct MLP(Copyable):
    var W1: Matrix
    var b1: List[Float64]
    var W2: Matrix
    var b2: List[Float64]
    var z1: Matrix
    var a1: Matrix
    var z2: Matrix
    var a2: Matrix
    var dW1: Matrix
    var db1: List[Float64]
    var dW2: Matrix
    var db2: List[Float64]

    def __init__(out self, seed: UInt64 = 7):
        self.W1 = Matrix.uniform(2, 2, seed, 0.5)
        self.b1 = List[Float64](2, 0.0)
        var rng = Prng(seed + 2)
        for i in range(2):
            self.b1[i] = rng.lower(0.5)
        self.W2 = Matrix.uniform(1, 2, seed + 4, 0.5)
        self.b2 = List[Float64](1, 0.0)
        self.b2[0] = rng.lower(0.5)
        self.z1 = Matrix.zeros(2, 1)
        self.a1 = Matrix.zeros(2, 1)
        self.z2 = Matrix.zeros(1, 1)
        self.a2 = Matrix.zeros(1, 1)
        self.dW1 = Matrix.zeros(2, 2)
        self.db1 = List[Float64](2, 0.0)
        self.dW2 = Matrix.zeros(1, 2)
        self.db2 = List[Float64](1, 0.0)

    def forward(mut self, inputs: List[Float64]) -> Float64:
        var x = column(inputs)
        self.z1 = add_bias(mul(self.W1, x), self.b1)
        self.a1 = relu_activation(self.z1)
        self.z2 = add_bias(mul(self.W2, self.a1), self.b2)
        self.a2 = sigmoid_activation(self.z2)
        return self.a2[0, 0]

    def predict(self, inputs: List[Float64]) -> Float64:
        var x = column(inputs)
        var z1 = add_bias(mul(self.W1, x), self.b1)
        var a1 = relu_activation(z1)
        var z2 = add_bias(mul(self.W2, a1), self.b2)
        return sigmoid_activation(z2)[0, 0]

    def backward(mut self, inputs: List[Float64], target: Float64):
        self.forward(inputs)
        var x = column(inputs)
        var delta2 = elementwise(self.a2, add_scalar(scale(self.a2, -1.0), target))
        self.dW2 = outer(delta2, self.a1)
        self.db2 = List[Float64](1, 0.0)
        self.db2[0] = delta2[0, 0]
        var d_z1 = elementwise(mul(transpose(self.W2), delta2), relu_mask(self.z1))
        self.dW1 = outer(d_z1, x)
        self.db1 = List[Float64](2, 0.0)
        for i in range(2):
            self.db1[i] = d_z1[i, 0]

    def update(mut self, lr: Float64):
        self.W1 = add_mul(self.W1, self.dW1, -lr)
        for i in range(2):
            self.b1[i] -= lr * self.db1[i]
        self.W2 = add_mul(self.W2, self.dW2, -lr)
        self.b2[0] -= lr * self.db2[0]

    def mse(self, xs: List[List[Float64]], ys: List[Float64]) -> Float64:
        var total: Float64 = 0.0
        for i in range(len(ys)):
            total += mse_loss(self.predict(xs[i]), ys[i])
        return total / Float64(len(ys))

    def train(mut self, xs: List[List[Float64]], ys: List[Float64], epochs: Int, lr: Float64):
        for epoch in range(epochs):
            for i in range(len(ys)):
                self.backward(xs[i], ys[i])
                self.update(lr)
            if epoch == 0 or (epoch + 1) % 500 == 0:
                print(t"epoch {epoch + 1}: loss {self.mse(xs, ys)}")
