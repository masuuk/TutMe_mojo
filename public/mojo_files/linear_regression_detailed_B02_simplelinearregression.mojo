struct SimpleLinearRegression:
    var w: Float64
    var b: Float64

    def __init__(out self):
        self.w = 0.0
        self.b = 0.0

    def fit(mut self, X: List[Float64], y: List[Float64]):
        var n = len(X)
        var x_mean: Float64 = 0.0
        var y_mean: Float64 = 0.0
        for i in range(n):
            x_mean += X[i]
            y_mean += y[i]
        x_mean /= Float64(n)
        y_mean /= Float64(n)

        var numerator: Float64 = 0.0
        var denominator: Float64 = 0.0
        for i in range(n):
            var dx = X[i] - x_mean
            numerator += dx * (y[i] - y_mean)
            denominator += dx * dx

        self.w = numerator / denominator
        self.b = y_mean - self.w * x_mean

    def predict(self, X: List[Float64]) -> List[Float64]:
        var preds: List[Float64] = []
        for i in range(len(X)):
            preds.append(self.w * X[i] + self.b)
        return preds
