# unannotated def — Python-like, dynamically typed
def add_loose(a, b):
    return a + b

# annotated def — strict, fully typed, high-performance
def add_strict(a: Int64, b: Int64) -> Int64:
    return a + b

# annotated arguments are immutable by default
def greet(name: String) -> String:
    return "Hello, " + name

# mut marks a mutable parameter
def increment(mut x: Int64):
    x += 1
