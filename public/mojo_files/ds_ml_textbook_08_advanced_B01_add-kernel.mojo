from std.gpu import thread_idx, block_idx, block_dim
from max.gpu.host import DeviceContext
from std.math import ceildiv

def add_kernel(A: DeviceBuffer, B: DeviceBuffer,
                C: DeviceBuffer, n: Int32):
    var idx = block_idx.x * block_dim.x + thread_idx.x
    if idx < n:
        C[idx] = A[idx] + B[idx]

def gpu_add() raises:
    comptime N = 1024
    comptime BLOCK = 256

    var ctx = DeviceContext()
    var A_gpu = ctx.enqueue_create_buffer[DType.float32](N)
    var B_gpu = ctx.enqueue_create_buffer[DType.float32](N)
    var C_gpu = ctx.enqueue_create_buffer[DType.float32](N)
    # ... copy inputs with ctx.enqueue_copy(...) ...

    # Launch kernel on the GPU
    ctx.enqueue_function[add_kernel](
        A_gpu, B_gpu, C_gpu, Int32(N),
        grid_dim=ceildiv(N, BLOCK), block_dim=BLOCK,
    )
    ctx.synchronize()
