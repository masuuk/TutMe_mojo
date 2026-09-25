def main():
    var snapshot = 42
    def frozen() {var snapshot} -> Int:
        return snapshot
    snapshot = 999
    print(frozen())   # 42
