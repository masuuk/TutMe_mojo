def main():
    var f = lambda (x: Int) {} -> Int:
        (lambda (y: Int) {imm x} -> Int: y + x)(3)
    print(f(6))   # 9
