from tensor import Tensor

def main():
    var a = Tensor[DType.int64](2, 3)       # zeros first, then fill
    var n: Int64 = 1
    for i in range(2):
        for j in range(3):
            a[i, j] = n
            n += 1
    print(a.shape())                          # (2, 3)
    print(a[0, 1])                        # element → 2

    var got: Int64 = 0                  # "mask": count elements > 3
    for i in range(2):
        for j in range(3):
            if a[i, j] > 3:
                got += 1
    print(got)                                # → 3  (elements 4, 5, 6)
