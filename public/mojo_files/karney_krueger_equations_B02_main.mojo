def main():
    var f = 1.0 / 298.257223563
    var e2 = 2.0 * f - f * f
    var n = f / (2.0 - f)
    for k in range(1, 6):
        print("term", k, ": ratio =", e2 ** k / n ** k)
    # term 1 : ratio = 3.98 ...   term 5 : ratio = 1002.6
