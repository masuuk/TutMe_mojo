from python import Python
from random import Random

def main() raises:
    var np = Python.import_module("numpy")
    var plt = Python.import_module("matplotlib.pyplot")
    var rng = Random(7)

    var x = np.array([rng.normal_float64() for _ in range(200)])
    var y = 2 * x + np.array([rng.normal_float64() * 0.5 for _ in range(200)])

    plt.figure(figsize=(12, 3.5))
    plt.subplot(1, 3, 1); plt.hist(x, bins=25, color="#3b82f6"); plt.title("histogram")
    plt.subplot(1, 3, 2); plt.scatter(x, y, s=12, alpha=0.7); plt.title("scatter")
    plt.tight_layout()
    plt.show()
