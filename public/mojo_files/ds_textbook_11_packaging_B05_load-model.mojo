from max.engine import InferenceSession
from math import sqrt, sin, cos
from collections import Dict

def load_model(path: String) -> InferenceSession:
    var session = InferenceSession(path)
    return session
