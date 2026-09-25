# Default — read-only borrow
def length(s: String) -> Int:
    return len(s)  # can read, can't modify

# mut — mutable borrow (in-place modification)
def append_exclamation(mut s: String):
    s += "!"  # modifies the original

var greeting = "Hello"
append_exclamation(greeting)
print(greeting)  # "Hello!"

# var — takes ownership (consumes the value)
def process(var data: List[Int]) -> Int:
    var total = 0
    for item in data:
        total += item
    return total

var numbers = [1, 2, 3]
var result = process(numbers^)  # moves numbers into process
# numbers is now invalid

# out — output parameter (constructs the value)
def create_vector(out result: List[Int], size: Int):
    result = List[Int]()  # initializes result
    for i in range(size):
        result.append(i * i)

var squares: List[Int]
create_vector(squares, 5)
print(squares)  # [0, 1, 4, 9, 16]
