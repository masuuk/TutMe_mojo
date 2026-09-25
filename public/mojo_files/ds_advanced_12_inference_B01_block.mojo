from compiler import compile_model, CompileConfig
from inference import InferenceSession

// Compile a trained model for inference
var cfg = CompileConfig(
    target=Target.CPU,   // or Target.CUDA, Target.METAL
    precision=Float16,
    fuse_ops=True,
    optimize_memory=True
)

var compiled = compile_model(
    model_path="model.mojomodel",
    config=cfg
)

// Run inference — no Python overhead
var session = InferenceSession(compiled)
var output = session.run(input_tensor)
print(output.shape)  // [1, 512, 1024]
