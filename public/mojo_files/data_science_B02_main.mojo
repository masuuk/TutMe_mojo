from python import Python

def main() raises:
    var pd = Python.import_module("pandas")
    var sklearn = Python.import_module("sklearn")
    var df = pd.read_csv("grades.csv")        # acquire
    df = df.dropna().drop_duplicates()     # clean
    var corr = df.corr()                    # explore
    var X = df.drop("final", axis=1)
    var y = df["final"]
    var tts = sklearn.model_selection.train_test_split(
        X, y, test_size=0.2, random_state=42)
    var pipe = sklearn.pipeline.Pipeline([(
        "scale", sklearn.preprocessing.StandardScaler()),
        ("reg", sklearn.linear_model.LinearRegression())])
    pipe.fit(tts[0], tts[2])                # model
    var r2 = pipe.score(tts[1], tts[3])     # evaluate → communicate
    print("test R^2 =", r2.__round__(3))
