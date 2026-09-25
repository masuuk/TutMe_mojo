var list: List[String] = ["a", "b", "c", "d"]

for var item in list:      # mutable copy — list unchanged
    item = item + "x"
    print(item)           # ax, bx, cx, dx
print(list)               # [a, b, c, d]

for ref item in list:      # reference — writes hit the list
    item = item + "x"
print(list)               # [ax, bx, cx, dx]
