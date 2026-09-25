# Full Mojo pipeline: load and split data natively, fit Holt-Winters via
# Python interop (pandas + statsmodels), then evaluate MAE in Mojo.
from std.python import Python
from std.python.numpy import copy_to_numpy_array

def main():
    # 1. Load data as a typed Mojo List
    var data: List[Float64] = [
        120.0, 132.0, 145.0, 138.0, 150.0, 165.0, 170.0,
        158.0, 175.0, 190.0, 185.0, 200.0, 210.0, 205.0,
        220.0, 215.0, 230.0, 240.0, 235.0, 250.0, 260.0,
        255.0, 270.0, 280.0,
    ]
    # 2. Chronological split (train: first 18, test: last 6)
    var train = List[Float64]()
    var test = List[Float64]()
    for i in range(18):
        train.append(data[i])
    for i in range(18, 24):
        test.append(data[i])
    # 3. Fit via Python interop: Mojo List -> NumPy -> pandas Series
    var pd_module = Python.import_module("pandas")
    var statsmodels = Python.import_module("statsmodels.tsa.holtwinters")
    var train_series = pd_module.Series(copy_to_numpy_array(train))
    var hw = statsmodels.ExponentialSmoothing(
        train_series, trend="add", seasonal="add", seasonal_periods=12,
    )
    var model = hw.fit()
    # 4. Forecast the next 6 months
    var forecast = model.forecast(6)
    # 5. Evaluate: mean absolute error against the held-out test set
    var mae: Float64 = 0.0
    for i in range(6):
        var diff = test[i] - Float64(forecast.values[i])
        if diff < 0.0:              # absolute value (sign check)
            diff = -diff
        mae += diff
    mae /= 6.0
    print("Forecast:", forecast.values)
    print("Test MAE:", mae)
