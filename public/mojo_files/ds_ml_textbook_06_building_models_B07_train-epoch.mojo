from tensor import Tensor

def train_epoch(
    mut model: TwoLayerNet,
    X: Tensor[Float32],
    y: Tensor[Float32],
    lr: Float32,
) -> Float32:
    var probs = model.forward(X)
    # Cross-entropy loss
    var loss: Float32 = 0.0
    for i in range(probs.num_elements()):
        if y[i] > 0.0:
            loss -= y[i] * log(probs[i] + 1e-7)
    # Backward: dL/d(logits) = probs - one_hot(y)
    var d_logits = Tensor[Float32](probs.shape())
    for i in range(probs.num_elements()):
        d_logits[i] = probs[i] - y[i]
    # SGD weight update
    for i in range(model.W2.num_elements()):
        model.W2[i] -= lr * d_logits[i % d_logits.num_elements()]
    return loss
