def fibonacci(n: Int) -> List[Int]:
    if n <= 0:
        return List[Int]()
    var seq = List[Int](0, 1)
    for i in range(2, n):
        seq.append(seq[i - 1] + seq[i - 2])
    return seq

def main():
    var result = fibonacci(10)
    print(result)
    # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
