# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ds_textbook_12_pytorch.html
#  File:    ds_textbook_12_pytorch_step.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ds_textbook_12_pytorch_step.mojo
# ============================================================================
# Step 2: Run inference in Mojo via MAX Engine
from max.engine import InferenceSession
from std.math import exp

def softmax(logits: List[Float64]) -> List[Float64]:
    var max_val = logits[0]
    for v in logits:
        if v > max_val:
            max_val = v
    var result = List[Float64](capacity=len(logits))
    var sum_exp: Float64 = 0.0
    for v in logits:
        sum_exp += exp(v - max_val)
    for v in logits:
        result.append(exp(v - max_val) / sum_exp)
    return result

def main():
    # Load the ONNX model into MAX Engine
    var session = InferenceSession("classifier.onnx")

    # Prepare input (e.g., a flattened 28x28 image)
    var input_data = List[Float64](capacity=784)
    for i in range(784):
        input_data.append(Float64(i) / 784.0)

    # Run inference
    var output = session.execute(input_data)
    var probs = softmax(output)

    # Find the predicted class
    var best_idx = 0
    var best_prob = probs[0]
    for i in range(1, len(probs)):
        if probs[i] > best_prob:
            best_prob = probs[i]
            best_idx = i

    print(f"Predicted class: {best_idx} (p={best_prob:.4f})")
