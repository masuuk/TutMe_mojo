var items: List[Int] = [99, 77, 33, 12]
var item = items[1]   # item is a COPY of items[1]

item += 1             # increments the copy
print(items[1])        # prints 77 — list untouched
