from autodiff import gradient, Value
from math import sqrt, exp

def linear_regression(
    x_data: List[Float64],
    y_data: List[Float64],
    lr: Float64 = 0.01,
    epochs: Int = 1000
) -> (Float64, Float64):
    // Learn y = w*x + b
    var w = 0.0
    var b = 0.0
    var n = Float64(len(x_data))

    for epoch in range(epochs):
        // Forward pass: compute MSE loss
        var loss = 0.0
        var dw = 0.0
        var db = 0.0

        for i in range(len(x_data)):
            var pred = w * x_data[i] + b
            var err = pred - y_data[i]
            loss += err * err
            dw += 2.0 * err * x_data[i] / n
            db += 2.0 * err / n

        loss /= n

        // Update parameters
        w -= lr * dw
        b -= lr * db

        if epoch % 200 == 0:
            print("Epoch", epoch, "loss =", loss)

    return (w, b)


// Generate synthetic data: y = 3x + 1 + noise
var x_data = List[Float64]()
var y_data = List[Float64]()
for i in range(100):
    var x = Float64(i) / 10.0
    x_data.append(x)
    y_data.append(3.0 * x + 1.0 + Normal(0.0, 0.5).sample())

var (w, b) = linear_regression(x_data, y_data)
print("Learned: y =", w, "* x +", b)
