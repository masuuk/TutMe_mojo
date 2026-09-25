# Extracted from tutorials on this site (source: praxis/drill_14.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_14.html

# math.mojo
def square(x: Int) -> Int:
    return x * x

# main.mojo
import math
from std.sys import CompilationTarget, get_defined_bool, is_defined

def main():
    print(math.square(9))               # 81

    # package: dir with __init__.mojo that re-exports a name
    # from mypackage import helper

    # compile-time defined flag
    comptime if is_defined["MY_FLAG"]():
        print("MY_FLAG was defined at build time")
    var has_fast = get_defined_bool["MOJO_ACCELERATOR"]()
    print(has_fast)

    # target introspection (ch12)
    comptime if CompilationTarget.is_linux():
        print("compiled for Linux")
    else:
        print("compiled for another target")
