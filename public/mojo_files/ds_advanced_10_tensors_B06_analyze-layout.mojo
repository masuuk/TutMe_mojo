from tensor import Tensor

// Memory layout analysis
def analyze_layout(t: Tensor[Float32]):
    print("Shape:", t.shape)
    print("Strides:", t.strides())
    print("Element size:", t.element_size(), "bytes")
    print("Total bytes:", t.nbytes())

    // Check if contiguous
    var is_contiguous = True
    for i in range(t.rank() - 1):
        if t.stride(i) != t.shape[i + 1] * t.stride(i + 1):
            is_contiguous = False
            break
    print("Contiguous:", is_contiguous)


// Pre-allocate output for fused operations
def fused_matmul_add(
    A: Tensor[Float32],
    B: Tensor[Float32],
    bias: Tensor[Float32],
    output: Tensor[Float32]  // pre-allocated
):
    // C = A @ B + bias (fused, no temp allocation)
    matmul(A, B, output)
    for i in range(output.shape[0]):
        for j in range(output.shape[1]):
            output[i, j] += bias[j]
