# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/time_series_analytics.html
#  File:    time_series_analytics_scikit.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo time_series_analytics_scikit.mojo
# ============================================================================
# Fit scikit-learn from Mojo: compute the features natively, hand them to
# NumPy with the interop helper, then call sklearn through Python.
from std.python import Python
from std.python.numpy import copy_to_numpy_array

def train_linear_regression():
    var sklearn_lr = Python.import_module("sklearn.linear_model").LinearRegression
    var sales = load_sales_data()
    # reuse the native Mojo feature builders defined earlier in this chapter
    var lags = create_lag_features(sales, 3)     # 21 rows x 3 lags, flat
    var roll_mean = create_rolling_mean(sales, 3)   # 22 values
    var X_rows = 21
    var X_flat = List[Float64]()
    var y_flat = List[Float64]()
    for i in range(X_rows):                      # align rows and targets
        for lag in range(3):
            X_flat.append(lags[i * 3 + lag])
        X_flat.append(roll_mean[i])
        y_flat.append(sales[i + 3])              # target = value at that time
    # convert Mojo List -> NumPy array, reshape to (rows, 4 features)
    var X = copy_to_numpy_array(X_flat).reshape(X_rows, 4)
    var y = copy_to_numpy_array(y_flat)
    var model = sklearn_lr()
    model.fit(X, y)
    var preds = model.predict(X)
    print("Linear Regression predictions:", preds)

def main():
    train_linear_regression()
