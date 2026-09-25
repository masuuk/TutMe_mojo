def main():
    var limit = 10
    def check(x: Int) {imm limit} -> Bool:
        return x < limit
    print(check(5))    # True
    limit = 3
    print(check(5))    # False
