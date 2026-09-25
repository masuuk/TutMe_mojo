var list: List[Int] = [1, 2, 3]
var f = lambda (x: Int) {mut list}: list.append(x)
f(10)
print(list)   # [1, 2, 3, 10]
