def main():
    comptime whole = (lambda (x: Int) {} -> Int: x * 2)(21)
    print(whole)   # 42
