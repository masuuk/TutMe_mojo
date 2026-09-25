from memory import memcpy, stack_allocation

# Small fixed-size buffer on the stack
def compute_with_stack_buf(
    input: Tensor[Float32]
) -> Float32:
    # 256 floats = 1KB on stack, no malloc
    comptime BUF_SIZE = 256
    var buf = stack_allocation[Float32, BUF_SIZE]()

    # Copy input into stack buffer
    var n = min(input.num_elements(), BUF_SIZE)
    memcpy(buf, input.data(), n)

    # Process on stack — cache-friendly
    var total: Float32 = 0.0
    for i in range(n):
        total += buf[i] * buf[i]
    return sqrt(total)
