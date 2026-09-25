# Import Python modules directly
from std.python import Python

def main() raises:
    # Use numpy from within Mojo
    var np = Python.import_module("numpy")
    var arr = np.array([1, 2, 3, 4, 5])
    var mean_val = np.mean(arr)
    print("NumPy mean:", mean_val)

    # Use matplotlib
    var plt = Python.import_module("matplotlib.pyplot")
    plt.plot(arr)
    plt.savefig("plot.png")
    plt.show()

    # Use pandas
    var pd = Python.import_module("pandas")
    var df = pd.DataFrame({"a": [1,2], "b": [3,4]})
    print(df.describe())
