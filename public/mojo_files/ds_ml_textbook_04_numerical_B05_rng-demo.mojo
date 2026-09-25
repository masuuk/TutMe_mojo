from random import random_float64, random_uniform, random_normal, seed

def rng_demo():
    seed(42)

    var r1 = random_float64()         # [0, 1)
    var r2 = random_uniform(5.0, 10.0) # [5, 10)
    var r3 = random_normal()           # N(0, 1)

    print("Uniform:", r1)
    print("Range:", r2)
    print("Normal:", r3)

    # Generate random weight vector
    var weights = List[Float64]()
    for _ in range(5):
        weights.append(random_normal())
    print("Weights:", weights)
