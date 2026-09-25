var items: List[Int] = [99, 77, 33, 12]

ref item_ref = items[1]   # item_ref IS items[1] — no copy
item_ref += 1              # increments items[1]
print(items[1])            # prints 78

# ref item_ref = items[2]  # Error: invalid redefinition of item_ref
