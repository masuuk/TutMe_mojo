# ============================================================================
#  A single sigmoid neuron that learns to ADD — Mojo 1.x
#
#  Faithful port of the classic Rust perceptron demo (Faisal Arshed, "Building
#  a Neural Network in Rust (From Scratch)"): online updates with
#      error  = target - output
#      delta  = output * (1 - output)      # sigmoid derivative
#      w[j]  += lr * error * input[j] * delta
#      bias  += lr * error * delta
#  Here we train on a deterministic grid of pairs and test on the same 25
#  inputs the Rust tutorial prints.
#
#  Run with:   mojo perceptron_add.mojo
# ============================================================================
from std.math import exp, floor, min, max

# ---------------------------------------------------------------- PRNG ----
struct XorShift:
    """Xorshift64* pseudo-random generator (deterministic, reproducible)."""

    var state: UInt64

    def __init__(out self, seed: UInt64):
        self.state = seed
        if self.state == 0:
            self.state = 88172645463325252
        for _ in range(10):
            _ = self.next_u64()

    def next_u64(mut self) -> UInt64:
        var s = self.state
        s ^= s << 13
        s ^= s >> 7
        s ^= s << 17
        self.state = s
        return s

    def next_f64(mut self) -> Float64:
        return Float64(self.next_u64() >> 11) / Float64(1 << 53)


# ----------------------------------------------------------- perceptron ----
struct Perceptron:
    """One sigmoid neuron: output = sigma(w . x + b)."""

    var w: List[Float64]  # two weights, one per input
    var bias: Float64
    var learning_rate: Float64

    def __init__(out self, mut rng: XorShift, learning_rate: Float64):
        self.w = List[Float64]()
        for _ in range(2):
            self.w.append(rng.next_f64())
        self.bias = rng.next_f64()
        self.learning_rate = learning_rate

    def predict(self, x0: Float64, x1: Float64) -> Float64:
        var z = self.bias + self.w[0] * x0 + self.w[1] * x1
        return 1.0 / (1.0 + exp(-z))

    def train_one(mut self, x0: Float64, x1: Float64, target: Float64):
        """One online update on a single example (gradient descent on MSE)."""
        var output = self.predict(x0, x1)
        var error = target - output
        var delta = output * (1.0 - output)  # sigma'(z)
        self.w[0] += self.learning_rate * error * x0 * delta
        self.w[1] += self.learning_rate * error * x1 * delta
        self.bias += self.learning_rate * error * delta


# -------------------------------------------------------------- driver ----
def main() raises:
    # Training data: every pair (a, b) on a 10x10 grid in [0, 1) with the
    # target equal to the sum a + b. 100 examples in total.
    var n_train = 0
    var tx = List[Float64]()
    var ty = List[Float64]()
    for a in range(10):
        for b in range(10):
            tx.append(Float64(a) / 10.0)
            tx.append(Float64(b) / 10.0)
            ty.append(Float64(a + b) / 10.0)
            n_train += 1

    # The 25 test inputs printed in the Rust tutorial.
    var n_test = 25
    var test_x = List[Float64]()
    var test_y = List[Float64]()
    # (x0, x1, expected sum).
    test_x.append(0.9); test_x.append(0.1); test_y.append(1.0)
    test_x.append(0.5); test_x.append(0.5); test_y.append(1.0)
    test_x.append(0.2); test_x.append(0.3); test_y.append(0.5)
    test_x.append(0.3); test_x.append(0.6); test_y.append(0.9)
    test_x.append(0.1); test_x.append(0.7); test_y.append(0.8)
    test_x.append(0.3); test_x.append(0.1); test_y.append(0.4)
    test_x.append(0.1); test_x.append(0.5); test_y.append(0.6)
    test_x.append(0.9); test_x.append(0.0); test_y.append(0.9)
    test_x.append(0.3); test_x.append(0.3); test_y.append(0.6)
    test_x.append(0.0); test_x.append(0.1); test_y.append(0.1)
    test_x.append(0.1); test_x.append(0.2); test_y.append(0.3)
    test_x.append(0.2); test_x.append(0.0); test_y.append(0.2)
    test_x.append(0.6); test_x.append(0.1); test_y.append(0.7)
    test_x.append(0.5); test_x.append(0.3); test_y.append(0.8)
    test_x.append(0.9); test_x.append(0.1); test_y.append(1.0)
    test_x.append(0.1); test_x.append(0.4); test_y.append(0.5)
    test_x.append(0.2); test_x.append(0.4); test_y.append(0.6)
    test_x.append(0.7); test_x.append(0.0); test_y.append(0.7)
    test_x.append(0.6); test_x.append(0.3); test_y.append(0.9)
    test_x.append(0.2); test_x.append(0.2); test_y.append(0.4)
    test_x.append(0.1); test_x.append(0.0); test_y.append(0.1)
    test_x.append(0.2); test_x.append(0.6); test_y.append(0.8)
    test_x.append(0.5); test_x.append(0.0); test_y.append(0.5)
    test_x.append(0.6); test_x.append(0.4); test_y.append(1.0)
    test_x.append(0.4); test_x.append(0.5); test_y.append(0.9)

    var rng = XorShift(seed=UInt64(42))
    var net = Perceptron(rng, learning_rate=0.1)

    var epochs = 10000
    for _ in range(epochs):
        for i in range(n_train):
            net.train_one(tx[2 * i], tx[2 * i + 1], ty[i])

    # How well does it sum? Round to one decimal, like the tutorial's output.
    var correct = 0
    for i in range(n_test):
        var pred = net.predict(test_x[2 * i], test_x[2 * i + 1])
        var rounded = floor(pred * 10.0 + 0.5) / 10.0
        var want = floor(test_y[i] * 10.0 + 0.5) / 10.0
        if rounded == want:
            correct += 1
        var shown = floor(pred * 10.0 + 0.5) / 10.0
        print(t"Input: [{test_x[2*i]}, {test_x[2*i+1]}], Prediction: {shown}")

    print(" ")
    print("Correct to 1 decimal place:", String(correct), "of", String(n_test))
    print("Weights:", String(net.w[0]), String(net.w[1]), " Bias:", String(net.bias))