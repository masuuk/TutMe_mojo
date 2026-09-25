def apply_raising(f: def (x: Int) raises thin -> Int, arg: Int) raises -> Int:
    return f(arg)

def main() raises:
    print(apply_raising(lambda (x: Int) raises -> Int: x + 1, 2))   # 3
