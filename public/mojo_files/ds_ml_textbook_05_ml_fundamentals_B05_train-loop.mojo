from std.math import sqrt

def train_loop(
    mut w: Float64,
    mut b: Float64,
    x: List[Float64],
    y: List[Float64],
    lr: Float64,
    epochs: Int
):
    var n = Float64(len(x))

    for epoch in range(epochs):
        # Forward pass + gradient in one pass
        var grad_w: Float64 = 0.0
        var grad_b: Float64 = 0.0
        var loss: Float64 = 0.0

        for i in range(len(x)):
            var pred = w * x[i] + b
            var err = pred - y[i]
            grad_w += 2.0 * err * x[i]
            grad_b += 2.0 * err
            loss += err * err

        grad_w /= n
        grad_b /= n
        loss /= n

        w -= lr * grad_w
        b -= lr * grad_b

        if epoch % 100 == 0:
            print("Epoch", epoch,
                   "Loss:", loss,
                   "w:", w, "b:", b)
