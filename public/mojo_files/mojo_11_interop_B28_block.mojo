var lib = OwnedDLHandle(LIBM)

if lib.check_symbol("exp10"):
    var exp10 = lib.get_function[c_double]("exp10")
    print(exp10(c_double(2.0)))   # 100.0
else:
    print("exp10 not found in libm")
