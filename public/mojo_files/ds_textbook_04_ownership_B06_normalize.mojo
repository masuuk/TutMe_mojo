# Multiple immutable borrows — ALLOWED
var tensor = create_tensor()
var a = tensor.shape   # immutable borrow
var b = tensor.shape   # another immutable borrow
print(a, b)              # both valid simultaneously

# Mutable borrow — EXCLUSIVE
def normalize(mut t: Tensor[DType.float32]):
    t /= t.max()

normalize(tensor)  # mutable — no other borrows allowed

# This would be a COMPILE ERROR:
var data = [1, 2, 3]
var slice = data[...]   # immutable borrow of data
data.append(4)          # ERROR — can't mutate while borrowed
print(slice)

# Deterministic destruction
def process_batch():
    var buffer = allocate(1024)
    # ... use buffer ...
    return  # buffer.__del__ called HERE, deterministically
# No GC pause, no finalize, no waiting
