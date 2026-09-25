from std.sys import CompilationTarget

def compute():
    comptime if CompilationTarget.has_avx512f():
        print("AVX-512 path")
    elif CompilationTarget.is_apple_silicon():
        print("Apple Silicon path")
    else:
        print("generic path")
