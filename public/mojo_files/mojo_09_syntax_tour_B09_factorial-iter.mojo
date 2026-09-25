def factorial_iter(n: Int) -> Int:
    var result: Int = 1
    for i in range(2, n + 1):
        result *= i
    return result

def factorial_rec(n: Int) -> Int:
    if n <= 1:
        return 1
    return n * factorial_rec(n - 1)

def main():
    for i in range(11):
        print(i, "! =", factorial_iter(i),
              "|", factorial_rec(i))
