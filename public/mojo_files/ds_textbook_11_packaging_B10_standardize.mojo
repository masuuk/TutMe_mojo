from benchmark import keep_running, benchmark_function
from random import randn

def standardize(data: List[Float64]) -> List[Float64]:
    var n = len(data)
    var mean: Float64 = 0.0
    for v in data:
        mean += v
    mean /= n

    var std: Float64 = 0.0
    for v in data:
        std += (v - mean) ** 2
    std = (std / n) ** 0.5

    var result = List[Float64](capacity=n)
    for v in data:
        result.append((v - mean) / std)
    return result

def main():
    var data = randn[Float64](1_000_000)

    def bench():
        _ = standardize(data)

    var stats = benchmark_function(bench, iterations=50, warmup=10)
    print(f"Median: {stats.median:.4f}s")
    print(f"Mean:   {stats.mean:.4f}s")
    print(f"Stddev: {stats.stddev:.4f}s")
