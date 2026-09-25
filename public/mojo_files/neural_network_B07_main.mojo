def main():
    print("== logical gates with hand-picked step weights ==")
    var and_gate = Neuron.gate([1.0, 1.0], -1.5)
    var or_gate = Neuron.gate([1.0, 1.0], -0.5)
    var not_gate = Neuron.gate([-1.0], 1.0)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print(p[0], p[1], "AND", and_gate.predict(p), "OR", or_gate.predict(p))
    print("NOT 0 ->", not_gate.predict([0.0]), " NOT 1 ->", not_gate.predict([1.0]))

    print("== train a single sigmoid neuron on AND ==")
    var and_xs = List[List[Float64]]()
    var and_ys = List[Float64]()
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        and_xs.append([p[0], p[1]])
        and_ys.append(1.0 if p[0] == 1.0 and p[1] == 1.0 else 0.0)
    var and_neuron = Neuron.sigmoid(2, 11)
    and_neuron.train(and_xs, and_ys, 3000, 0.7)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("AND", p[0], p[1], "->", and_neuron.predict(p))

    print("== one sigmoid neuron cannot learn XOR ==")
    var xor_xs = List[List[Float64]]()
    var xor_ys = List[Float64]()
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        xor_xs.append([p[0], p[1]])
        xor_ys.append(1.0 if p[0] != p[1] else 0.0)
    var lone_neuron = Neuron.sigmoid(2, 13)
    lone_neuron.train(xor_xs, xor_ys, 2000, 0.7)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("XOR", p[0], p[1], "->", lone_neuron.predict(p))

    print("== 2-2-1 MLP learns XOR ==")
    var mlp = MLP(7)
    mlp.train(xor_xs, xor_ys, 6000, 0.5)
    for p in [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]:
        print("XOR", p[0], p[1], "->", mlp.predict(p))
    print("final mean squared error:", mlp.mse(xor_xs, xor_ys))
