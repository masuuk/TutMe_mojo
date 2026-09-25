def repeat[
    MsgType: Writable,   // trait constraint...
    //,                  // ...and infer-only
    count: Int
](msg: MsgType):
    comptime for _ in range(count):
        print(msg)

def main():
    repeat[2](42)   # MsgType inferred from the argument
