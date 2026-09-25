from std.python import Python

def main():
    var pd = Python.import_module("pandas")
    var df = pd.read_csv("grades.csv")
    print(df.head())

    var np = Python.import_module("numpy")
    var scores = df["score"].to_list()
    print("mean:", np.mean(scores))
