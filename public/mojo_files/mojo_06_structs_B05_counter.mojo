struct Counter:
    var value: Int

    def __init__(out self):
        self.value = 0

    def increment(mut self):
        self.value += 1   # OK with mut self

def main():
    var c = Counter()
    c.increment()
    c.increment()
    print(c.value)   # 2
