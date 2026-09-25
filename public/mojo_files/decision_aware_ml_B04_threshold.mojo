from collections import List

def threshold(c_fp: Float64, c_fn: Float64) -> Float64:
    return c_fp / (c_fp + c_fn)

def decide(p: List[Float64], tau: Float64) -> List[Int]:
    var out = List[Int](capacity=len(p))
    for i in range(len(p)):
        out[i] = 1 if p[i] > tau else 0
    return out

def decision_cost(C: List[Float64],       # flattened 2×2
                    y: List[Int], d: List[Int]) -> Float64:
    var total: Float64 = 0.0
    for i in range(len(y)):
        total += C[y[i]*2 + d[i]]       # C[y, d]
    return total / Float64(len(y))
