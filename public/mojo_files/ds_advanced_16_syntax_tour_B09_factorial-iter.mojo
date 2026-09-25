# Iterative
def factorial_iter(n: Int) -> Int:
    var result = 1
    for i in range(2, n + 1):
        result *= i
    return result

# Recursive
def factorial_rec(n: Int) -> Int:
    if n <= 1:
        return 1
    return n * factorial_rec(n - 1)

def main():
    print("Iterative 10! =", factorial_iter(10))
    print("Recursive 10! =", factorial_rec(10))
    # Both print: 3628800
