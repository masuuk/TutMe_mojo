from std.ffi import external_call, c_double, c_int

def main():
    # double frexp(double x, int *exp);
    var exponent: c_int = 0
    var mantissa = external_call["frexp", c_double](
        c_double(12.0), Pointer(to=exponent)
    )
    print(t"12.0 = {mantissa} * 2^{exponent}")
