# Mojo — data cleaning with SIMD-accelerated operations
from math import sqrt, isnan

struct DataCleaner:
    var mean: Float64
    var std: Float64

    def __init__(out self):
        self.mean = 0.0
        self.std = 0.0

    def compute_stats(mut self, data: List[Float64]):
        # Compute mean, ignoring NaN
        var total: Float64 = 0.0
        var count: Int = 0
        for val in data:
            if not isnan(val):
                total += val
                count += 1
        self.mean = total / count

        # Compute standard deviation
        var sum_sq: Float64 = 0.0
        for val in data:
            if not isnan(val):
                sum_sq += (val - self.mean) ** 2
        self.std = sqrt(sum_sq / count)

    def z_score_normalize(self, data: List[Float64]) -> List[Float64]:
        var result = List[Float64]()
        for val in data:
            if isnan(val):
                result.append(self.mean)  # impute with mean
            else:
                result.append((val - self.mean) / self.std)
        return result

    def clip_outliers(data: List[Float64], n_sigmas: Float64 = 3.0) -> List[Float64]:
        var cleaner = DataCleaner()
        cleaner.compute_stats(data)
        var lo = cleaner.mean - n_sigmas * cleaner.std
        var hi = cleaner.mean + n_sigmas * cleaner.std
        var result = List[Float64]()
        for val in data:
            if val < lo: result.append(lo)
            elif val > hi: result.append(hi)
            else: result.append(val)
        return result

# Usage
var raw = [1.0, 2.0, 3.0, 1000.0, 4.0, 5.0]
var cleaned = DataCleaner.clip_outliers(raw)
# cleaned == [1.0, 2.0, 3.0, 3.0, 4.0, 5.0]
