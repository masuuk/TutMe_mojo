# Mojo — forward pass with ReLU and sigmoid
from math import sigmoid

def matmul(A: List[Float64], B: List[Float64],
           rows: Int, cols: Int, inner: Int) -> List[Float64]:
    # A is (rows × inner), B is (inner × cols)
    var C = List[Float64]()
    for i in range(rows):
        for j in range(cols):
            var sum: Float64 = 0.0
            for k in range(inner):
                sum += A[i * inner + k] * B[k * cols + j]
            C.append(sum)
    return C

def relu(x: List[Float64]) -> List[Float64]:
    var result = List[Float64]()
    for val in x:
        result.append(max(val, 0.0))
    return result

def forward(self: NeuralNetwork,
             x: List[Float64]) -> (List[Float64], List[Float64], List[Float64]):
    # Layer 1: z1 = W1 · x + b1, a1 = ReLU(z1)
    var z1 = matmul(self.W1, x,
                    self.n_hidden, 1, self.n_features)
    for i in range(self.n_hidden):
        z1[i] += self.b1[i]
    var a1 = relu(z1)

    # Layer 2: z2 = W2 · a1 + b2
    var z2 = matmul(self.W2, a1, 1, 1, self.n_hidden)
    z2[0] += self.b2[0]
    var output = [sigmoid(z2[0])]

    return (z1, a1, output)
