// Mojo — typed variables and control flow
def compute_mean(data: List[Float32]) -> Float32:
    var sum: Float32 = 0.0
    for x in data:
        sum += x
    return sum / len(data)

def main():
    var values = List[Float32]([1.5, 2.3, 3.7, 4.1])
    var mean = compute_mean(values)
    print("Mean:", mean)
