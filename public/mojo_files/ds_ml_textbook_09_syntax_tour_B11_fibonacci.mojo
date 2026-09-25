def fibonacci(n: Int64) -> List[Int64]:
    if n <= 0:
        return List[Int64]()
    var seq = List[Int64]()
    seq.append(0)
    if n > 1:
        seq.append(1)
    for i in range(2, n):
        var next_val = seq[i - 1] + seq[i - 2]
        seq.append(next_val)
    return seq

def main():
    var fib = fibonacci(15)
    for val in fib:
        print(val, end=" ")
    print()
