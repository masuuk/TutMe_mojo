from max.algorithm import parallelize
from std.runtime import initialize_runtime

@export("parallel_sum")
def parallel_sum(n: Int64) abi("C") -> Int64:
    initialize_runtime()

    var count = Int(n)
    var results = List[Int64](length=count, fill=0)

    @parameter
    def fill(i: Int):
        results[i] = Int64(i)

    parallelize[fill](count)

    var total = Int64(0)
    for r in results:
        total += r
    return total
# Int64 matches C's long long across the ABI
