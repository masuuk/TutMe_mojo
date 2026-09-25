from std.sys.compile import OptimizationLevel, DebugLevel

def main():
    comptime if OptimizationLevel.level == 0:
        print("unoptimized build")

    comptime if DebugLevel.level == "full":
        print("source-aware logging enabled")
