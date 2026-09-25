from max.engine import InferenceSession
from tensor import Tensor

def serve(prompt_ids: Tensor[DType.int32]) raises:
    var session = InferenceSession("phi3-yoda.onnx",
                                 dtype=DType.float16)
    _ = session.execute(prompt_ids)         # first call compiles
    var tokens = session.execute(prompt_ids)  # warm: native latency
    return tokens
