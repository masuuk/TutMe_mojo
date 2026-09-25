# Mojo — inference worker for the hybrid pipeline
from max.engine import InferenceSession

struct InferenceWorker:
    var session: InferenceSession

    def __init__(out self, model_path: String):
        self.session = InferenceSession(model_path)

    def predict(self, features: List[Float64]) -> List[Float64]:
        return self.session.execute(features)
