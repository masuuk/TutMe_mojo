from std.ffi import OwnedDLHandle, c_double
from std.sys.info import platform_map

comptime LIBM = platform_map["libm", linux="libm.so.6", macos="libm.dylib"]()

def main() raises:
    var lib = OwnedDLHandle(LIBM)
    var sqrt = lib.get_function[c_double]("sqrt")
    print(sqrt(c_double(4.0)))
    # Library automatically closed when lib goes out of scope
