struct Prng(Copyable):
    var state: UInt64

    def __init__(out self, seed: UInt64 = 42):
        self.state = seed

    def next_float(mut self) -> Float64:
        self.state ^= self.state << 13
        self.state ^= self.state >> 7
        self.state ^= self.state << 17
        return Float64(self.state) / 18446744073709551616.0

    def lower(mut self, scale: Float64) -> Float64:
        return self.next_float() * scale
