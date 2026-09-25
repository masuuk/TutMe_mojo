from collections import List

def exact_match(outs: List[String],
                  tgts: List[String]) -> Float64:
    var hits = 0
    for i in range(len(outs)):
        if outs[i].strip() == tgts[i].strip():
            hits += 1
    return Float64(hits) / Float64(len(outs))

# Elo update after one judged match (K = 32, S = 1/0/0.5):
def elo_update(ra: Float64, rb: Float64,
                   s_a: Float64) -> (Float64, Float64):
    var ea = 1.0 / (1.0 + 10.0 ** ((rb - ra) / 400.0))
    var delta = 32.0 * (s_a - ea)
    return (ra + delta, rb - delta)
