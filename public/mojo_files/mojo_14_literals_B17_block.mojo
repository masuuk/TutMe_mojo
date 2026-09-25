# List: [expr for pattern in iterable if condition]
var squares = [x * x for x in [0, 1, 2, 3, 4] if x % 2 == 0]
# [0, 4, 16]

# Set: {expr for pattern in iterable if condition}
var fibs = {fib(x) for x in range(6)}   # {1, 2, 3, 5, 8} — deduped

# Dict: {key: value for pattern in iterable if condition}
var lengths: Dict[String, Int] =
    {k: len(k) for k in ["one", "two", "three"]}
# {one: 3, two: 3, three: 5}

print(squares)
