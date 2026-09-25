from max.engine import InferenceSession
from math import sqrt, sin, cos
from collections import defaultdict

def load_model(path: str) -> InferenceSession:
    session = InferenceSession(path)
    return session
