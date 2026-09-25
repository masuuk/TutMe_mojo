struct MyPair(Copyable):
    var first: Int
    var second: Int
    # Mojo synthesizes __init__(out self, *, copy: Self)
