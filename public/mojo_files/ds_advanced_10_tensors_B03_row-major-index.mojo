from tensor import Tensor, LayoutTensor, NDBuffer

// Mojo encodes stride pattern at compile time
def row_major_index(i: Int, j: Int, cols: Int) -> Int:
    return i * cols + j

def col_major_index(i: Int, j: Int, rows: Int) -> Int:
    return j * rows + i


// Strided tensor view -- no data copy
def transpose_view(
    t: Tensor[Float32]
) -> Tensor[Float32]:
    // Swaps strides, not data
    var new_strides = (t.stride(1), t.stride(0))
    return Tensor[Float32](
        data=t.data(),
        shape=TensorShape(t.shape[1], t.shape[0]),
        strides=new_strides
    )


// Compute optimal stride for alignment
def aligned_stride(
    shape: TensorShape,
    elem_size: Int,
    alignment: Int = 64
) -> Int:
    var stride = shape[1] * elem_size
    return (stride + alignment - 1) & ~(alignment - 1)
