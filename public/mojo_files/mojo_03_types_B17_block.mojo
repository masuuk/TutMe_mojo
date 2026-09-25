var empty_dict: Dict[String, Float64] = {}
var values: Dict[String, Float64] = {"pi": 3.14159, "e": 2.71828}
var d = Dict[String, Float64]()   # Constructor syntax works too

# Iterating items() yields references
var props: Dict[String, Float64] = {
    "plasticity": 3.1,
    "elasticity": 1.3,
}
for item in props.items():
    print(item.key, item.value)
