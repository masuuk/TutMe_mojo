trait Named:
    # required: every conformance must provide this
    def name(self) -> String: ...
    # provided: shared behavior, built on the required method
    def greeting(self) -> String:
        return String(t"Hello, {self.name()}!")

@fieldwise_init
struct City(Named):
    var title: String
    def name(self) -> String:
        return self.title

@fieldwise_init
struct Robot(Named):
    var id: Int
    def name(self) -> String:
        return String(t"Robot-{self.id}")

def main():
    var c = City("Oslo")
    var r = Robot(7)
    print(c.greeting())   # Hello, Oslo!
    print(r.greeting())   # Hello, Robot-7!
