# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/data_science.html
#  File:    data_science_program.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo data_science_program.mojo
# ============================================================================
from std.math import sqrt

def perceptron(X: List[List[Float64]], y: List[Float64],
               epochs: Int = 10, lr: Float64 = 0.1) -> (List[Float64], Float64):
    var w = List[Float64](0.0, 0.0)       # two weights for two inputs
    var b: Float64 = 0.0
    for _ in range(epochs):
        for i in range(X.size):
            var z = X[i][0] * w[0] + X[i][1] * w[1] + b
            var yhat = float64(z > 0.0)  # step function
            var err = y[i] - yhat
            w[0] += lr * err * X[i][0]
            w[1] += lr * err * X[i][1]
            b += lr * err
    return (w, b)

def main():
    var X = List[List[Float64]](
        List[Float64](0,0), List[Float64](0,1),
        List[Float64](1,0), List[Float64](1,1))
    var y = List[Float64](0, 1, 1, 1)  # OR gate
    var (w, b) = perceptron(X, y)
    print(w[0], w[1], b)
    var preds = List[Float64]()
    for i in range(X.size):
        var z = X[i][0] * w[0] + X[i][1] * w[1] + b
        preds.append(float64(z > 0.0))
    print(preds)            # [0, 1, 1, 1] ✓
