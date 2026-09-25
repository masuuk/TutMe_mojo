def mle_normal(data: List[Float64]) -> (Float64, Float64):
    // MLE for normal distribution parameters
    var n = len(data)
    var mu_hat = sum(data) / Float64(n)

    var sigma_sq = 0.0
    for x in data:
        sigma_sq += (x - mu_hat) ** 2.0
    sigma_sq /= Float64(n)  // MLE uses n, not n-1

    return (mu_hat, sqrt(sigma_sq))


def mle_exponential(data: List[Float64]) -> Float64:
    // MLE for exponential rate parameter
    var n = len(data)
    var total = sum(data)
    return Float64(n) / total


var data = List[Float64]()

// Generate sample data
for i in range(10000):
    data.append(Normal(5.0, 2.0).sample())

var (mu, sigma) = mle_normal(data)
print("μ̂ =", mu, "σ̂ =", sigma)
