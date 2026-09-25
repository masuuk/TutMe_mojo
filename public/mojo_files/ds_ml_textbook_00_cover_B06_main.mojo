// Mojo — tensor creation and operations
from tensor import Tensor

def main():
    // Create a 2x3 tensor
    var a = Tensor[Float32](shape=[2, 3], values=[1.0, 2.0, 3.0,
        4.0, 5.0, 6.0])

    // Element-wise operations
    var b = a + 10.0                 // broadcast add
    var c = a * Tensor[Float32]([2.0, 3.0, 4.0])  // broadcast multiply

    // Matrix multiplication
    var d = matmul(a, transpose(a))

    print("a:", a)
    print("b:", b)
    print("d:", d)
