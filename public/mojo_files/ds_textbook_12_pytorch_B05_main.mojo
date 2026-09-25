from max.engine import InferenceSession, Model

def main():
    # Load model with hardware-specific optimizations
    var session = InferenceSession(
        "classifier.onnx",
        dtype=DType.float32,
    )

    # Warmup — first inference compiles the graph
    _ = session.execute(List[Float64](capacity=784))

    # Benchmark inference latency
    var total_time: Float64 = 0.0
    var iterations = 1000

    for i in range(iterations):
        var start = now()
        var _ = session.execute(input_data)
        total_time += (now() - start)

    var avg_ms = (total_time / iterations) * 1000
    print(f"Average latency: {avg_ms:.2f}ms")
    print(f"Throughput: {1000/avg_ms:.0f} inferences/sec")

    # Batch inference for throughput
    var batch_size = 32
    var batch = List[List[Float64]](capacity=batch_size)
    for i in range(batch_size):
        batch.append(create_input(i))

    var batch_output = session.execute_batch(batch)
    print(f"Batch of {batch_size} completed")
