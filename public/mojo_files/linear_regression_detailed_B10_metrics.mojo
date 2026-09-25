from std.math import sqrt, abs

def metrics(y_true: List[Float64], y_pred: List[Float64]) -> Dict[String, Float64]:
    var n = len(y_true)
    var sse: Float64 = 0.0
    var mae: Float64 = 0.0
    var sst: Float64 = 0.0
    var mean_y: Float64 = 0.0
    for y in y_true:
        mean_y += y
    mean_y /= Float64(n)

    for i in range(n):
        var e = y_true[i] - y_pred[i]
        sse += e * e
        mae += abs(e)
        sst += (y_true[i] - mean_y) ** 2

    var mse = sse / Float64(n)
    var r2 = 1.0 - sse / sst
    return {"MSE": mse, "RMSE": sqrt(mse), "MAE": mae / Float64(n), "R²": r2}
