struct RunningStats:
    var n: Int
    var mean: Float64
    var m2: Float64  // sum of squared deviations
    var min_val: Float64
    var max_val: Float64

    def __init__(out self):
        self.n = 0
        self.mean = 0.0
        self.m2 = 0.0
        self.min_val = Float64.infinity
        self.max_val = -Float64.infinity

    def update(mut self, x: Float64):
        self.n += 1
        var delta = x - self.mean
        self.mean += delta / Float64(self.n)
        var delta2 = x - self.mean
        self.m2 += delta * delta2
        self.min_val = min(self.min_val, x)
        self.max_val = max(self.max_val, x)

    def variance(self) -> Float64:
        if self.n < 2: return 0.0
        return self.m2 / Float64(self.n - 1)

    def std_dev(self) -> Float64:
        return sqrt(self.variance())


var stats = RunningStats()
for x in data:
    stats.update(x)

print("Mean:", stats.mean)
print("Std:", stats.std_dev())
print("Range:", stats.min_val, "to", stats.max_val)
