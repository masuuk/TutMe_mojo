from std.math import sqrt

def main():
    var x: List[Float64] = [100.0, 150.0, 200.0, 250.0, 300.0]
    var y: List[Float64] = [2.0, 2.8, 3.4, 4.2, 4.9]

    var x_bar = 0.0
    var y_bar = 0.0
    for i in range(len(x)):
        x_bar += x[i]; y_bar += y[i]
    x_bar /= Float64(len(x)); y_bar /= Float64(len(y))

    var num = 0.0
    var den = 0.0
    for i in range(len(x)):
        num += (x[i] - x_bar) * (y[i] - y_bar)
        den += (x[i] - x_bar) ** 2

    var beta1 = num / den
    var beta0 = y_bar - beta1 * x_bar
    var pred = beta0 + beta1 * 225.0

    var sse = 0.0
    for i in range(len(x)):
        var e = y[i] - (beta0 + beta1 * x[i])
        sse += e * e
    var rmse = sqrt(sse / Float64(len(x)))

    print("slope:", beta1, "prediction at 225 mm:", pred, "RMSE:", rmse)
