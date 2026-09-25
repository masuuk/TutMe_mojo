var items = [0, 1, 2, 3, 4, 5]
var first_three = items[0:3]    # [0, 1, 2] — stop not included
var from_three = items[3:]     # [3, 4, 5]
var every_other = items[::2]    # [0, 2, 4]
var reversed = items[::-1]    # [5, 4, 3, 2, 1, 0]
print(first_three, from_three, every_other, reversed)
