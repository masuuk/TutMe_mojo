from std.math import exp


def step(x: Float64) -> Float64:
    return 1.0 if x >= 0.0 else 0.0


def relu(x: Float64) -> Float64:
    return x if x > 0.0 else 0.0


def sigmoid(x: Float64) -> Float64:
    return 1.0 / (1.0 + exp(-x))


def sigmoid_derivative(a: Float64) -> Float64:
    return a * (1.0 - a)


def mse_loss(predicted: Float64, target: Float64) -> Float64:
    var diff = predicted - target
    return diff * diff
struct Prng(Copyable):
    var state: UInt64

    def __init__(out self, seed: UInt64 = 42):
        self.state = seed

    def next_float(mut self) -> Float64:
        self.state ^= self.state << 13
        self.state ^= self.state >> 7
        self.state ^= self.state << 17
        return Float64(self.state) / 18446744073709551616.0

    def lower(mut self, scale: Float64) -> Float64:
        return self.next_float() * scale
@fieldwise_init
struct Matrix(Copyable):
    var rows: Int
    var cols: Int
    var data: List[Float64]

    def __getitem__(self, r: Int, c: Int) -> Float64:
        return self.data[r * self.cols + c]

    def __setitem__(mut self, r: Int, c: Int, value: Float64):
        self.data[r * self.cols + c] = value

    @staticmethod
    def zeros(rows: Int, cols: Int) -> Matrix:
        return Matrix(rows, cols, List[Float64](rows * cols, 0.0))

    @staticmethod
    def uniform(rows: Int, cols: Int, seed: UInt64 = 42, scale: Float64 = 1.0) -> Matrix:
        var rng = Prng(seed)
        var data = List[Float64]()
        for _ in range(rows * cols):
            data.append(rng.lower(scale))
        return Matrix(rows, cols, data)
def mul(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for k in range(b.cols):
            var total: Float64 = 0.0
            for j in range(a.cols):
                total += a[i, j] * b[j, k]
            out.append(total)
    return Matrix(a.rows, b.cols, out)


def add_bias(z: Matrix, b: List[Float64]) -> Matrix:
    var out = List[Float64]()
    for i in range(z.rows):
        out.append(z[i, 0] + b[i])
    return Matrix(z.rows, 1, out)


def transpose(a: Matrix) -> Matrix:
    var out = List[Float64]()
    for c in range(a.cols):
        for r in range(a.rows):
            out.append(a[r, c])
    return Matrix(a.cols, a.rows, out)


def outer(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(b.rows):
            out.append(a[i, 0] * b[j, 0])
    return Matrix(a.rows, b.rows, out)


def elementwise(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] * b[i, j])
    return Matrix(a.rows, a.cols, out)


def scale(a: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] * s)
    return Matrix(a.rows, a.cols, out)


def add_scalar(a: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] + s)
    return Matrix(a.rows, a.cols, out)


def add_mul(a: Matrix, b: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] + s * b[i, j])
    return Matrix(a.rows, a.cols, out)


def column(vals: List[Float64]) -> Matrix:
    var out = List[Float64]()
    for i in range(len(vals)):
        out.append(vals[i])
    return Matrix(len(vals), 1, out)


def relu_activation(m: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(m.rows):
        for j in range(m.cols):
            out.append(relu(m[i, j]))
    return Matrix(m.rows, m.cols, out)


def sigmoid_activation(m: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(m.rows):
        for j in range(m.cols):
            out.append(sigmoid(m[i, j]))
    return Matrix(m.rows, m.cols, out)


def relu_mask(z: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(z.rows):
        for j in range(z.cols):
            out.append(1.0 if z[i, j] > 0.0 else 0.0)
    return Matrix(z.rows, z.cols, out)
struct Neuron(Copyable):
    var weights: List[Float64]
    var bias: Float64
    var activate: def (raw: Float64) thin -> Float64

    def __init__(
        out self, weights: List[Float64], bias: Float64,
        activate: def (raw: Float64) thin -> Float64,
    ):
        self.weights = weights
        self.bias = bias
        self.activate = activate

    @staticmethod
    def sigmoid(n_inputs: Int, seed: UInt64 = 42) -> Self:
        var rng = Prng(seed)
        var weights = List[Float64]()
        for _ in range(n_inputs):
            weights.append(rng.lower(1.0))
        return Self(weights, rng.lower(1.0), sigmoid)

    @staticmethod
    def gate(weights: List[Float64], bias: Float64) -> Self:
        return Self(weights, bias, step)

    def weighted_sum(self, inputs: List[Float64]) -> Float64:
        var total = self.bias
        for i in range(len(inputs)):
            total += inputs[i] * self.weights[i]
        return total

    def predict(self, inputs: List[Float64]) -> Float64:
        return self.activate(self.weighted_sum(inputs))

    def train_step(mut self, xs: List[Float64], target: Float64, lr: Float64) -> Float64:
        var out = self.activate(self.weighted_sum(xs))
        var error = target - out
        var slope = sigmoid_derivative(out)
        for i in range(len(xs)):
            self.weights[i] += lr * error * slope * xs[i]
        self.bias += lr * error * slope
        return out

    def train(mut self, xs: List[List[Float64]], ys: List[Float64], epochs: Int, lr: Float64):
        for epoch in range(epochs):
            var loss: Float64 = 0.0
            for i in range(len(ys)):
                var out = self.train_step(xs[i], ys[i], lr)
                loss += mse_loss(out, ys[i])
            if epoch == 0 or (epoch + 1) % 500 == 0:
                print(t"epoch {epoch + 1}: loss {loss / Float64(len(ys))}")
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
def main():
    print("== logical gates with hand-picked step weights ==")
    var and_gate = Neuron.gate([1.0, 1.0], -1.5)
    var or_gate = Neuron.gate([1.0, 1.0], -0.5)
    var not_gate = Neuron.gate([-1.0], 1.0)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print(p[0], p[1], "AND", and_gate.predict(p), "OR", or_gate.predict(p))
    print("NOT 0 ->", not_gate.predict([0.0]), " NOT 1 ->", not_gate.predict([1.0]))

    print("== train a single sigmoid neuron on AND ==")
    var and_xs = List[List[Float64]]()
    var and_ys = List[Float64]()
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        and_xs.append([p[0], p[1]])
        and_ys.append(1.0 if p[0] == 1.0 and p[1] == 1.0 else 0.0)
    var and_neuron = Neuron.sigmoid(2, 11)
    and_neuron.train(and_xs, and_ys, 3000, 0.7)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("AND", p[0], p[1], "->", and_neuron.predict(p))

    print("== one sigmoid neuron cannot learn XOR ==")
    var xor_xs = List[List[Float64]]()
    var xor_ys = List[Float64]()
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        xor_xs.append([p[0], p[1]])
        xor_ys.append(1.0 if p[0] != p[1] else 0.0)
    var lone_neuron = Neuron.sigmoid(2, 13)
    lone_neuron.train(xor_xs, xor_ys, 2000, 0.7)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("XOR", p[0], p[1], "->", lone_neuron.predict(p))

    print("== 2-2-1 MLP learns XOR ==")
    var mlp = MLP(7)
    mlp.train(xor_xs, xor_ys, 6000, 0.5)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("XOR", p[0], p[1], "->", mlp.predict(p))
    print("final mean squared error:", mlp.mse(xor_xs, xor_ys))
