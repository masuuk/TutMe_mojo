# unannotated def — lenient, Python-like
def greet(name):
    return "Hello, " + name

# annotated def — strict, compiled, optimized
def add(a: Int, b: Int) -> Int:
    return a + b

def divide(a: Float64, b: Float64) raises -> Float64:
    if b == 0:
        raise "Division by zero"
    return a / b
