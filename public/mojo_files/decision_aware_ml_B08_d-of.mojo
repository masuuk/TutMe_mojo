# SPO+ for the 1-D allocation case: D = [0, q_max], c(d; y) = -y*d
# (buy d units, earn y per unit). d(c) = q_max if c > 0 else 0.

def d_of(c: Float64, q_max: Float64) -> Float64:
    return q_max if c > 0.0 else 0.0

def spo_plus_1d(y: Float64, y_hat: Float64,
                    q_max: Float64) -> Float64:
    var c_your = -(y * d_of(y_hat, q_max))     # c(d(y_hat); y)
    var c_orac = -(y * d_of(y,      q_max))     # c(d(y); y)
    # worst-case over D = {0, q_max}: pick the max of the two corners
    var g0 = y*0.0  - 2.0*y_hat*0.0
    var g1 = y*q_max - 2.0*y_hat*q_max
    return max(g0, g1) - 2.0*c_your + c_orac

# piecewise-linear in y_hat → subgradient exists everywhere;
# train with a subgradient step per sample.
