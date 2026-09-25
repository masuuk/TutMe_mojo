def raises_error() raises:
    raise Error("There was an error.")

# Will not compile:
def unhandled_error():
    raises_error()   # Error: can't call raising function in a non-raising context

# Handle it explicitly:
def handle_error():
    try:
        raises_error()
    except e:
        print("Handled an error:", e)

# Or propagate it:
def propagate_error() raises:
    raises_error()
