from collections import List
from random import normal_float64, seed
from math import sqrt

def perturbed_grad(y_hat: List[Float64],
                     solve: SolverFn, eps: Float64,
                     k: Int) -> List[Float64]:
    var n = len(y_hat)
    var grad = List[Float64](n, 0.0)
    for j in range(k):
        var z = List[Float64](n)
        for i in range(n):
            z[i] = normal_float64()
        var noisy = List[Float64](n)
        for i in range(n):
            noisy[i] = y_hat[i] + eps * z[i]
        var d_j = solve(noisy)         # one optimizer solve
        for i in range(n):
            grad[i] += d_j[i] * z[i] / eps
    for i in range(n):
        grad[i] /= Float64(k)
    return grad

# k solves per step × millions of steps — batch them and the
# compiled loop is the difference between a day and an hour.
