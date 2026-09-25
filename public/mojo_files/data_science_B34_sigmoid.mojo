from std.math import exp

def sigmoid(x: Float64) -> Float64:
    return 1.0 / (1.0 + exp(-x))

def relu(x: Float64) -> Float64:
    if x > 0.0: return x
    return 0.0

def main():
    var xs = [-2.0, -1.0, 0.0, 1.0, 2.0]
    var sig = List[Float64]()
    var rel = List[Float64]()
    for v in xs:
        sig.append(sigmoid(v))
        rel.append(relu(v))
    print(sig)   # [0.119 0.269 0.5 0.731 0.881]
    print(rel)   # [0.0 0.0 0.0 1.0 2.0]
