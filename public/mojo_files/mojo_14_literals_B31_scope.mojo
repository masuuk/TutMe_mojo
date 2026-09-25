with open("file.txt") as f:
    var content = f.read()

# A minimal custom context manager:
struct Scope (ImplicitlyCopyable):
    var label: String
    def __init__(out self, label: String):
        self.label = label
    def __enter__(self) -> Self:
        print("entering", self.label)
        return self
    def __exit__(self):
        print("exiting", self.label)

def main():
    with Scope("setup") as s:
        print("inside", s.label)
