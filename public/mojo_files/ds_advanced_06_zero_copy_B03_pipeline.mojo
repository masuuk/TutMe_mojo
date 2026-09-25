# Zero-copy pipeline: data flows as Views
from tensor import Tensor, TensorSpec

struct Pipeline:
    var source: Tensor[Float32]
    var arena: Arena

    def __init__(out self, source: Tensor[Float32]):
        self.source = source^  # take ownership
        self.arena = Arena(source.size * 4 * 3)

    def run(self) -> Tensor[Float32]:
        # Stage 1: normalize (in-place via View)
        var normalized = normalize_view(self.source)

        # Stage 2: extract features (zero-copy View chain)
        var features = extract_view(normalized)

        # Stage 3: reduce (only this stage allocates)
        var result = reduce_to_tensor(features)

        return result

# Each stage returns a View — no data is copied
def normalize_view(data: Tensor[Float32]) -> View[Float32]:
    # Returns a View that lazily computes normalization
    return LazyNormalizeView(data)

def extract_view(data: View[Float32]) -> View[Float32]:
    # Returns a View that lazily computes features
    return LazyFeatureView(data)

def reduce_to_tensor(data: View[Float32]) -> Tensor[Float32]:
    # Only NOW do we materialize the result
    var result = Tensor[Float32](data.shape())
    for i in parallelize(data.size()):
        result[i] = data[i]
    return result
