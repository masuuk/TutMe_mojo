def main():
    var x = 10         # constant by convention — never reassign
    var y = 20         # mutable — can reassign
    y = 30             # OK

    # Type annotations are optional with inference
    var name: String = "Mojo"
    var pi: Float64 = 3.14159
    var count: Int = 42

    # Printing values
    print("x =", x, "y =", y)
