# Mojo compiles to MLIR under the hood
# The compiler pipeline:
#   Mojo source → Mojo IR → MLIR (standard + GPU + LLVM dialects) → LLVM IR → Machine code

# You can target specific hardware via MLIR attributes
def gpu_kernel(ctx: DeviceContext):
    # Mojo automatically maps to the GPU dialects
    ctx.enqueue_function[work](grid_dim=1, block_dim=1024)
    # Each thread runs one iteration of the work function

# This compiles to:
#   gpu.launch_func @kernel blocks=(1,1,1) threads=(1024,1,1)
# Which the GPU backend lowers to PTX / Metal / SPIR-V

# Cross-compilation targets
# mojo build --target aarch64-apple-darwin    # Apple Silicon
# mojo build --target x86_64-unknown-linux    # Linux x86
# mojo build --target nvptx64-nvidia-cuda     # NVIDIA GPU
