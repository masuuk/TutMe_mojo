struct Regression:
    var x: List[Float64]
    var y: List[Float64]

    def __init__(out self):
        self.x = []
        self.y = []

    def push(mut self, xi: Float64, yi: Float64):
        self.x.append(xi)
        self.y.append(yi)

    def slope(self) -> Float64:
        var n = Float64(len(self.x))
        var mx = 0.0
        for v in self.x:
            mx += v
        mx /= n
        var my = 0.0
        for v in self.y:
            my += v
        my /= n

        # slope = covariance / variance
        var num = 0.0
        var den = 0.0
        for i in range(len(self.x)):
            num += (self.x[i] - mx) * (self.y[i] - my)
            den += (self.x[i] - mx) * (self.x[i] - mx)
        return num / den
