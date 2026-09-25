@fieldwise_init
struct Counter:
    var value: Int

    def increment(mut self):
        self.value += 1

    def get(self) -> Int:
        return self.value

var c = Counter(value=0)
c.increment()
print(c.get())  # 1
