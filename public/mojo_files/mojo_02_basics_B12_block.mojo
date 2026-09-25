var first: List[Int] = [1, 2, 3]

var second = first.copy()   # Independent copy; `first` unchanged
second.append(4)             # [1, 2, 3, 4] — only in `second`
print(first)                 # [1, 2, 3]

var third = first^           # Transfer ownership; `first` unusable now
