# Mojo — batch iterator for training data
import sys

struct BatchIterator:
    var features: List[Float64]
    var labels: List[Int]
    var batch_size: Int
    var position: Int
    var n_samples: Int

    def __init__(out self, features: List[Float64],
                labels: List[Int], batch_size: Int):
        self.features = features
        self.labels = labels
        self.batch_size = batch_size
        self.position = 0
        self.n_samples = len(labels)

    def has_next(self) -> Bool:
        return self.position < self.n_samples

    def next_batch(mut self, n_features: Int) -> (List[Float64], List[Int]):
        var start = self.position
        var end = min(start + self.batch_size, self.n_samples)
        var batch_x = List[Float64]()
        var batch_y = List[Int]()

        for i in range(start, end):
            for j in range(n_features):
                batch_x.append(self.features[i * n_features + j])
            batch_y.append(self.labels[i])

        self.position = end
        return (batch_x, batch_y)

    def shuffle(mut self, n_features: Int):
        # Fisher-Yates shuffle
        var i = self.n_samples - 1
        while i > 0:
            var j = int(random_float64() * i)
            # Swap features
            for k in range(n_features):
                var a = self.features[i * n_features + k]
                var b = self.features[j * n_features + k]
                self.features[i * n_features + k] = b
                self.features[j * n_features + k] = a
            # Swap labels
            var tmp = self.labels[i]
            self.labels[i] = self.labels[j]
            self.labels[j] = tmp
            i -= 1
        self.position = 0

# Usage
var features: List[Float64] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
var labels: List[Int] = [0, 1]
var batches = BatchIterator(features, labels, batch_size=2)
while batches.has_next():
    var (bx, by) = batches.next_batch(n_features=3)
    print(f"Batch: {bx}, Labels: {by}")
