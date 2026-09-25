from math import sqrt

def tensor_basics():
    # Create a 2x3 tensor of zeros
    var t = Tensor[Float32](2, 3)
    print("Shape:", t.shape())

    # Create a tensor with specific values
    var mat = Tensor[Float32](2, 2)
    mat[0, 0] = 1.0
    mat[0, 1] = 2.0
    mat[1, 0] = 3.0
    mat[1, 1] = 4.0

    # Element access
    print("mat[0,1] =", mat[0, 1])

    # Fill with a constant
    var ones = Tensor[Float32](3, 3)
    ones.fill(1.0)
