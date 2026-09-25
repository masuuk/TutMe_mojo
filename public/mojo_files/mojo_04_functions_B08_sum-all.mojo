def sum_all(*values: Int) -> Int:
    var total: Int = 0
    for value in values:
        total = total + value
    return total

print(sum_all(1, 2, 3))   # 6

# Mutate variadic elements via ref bindings...
def make_worldly(mut *strs: String):
    for ref i in strs:
        i += " world"

# ...or by direct indexing
def make_worldly2(mut *strs: String):
    for i in range(len(strs)):
        strs[i] += " world"
