def print_nicely(var **kwargs: Int):
    for item in kwargs.items():
        print(item.key, "=", item.value)

print_nicely(a=7, y=8)
