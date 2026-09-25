from math import sqrt, exp, min, max
from collections import List

struct Perceptron:
    var lr: Float64
    var epochs: Int
    var weights: List[Float64]
    var bias: Float64

    def __init__(out self, learning_rate: Float64 = 0.1, epochs: Int = 100):
        self.lr = learning_rate
        self.epochs = epochs
        self.weights = List[Float64]()
        self.bias = 0.0

    def step_function(self, z: Float64) -> Int:
        """The activation function for a standard perceptron."""
        if z >= 0.0:
            return 1
        return 0

    def fit(mut self, X: List[List[Float64]], y: List[Int]):
        var n_features = X[0].size

        # Initialize weights to zeros
        self.weights = List[Float64]()
        for i in range(n_features):
            self.weights.append(0.0)
        self.bias = 0.0

        for _ in range(self.epochs):
            var errors = 0
            for idx in range(len(X)):
                var x_i = X[idx]

                # Linear combination
                var z = self.bias
                for j in range(n_features):
                    z += self.weights[j] * x_i[j]

                var y_predicted = self.step_function(z)

                # Update if misclassified
                var update = self.lr * Float64(y[idx] - y_predicted)
                if update != 0.0:
                    for j in range(n_features):
                        self.weights[j] += update * x_i[j]
                    self.bias += update
                    errors += 1

            if errors == 0:
                break

    def predict(self, X: List[List[Float64]]) -> List[Int]:
        var results = List[Int]()
        for idx in range(len(X)):
            var z = self.bias
            for j in range(self.weights.size):
                z += self.weights[j] * X[idx][j]
            results.append(self.step_function(z))
        return results

# --- Test the Perceptron (Logical AND Gate) ---
def main():
    var X = List[List[Float64]]()
    X.append([0.0, 0.0])
    X.append([0.0, 1.0])
    X.append([1.0, 0.0])
    X.append([1.0, 1.0])

    var y = List[Int]()
    y.append(0)
    y.append(0)
    y.append(0)
    y.append(1)

    var p = Perceptron(learning_rate=0.1, epochs=10)
    p.fit(X, y)

    print("Perceptron Predictions for AND gate:")
    var predictions = p.predict(X)
    for idx in range(len(X)):
        print(X[idx], "->", predictions[idx])
