from collections import List
from math import abs, max

# block-wise absmax quantize to 4-bit codes — the kernel that
# makes serving-side quantization a single compiled pass.
def quantize_absmax(w: List[Float64], b: Int,
                     out_q: List[Int], out_scale: List[Float64]):
    var n = len(w)
    var n_blocks = n // b
    for blk in range(n_blocks):
        var lo = blk * b
        var hi = lo + b
        var am: Float64 = 0.0
        for i in range(lo, hi):
            am = max(am, abs(w[i]))
        out_scale[blk] = am                 # fp32 constant per block
        for i in range(lo, hi):
            var wn = w[i] / (am + 1e-12)      # to [-1,1]
            out_q[i] = Int((wn + 1.0) * 7.5 + 0.5) # 16 codes

def dequant(q: List[Int], scale: Float64) -> Float64:
    return (Float64(q) / 7.5 - 1.0) * scale
