var maybe: Optional[Int] = Optional(7)

if maybe is None:
    print("nothing stored")
else:
    print(maybe.value())   # 7
