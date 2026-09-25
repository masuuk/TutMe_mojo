def bce_loss(pred: Float64, target: Float64) -> Float64:
    var eps = 1e-7
    var p = max(min(pred, 1.0 - eps), eps)
    return -(target * log(p) + (1.0 - target) * log(1.0 - p))

def train(mut self, X: List[Float64], y: List[Float64],
          epochs: Int = 1000):
    var n_samples = len(y)
    for epoch in range(epochs):
        var total_loss: Float64 = 0.0

        for i in range(n_samples):
            # Extract sample i as a flat list
            var x_i = List[Float64]()
            for j in range(self.n_features):
                x_i.append(X[i * self.n_features + j])

            # Forward
            var (z1, a1, output) = self.forward(x_i)

            # Loss
            total_loss += bce_loss(output[0], y[i])

            # Backward + update
            self.backward(x_i, y[i], output[0], a1, z1)

        if epoch % 100 == 0:
            var avg_loss = total_loss / Float64(n_samples)
            print(f"Epoch {epoch}: loss = {avg_loss:.6f}")

# Create synthetic XOR data and train
var X = [0.0,0.0, 0.0,1.0, 1.0,0.0, 1.0,1.0]
var y = [0.0, 1.0, 1.0, 0.0]
var net = NeuralNetwork(n_features=2, n_hidden=8, lr=0.1)
net.train(X, y, epochs=2000)
