comptime SIZE = 256
comptime MAX = SIZE * 2

comptime AscendingMidpoint[lo: Int, hi: Int]: Int
    where lo < hi = (lo + hi) / 2

def main():
    comptime mid = AscendingMidpoint[2, 10]   # 6
    # comptime bad = AscendingMidpoint[10, 2]  # Error: lo < hi not satisfied
    print(mid)
