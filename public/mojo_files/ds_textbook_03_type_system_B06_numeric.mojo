# Mojo — traits as type constraints
trait Numeric:
    def __add__(self, other: Self) -> Self: ...
    def __mul__(self, other: Self) -> Self: ...
    def __sub__(self, other: Self) -> Self: ...

# Copying and moving are unified into __init__ overloads:
#   Mojo synthesizes __init__(out self, *, copy: Self) for Copyable
#   Mojo synthesizes __init__(out self, *, take: Self) for Movable
# (the old __copyinit__/__moveinit__ spellings were removed pre-1.0)

# Generic function constrained by traits
def mean[T: Numeric](items: List[T]) -> T:
    var total = items[0]
    for i in range(1, len(items)):
        total += items[i]
    return total / T(len(items))

# Works with any Numeric type
var float_vals = [1.0, 2.0, 3.0]  # List[Float64]
var int_vals = [10, 20, 30]       # List[Int]
print(mean(float_vals))  # 2.0
print(mean(int_vals))    # 20

# Multiple trait constraints
def clamp[T: Comparable, Copyable](val: T, lo: T, hi: T) -> T:
    if val < lo:
        return lo
    elif val > hi:
        return hi
    return val
