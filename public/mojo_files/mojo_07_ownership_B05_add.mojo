def add(mut x: Int, y: Int):   # mutable + immutable refs
    x += y

def main():
    var a = 1
    var b = 2
    add(a, b)
    print(a)   # 3 — mutation persisted
