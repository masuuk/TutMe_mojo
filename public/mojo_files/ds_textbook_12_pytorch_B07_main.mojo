from max.engine import InferenceSession
from max.engine.optimization import (
    quantize_int8,
    quantize_int4,
    fuse_operators,
    optimize_memory,
)

def main():
    # Load model
    var session = InferenceSession("classifier.onnx")

    # Apply optimization pipeline
    var optimized = session.optimize([
        fuse_operators(),       # combine MatMul + Add + ReLU
        optimize_memory(),      # minimize peak allocation
        quantize_int8(),        # INT8 weight quantization
    ])

    # Compare model sizes
    var original_size = session.model_size()
    var optimized_size = optimized.model_size()
    var reduction = (1 - optimized_size / original_size) * 100

    print(f"Original:  {original_size / 1_000_000:.1f} MB")
    print(f"Optimized: {optimized_size / 1_000_000:.1f} MB")
    print(f"Reduction: {reduction:.0f}%")

    # Benchmark the optimized model
    var original_time = benchmark_inference(session, input_data)
    var optimized_time = benchmark_inference(optimized, input_data)

    print(f"Speedup: {original_time / optimized_time:.1f}x")

    # INT4 for edge deployment (more aggressive)
    var edge_model = session.optimize([quantize_int4()])
    print(f"INT4 size: {edge_model.model_size() / 1_000_000:.1f} MB")
