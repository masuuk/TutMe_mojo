# Mojo — streaming pipeline with chunk processing
import sys

struct StreamingPipeline:
    var chunk_size: Int
    var buffer: List[List[Float64]]

    def __init__(out self, chunk_size: Int = 10_000):
        self.chunk_size = chunk_size
        self.buffer = List[List[Float64]]()

    def process_chunk(self, chunk: List[Float64]) -> Float64:
        # Simulated transform: normalize and sum
        var total: Float64 = 0.0
        var n = len(chunk)
        var i = 0
        while i < n:
            total += chunk[i] * 0.001
            i += 1
        return total

    def run(self, path: String) -> Float64:
        var grand_total: Float64 = 0.0
        var reader = open(path, "r")
        var chunk = List[Float64]()

        while True:
            var line = reader.readline()
            if len(line) == 0:
                if len(chunk) > 0:
                    grand_total += self.process_chunk(chunk)
                break
            chunk.append(atof(line.strip()))
            if len(chunk) >= self.chunk_size:
                grand_total += self.process_chunk(chunk)
                chunk.clear()

        reader.close()
        return grand_total

var pipe = StreamingPipeline(chunk_size=50_000)
var result = pipe.run("huge_dataset.csv")
print(f"Result: {result}")
