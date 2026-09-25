def fibonacci(n: Int) -> List[Int]:
    if n <= 0:
        return List[Int]()
    var seq = List[Int]()
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
        print(val)
