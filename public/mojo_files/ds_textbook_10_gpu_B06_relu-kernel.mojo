# Element-wise ReLU kernel
def relu_kernel(x: DeviceBuffer, y: DeviceBuffer, n: Int32):
    var tid = block_idx.x * block_dim.x + thread_idx.x
    if tid < n:
        y[tid] = max(x[tid], 0.0)

# Element-wise sigmoid kernel
def sigmoid_kernel(x: DeviceBuffer, y: DeviceBuffer, n: Int32):
    var tid = block_idx.x * block_dim.x + thread_idx.x
    if tid < n:
        y[tid] = 1.0 / (1.0 + exp(-x[tid]))

# Batched softmax (more complex — needs reduction)
def softmax_kernel(x: DeviceBuffer, y: DeviceBuffer,
                   rows: Int32, cols: Int32):
    var row = block_idx.x * block_dim.x + thread_idx.x
    if row >= rows:
        return

    # Find max for numerical stability
    var row_max: Float32 = x[row * cols]
    for j in range(1, cols):
        row_max = max(row_max, x[row * cols + j])

    # Compute exp and sum
    var row_sum: Float32 = 0.0
    for j in range(cols):
        var val = exp(x[row * cols + j] - row_max)
        y[row * cols + j] = val
        row_sum += val

    # Normalize
    for j in range(cols):
        y[row * cols + j] /= row_sum

# Launch: one thread per row for softmax
ctx.enqueue_function[softmax_kernel](
    d_x, d_y, Int32(rows), Int32(cols),
    grid_dim=num_blocks, block_dim=256,
)
