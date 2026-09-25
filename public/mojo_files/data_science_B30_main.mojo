from std.python import Python

def main() raises:
    var np = Python.import_module("numpy")
    var lm = Python.import_module("sklearn.linear_model")
    var en = Python.import_module("sklearn.ensemble")

    # --- regression: y = 3x + 2 ---
    var X = np.array([[1],[2],[3],[4],[5],[6]])
    var y = np.array([5,8,11,14,17,20])
    var lr = lm.LinearRegression().fit(X, y)
    print("coef =", lr.coef_, "intercept =", lr.intercept_)   # [3.] 2.0

    # --- classification ---
    var Xc = np.array([[1,0],[2,0],[3,1],[4,1]])
    var yc = np.array([0,0,1,1])
    print(lm.LogisticRegression().fit(Xc, yc).predict([[2.5,0.5]]))   # → [0]
    print(en.RandomForestClassifier(n_estimators=100)
          .fit(Xc, yc).predict([[3.5,1.0]]))   # → [1]
