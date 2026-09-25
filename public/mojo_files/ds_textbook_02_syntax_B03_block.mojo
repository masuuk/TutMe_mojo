# Explicit type annotation
var greeting: String = "Hello World"
var count: Int = 0
var pi: Float64 = 3.14159

# Type inference — compiler figures it out
var name = "Mojo"        # inferred as String
var temperature = 22.5   # inferred as Float64

# Conventionally constant: declared once, never reassigned
var max_retries = 3      # just don't reassign it

# Late initialization
var result: Float64
if condition:
    result = compute_a()
else:
    result = compute_b()

# Copying and moving
var first = [1, 2, 3]
var second = first.copy()   # explicit copy
var third = first^          # move (transfers ownership)
