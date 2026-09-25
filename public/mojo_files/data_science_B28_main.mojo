from python import Python

def main() raises:
    var pd = Python.import_module("pandas")
    var sklearn = Python.import_module("sklearn")

    var X = pd.DataFrame({
        "hours": [1,2,3,4,5,6,7,8,9,10],
        "prev":  [40,55,60,70,75,80,82,88,90,95]})
    var y = [0,0,0,1,1,1,1,1,1,1]   # passed?

    var tts = sklearn.model_selection.train_test_split(X, y,
        test_size=0.3, random_state=0)
    var pipe = sklearn.pipeline.Pipeline([
        ("scale", sklearn.preprocessing.StandardScaler()),
        ("clf", sklearn.linear_model.LogisticRegression())])
    pipe.fit(tts[0], tts[2])
    var pred = pipe.predict(tts[1])
    print("accuracy", sklearn.metrics.accuracy_score(tts[3], pred))
