struct ImmovableObject:
    var name: String
    def __init__(out self, name: String):
        self.name = name^

# Build directly in the caller's storage — no move/copy needed
def create_immovable_object(name: String, out obj: ImmovableObject):
    obj = ImmovableObject(name^)
    obj.name += "!"
    # obj is implicitly returned if no return statement runs

def main():
    var my_obj = create_immovable_object("Blob")
    print(my_obj.name)   # Blob!
