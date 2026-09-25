def take_text(var text: String):
    text += "!"
    print(text)

def main():
    var message = "Hello"
    take_text(message)     # copy path (String is Copyable)
    print(message)         # still usable
