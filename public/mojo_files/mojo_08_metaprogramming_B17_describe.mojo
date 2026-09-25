def describe[size: Int]():
    comptime label = "big"   # computed at compile time
    comptime if size >= 4:    # only this branch is instantiated
        print(label, "buffer:", size)

def main():
    describe[16]()
    describe[2]()   # prints nothing — branch not instantiated
