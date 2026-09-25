// The compiler decides the best backend automatically
from nn import Transformer, compile_for

var model = Transformer(n_layers=32, d_model=4096)

// Compile for whatever hardware is available
var compiled = compile_for(model, target=Target.AUTO)
// AUTO detects: GPU (CUDA/Metal/ROCm), CPU (AVX-512/NEON)
// Generates vendor-specific optimized code

// Or target multiple backends at once for deployment
var multi = compile_for(model, target=[
    Target.CUDA,
    Target.CPU_AVX512,
    Target.METAL
])
// One source, three optimized binaries
