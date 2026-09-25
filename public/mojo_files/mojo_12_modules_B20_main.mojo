from std.sys import get_defined_string

def main():
    comptime mode = get_defined_string["mode", "debug"]()

    comptime if mode == "release":
        print("optimized path")
    else:
        print("debug path with extra checks")
