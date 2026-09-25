def main():
    var a = 1
    var b = 2
    var z = "snapshot"
    def mixed() {mut, var z}:
        a += 10     # 'a' uses default: mut
        b += 20     # 'b' uses default: mut
        print(a, b, z)
    mixed()       # 11 22 snapshot
    z = "changed"
    mixed()       # 21 42 snapshot  ('z' was copied at declaration)
