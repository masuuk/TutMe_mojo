@fieldwise_init
struct MyPair:
    var first: Int
    var second: Int

    def get_sum(self) -> Int:
        return self.first + self.second

var mine = MyPair(6, 8)
print(mine.get_sum())
