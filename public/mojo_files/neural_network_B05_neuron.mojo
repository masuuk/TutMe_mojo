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
