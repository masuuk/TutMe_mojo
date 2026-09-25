def main():
    # Fully explicit. Empty "no-capture" capture list `{}`
    var a = lambda (x: Int) {} -> Int: x + 1
    # Parameterized
    var b = lambda [T: Intable](x: T) -> Int: Int(x) + 1
    var y = 1
    # Capture list omitted. `y` defaults to `imm`
    var c = lambda (x: Int) -> Int: x * 2 + y
    # Mutable capture, return type omitted (`None`)
    var list: List[Int] = [1]
    var d = lambda (x: Int) {mut list}: list.append(x)
    # Arguments and return type omitted. Mutable capture
    var e = lambda {mut list}: list.append(0)
    print(a(4), b(4))   # 5 8
