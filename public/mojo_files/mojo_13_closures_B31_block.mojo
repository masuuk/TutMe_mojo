var fp = lambda (a: Int32, b: Int32) abi("C") -> Int32: a + b
print(fp(1, 2))   # 3
