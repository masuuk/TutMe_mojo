from tensor import Tensor
from math import sqrt

def linear_algebra_demo():
    # Broadcasting: scalar + tensor
    var t = Tensor[Float32](3, 3)
    t.fill(2.0)
    t += 1.0           # each element becomes 3.0

    # Broadcasting: row vector + matrix
    var row = Tensor[Float32](3)
    row[0] = 1.0; row[1] = 2.0; row[2] = 3.0

    # Matrix multiplication
    var a = Tensor[Float32](2, 3)
    a[0,0] = 1.0; a[0,1] = 2.0; a[0,2] = 3.0
    a[1,0] = 4.0; a[1,1] = 5.0; a[1,2] = 6.0

    var b = Tensor[Float32](3, 2)
    b[0,0] = 7.0;  b[0,1] = 8.0
    b[1,0] = 9.0;  b[1,1] = 10.0
    b[2,0] = 11.0; b[2,1] = 12.0

    var c = matmul(a, b)  # Result is 2x2
    print("c[0,0] =", c[0, 0])  # 58.0
    print("c[1,1] =", c[1, 1])  # 154.0
