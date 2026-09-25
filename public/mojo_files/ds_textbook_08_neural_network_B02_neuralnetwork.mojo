# Mojo — network struct with He initialization
from math import sqrt, sigmoid

struct NeuralNetwork:
    var W1: List[Float64]
    var b1: List[Float64]
    var W2: List[Float64]
    var b2: List[Float64]
    var n_hidden: Int
    var n_features: Int
    var lr: Float64

    def __init__(out self, n_features: Int, n_hidden: Int,
                lr: Float64 = 0.01):
        self.n_features = n_features
        self.n_hidden = n_hidden
        self.lr = lr

        # He initialization for ReLU layers
        var scale1 = sqrt(2.0 / Float64(n_features))
        self.W1 = List[Float64]()
        for _ in range(n_hidden * n_features):
            self.W1.append(randn() * scale1)
        self.b1 = List[Float64]()
        for _ in range(n_hidden):
            self.b1.append(0.0)

        var scale2 = sqrt(2.0 / Float64(n_hidden))
        self.W2 = List[Float64]()
        for _ in range(n_hidden):
            self.W2.append(randn() * scale2)
        self.b2 = [0.0]
