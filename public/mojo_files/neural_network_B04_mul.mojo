def mul(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for k in range(b.cols):
            var total: Float64 = 0.0
            for j in range(a.cols):
                total += a[i, j] * b[j, k]
            out.append(total)
    return Matrix(a.rows, b.cols, out)


def add_bias(z: Matrix, b: List[Float64]) -> Matrix:
    var out = List[Float64]()
    for i in range(z.rows):
        out.append(z[i, 0] + b[i])
    return Matrix(z.rows, 1, out)


def transpose(a: Matrix) -> Matrix:
    var out = List[Float64]()
    for c in range(a.cols):
        for r in range(a.rows):
            out.append(a[r, c])
    return Matrix(a.cols, a.rows, out)


def outer(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(b.rows):
            out.append(a[i, 0] * b[j, 0])
    return Matrix(a.rows, b.rows, out)


def elementwise(a: Matrix, b: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] * b[i, j])
    return Matrix(a.rows, a.cols, out)


def scale(a: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] * s)
    return Matrix(a.rows, a.cols, out)


def add_scalar(a: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] + s)
    return Matrix(a.rows, a.cols, out)


def add_mul(a: Matrix, b: Matrix, s: Float64) -> Matrix:
    var out = List[Float64]()
    for i in range(a.rows):
        for j in range(a.cols):
            out.append(a[i, j] + s * b[i, j])
    return Matrix(a.rows, a.cols, out)


def column(vals: List[Float64]) -> Matrix:
    var out = List[Float64]()
    for i in range(len(vals)):
        out.append(vals[i])
    return Matrix(len(vals), 1, out)


def relu_activation(m: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(m.rows):
        for j in range(m.cols):
            out.append(relu(m[i, j]))
    return Matrix(m.rows, m.cols, out)


def sigmoid_activation(m: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(m.rows):
        for j in range(m.cols):
            out.append(sigmoid(m[i, j]))
    return Matrix(m.rows, m.cols, out)


def relu_mask(z: Matrix) -> Matrix:
    var out = List[Float64]()
    for i in range(z.rows):
        for j in range(z.cols):
            out.append(1.0 if z[i, j] > 0.0 else 0.0)
    return Matrix(z.rows, z.cols, out)
