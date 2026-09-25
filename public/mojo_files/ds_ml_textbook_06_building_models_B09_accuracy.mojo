from tensor import Tensor

def accuracy(
    model: TwoLayerNet,
    X_test: Tensor[Float32],
    y_test: Tensor[Float32],
) -> Float32:
    var probs = model.forward(X_test)
    var correct: Int = 0
    var total = probs.shape()[0]
    var nc = probs.shape()[1]
    for i in range(total):
        var pred_class: Int = 0
        var best: Float32 = probs[i * nc]
        for c in range(1, nc):
            if probs[i * nc + c] > best:
                best = probs[i * nc + c]
                pred_class = c
        if Float32(pred_class) == y_test[i]:
            correct += 1
    return Float32(correct) / Float32(total)

var acc = accuracy(model, X_test, y_test)
print("Test accuracy:", acc * 100.0, "%")
