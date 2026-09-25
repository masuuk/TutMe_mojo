from python import Python

def main() raises:
    var np = Python.import_module("numpy")
    var pd = Python.import_module("pandas")
    var sns = Python.import_module("seaborn")
    var plt = Python.import_module("matplotlib.pyplot")

    var rng = np.random.default_rng(1)
    var mat = pd.DataFrame(rng.normal(0, 1, (5, 5)),
                          columns=["a", "b", "c", "d", "e"])
    sns.heatmap(mat.corr(), annot=True, cmap="viridis", center=0)
    plt.show()
