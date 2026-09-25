# With a value — two ways
var opt1 = Optional(5)
var opt2: Optional[Int] = 5

# Without a value — two ways
var opt3 = Optional[Int]()
var opt4: Optional[Int] = None

# Truthy when holding a value; guard before unwrapping
var opt: Optional[String] = "Testing"
if opt:
    var value_ref = opt.value()
    print(value_ref)

# Or supply a default
var greeting: Optional[String] = None
print(greeting.or_else("Hello"))   # Hello
greeting = "Hi"
print(greeting.or_else("Hello"))   # Hi
