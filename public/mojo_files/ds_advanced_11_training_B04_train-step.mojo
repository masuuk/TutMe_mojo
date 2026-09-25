from precision import amp, autocast
from tensor import Tensor, Float16, Float32

def train_step(model: Model, batch: Batch):
    // Autocast wraps forward pass in reduced precision
    with autocast(dtype=Float16):
        var logits = model.forward(batch.data)
        var loss = cross_entropy(logits, batch.labels)

    // Loss scaling prevents underflow in FP16 gradients
    var scaled_loss = loss * amp.scale_factor()
    scaled_loss.backward()

    // Unscaled gradients in FP32 master weights
    amp.unscale(model.optimizer)
    model.optimizer.step()
    amp.update_scale()
