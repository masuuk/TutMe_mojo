def repeat[count: Int](msg: String):
    comptime for i in range(count):   # fully unrolled at compile time
        print(msg)

def main():
    repeat[3]("Hello")
