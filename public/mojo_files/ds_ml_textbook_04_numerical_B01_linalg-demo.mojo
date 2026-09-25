from tensor import Tensor
from math import sqrt

def linalg_demo():
    # Dot product
    var a = Tensor[Float32](4)
    var b = Tensor[Float32](4)
    for i in range(4):
        a[i] = Float32(i + 1)
        b[i] = Float32(i + 1) * 2.0
    var dp = dot(a, b)  # 60
    print("Dot product:", dp)

    # Matrix-vector multiply
    var M = Tensor[Float32](3, 3)
    M[0,0]=1.0; M[0,1]=2.0; M[0,2]=3.0
    M[1,0]=4.0; M[1,1]=5.0; M[1,2]=6.0
    M[2,0]=7.0; M[2,1]=8.0; M[2,2]=9.0

    var v = Tensor[Float32](3)
    v[0]=1.0; v[1]=0.0; v[2]=-1.0

    var result = matmul(M, v)
    print("M * v =", result[0], result[1], result[2])

    # Frobenius norm
    var norm: Float32 = 0.0
    for i in range(3):
        for j in range(3):
            norm += M[i, j] * M[i, j]
    norm = sqrt(norm)
    print("Frobenius norm:", norm)
