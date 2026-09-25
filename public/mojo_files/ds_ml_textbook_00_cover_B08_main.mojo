// Mojo — linear algebra
from linalg import matmul, inverse, svd
from stats import mean, std, corrcoef

def main():
    var X = Tensor[Float32](randn([100, 10]))
    var y = Tensor[Float32](randn([100, 1]))

    // Normal equation: (X^T X)^(-1) X^T y
    var XtX = matmul(transpose(X), X)
    var Xty = matmul(transpose(X), y)
    var beta = matmul(inverse(XtX), Xty)

    // Summary statistics
    var means = mean(X, axis=0)
    var stdevs = std(X, axis=0)

    print("Beta:", beta)
    print("Means:", means)
