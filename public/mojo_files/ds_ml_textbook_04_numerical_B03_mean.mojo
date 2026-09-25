from math import sqrt

def mean(data: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for x in data:
        total += x
    return total / Float64(len(data))

def std_dev(data: List[Float64]) -> Float64:
    var mu = mean(data)
    var sq_sum: Float64 = 0.0
    for x in data:
        sq_sum += (x - mu) * (x - mu)
    return sqrt(sq_sum / Float64(len(data)))

def main():
    var data = [2.1, 4.5, 3.3, 7.8, 1.2, 6.4, 5.9]
    print("Mean:", mean(data))
    print("Std Dev:", std_dev(data))
