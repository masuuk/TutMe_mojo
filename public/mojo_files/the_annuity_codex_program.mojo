# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/applications/finance/the_annuity_codex.html
#  File:    the_annuity_codex_program.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo the_annuity_codex_program.mojo
# ============================================================================
from std.math import pow

def fvifa(r: Float64, n: Int) -> Float64:
    """Future Value Interest Factor of Annuity."""
    if r == 0.0:
        return Float64(n)
    return (pow(1.0 + r, Float64(n)) - 1.0) / r

def pvifa(r: Float64, n: Int) -> Float64:
    """Present Value Interest Factor of Annuity."""
    if r == 0.0:
        return Float64(n)
    return (1.0 - pow(1.0 + r, -Float64(n))) / r

def fv_annuity(pmt: Float64, r: Float64, n: Int, due: Bool = False) -> Float64:
    """Future value of an annuity."""
    var factor = fvifa(r, n)
    if due:
        factor *= (1.0 + r)
    return pmt * factor

def pv_annuity(pmt: Float64, r: Float64, n: Int, due: Bool = False) -> Float64:
    """Present value of an annuity."""
    var factor = pvifa(r, n)
    if due:
        factor *= (1.0 + r)
    return pmt * factor

# ---- Example ----
def main():
    var pmt = 200.0
    var annual_rate = 0.07
    var years = 20
    var freq = 12

    var r = annual_rate / Float64(freq)
    var n = years * freq

    print("FVIFA  = ", fvifa(r, n))
    print("PVIFA  = ", pvifa(r, n))
    print("FV     = $", fv_annuity(pmt, r, n))
    print("PV     = $", pv_annuity(pmt, r, n))
