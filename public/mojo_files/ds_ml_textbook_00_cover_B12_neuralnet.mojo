// Mojo — 2-layer neural network
struct NeuralNet:
    var w1: Tensor[Float32]
    var w2: Tensor[Float32]
    var b1: Tensor[Float32]
    var b2: Tensor[Float32]

impl NeuralNet:
    def forward(self, X: Tensor[Float32]) -> Tensor[Float32]:
        var h = relu(matmul(X, self.w1) + self.b1)
        return matmul(h, self.w2) + self.b2

    def train_step(mut self, X: Tensor[Float32],
        y: Tensor[Float32], lr: Float32):
        // ... gradient computation & update (simplified)
        // In practice, use Mojo's autodiff
