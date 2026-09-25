# Mojo — vector addition GPU kernel (Mojo 1.x / MAX 26.5)
from std.gpu import thread_idx, block_idx, block_dim
from max.gpu.host import DeviceContext, DeviceBuffer
from std.math import ceildiv

comptime BLOCK_SIZE = 256
comptime N = 1_000_000

def vec_add_kernel(a: DeviceBuffer, b: DeviceBuffer,
                   c: DeviceBuffer, n: Int32):
    var tid = block_idx.x * block_dim.x + thread_idx.x
    if tid < n:
        c[tid] = a[tid] + b[tid]

def main() raises:
    var ctx = DeviceContext()

    # Allocate GPU memory (asynchronous, queued on the device stream)
    var d_a = ctx.enqueue_create_buffer[float32](N)
    var d_b = ctx.enqueue_create_buffer[float32](N)
    var d_c = ctx.enqueue_create_buffer[float32](N)
    # ... copy inputs from host with ctx.enqueue_copy(...) ...

    # Compile and launch the kernel on the GPU
    comptime num_blocks = ceildiv(N, BLOCK_SIZE)
    ctx.enqueue_function[vec_add_kernel](
        d_a, d_b, d_c, Int32(N),
        grid_dim=num_blocks, block_dim=BLOCK_SIZE,
    )
    ctx.synchronize()
