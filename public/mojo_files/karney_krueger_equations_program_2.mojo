# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/applications/geomatics/karney_krueger_equations.html
#  File:    karney_krueger_equations_program_2.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo karney_krueger_equations_program_2.mojo
# ============================================================================
from std.math import sin, radians, degrees

def conformal_latitude(phi: Float64, n: Float64) -> Float64:
    var n2 = n * n
    var n3 = n2 * n
    var n4 = n3 * n
    var n5 = n4 * n
    var n6 = n5 * n
    var c0 = -2*n + 2*n2/3 + 4*n3/3 - 82*n4/45 + 32*n5/45 + 4642*n6/4725
    var c1 =  5*n2/3 - 16*n3/15 - 13*n4/9 + 904*n5/315 - 1522*n6/945
    var c2 = -26*n3/15 + 34*n4/21 + 8*n5/5 - 12686*n6/2835
    var c3 = 1237*n4/630 - 12*n5/5 - 24832*n6/14175
    var c4 = -734*n5/315 + 109598*n6/31185
    var c5 = 444337*n6/155925
    return phi + c0*sin(2*phi) + c1*sin(4*phi) + c2*sin(6*phi)
                + c3*sin(8*phi) + c4*sin(10*phi) + c5*sin(12*phi)

def inverse_conformal_latitude(chi: Float64, n: Float64) -> Float64:
    var phi = chi
    for _ in range(3):
        phi -= conformal_latitude(phi, n) - chi
    return phi

def main():
    var n = (1.0 / 298.257223563) / (2.0 - 1.0 / 298.257223563)
    var chi = conformal_latitude(radians(-17.829), n)
    print(degrees(chi))                               # -17.8275589...
    print(degrees(inverse_conformal_latitude(chi, n))) # -17.829
