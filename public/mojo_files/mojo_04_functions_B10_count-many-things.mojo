def count_many_things[*ArgTypes: Intable](*args: *ArgTypes) -> Int:
    var total = 0
    comptime for i in range(args.__len__()):
        total += Int(args[i])
    return total

print(count_many_things(5, 11.7, 12))   # 28
