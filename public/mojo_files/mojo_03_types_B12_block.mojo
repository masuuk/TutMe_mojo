# Explicitly typed...
var example_tuple = Tuple[Int, String](1, "Example")

# ...or inferred from a literal
var pair = (1, "Example")

# Unpack into multiple variables
var x, y = pair
print(x, y)         # 1 Example

# Or index individual values
var s = pair[1]
print(s)            # Example
