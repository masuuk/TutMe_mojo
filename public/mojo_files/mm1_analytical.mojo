# Extracted from tutorials on this site (source: praxis/drill_24.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_24.html

def mm1(lambda_: Float64, mu: Float64):
    var rho = lambda_ / mu            # utilisation
    var l = rho / (1.0 - rho)         # avg in system
    var lq = rho * rho / (1.0 - rho)  # avg in queue
    var w = l / lambda_               # avg time in system
    var wq = lq / lambda_             # avg wait in queue
    var p0 = 1.0 - rho                # server idle probability
    print("rho", rho, "L", l, "Lq", lq)
    print("W", w, "Wq", wq, "P0", p0)
    # Little's law: L = lambda * W  -> 3 = 6 * 0.5  ✓

def main():
    mm1(6.0, 8.0)                     # rho .75 L 3 Lq 2.25 W .5 Wq .375
