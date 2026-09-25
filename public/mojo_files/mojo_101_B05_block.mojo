var income: Dict[String, Float64] = {"salary": 2400.0}
var expenses: Dict[String, Float64] = {
    "rent": 900.0,
    "food": 300.0,
}

var total_in = 0.0
for entry in income.items():
    total_in += entry.value

var total_out = 0.0
for entry in expenses.items():
    total_out += entry.value

print("saved:", total_in - total_out)   # 1200.0
