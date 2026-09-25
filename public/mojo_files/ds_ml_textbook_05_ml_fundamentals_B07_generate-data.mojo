from math import sqrt
from random import random_normal, seed

def generate_data(n: Int) -> Tuple[List[Float64], List[Float64]]:
    seed(42)
    var x = List[Float64]()
    var y = List[Float64]()
    for _ in range(n):
        var xi = random_normal() * 10.0
        var yi = 3.5 * xi + 2.0 + random_normal() * 1.0
        x.append(xi)
        y.append(yi)
    return (x^, y^)

def predict(x: List[Float64], w: Float64, b: Float64) -> List[Float64]:
    var preds = List[Float64]()
    for xi in x:
        preds.append(w * xi + b)
    return preds^

def main():
    var (x, y) = generate_data(200)

    var w: Float64 = 0.0
    var b: Float64 = 0.0
    var lr: Float64 = 0.01
    var n = Float64(len(x))

    # Train for 500 epochs
    for epoch in range(500):
        var grad_w: Float64 = 0.0
        var grad_b: Float64 = 0.0
        for i in range(len(x)):
            var pred = w * x[i] + b
            var err = pred - y[i]
            grad_w += 2.0 * err * x[i]
            grad_b += 2.0 * err
        w -= lr * grad_w / n
        b -= lr * grad_b / n

    print("Learned w:", w, "(expected ~3.5)")
    print("Learned b:", b, "(expected ~2.0)")

    # Compute final RMSE
    var sse: Float64 = 0.0
    for i in range(len(x)):
        var pred = w * x[i] + b
        sse += (pred - y[i]) * (pred - y[i])
    print("RMSE:", sqrt(sse / n))
