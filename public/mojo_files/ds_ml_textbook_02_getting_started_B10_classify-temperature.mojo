def classify_temperature(temp: Float64) -> String:
    if temp < 0.0:
        return "Freezing"
    elif temp < 20.0:
        return "Cold"
    elif temp < 35.0:
        return "Warm"
    else:
        return "Hot"

def main():
    var readings = [-5.0, 12.5, 22.0, 38.5, 8.0]

    var hot_count = 0
    var total: Float64 = 0.0

    for temp in readings:
        var category = classify_temperature(temp)
        print(temp, "°C →", category)
        if category == "Hot":
            hot_count += 1
        total += temp

    var avg = total / Float64(len(readings))
    print("\nAverage:", avg, "°C")
    print("Hot readings:", hot_count)
