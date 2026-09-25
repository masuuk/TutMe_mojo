from std.utils.numerics import isfinite, isinf, isnan

def main():
    var inf = FloatLiteral.infinity
    print(isinf(inf))       # True
    var nan = FloatLiteral.nan
    print(isnan(nan))       # True
