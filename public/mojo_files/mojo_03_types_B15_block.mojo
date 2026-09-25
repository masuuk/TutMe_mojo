var list = [2, 3, 4]

for ref item in list:   # Capture a ref to the list element
    print(item, end=", ")
    item = 0            # Mutates the element inside the list

print("\nAfter loop:", list[0], list[1], list[2])
