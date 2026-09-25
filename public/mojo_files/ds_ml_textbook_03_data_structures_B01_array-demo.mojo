from collections import List

def array_demo():
    # Dynamic list — can grow and shrink
    var scores = List[Float64]()
    scores.append(9.5)
    scores.append(8.7)
    scores.append(7.2)
    print("Scores:", scores)
    print("Length:", len(scores))

    # Fixed-size array — stack allocated
    var coordinates = Array[Float64, 3](
        1.0, 2.0, 3.0
    )
    print("x =", coordinates[0])
    print("y =", coordinates[1])

    # Iterate over a list
    for s in scores:
        print(s * 10.0)
