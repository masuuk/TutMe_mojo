# Define a trait
trait Describable:
    def describe(self) -> String: ...

# Implement the trait
@fieldwise_init
struct Dog(Describable):
    var name: String
    var breed: String

    def describe(self) -> String:
        return f"{self.name} the {self.breed}"

# Generic function — works with ANY type that implements Describable
def print_description[T: Describable](item: T):
    print(item.describe())

var dog = Dog(name="Rex", breed="Labrador")
print_description(dog)  # Rex the Labrador
