def calculate_average(temps: List[Float64]) -> Float64:
    # The 0.0 floating-point literal defaults to Float64
    var total = 0.0
    for temp in temps:
        total += temp
    return total / Float64(len(temps))

def main():
    # [Float64] tells Mojo the `List` type at compile time
    var temps: List[Float64] = [20.5, 22.3, 19.8, 25.1]

    print("Recorded", len(temps), "temperatures")
    for index in range(len(temps)):  # The range is [0, len(temps))
        print(t" Day {index + 1}: {temps[index]}°C")

    var avg = calculate_average(temps)
    print(t"Average: {avg}°C")
