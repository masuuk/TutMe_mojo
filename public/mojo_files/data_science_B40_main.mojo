from std.python import Python

def main() raises:
    var np = Python.import_module("numpy")
    var sklearn = Python.import_module("sklearn")
    var RF = sklearn.ensemble.RandomForestClassifier(n_estimators=200, random_state=0)

    var iris = sklearn.datasets.load_iris()
    var tts = sklearn.model_selection.train_test_split(
        iris.data, iris.target, test_size=0.25, random_state=0)
    RF.fit(tts[0], tts[2])
    print("hold-out accuracy", RF.score(tts[1], tts[3]))

    var cv = sklearn.model_selection.cross_val_score(RF, tts[0], tts[2], cv=5)
    print("CV mean / std", cv.mean().__round__(3), cv.std().__round__(3))
