def main():
    var total = 0
    def accumulate(x: Int) {mut total}:
        total += x
    accumulate(10)
    accumulate(20)
    print(total)   # 30
