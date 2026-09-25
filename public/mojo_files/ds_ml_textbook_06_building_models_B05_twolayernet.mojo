from tensor import Tensor
from math import sqrt

struct TwoLayerNet:
    var W1: Tensor[Float32]
    var b1: Tensor[Float32]
    var W2: Tensor[Float32]
    var b2: Tensor[Float32]

    def __init__(
        mut self,
        input_dim: Int, hidden_dim: Int, output_dim: Int,
    ):
        self.W1 = Tensor[Float32](input_dim, hidden_dim)
        self.b1 = Tensor[Float32](hidden_dim)
        self.W2 = Tensor[Float32](hidden_dim, output_dim)
        self.b2 = Tensor[Float32](output_dim)
        # Xavier initialization
        var scale1 = sqrt(2.0 / Float32(input_dim))
        for i in range(self.W1.num_elements()):
            self.W1[i] = randn_float32() * scale1
        var scale2 = sqrt(2.0 / Float32(hidden_dim))
        for i in range(self.W2.num_elements()):
            self.W2[i] = randn_float32() * scale2

    def forward(self, X: Tensor[Float32]) -> Tensor[Float32]:
        var h = matmul(X, self.W1)
        for i in range(h.num_elements()):
            h[i] += self.b1[i % self.b1.shape()[0]]
        relu(h)
        var out = matmul(h, self.W2)
        for i in range(out.num_elements()):
            out[i] += self.b2[i % self.b2.shape()[0]]
        softmax(out)
        return out
