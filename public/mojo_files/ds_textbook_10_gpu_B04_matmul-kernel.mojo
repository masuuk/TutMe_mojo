# Mojo — tiled matrix multiplication kernel
from std.gpu import thread_idx, block_idx
from max.gpu.sync import barrier
from std.memory import stack_allocation
from std.memory.address_space import AddressSpace

comptime TILE = 16  # tile size (16x16 = 256 threads)

def matmul_kernel(M: Int32, N: Int32, K: Int32,
                   A: DeviceBuffer, B: DeviceBuffer, C: DeviceBuffer):
    # Shared memory tiles
    var sA = stack_allocation[TILE*TILE, Float32,
        address_space=AddressSpace.SHARED]()
    var sB = stack_allocation[TILE*TILE, Float32,
        address_space=AddressSpace.SHARED]()

    var row = block_idx.y * TILE + thread_idx.y
    var col = block_idx.x * TILE + thread_idx.x
    var sum: Float32 = 0.0

    # Loop over tiles
    var num_tiles = (K + TILE - 1) // TILE
    for t in range(num_tiles):
        # Load tile into shared memory
        var a_col = t * TILE + thread_idx.x
        var b_row = t * TILE + thread_idx.y

        if row < M and a_col < K:
            sA[thread_idx.y * TILE + thread_idx.x] = A[row * K + a_col]
        else:
            sA[thread_idx.y * TILE + thread_idx.x] = 0.0

        if b_row < K and col < N:
            sB[thread_idx.y * TILE + thread_idx.x] = B[b_row * N + col]
        else:
            sB[thread_idx.y * TILE + thread_idx.x] = 0.0

        barrier()  # wait for all threads to load

        # Compute partial dot product from shared memory
        for k in range(TILE):
            sum += sA[thread_idx.y * TILE + k] * sB[k * TILE + thread_idx.x]

        barrier()  # wait before loading next tile

    # Write result to global memory
    if row < M and col < N:
        C[row * N + col] = sum

# Launch: grid of tiles, block of TILE x TILE threads
var grid = ((N + TILE - 1) // TILE, (M + TILE - 1) // TILE)
ctx.enqueue_function[matmul_kernel](
    Int32(M), Int32(N), Int32(K), d_A, d_B, d_C,
    grid_dim=grid, block_dim=(TILE, TILE),
)
