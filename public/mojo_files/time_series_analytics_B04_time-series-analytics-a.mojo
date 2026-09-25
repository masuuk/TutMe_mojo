# Calling pandas from Mojo via Python interop.
# Mojo 1.x stdlib paths start with std., so the Python bridge lives here.
from std.python import Python
from std.python.numpy import copy_to_numpy_array

def use_pandas_from_mojo():
    var pd = Python.import_module("pandas")
    # copy_to_numpy_array() turns a Mojo List into a NumPy array
    var sales: List[Float64] = [
        120.0, 132.0, 145.0, 138.0, 150.0, 165.0, 170.0,
        158.0, 175.0, 190.0, 185.0, 200.0, 210.0, 205.0,
        220.0, 215.0, 230.0, 240.0, 235.0, 250.0, 260.0,
        255.0, 270.0, 280.0,
    ]
    var dates = pd.date_range(start="2023-01-01", periods=24, freq="MS")
    # pandas Series built from the NumPy array with the date index attached
    var series = pd.Series(copy_to_numpy_array(sales), index=dates)
    print(series.head())
    print("Missing values:", series.isna().sum())

def main():
    use_pandas_from_mojo()
