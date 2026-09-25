from math import exp

def softmax(z: List[Float64], temperature: Float64 = 1.0) -> List[Float64]:
    var mz = z[0] / temperature
    for i in range(1, z.size):
        var zi = z[i] / temperature
        if zi > mz: mz = zi
    var numer = List[Float64]()
    var denom: Float64 = 0.0
    for zi in z:
        var ei = exp(zi / temperature - mz)
        numer.append(ei)
        denom += ei
    var result = List[Float64]()
    for ei in numer:
        result.append(ei / denom)
    return result

def main():
    var logits = List[Float64](2.0, 0.5, 0.1, -0.3)
    for T in [0.2, 1.0, 5.0]:
        print("T =", T, softmax(logits, T))
