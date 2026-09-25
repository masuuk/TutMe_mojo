# Ownership: value moves to the new owner
def ownership_example():
    var tensor = Tensor[Float32](1000)

    # tensor is MOVED to process() — tensor is no longer valid
    process(tensor^)  # ^ denotes explicit transfer
    # print(tensor.size)  # COMPILE ERROR: tensor was moved

# Borrowing: read without taking ownership
def analyze(ref data: Tensor[Float32]) -> Float32:
    # ref = immutable borrow — read-only access
    return data.mean()

# Mutable borrowing: modify in place
def scale_inplace(mut data: Tensor[Float32], factor: Float32):
    # mut = mutable borrow — modify in place
    data *= factor

# Multiple borrows
def multi_borrow():
    var t = Tensor[Float32](100)
    var mean_val = analyze(t)     # borrow t
    scale_inplace(t, 2.0)       # mutate t
    var variance = analyze(t)    # borrow t again

    print(mean_val, variance)
