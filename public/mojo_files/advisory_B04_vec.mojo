struct Vec:
    var x: Float64
    var y: Float64

    def __init__(out self, x: Float64,
                y: Float64):
        self.x = x
        self.y = y

def safe_div(a: Float64,
             b: Float64) raises -> Float64:
    if b == 0:
        raise "div by 0"
    return a / b
