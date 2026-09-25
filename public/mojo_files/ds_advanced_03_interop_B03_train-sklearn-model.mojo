from python import Python, PythonObject

def train_sklearn_model() raises:
    # scikit-learn inside Mojo
    var sklearn = Python.import_module("sklearn.linear_model")
    var np = Python.import_module("numpy")

    # Prepare data
    var X = np.array([[1],[2],[3],[4]])
    var y = np.array([2, 4, 6, 8])

    # Train model
    var model = sklearn.LinearRegression()
    model.fit(X, y)

    # Predict from Mojo
    var pred = model.predict(np.array([[5]]))
    print("Prediction for 5:", pred)

# Pass Mojo data to Python via buffer protocol
def mojo_to_numpy():
    var np = Python.import_module("numpy")
    var data = List[Float64]()
    for i in range(100):
        data.append(Float64(i) * 0.1)

    # Convert List to numpy array via Python
    var arr = np.array(data)
    print(arr.shape)
