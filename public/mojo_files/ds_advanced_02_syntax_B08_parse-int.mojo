# Raising functions
def parse_int(s: String) raises -> Int:
    return int(s)

# Generic / parameterized functions
def max_of[T: Comparable](a: T, b: T) -> T:
    if a > b:
        return a
    return b

# Closures as first-class values
def apply[T: AnyType, U: AnyType](f: T -> U, x: T) -> U:
    return f(x)

var double = lambda x: x * 2
print(apply(double, 21))  # 42
