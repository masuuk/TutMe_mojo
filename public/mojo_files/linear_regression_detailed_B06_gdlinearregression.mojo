struct GDLinearRegression:
    var w: Float64
    var b: Float64
    var lr: Float64
    var epochs: Int

    def __init__(out self, lr: Float64 = 0.01, epochs: Int = 1000):
        self.w = 0.0
        self.b = 0.0
        self.lr = lr
        self.epochs = epochs

    def fit(mut self, X: List[Float64], y: List[Float64]):
        var n = Float64(len(X))
        for _ in range(self.epochs):
            var dw: Float64 = 0.0
            var db: Float64 = 0.0
            for i in range(len(X)):
                var pred = self.w * X[i] + self.b
                var error = y[i] - pred
                dw += error * X[i]
                db += error
            dw = -(2.0 / n) * dw
            db = -(2.0 / n) * db
            self.w -= self.lr * dw
            self.b -= self.lr * db
