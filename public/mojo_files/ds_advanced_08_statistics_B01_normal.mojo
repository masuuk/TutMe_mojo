from math import sqrt, exp, log, pi
from random import random_float64

struct Normal:
    var mean: Float64
    var std: Float64

    def __init__(out self, mean: Float64, std: Float64):
        self.mean = mean
        self.std = std

    def pdf(self, x: Float64) -> Float64:
        var z = (x - self.mean) / self.std
        return exp(-0.5 * z * z) / (self.std * sqrt(2.0 * pi))

    def sample(self) -> Float64:
        // Box-Muller transform
        var u1 = random_float64()
        var u2 = random_float64()
        var z = sqrt(-2.0 * log(u1)) * cos(2.0 * pi * u2)
        return self.mean + self.std * z

    def log_likelihood(self, x: Float64) -> Float64:
        return log(self.pdf(x))


var dist = Normal(mean=0.0, std=1.0)
print(dist.pdf(1.0))  // ~0.242
print(dist.sample())    // random value ~ N(0, 1)
