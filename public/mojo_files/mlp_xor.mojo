# ============================================================================
#  Neural Network from scratch in Mojo 1.x  —  XOR (2 - 4 - 1 MLP)
#
#  Written in the style of the classic "from scratch" tutorials for Python
#  (Murmuarpan: ReLU hidden, sigmoid output, binary cross-entropy, SGD) and
#  Rust (Faisal Arshed / Julius Hietala: hand-rolled matrices and backprop).
#
#  Run with:   mojo mlp_xor.mojo
# ============================================================================
from std.math import exp, log, floor, max, min

# ---------------------------------------------------------------- PRNG ----
struct XorShift:
    """A tiny deterministic pseudo-random generator (xorshift64*).

    Implemented by hand so that every run of the tutorial is reproducible:
    the same seed always produces the same network and the same results.
    """

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
        # Pull the top 53 bits and scale them into [0, 1).
        return Float64(self.next_u64() >> 11) / Float64(1 << 53)


# -------------------------------------------------------------- Matrix ----
struct Matrix(Copyable, Movable):
    """A dense matrix stored row-major in a flat List[Float64].

    Convention used everywhere below: an example is a *column*. So X is
    (features_d x m), y is (1 x m), W1 is (hidden x features_d), etc.
    """

    var rows: Int
    var cols: Int
    var data: List[Float64]

    def __init__(out self, rows: Int, cols: Int):
        self.rows = rows
        self.cols = cols
        self.data = List[Float64]()
        for _ in range(rows * cols):
            self.data.append(0.0)

    def __init__(out self, *, copy: Self):
        self.rows = copy.rows
        self.cols = copy.cols
        self.data = List[Float64]()
        for i in range(len(copy.data)):
            self.data.append(copy.data[i])

    def get(self, r: Int, c: Int) -> Float64:
        return self.data[r * self.cols + c]

    def set(mut self, r: Int, c: Int, v: Float64):
        self.data[r * self.cols + c] = v

    @staticmethod
    def zeros(rows: Int, cols: Int) -> Matrix:
        return Matrix(rows, cols)

    @staticmethod
    def rand_small(rows: Int, cols: Int, mut rng: XorShift, scale: Float64) -> Matrix:
        """Uniform entries in [-scale/2, +scale/2) — a tiny random init."""
        var m = Matrix(rows, cols)
        for i in range(len(m.data)):
            m.data[i] = (rng.next_f64() - 0.5) * scale
        return m^

    def transpose(self) -> Matrix:
        var out = Matrix(self.cols, self.rows)
        for r in range(self.rows):
            for c in range(self.cols):
                out.data[c * self.rows + r] = self.data[r * self.cols + c]
        return out^

    def matmul(self, other: Matrix) -> Matrix:
        """This @ other, with a pure triple loop. No BLAS, no surprises."""
        var out = Matrix(self.rows, other.cols)
        for i in range(self.rows):
            for j in range(other.cols):
                var acc = 0.0
                for k in range(self.cols):
                    acc += self.data[i * self.cols + k] * other.data[k * other.cols + j]
                out.data[i * other.cols + j] = acc
        return out^

    def add(self, other: Matrix) -> Matrix:
        var out = Matrix(self.rows, self.cols)
        for i in range(len(out.data)):
            out.data[i] = self.data[i] + other.data[i]
        return out^

    def sub(self, other: Matrix) -> Matrix:
        var out = Matrix(self.rows, self.cols)
        for i in range(len(out.data)):
            out.data[i] = self.data[i] - other.data[i]
        return out^

    def mul(self, other: Matrix) -> Matrix:
        """Element-wise (Hadamard) product: same shape, entry by entry."""
        var out = Matrix(self.rows, self.cols)
        for i in range(len(out.data)):
            out.data[i] = self.data[i] * other.data[i]
        return out^

    def scalar_mul(self, factor: Float64) -> Matrix:
        var out = Matrix(self.rows, self.cols)
        for i in range(len(out.data)):
            out.data[i] = self.data[i] * factor
        return out^

    def add_bias(self, b: Matrix) -> Matrix:
        """Add a column bias vector b (rows x 1) to every column."""
        var out = Matrix(self.rows, self.cols)
        for r in range(self.rows):
            var bias = b.get(r, 0)
            for c in range(self.cols):
                out.data[r * self.cols + c] = self.data[r * self.cols + c] + bias
        return out^

    def sum_rows(self) -> Matrix:
        """Sum each row into a rows x 1 matrix (numpy keepdims=True)."""
        var out = Matrix(self.rows, 1)
        for r in range(self.rows):
            var acc = 0.0
            for c in range(self.cols):
                acc += self.data[r * self.cols + c]
            out.data[r] = acc
        return out^


# ---------------------------------------------------------- activations ---
def sigmoid(x: Float64) -> Float64:
    return 1.0 / (1.0 + exp(-x))

def relu(x: Float64) -> Float64:
    if x > 0.0:
        return x
    return 0.0

def sigmoid_m(m: Matrix) -> Matrix:
    var out = Matrix(m.rows, m.cols)
    for i in range(len(out.data)):
        out.data[i] = sigmoid(m.data[i])
    return out^

def relu_m(m: Matrix) -> Matrix:
    var out = Matrix(m.rows, m.cols)
    for i in range(len(out.data)):
        out.data[i] = relu(m.data[i])
    return out^

def relu_mask(m: Matrix) -> Matrix:
    """ReLU derivative: 1.0 where the input was positive, else 0.0."""
    var out = Matrix(m.rows, m.cols)
    for i in range(len(out.data)):
        out.data[i] = 1.0 if m.data[i] > 0.0 else 0.0
    return out^


# --------------------------------------------------------------- network ---
@fieldwise_init
struct Parameters(Movable):
    var w1: Matrix  # (hidden x 2)
    var b1: Matrix  # (hidden x 1)
    var w2: Matrix  # (hidden x 1)
    var b2: Matrix  # (1 x 1)

@fieldwise_init
struct Cache(Movable):
    """Intermediates of forward(), needed again by backward()."""
    var z1: Matrix  # pre-activation of the hidden layer
    var a1: Matrix  # ReLU(z1)
    var z2: Matrix  # pre-activation of the output
    var a2: Matrix  # sigmoid(z2) — the prediction probability

@fieldwise_init
struct Gradients(Movable):
    var dw1: Matrix
    var db1: Matrix
    var dw2: Matrix
    var db2: Matrix

def init_parameters(mut rng: XorShift, hidden: Int, scale: Float64) -> Parameters:
    """Small random weights; zero biases. Deterministic for a fixed seed."""
    return Parameters(
        w1=Matrix.rand_small(hidden, 2, rng, scale),
        b1=Matrix.zeros(hidden, 1),
        w2=Matrix.rand_small(hidden, 1, rng, scale),
        b2=Matrix.zeros(1, 1),
    )

def forward(X: Matrix, p: Parameters) -> Cache:
    var z1 = p.w1.matmul(X).add_bias(p.b1)
    var a1 = relu_m(z1)
    var z2 = p.w2.transpose().matmul(a1).add_bias(p.b2)
    var a2 = sigmoid_m(z2)
    return Cache(z1=z1^, a1=a1^, z2=z2^, a2=a2^)

def compute_loss(Y: Matrix, cache: Cache) -> Float64:
    """Binary cross-entropy, averaged over the m examples.

    We clamp a2 to [eps, 1-eps] so log() never sees 0 or 1.
    """
    var m = Y.cols
    var acc = 0.0
    for j in range(m):
        var y = Y.get(0, j)
        var a = min(max(cache.a2.get(0, j), 1e-15), 1.0 - 1e-15)
        acc += y * log(a) + (1.0 - y) * log(1.0 - a)
    return -acc / Float64(m)

def backward(X: Matrix, Y: Matrix, cache: Cache, p: Parameters) -> Gradients:
    var m = Float64(X.cols)

    # For the output neuron, sigmoid + cross-entropy simplify beautifully:
    #   dL/dZ2 = A2 - Y
    var dz2 = cache.a2.sub(Y)
    #   dL/dW2 = (1/m) * A1 @ dZ2^T        dL/db2 = (1/m) * sum_rows(dZ2)
    var dw2 = cache.a1.matmul(dz2.transpose()).scalar_mul(1.0 / m)
    var db2 = dz2.sum_rows().scalar_mul(1.0 / m)

    # Backprop through the hidden layer:
    #   dL/dA1 = W2 @ dZ2                 dL/dZ1 = dL/dA1 * relu'(Z1)
    var da1 = p.w2.matmul(dz2)
    var dz1 = da1.mul(relu_mask(cache.z1))
    #   dL/dW1 = (1/m) * dZ1 @ X^T        dL/db1 = (1/m) * sum_rows(dZ1)
    var dw1 = dz1.matmul(X.transpose()).scalar_mul(1.0 / m)
    var db1 = dz1.sum_rows().scalar_mul(1.0 / m)

    return Gradients(dw1=dw1^, db1=db1^, dw2=dw2^, db2=db2^)

def update(mut p: Parameters, g: Gradients, learning_rate: Float64):
    """One vanilla batch-gradient-descent step."""
    p.w1 = p.w1.sub(g.dw1.scalar_mul(learning_rate))
    p.b1 = p.b1.sub(g.db1.scalar_mul(learning_rate))
    p.w2 = p.w2.sub(g.dw2.scalar_mul(learning_rate))
    p.b2 = p.b2.sub(g.db2.scalar_mul(learning_rate))

def predict(X: Matrix, p: Parameters) -> Matrix:
    """Threshold the network's probability at 0.5."""
    var cache = forward(X, p)
    var out = Matrix(1, X.cols)
    for j in range(X.cols):
        out.data[j] = 1.0 if cache.a2.get(0, j) > 0.5 else 0.0
    return out^


# -------------------------------------------------------------- driver ----
def main() raises:
    # The XOR truth table. Each example is a column:
    #   x1 x2 -> y
    #   0  0     0
    #   0  1     1
    #   1  0     1
    #   1  1     0
    var X = Matrix.zeros(2, 4)
    X.set(0, 0, 0.0); X.set(1, 0, 0.0)
    X.set(0, 1, 0.0); X.set(1, 1, 1.0)
    X.set(0, 2, 1.0); X.set(1, 2, 0.0)
    X.set(0, 3, 1.0); X.set(1, 3, 1.0)

    var Y = Matrix.zeros(1, 4)
    Y.set(0, 0, 0.0)
    Y.set(0, 1, 1.0)
    Y.set(0, 2, 1.0)
    Y.set(0, 3, 0.0)

    # Hyper-parameters. (Try hidden=2: the network gets stuck — XOR needs
    # room for two competing "on/off" hidden features.)
    var hidden = 4               # neurons in the hidden layer
    var init_scale = 1.0         # initial weights come from [-0.5, +0.5)
    var learning_rate = 0.5
    var epochs = 4000
    var rng = XorShift(seed=UInt64(100))

    var params = init_parameters(rng, hidden, init_scale)

    for epoch in range(epochs):
        var cache = forward(X, params)
        var loss = compute_loss(Y, cache)
        var grads = backward(X, Y, cache, params)
        update(params, grads, learning_rate)
        if epoch % 1000 == 0:
            var shown = floor(loss * 10000.0) / 10000.0
            print(t"epoch {epoch}   loss {shown}")

    # What the network actually outputs (before thresholding) — it should be
    # close to 0.01 / 0.99, not just "less than / greater than 0.5".
    var cache = forward(X, params)
    var line = ""
    for j in range(X.cols):
        line += String(t"  {floor(cache.a2.get(0, j) * 10000.0) / 10000.0}")
    print("sigmoid output probabilities:")
    print(" ", line)

    # Thresholded predictions: 0 1 1 0 is the XOR truth table.
    var preds = predict(X, params)
    line = ""
    for j in range(X.cols):
        line += String(t" {Int(preds.get(0, j))}")
    print("predictions (expected 0 1 1 0):")
    print(" ", line)