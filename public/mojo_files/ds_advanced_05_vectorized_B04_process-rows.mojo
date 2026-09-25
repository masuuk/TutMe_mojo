# Views — zero-copy slicing and reshaping
from tensor import Tensor, TensorSpec

def process_rows():
    var t = Tensor[Float32](100, 10)  # 100 rows, 10 cols

    # Slice — creates a view, no data copy
    var row5 = t[5, :]        # View of row 5
    var col3 = t[:, 3]        # View of column 3
    var block = t[10:20, 2:8]  # View of a sub-block

    # Reshape — also zero-copy
    var flat = t.reshape[1000]()

    # Transpose — zero-copy (swaps strides)
    var transposed = t.T  # View of shape (10, 100)

# Mutable views for in-place transformation
def normalize_rows(mut t: Tensor[Float32]):
    for i in range(t.dim[0]):
        var row = t[i, :]       # View of row i
        var mean = row.reduce_add() / Float32(t.dim[1])
        var std = row.std()
        t[i, :] = (row - mean) / std  # In-place via view
