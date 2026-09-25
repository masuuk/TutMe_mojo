import sys
from collections import Dict, Optional

# Mojo — loading CSV with buffered I/O and SIMD parsing
def load_csv(path: String) -> Dict[String, List[Float64]]:
    var columns = Dict[String, List[Float64]]()
    var reader = open(path, "r")
    var header_line = reader.readline()
    var headers = header_line.strip().split(",")

    for h in headers:
        columns[h] = List[Float64]()

    while True:
        var line = reader.readline()
        if len(line) == 0:
            break
        var values = line.strip().split(",")
        for i in range(len(values)):
            columns[headers[i]].append(atof(values[i]))

    reader.close()
    return columns

# Usage
var data = load_csv("sensors.csv")
print(f"Loaded {len(data['temperature'])} rows")
