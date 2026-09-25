# Broadcasting — implicit shape alignment
def broadcast_add():
    var a = Tensor[Float32](4, 3)  # shape (4, 3)
    var b = Tensor[Float32](3)     # shape (3,)

    # b is broadcast to (4, 3) automatically
    var result = a + b

    # Adding a column vector to a matrix
    var matrix = Tensor[Float32](100, 64)  # (100, 64)
    var bias = Tensor[Float32](1, 64)       # (1, 64)
    var output = matrix + bias               # broadcast along axis 0

# Element-wise operations with broadcasting
def normalize_batch(batch: Tensor[Float32]) -> Tensor[Float32]:
    # batch shape: (N, C, H, W)
    var means = batch.mean(axis=1)  # shape: (N, 1, H, W)
    var stds = batch.std(axis=1)    # shape: (N, 1, H, W)

    # Broadcasting: (N, C, H, W) - (N, 1, H, W) / (N, 1, H, W)
    return (batch - means) / stds
