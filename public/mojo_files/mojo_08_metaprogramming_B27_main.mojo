def main():
    var greeting = "Hello"
    var calls = 0

    def greeter(name: String) {imm greeting, mut calls}:
        calls += 1
        print(greeting + ", " + name + "!")

    greeter("Alice")
    greeter("Bob")
    print(calls)
