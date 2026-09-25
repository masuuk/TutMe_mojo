from std.ffi import external_call, c_int

def main():
    # int abs(int n);
    var n = external_call["abs", c_int](c_int(-42))
    print(t"Absolute value is 42: {n == 42}")
