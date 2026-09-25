struct NameList:
    var names: List[String]

    def __init__(out self, *names: String):
        self.names = []
        for name in names:
            self.names.append(name)

    def __getitem__(ref self, index: Int) raises -> ref[self] String:
        if index >= 0 and index < len(self.names):
            return self.names[index]
        raise Error("index out of bounds")

def main() raises:
    var list = NameList("Thor", "Athena", "Dana")
    ref name = list[2]   # reference binding, not a copy
    print(name)
    name += "?"          # writes through to the list
    print(list[2])
