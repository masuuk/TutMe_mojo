# Pattern 1: Transfer into a function
var model_data = load_training_data()
var stats = compute_statistics(model_data^)  # model_data is moved
# Can't use model_data anymore — it's been consumed

# Pattern 2: Move into a collection
var results = List[Experiment]()
for config in configs:
    results.append(run_experiment(config^))

# Pattern 3: Swap ownership
var old_buffer = allocate_buffer()
var new_buffer = old_buffer^  # old_buffer is now empty

# Pattern 4: Return to transfer out
def transform(var data: List[Int]) -> List[Int]:
    for i in range(len(data)):
        data[i] *= 2
    return data^  # transfers ownership back to caller

var raw = [1, 2, 3]
var doubled = transform(raw^)
print(doubled)  # [2, 4, 6]
