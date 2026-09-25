# Mojo — def with full type annotations
def add(a: Int, b: Int) -> Int:
    return a + b

# Optional arguments (default values)
def my_pow(base: Int, exp: Int = 2) -> Int:
    return base ** exp

# Variadic arguments
def sum_all(*values: Int) -> Int:
    var total: Int = 0
    for v in values:
        total += v
    return total

# Error handling with raises
def divide(a: Float64, b: Float64) raises -> Float64:
    if b == 0.0:
        raise Error("Division by zero")
    return a / b

def strict_add(a: Int, b: Int) -> Int:
    return a + b  # same result, stricter checking
