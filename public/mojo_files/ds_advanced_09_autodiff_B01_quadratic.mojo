// Mojo's autodiff uses the ADT (Automatic Differentiation Type) system
from autodiff import gradient, Value

def quadratic(x: Value) -> Value:
    // f(x) = 3x² + 2x + 1
    return 3.0 * x * x + 2.0 * x + 1.0

def rosenbrock(x: Value, y: Value) -> Value:
    // f(x,y) = (1-x)² + 100(y-x²)²
    var a = 1.0 - x
    var b = y - x * x
    return a * a + 100.0 * b * b


// Compute gradients
var df_dx = gradient(quadratic)
print(df_dx(2.0))  // f'(2) = 12 + 2 = 14.0

// Multi-variable gradient
var grad = gradient(rosenbrock)
var (dx, dy) = grad(1.0, 1.0)
print(dx, dy)  // (0.0, 0.0) — minimum at (1,1)
