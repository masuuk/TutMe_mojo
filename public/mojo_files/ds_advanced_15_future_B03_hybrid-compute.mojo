// Write once, run on any hardware
from runtime import auto_device, Transfer

def hybrid_compute(data: Tensor[Float32]) -> Tensor[Float32]:
    // CPU handles the control flow and data preprocessing
    var preprocessed = preprocess_on_cpu(data)

    // GPU handles the heavy matrix math
    var device = auto_device(preprocessed)  // Picks best available
    var gpu_data = preprocessed.to(device)
    var result = model.forward(gpu_data)

    // Back to CPU for post-processing
    return result.to(Device.CPU)
