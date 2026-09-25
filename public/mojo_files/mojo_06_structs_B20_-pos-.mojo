# Unary: +c and -c
    def __pos__(self) -> Self:
        return self

    def __neg__(self) -> Self:
        return Self(-self.re, -self.im)

    # Binary arithmetic (same-type shown; add Float64 overloads
    # plus __radd__/__rsub__/... to accept scalar on the left)
    def __add__(self, rhs: Self) -> Self:
        return Self(self.re + rhs.re, self.im + rhs.im)

    def __sub__(self, rhs: Self) -> Self:
        return Self(self.re - rhs.re, self.im - rhs.im)

    # In-place: modifies self, returns nothing
    def __iadd__(mut self, rhs: Self):
        self.re += rhs.re
        self.im += rhs.im

    # Boolean context: nonzero if either component nonzero
    def __bool__(self) -> Bool:
        return self.re != 0.0 or self.im != 0.0

    # Subscript: index 0 → real part, 1 → imaginary part
    def __getitem__(self, idx: Int) raises -> Float64:
        if idx == 0: return self.re
        if idx == 1: return self.im
        raise "index out of bounds"

    def __setitem__(mut self, idx: Int, value: Float64) raises:
        if idx == 0: self.re = value
        elif idx == 1: self.im = value
        else: raise "index out of bounds"
