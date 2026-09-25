from max.algorithm import parallelize

def main():
    var results = List[Int](length=8, fill=0)

    def work(i: Int) {mut results}:
        results[i] = i * i

    parallelize(work, 8)
    print(results.__str__())
