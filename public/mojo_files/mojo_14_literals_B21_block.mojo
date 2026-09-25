var x = 42                     # type inferred
var values: List[Float64] = []  # annotated
# var x                      # Error: needs a type or an initializer

ref y = my_list[3]           # reference binding — no copy

# Same value to several names (right-associative, RHS runs once)
var x = var y = var z = "Hello"

# Destructuring
var a, b = 1, 2
var e, f = returns_pair()

# Swaps need no temp
a, b = b, a
