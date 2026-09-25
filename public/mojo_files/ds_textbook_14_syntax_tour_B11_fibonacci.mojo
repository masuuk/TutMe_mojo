def fibonacci(n: Int) -> List[Int]:
    var seq = List[Int]()
    var a: Int = 0
    var b: Int = 1
    for _ in range(n):
        seq.append(a)
        var temp = a + b
        a = b
        b = temp
    return seq

def main():
    var fib = fibonacci(15)
    for i in range(len(fib)):
        print("fib[", i, "] =", fib[i])
