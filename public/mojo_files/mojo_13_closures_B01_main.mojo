def main():
    var multiplier = 3
    def scale(x: Int) {imm multiplier} -> Int:
        return x * multiplier
    print(scale(5))   # 15
