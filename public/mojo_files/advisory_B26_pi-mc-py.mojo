# file: kernels.mojo
from python import PythonObject

def pi_mc_py(n: Int) -> Float64:
    return pi_mc(n, 42)   # SIMD kernel above

# register with the package builder:
# [project]
# name = "kernels"
# [tool.pixi.project]  # or mojo pack
